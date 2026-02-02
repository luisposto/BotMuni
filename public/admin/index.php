<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();

$pdo = Db::pdo();
$nodes = (int)$pdo->query('SELECT COUNT(*) FROM bot_nodes')->fetchColumn();
$options = (int)$pdo->query('SELECT COUNT(*) FROM bot_options')->fetchColumn();
$openH = (int)$pdo->query("SELECT COUNT(*) FROM handoff_requests WHERE status='OPEN'")->fetchColumn();
$logs = (int)$pdo->query('SELECT COUNT(*) FROM message_logs')->fetchColumn();
?>
<div class="grid">
  <div class="card">
    <h2>Resumen</h2>
    <div class="row">
      <div><strong>Menús:</strong> <?php echo $nodes; ?></div>
      <div><strong>Opciones:</strong> <?php echo $options; ?></div>
      <div><strong>Derivaciones abiertas:</strong> <?php echo $openH; ?></div>
      <div><strong>Logs:</strong> <?php echo $logs; ?></div>
    </div>
    <p class="muted">Este admin te deja editar el árbol de menús del bot sin tocar código.</p>
    <div class="row">
      <a class="btn primary" href="nodes.php">Gestionar menús</a>
      <a class="btn" href="handoff.php">Ver derivaciones</a>
      <a class="btn" href="logs.php">Ver logs</a>
    </div>
  </div>
  <div class="card">
    <h2>Webhooks</h2>
    <p>En Twilio, configurá el webhook de WhatsApp para apuntar a:</p>
    <div class="card" style="background:#f9fafb; border-style:dashed">
      <code><?php echo h(Config::get('APP_URL','http://tu-dominio') . '/webhook.php'); ?></code>
    </div>
    <p class="muted">Si estás en Hostinger, asegurate de que <code>public/</code> sea el docroot o mapealo con un subdominio/carpeta.</p>
  </div>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
