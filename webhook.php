<?php
declare(strict_types=1);

ini_set('display_errors', '0');
error_reporting(E_ALL);

function log_line(string $file, $data): void {
    @file_put_contents($file, date('Y-m-d H:i:s') . ' - ' . $data . PHP_EOL, FILE_APPEND);
}

$baseDir = __DIR__;
$logFile = $baseDir . '/logs/debug.txt';

require_once $baseDir . '/src/Config.php';
require_once $baseDir . '/src/BotEngine.php';
require_once $baseDir . '/src/MetaWhatsAppClient.php';

Config::loadEnv($baseDir . '/.env');

$verifyToken = Config::get('META_VERIFY_TOKEN', 'mi_token_verificacion_123');

// =========================
// VERIFICACION WEBHOOK META
// =========================
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {

    $mode = $_GET['hub_mode'] ?? $_GET['hub.mode'] ?? '';
    $token = $_GET['hub_verify_token'] ?? $_GET['hub.verify_token'] ?? '';
    $challenge = $_GET['hub_challenge'] ?? $_GET['hub.challenge'] ?? '';

    if ($mode === 'subscribe' && $token === $verifyToken) {
        echo $challenge;
        exit;
    }

    header('Content-Type: text/plain; charset=utf-8');
    http_response_code(403);
    echo 'Token inválido';
    exit;
}

$raw = file_get_contents('php://input');
log_line($logFile, 'RAW: ' . $raw);

$payload = json_decode($raw, true);

$message = $payload['entry'][0]['changes'][0]['value']['messages'][0] ?? null;
$contact = $payload['entry'][0]['changes'][0]['value']['contacts'][0] ?? null;

if (!$message) {
    echo 'EVENT_RECEIVED';
    exit;
}

$from = $message['from'] ?? '';
$profileName = $contact['profile']['name'] ?? '';
$messageType = $message['type'] ?? 'text';

$body = '';

switch ($messageType) {
    case 'text':
        $body = trim((string)($message['text']['body'] ?? ''));
        break;

    case 'button':
        $body = trim((string)($message['button']['text'] ?? ''));
        break;

    case 'interactive':
        $body = trim((string)(
            $message['interactive']['button_reply']['title']
            ?? $message['interactive']['list_reply']['title']
            ?? ''
        ));
        break;

    default:
        $body = '[media]';
        break;
}

$waFrom = 'whatsapp:+' . $from;

try {

    $engine = new BotEngine();

    $res = $engine->handleIncoming(
        $waFrom,
        $body,
        $profileName
    );

    $messages = $res['messages'] ?? null;

    if (!is_array($messages) || count($messages) === 0) {
        $messages = [
            [
                'body' => ($res['message'] ?? 'Hola 👋')
            ]
        ];
    }

    foreach ($messages as $m) {
        $send = MetaWhatsAppClient::sendMessageArray($waFrom, $m);
        log_line($logFile, 'SEND: ' . json_encode($send, JSON_UNESCAPED_UNICODE));
    }

} catch (Throwable $e) {

    log_line($logFile, 'ERROR: ' . $e->getMessage());

    MetaWhatsAppClient::sendText(
        $waFrom,
        'Estoy con un problema técnico 😕. Probá nuevamente en unos minutos.'
    );
}

http_response_code(200);
echo 'EVENT_RECEIVED';
