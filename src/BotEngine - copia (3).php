<?php
require_once __DIR__ . '/Db.php';
require_once __DIR__ . '/TwilioClient.php';

class BotEngine {

    /**
     * @param string $waFrom      Ej: "whatsapp:+54911..."
     * @param string $text        Mensaje del usuario
     * @param string $profileName Nombre que envía Twilio en ProfileName (nombre del contacto en WhatsApp)
     */
    public function handleIncoming(string $waFrom, string $text, string $profileName = ''): array {
        $text = trim($text);

        // crear/obtener sesion
        $session = $this->getOrCreateSession($waFrom);
        $currentNodeId = (int)$session['current_node_id'];
        $mode = (string)$session['mode'];
        $isNew = (bool)($session['is_new'] ?? false);

        // Normalización de comandos
        $cmd = mb_strtoupper(trim($text), 'UTF-8');
        $cmd = str_replace(['Á','É','Í','Ó','Ú','Ü'], ['A','E','I','O','U','U'], $cmd);

        // =========================
        // MODO HUMANO
        // =========================
        if ($mode === 'HUMAN') {

            // Volver al bot (dos comportamientos):
            // - MENU/0/INICIO => vuelve al MAIN
            // - BOT/VOLVER    => vuelve al mismo nodo donde estaba (sin resetear)
            if ($cmd === 'MENU' || $cmd === 'MENU.' || $cmd === 'MENÚ' || $cmd === '0' || $cmd === 'INICIO') {
                $this->setSessionMode($waFrom, 'BOT');
                $currentNodeId = $this->getNodeIdByKey('MAIN');
                $this->updateSessionNode($waFrom, $currentNodeId);

                $menu = $this->renderNode($currentNodeId);
                $this->log($waFrom, 'IN', $text);
                $this->log($waFrom, 'OUT', $menu);

                return ['message' => $menu, 'end' => false];
            }

            if ($cmd === 'BOT' || $cmd === 'VOLVER') {
                $this->setSessionMode($waFrom, 'BOT');

                $msg = $this->nodeHasOptions($currentNodeId)
                    ? $this->renderNode($currentNodeId)
                    : $this->renderNodeTextOnly($currentNodeId);

                $this->log($waFrom, 'IN', $text);
                $this->log($waFrom, 'OUT', $msg);

                return ['message' => $msg, 'end' => false];
            }

            // Si no pidió volver, seguimos en modo humano
            $this->log($waFrom, 'IN', $text);
            $this->storeHandoffMessage($waFrom, $text, 'USER');

            return [
                'message' => "Ya te derivé con un agente 👤. Escribí tu consulta y te responden a la brevedad.

Si querés volver al bot, enviá: MENU",
                'end' => false
            ];
        }

        // =========================
        // FUERA DE HORARIO
        // =========================
        if (!$this->isWithinBusinessHours()) {
            $outId = $this->getNodeIdByKey('OUT_OF_HOURS');
            if ($outId > 0) {
                $this->updateSessionNode($waFrom, $outId);

                $msg = $this->nodeHasOptions($outId)
                    ? $this->renderNode($outId)
                    : $this->renderNodeTextOnly($outId);

                $this->log($waFrom, 'IN', $text);
                $this->log($waFrom, 'OUT', $msg);
                return ['message' => $msg, 'end' => false];
            }
            // Si no existe el nodo, no bloqueamos.
        }

        // =========================
        // BIENVENIDA (imagen + saludo + menú)
        // =========================
        if (
            $text === '' ||
            $cmd === 'MENU' || $cmd === 'MENU.' || $cmd === 'MENÚ' || $cmd === 'MENÚ' ||
            $cmd === '0' || $cmd === 'INICIO' ||
            $this->isGreeting($cmd) ||
            $isNew
        ) {
            $mainId = $this->getNodeIdByKey('MAIN');
            $this->updateSessionNode($waFrom, $mainId);

            $menu = $this->renderNode($mainId);
            $greeting = $this->greetingText($profileName);
            $media = $this->getNodeMediaUrl($mainId); // configurado en DB (bot_nodes.media_url)

            $this->log($waFrom, 'IN', $text);

  
        $messages = [];
        // 1) Imagen (si hay)
        if ($media !== '') {
            $messages[] = ['media_url' => $media];
            $this->log($waFrom, 'OUT', '[MEDIA] ' . $media);
        }
        // 2) Saludo (solo)
        $messages[] = ['body' => $greeting];
        $this->log($waFrom, 'OUT', $greeting);
        
        // 3) Menú (solo)
        $messages[] = ['body' => $menu];
        $this->log($waFrom, 'OUT', $menu);
        
        return ['messages' => $messages, 'end' => false];

        }

        // =========================
        // buscar opción válida en el nodo actual
        // =========================
        $opt = $this->findOption($currentNodeId, $text);

        $this->log($waFrom, 'IN', $text);

        if (!$opt) {
            $menu = $this->renderNode($currentNodeId);
            $msg = "No te entendí 😅

" . $menu;
            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        $actionType = (string)$opt['action_type'];
        $actionValue = $opt['action_value'];

        if ($actionType === 'GOTO_NODE') {
            $nextNodeId = (int)$actionValue;
            $this->updateSessionNode($waFrom, $nextNodeId);

            // Si el nodo tiene opciones, lo mostramos como menú.
            // Si no tiene opciones, mostramos solo el texto (descripción).
            $msg = $this->nodeHasOptions($nextNodeId)
                ? $this->renderNode($nextNodeId)
                : $this->renderNodeTextOnly($nextNodeId);

            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        if ($actionType === 'SHOW_TEXT') {
            $msg = trim((string)$actionValue) . "

👉 Escribí MENU para volver.";
            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        if ($actionType === 'HUMAN_HANDOFF') {
            // Opcional: restringir handoff por horario (si querés)
            if (!$this->isWithinBusinessHours()) {
                $msg = "⏰ En este momento estamos fuera de horario.

👉 Escribí MENU para ver opciones.";
                $this->log($waFrom, 'OUT', $msg);
                return ['message' => $msg, 'end' => false];
            }

            $targetWa = trim((string)$actionValue);
            $this->setSessionMode($waFrom, 'HUMAN');
            $this->createHandoffRequest($waFrom, $targetWa, $currentNodeId, $text);

            // Si tenés configurado TWILIO_WHATSAPP_FROM + credenciales, notifica al agente.
            $agentNotified = false;
            if ($targetWa !== '') {
                $fromWa = Config::get('TWILIO_WHATSAPP_FROM', '');
                if ($fromWa !== '') {
                    $preview = "Nueva derivación (Tránsito San Fernando)
" .
                               "Usuario: {$waFrom}
" .
                               "Mensaje: {$text}

" .
                               "Abrí el panel admin para ver la conversación.";
                    $resp = TwilioClient::sendWhatsApp($targetWa, $fromWa, $preview);
                    $agentNotified = (bool)($resp['ok'] ?? false);
                }
            }

            $directLink = $this->toWaMeLink($targetWa);
            $msg = "Listo ✅ Te paso con un agente.

" .
                   "👉 Para chatear directo por WhatsApp con el agente: {$directLink}

" .
                   "Dejá tu consulta con el mayor detalle posible (DNI, patente, nro de acta, etc si aplica).

" .
                   "Para volver al menú, enviá: MENU";
            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        if ($actionType === 'RESET') {
            $main = $this->getNodeIdByKey('MAIN');
            $this->updateSessionNode($waFrom, $main);
            $menu = $this->renderNode($main);
            $this->log($waFrom, 'OUT', $menu);
            return ['message' => $menu, 'end' => false];
        }

        // fallback
        $menu = $this->renderNode($currentNodeId);
        $msg = "Acción no implementada.

" . $menu;
        $this->log($waFrom, 'OUT', $msg);
        return ['message' => $msg, 'end' => false];
    }

    private function getOrCreateSession(string $waFrom): array {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT * FROM user_sessions WHERE wa_from = ? LIMIT 1');
        $stmt->execute([$waFrom]);
        $row = $stmt->fetch();
        if ($row) {
            $row['is_new'] = false;
            return $row;
        }

        $mainId = $this->getNodeIdByKey('MAIN');
        $stmt = $pdo->prepare('INSERT INTO user_sessions (wa_from, current_node_id, mode, updated_at) VALUES (?, ?, "BOT", NOW())');
        $stmt->execute([$waFrom, $mainId]);

        return [
            'wa_from' => $waFrom,
            'current_node_id' => $mainId,
            'mode' => 'BOT',
            'is_new' => true
        ];
    }

    private function updateSessionNode(string $waFrom, int $nodeId): void {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('UPDATE user_sessions SET current_node_id=?, updated_at=NOW() WHERE wa_from=?');
        $stmt->execute([$nodeId, $waFrom]);
    }

    private function setSessionMode(string $waFrom, string $mode): void {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('UPDATE user_sessions SET mode=?, updated_at=NOW() WHERE wa_from=?');
        $stmt->execute([$mode, $waFrom]);
    }

    private function getNodeIdByKey(string $key): int {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT id FROM bot_nodes WHERE key_name=? LIMIT 1');
        $stmt->execute([$key]);
        $id = $stmt->fetchColumn();
        return $id ? (int)$id : 0;
    }

    private function getNodeMediaUrl(int $nodeId): string {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT media_url FROM bot_nodes WHERE id=?');
        $stmt->execute([$nodeId]);
        $url = $stmt->fetchColumn();
        return $url ? trim((string)$url) : '';
    }

    private function renderNode(int $nodeId): string {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT title, message FROM bot_nodes WHERE id=?');
        $stmt->execute([$nodeId]);
        $node = $stmt->fetch();
        if (!$node) {
            return "Menú no encontrado.";
        }

        $stmt = $pdo->prepare('SELECT option_key, label FROM bot_options WHERE node_id=? ORDER BY sort_order ASC, id ASC');
        $stmt->execute([$nodeId]);
        $options = $stmt->fetchAll();

        $lines = [];
        $lines[] = $node['message'];
        foreach ($options as $opt) {
            $lines[] = $opt['option_key'] . ") " . $opt['label'];
        }
        $lines[] = "
Enviá MENU para volver al inicio.";
        return implode("
", $lines);
    }

    private function renderNodeTextOnly(int $nodeId): string {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT message FROM bot_nodes WHERE id=?');
        $stmt->execute([$nodeId]);
        $msg = $stmt->fetchColumn();

        if (!$msg) return "Contenido no encontrado.";

        return trim((string)$msg) . "

👉 Escribí MENU para volver.";
    }

    private function findOption(int $nodeId, string $key): ?array {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT * FROM bot_options WHERE node_id=? AND option_key=? LIMIT 1');
        $stmt->execute([$nodeId, $key]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    private function createHandoffRequest(string $waFrom, string $targetWa, int $nodeId, string $triggerText): void {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('INSERT INTO handoff_requests (wa_from, target_wa, node_id, trigger_text, status, created_at) VALUES (?, ?, ?, ?, "OPEN", NOW())');
        $stmt->execute([$waFrom, $targetWa !== '' ? $targetWa : null, $nodeId, $triggerText]);
    }

    private function toWaMeLink(string $targetWa): string {
        // Espera formatos: whatsapp:+54911... o +54911... o 54911...
        $n = trim($targetWa);
        if (str_starts_with($n, 'whatsapp:')) {
            $n = substr($n, 8);
        }
        $n = str_replace(['+', ' '], '', $n);
        if ($n === '') {
            return 'No configurado';
        }
        return "https://wa.me/{$n}";
    }

    private function storeHandoffMessage(string $waFrom, string $text, string $sender): void {
        $pdo = Db::pdo();
        // toma el último OPEN
        $stmt = $pdo->prepare('SELECT id FROM handoff_requests WHERE wa_from=? ORDER BY id DESC LIMIT 1');
        $stmt->execute([$waFrom]);
        $hid = $stmt->fetchColumn();
        if (!$hid) return;
        $stmt = $pdo->prepare('INSERT INTO handoff_messages (handoff_id, sender, body, created_at) VALUES (?, ?, ?, NOW())');
        $stmt->execute([(int)$hid, $sender, $text]);
    }

    private function log(string $waFrom, string $dir, string $msg): void {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('INSERT INTO message_logs (wa_from, direction, body, created_at) VALUES (?, ?, ?, NOW())');
        $stmt->execute([$waFrom, $dir, $msg]);
    }

    private function nodeHasOptions(int $nodeId): bool {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT COUNT(*) FROM bot_options WHERE node_id=?');
        $stmt->execute([$nodeId]);
        return ((int)$stmt->fetchColumn()) > 0;
    }

    // =========================
    // Helpers: saludo / horario
    // =========================
    private function isGreeting(string $cmd): bool {
        return in_array($cmd, ['HOLA','HOLAA','BUENAS','BUEN DIA','BUEN DÍA','HI','HELLO'], true);
    }

    private function greetingText(string $profileName): string {
        $name = trim($profileName);
        if ($name === '') return "👋 ¡Hola! Estoy acá para ayudarte.";
        $name = mb_substr($name, 0, 32, 'UTF-8');
        return "👋 ¡Hola, {$name}! Estoy acá para ayudarte.";
    }

    private function getSetting(string $k, string $default = ''): string {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT v FROM bot_settings WHERE k=? LIMIT 1');
        $stmt->execute([$k]);
        $v = $stmt->fetchColumn();
        return $v !== false ? (string)$v : $default;
    }

    private function isWithinBusinessHours(): bool {
        $json = $this->getSetting('BUSINESS_HOURS', '');
        if ($json === '') return true; // sin config => no bloquea

        $cfg = json_decode($json, true);
        if (!is_array($cfg)) return true;

        $tz = $cfg['tz'] ?? 'America/Argentina/Buenos_Aires';
        $now = new DateTime('now', new DateTimeZone($tz));

        $map = [1 => 'mon', 2 => 'tue', 3 => 'wed', 4 => 'thu', 5 => 'fri', 6 => 'sat', 7 => 'sun'];
        $dayKey = $map[(int)$now->format('N')] ?? 'mon';

        $range = $cfg[$dayKey] ?? null;
        if ($range === null) return false; // cerrado

        if (!is_array($range) || count($range) !== 2) return true; // formato raro => no bloquea

        [$start, $end] = $range;
        if (!$start || !$end) return false;

        $startDt = DateTime::createFromFormat('Y-m-d H:i', $now->format('Y-m-d') . ' ' . $start, new DateTimeZone($tz));
        $endDt   = DateTime::createFromFormat('Y-m-d H:i', $now->format('Y-m-d') . ' ' . $end, new DateTimeZone($tz));
        if (!$startDt || !$endDt) return true;

        return ($now >= $startDt && $now <= $endDt);
    }
}
