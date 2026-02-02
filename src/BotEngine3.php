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
// ATAJO GLOBAL AL MENÚ (prioridad absoluta)
// =========================
if (in_array($cmd, ['MENU', 'MENÚ', 'MENU.', '0', 'INICIO'], true)) {
    $this->setSessionMode($waFrom, 'BOT');

    $mainId = $this->getNodeIdByKey('MAIN');
    $this->updateSessionNode($waFrom, $mainId);

    // Evitar saludo al volver manualmente
    $this->setSuppressGreeting($waFrom, 1);

    $menu = $this->renderNode($mainId);

    $this->log($waFrom, 'IN', $text);
    $this->log($waFrom, 'OUT', $menu);

    return [
        'messages' => [
            ['body' => $menu]
        ],
        'end' => false
    ];
}


        // =========================
// SALUDO 1 vez por día + MEDIA solo 1 vez (ever) + A/B
// (Importante: este bloque debe ejecutarse ANTES de renderizar cualquier menú)
// =========================
if ($mode !== 'HUMAN') {
    $tz = 'America/Argentina/Buenos_Aires';
    $bh = $this->getSetting('BUSINESS_HOURS', '');
    if ($bh !== '') {
        $cfg = json_decode($bh, true);
        if (is_array($cfg) && !empty($cfg['tz'])) $tz = (string)$cfg['tz'];
    }

    $shouldGreet = $this->shouldGreetToday($session, $cmd, $tz);

    // Media solo la primera vez (ever) si hay media_url configurado en MAIN.
    // OJO: NO lo atamos a is_new porque si agregás la URL después, querés que igual se envíe una sola vez.
    $mainId = $this->getNodeIdByKey('MAIN');
    $shouldMedia = ((int)($session['media_sent'] ?? 0) === 0);

    // Disparadores: si toca saludar hoy o si toca mandar media por 1ra vez
    if ($shouldGreet || $shouldMedia) {
        $this->updateSessionNode($waFrom, $mainId);

        $menu = $this->renderNode($mainId);
        $variant = $this->pickGreetVariant($session);
        $greeting = $this->greetingTextAB($profileName, $variant);

        $messages = [];
        $sentMedia = false;

        // Orden deseado: SALUDO -> IMAGEN -> MENÚ (en WhatsApp el caption de una imagen puede no mostrarse si la media se interpreta como sticker/webp)
        // Por eso enviamos el saludo SIEMPRE como mensaje de texto separado, luego la imagen, y por último el menú.

        if ($shouldGreet) {
            $messages[] = ['body' => $greeting];
        }

        // Media solo la primera vez (ever)
        if ($shouldMedia) {
            $media = $this->getNodeMediaUrl($mainId);
            if ($media !== '') {
                // Sin body: evita que WhatsApp lo "oculte" como caption en ciertos formatos
                $messages[] = ['media_url' => $media];
                $sentMedia = true;
            }
        }

        // Menú siempre al final
        $messages[] = ['body' => $menu];

        // actualizar meta (marca saludo hoy, variante A/B, media_sent, y apaga suppress_greeting)
        $this->updateGreetingMeta($waFrom, $variant, $sentMedia, true);

        $this->log($waFrom, 'IN', $text);
        $this->log($waFrom, 'OUT', ($shouldGreet ? $greeting . "\n\n" : "") . $menu);

        return ['messages' => $messages, 'end' => false];
    }
}

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


                // Evitar saludo al volver desde HUMANO
                $this->setSuppressGreeting($waFrom, 1);
                $menu = $this->renderNode($currentNodeId);
                $this->log($waFrom, 'IN', $text);
                $this->log($waFrom, 'OUT', $menu);

                return ['message' => $menu, 'end' => false];
            }

            if ($cmd === 'BOT' || $cmd === 'VOLVER') {
                $this->setSessionMode($waFrom, 'BOT');


                // Evitar saludo al volver desde HUMANO
                $this->setSuppressGreeting($waFrom, 1);
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
        // buscar opción válida en el nodo actual
        // =========================
        $opt = $this->findOption($currentNodeId, $text);

        $this->log($waFrom, 'IN', $text);

        if (!$opt) {
            $menu = $this->renderNode($currentNodeId);
            $msg = "No te entendí 😅
Escribí una opción del menú

". $menu;
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
        $lines[] = "";
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
    
    // A/B test: asigna variante A o B por usuario (persistida en user_sessions.greet_variant)
    private function pickGreetVariant(array $session): string {
        $v = strtoupper(trim((string)($session['greet_variant'] ?? '')));
        if ($v === 'A' || $v === 'B') return $v;
        return (random_int(0, 1) === 0) ? 'A' : 'B';
    }

    private function updateGreetingMeta(string $waFrom, string $variant, bool $sentMedia, bool $resetSuppress = true): void {
        $pdo = Db::pdo();

        // Nota: requiere columnas last_greeted_at, greet_variant, media_sent, suppress_greeting
        $sql = 'UPDATE user_sessions
                SET last_greeted_at = NOW(),
                    greet_variant = IFNULL(greet_variant, ?),
                    media_sent = IF(media_sent=1, 1, ?),
                    suppress_greeting = ' . ($resetSuppress ? '0' : 'suppress_greeting') . ',
                    updated_at = NOW()
                WHERE wa_from = ?';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$variant, $sentMedia ? 1 : 0, $waFrom]);
    }

    private function setSuppressGreeting(string $waFrom, int $val): void {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('UPDATE user_sessions SET suppress_greeting=?, updated_at=NOW() WHERE wa_from=?');
        $stmt->execute([$val, $waFrom]);
    }

    private function isSameLocalDay(?string $lastGreetedAt, string $tz): bool {
        if (!$lastGreetedAt) return false;
        try {
            // IMPORTANTE:
            // - En muchos hostings/MySQL, NOW() se guarda en UTC (o en la TZ del servidor).
            // - Si lo interpretamos como si ya estuviera en $tz, el "día" puede correrse y terminar saludando de nuevo
            //   (típico a la noche en Argentina).
            // Por eso: parseamos el timestamp como UTC y recién después lo convertimos a la TZ de negocio.
            $d = new DateTime($lastGreetedAt, new DateTimeZone('UTC'));
            $d->setTimezone(new DateTimeZone($tz));

            $now = new DateTime('now', new DateTimeZone($tz));
            return $d->format('Y-m-d') === $now->format('Y-m-d');
        } catch (Exception $e) {
            return false;
        }
    }

    // Regla: saluda 1 vez por día, no saluda si volvió desde HUMANO (suppress_greeting=1)
    private function shouldGreetToday(array $session, string $cmd, string $tz): bool {
// No saludar ante comandos de control (evita loops cuando el usuario pone MENU)
if (in_array($cmd, ['MENU','MENÚ','MENU.','0','INICIO'], true)) return false;

        // No saludar si volvió desde HUMANO (se apaga automáticamente al saludar/mostrar menú)
        if ((int)($session['suppress_greeting'] ?? 0) === 1) return false;

        // Si ya saludó hoy (según tz), no repetir
        $last = $session['last_greeted_at'] ?? null;
        if ($this->isSameLocalDay($last ? (string)$last : null, $tz)) return false;

        // Si no saludó hoy, saludamos con el primer mensaje del día (cualquier texto)
        // Esto cumple: "saludar 1 vez por día" + "cualquier palabra que inicie el chat"
        return true;
    }

    private function greetingTextAB(string $profileName, string $variant): string {
        $name = trim($profileName);
        if ($name !== '') $name = mb_substr($name, 0, 32, 'UTF-8');

        if (strtoupper($variant) === 'A') {
            // Corto
            return ($name === '')
                ? "👋 ¡Hola! Estoy acá para ayudarte."
                : "👋 ¡Hola, {$name}! Estoy acá para ayudarte.";
        }

        // Largo
        return ($name === '')
            ? "👋 ¡Hola! Soy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte."
            : "👋 ¡Hola, {$name}!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.";
    }

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
