<?php
require_once __DIR__ . '/../src/Config.php';
Config::loadEnv(__DIR__ . '/../.env');
?><!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Bot Tránsito</title>
  <style>body{font-family:system-ui; padding:24px} code{background:#f3f4f6; padding:2px 6px; border-radius:6px}</style>
</head>
<body>
  <h1>Bot Tránsito - San Fernando Municipio</h1>
  <p>Webhook: <code><?php echo htmlspecialchars(rtrim(Config::get('APP_URL',''),'/') . '/webhook.php'); ?></code></p>
  <p>Admin: <a href="admin/login.php">/admin</a></p>
</body>
</html>
