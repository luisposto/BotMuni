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
  $res = $engine->handleIncoming($waFrom, $body);
  $msg = $res['message'] ?? 'Hola 👋';
} catch (Throwable $e) {
  log_line($logFile, "ERROR: " . $e->getMessage());
  $msg = "Estoy con un problema técnico 😕. Probá de nuevo en unos minutos.";
}

// Respuesta TwiML
header('Content-Type: text/xml; charset=utf-8');
echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
echo "<Response><Message>" . htmlspecialchars($msg, ENT_XML1 | ENT_COMPAT, 'UTF-8') . "</Message></Response>";
