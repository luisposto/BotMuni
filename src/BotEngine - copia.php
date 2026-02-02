<?php
require_once __DIR__ . '/Db.php';
require_once __DIR__ . '/TwilioClient.php';

class BotEngine {
    public function handleIncoming(string $waFrom, string $text): array {
        $text = trim($text);
        $pdo = Db::pdo();

        // crear/obtener sesion
        $session = $this->getOrCreateSession($waFrom);
        $currentNodeId = (int)$session['current_node_id'];
        $mode = $session['mode'];

        // Si está en modo HUMANO, el bot no responde menús.
        if ($mode === 'HUMAN') {
            $this->log($waFrom, 'IN', $text);
            // opcional: guardar mensajes para que un operador los vea
            $this->storeHandoffMessage($waFrom, $text, 'USER');
            return [
                'message' => "Ya te derivé con un agente 👤. Escribí tu consulta y te responden a la brevedad.\n\nSi querés volver al bot, enviá: MENU",
                'end' => false
            ];
        }

        if ($text === '' || strtoupper($text) === 'MENU' || $text === '0') {
            $currentNodeId = $this->getNodeIdByKey('MAIN');
            $this->updateSessionNode($waFrom, $currentNodeId);
            $menu = $this->renderNode($currentNodeId);
            $this->log($waFrom, 'IN', $text);
            $this->log($waFrom, 'OUT', $menu);
            return ['message' => $menu, 'end' => false];
        }

        // buscar opción válida en el nodo actual
        $opt = $this->findOption($currentNodeId, $text);

        $this->log($waFrom, 'IN', $text);

        if (!$opt) {
            $menu = $this->renderNode($currentNodeId);
            $msg = "No te entendí 😅\n\n" . $menu;
            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        $actionType = $opt['action_type'];
        $actionValue = $opt['action_value'];

        if ($actionType === 'GOTO_NODE') {
            $nextNodeId = (int)$actionValue;
            $this->updateSessionNode($waFrom, $nextNodeId);
            $menu = $this->renderNode($nextNodeId);
            $this->log($waFrom, 'OUT', $menu);
            return ['message' => $menu, 'end' => false];
        }

        if ($actionType === 'SHOW_TEXT') {
            // responde texto + muestra nuevamente el menú actual
            $menu = $this->renderNode($currentNodeId);
            $msg = $actionValue . "\n\n" . $menu;
            $this->log($waFrom, 'OUT', $msg);
            return ['message' => $msg, 'end' => false];
        }

        if ($actionType === 'HUMAN_HANDOFF') {
            $targetWa = trim((string)$actionValue);
            $this->setSessionMode($waFrom, 'HUMAN');
            $this->createHandoffRequest($waFrom, $targetWa, $currentNodeId, $text);

            // Si tenés configurado TWILIO_WHATSAPP_FROM + credenciales, notifica al agente.
            // Nota: el agente debe estar habilitado en tu canal (Sandbox / número aprobado).
            $agentNotified = false;
            if ($targetWa !== '') {
                $fromWa = Config::get('TWILIO_WHATSAPP_FROM', '');
                if ($fromWa !== '') {
                    $preview = "Nueva derivación (Tránsito San Fernando)\n" .
                               "Usuario: {$waFrom}\n" .
                               "Mensaje: {$text}\n\n" .
                               "Abrí el panel admin para ver la conversación.";
                    $resp = TwilioClient::sendWhatsApp($targetWa, $fromWa, $preview);
                    $agentNotified = (bool)($resp['ok'] ?? false);
                }
            }

            $directLink = $this->toWaMeLink($targetWa);
            $msg = "Listo ✅ Te paso con un agente.\n\n" .
                   "👉 Para chatear directo por WhatsApp con el agente: {$directLink}\n\n" .
                   "Dejá tu consulta con el mayor detalle posible (DNI, patente, nro de acta, etc si aplica).\n\n" .
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
        $msg = "Acción no implementada.\n\n" . $menu;
        $this->log($waFrom, 'OUT', $msg);
        return ['message' => $msg, 'end' => false];
    }

    private function getOrCreateSession(string $waFrom): array {
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT * FROM user_sessions WHERE wa_from = ? LIMIT 1');
        $stmt->execute([$waFrom]);
        $row = $stmt->fetch();
        if ($row) return $row;

        $mainId = $this->getNodeIdByKey('MAIN');
        $stmt = $pdo->prepare('INSERT INTO user_sessions (wa_from, current_node_id, mode, updated_at) VALUES (?, ?, "BOT", NOW())');
        $stmt->execute([$waFrom, $mainId]);
        return [
            'wa_from' => $waFrom,
            'current_node_id' => $mainId,
            'mode' => 'BOT'
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
        $lines[] = "\nTip: enviá MENU para volver al inicio.";
        return implode("\n", $lines);
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
}
