<?php
require_once __DIR__ . '/../../src/Config.php';
require_once __DIR__ . '/../../src/Auth.php';

Config::loadEnv(__DIR__ . '/../../.env');
Auth::start();

function h(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }

?><!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Bot Tránsito - San Fernando Municipio</title>
  <style>
    body{font-family:system-ui, -apple-system, Segoe UI, Roboto, Arial; margin:0; background:#f6f7f9; color:#111;}
    .top{background:#111827; color:#fff; padding:12px 16px; display:flex; align-items:center; justify-content:space-between;}
    .top a{color:#fff; text-decoration:none; margin-right:12px; opacity:.9}
    .top a:hover{opacity:1}
    .wrap{max-width:1100px; margin:18px auto; padding:0 12px;}
    .card{background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:16px; box-shadow:0 1px 2px rgba(0,0,0,.04);}
    .grid{display:grid; grid-template-columns:1fr; gap:12px;}
    @media(min-width:900px){.grid{grid-template-columns:1fr 1fr;}}
    table{width:100%; border-collapse:collapse;}
    th,td{padding:10px; border-bottom:1px solid #eee; text-align:left;}
    th{background:#f3f4f6; font-weight:600}
    .btn{display:inline-block; padding:9px 12px; border-radius:10px; border:1px solid #d1d5db; background:#fff; color:#111; text-decoration:none; cursor:pointer}
    .btn.primary{background:#2563eb; border-color:#2563eb; color:#fff}
    .btn.danger{background:#dc2626; border-color:#dc2626; color:#fff}
    .row{display:flex; gap:10px; flex-wrap:wrap; align-items:center}
    .muted{color:#6b7280}
    input,textarea,select{width:100%; padding:10px; border:1px solid #d1d5db; border-radius:10px;}
    textarea{min-height:120px}
    .flash{padding:10px; border-radius:10px; background:#ecfeff; border:1px solid #a5f3fc;}
  </style>
</head>
<body>
  <div class="top">
    <div>
      <strong>Bot Tránsito - San Fernando Municipio</strong>
      <span class="muted" style="color:#c7cbd1; margin-left:8px;"></span>
    </div>
    <div>
      <?php if (Auth::isLoggedIn()): ?>
        <a href="index.php">Dashboard</a>
        <a href="nodes.php">Menús</a>
        <a href="handoff.php">Derivaciones</a>
        <a href="logs.php">Logs</a>
        <a href="logout.php">Salir (<?php echo h($_SESSION['admin_username'] ?? ''); ?>)</a>
      <?php endif; ?>
    </div>
  </div>
  <div class="wrap">
