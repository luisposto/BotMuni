<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();
$pdo = Db::pdo();

$q = trim($_GET['q'] ?? '');
if ($q !== '') {
    $stmt = $pdo->prepare('SELECT * FROM message_logs WHERE wa_from LIKE ? OR body LIKE ? ORDER BY id DESC LIMIT 200');
    $like = '%' . $q . '%';
    $stmt->execute([$like, $like]);
    $rows = $stmt->fetchAll();
} else {
    $rows = $pdo->query('SELECT * FROM message_logs ORDER BY id DESC LIMIT 200')->fetchAll();
}
?>
<div class="card">
  <div class="row" style="justify-content:space-between">
    <h2>Logs de mensajes</h2>
    <span class="muted">Últimos 200</span>
  </div>
  <form method="get" class="row" style="margin:12px 0">
    <input name="q" value="<?php echo h($q); ?>" placeholder="buscar por número o texto..." style="max-width:420px">
    <button class="btn" type="submit">Buscar</button>
    <?php if ($q !== ''): ?>
      <a class="btn" href="logs.php">Limpiar</a>
    <?php endif; ?>
  </form>
  <table>
    <thead>
      <tr>
        <th>ID</th><th>Usuario</th><th>Dir</th><th>Fecha</th><th>Mensaje</th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($rows as $r): ?>
        <tr>
          <td><?php echo (int)$r['id']; ?></td>
          <td><code><?php echo h($r['wa_from']); ?></code></td>
          <td><strong><?php echo h($r['direction']); ?></strong></td>
          <td class="muted"><?php echo h($r['created_at']); ?></td>
          <td style="white-space:pre-wrap"><?php echo h($r['body']); ?></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
