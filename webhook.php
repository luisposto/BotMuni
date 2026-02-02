<?php
declare(strict_types=1);

// --- Hardening / debugging ---
ini_set('display_errors', '0');
error_reporting(E_ALL);

function log_line(string $file, $data): void {
  @file_put_contents($file, date('Y-m-d H:i:s') . " - " . $data . PHP_EOL, FILE_APPEND);
}

$baseDir = __DIR__; // public_html
$logFile = $baseDir . '/logs/debug.txt';

// Cargar clases (en tu estructura src está dentro de public_html)
require_once $baseDir . '/src/Config.php';
require_once $baseDir . '/src/BotEngine.php';
require_once $baseDir . '/src/TwilioValidator.php';

// Cargar .env (en public_html/.env)
Config::loadEnv($baseDir . '/.env');

// Log de entrada (para ver qué llega)
log_line($logFile, json_encode($_POST));

// Si alguien abre por navegador (GET), devolvemos OK
if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
  header('Content-Type: text/plain; charset=utf-8');
  echo "OK - webhook activo";
  exit;
}

// Twilio manda POST con campos tipo: From=whatsapp:+... Body=...
$waFrom = $_POST['From'] ?? '';
$body   = $_POST['Body'] ?? '';
$profileName = $_POST['ProfileName'] ?? ''; // ✅ Nombre del contacto en WhatsApp

// Normalizar Body (evita espacios raros que rompen option_key)
$body = preg_replace('/\s+/u', ' ', trim((string)$body));

// Validación de firma Twilio (si hay token configurado)
$signature = $_SERVER['HTTP_X_TWILIO_SIGNATURE'] ?? '';
$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host   = $_SERVER['HTTP_HOST'] ?? '';
$uri    = $_SERVER['REQUEST_URI'] ?? '/webhook.php';
$url    = $scheme . '://' . $host . $uri;

if ($signature) {
  $ok = TwilioValidator::validateRequest($url, $_POST, $signature);
  if (!$ok) {
    http_response_code(403);
    header('Content-Type: text/plain; charset=utf-8');
    echo "Forbidden";
    exit;
  }
}

try {
  $engine = new BotEngine();
  $res = $engine->handleIncoming($waFrom, $body, $profileName);

  // Soporta: single message (message) o múltiples (messages)
  $messages = $res['messages'] ?? null;
  if (!is_array($messages) || count($messages) === 0) {
    $messages = [
      ['body' => ($res['message'] ?? 'Hola 👋')]
    ];
  }
} catch (Throwable $e) {
  log_line($logFile, "ERROR: " . $e->getMessage());
  $messages = [
    ['body' => "Estoy con un problema técnico 😕. Probá de nuevo en unos minutos."]
  ];
}

// Log de salida (para ver exactamente qué se envía)
log_line($logFile, 'OUT: ' . json_encode($messages, JSON_UNESCAPED_UNICODE));

// Respuesta TwiML (multi-message + media)
header('Content-Type: text/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
echo "<Response>";

foreach ($messages as $m) {
  $bodyOut = $m['body'] ?? '';
  $media   = $m['media_url'] ?? '';

  echo "<Message>";
  if ($bodyOut !== '') {
    echo "<Body>" . htmlspecialchars($bodyOut, ENT_XML1 | ENT_COMPAT, 'UTF-8') . "</Body>";
  }
  if ($media !== '') {
    echo "<Media>" . htmlspecialchars($media, ENT_XML1 | ENT_COMPAT, 'UTF-8') . "</Media>";
  }
  echo "</Message>";
}

echo "</Response>";
