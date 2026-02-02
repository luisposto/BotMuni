<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();
$pdo = Db::pdo();

if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    // borrar opciones primero
    $pdo->prepare('DELETE FROM bot_options WHERE node_id=?')->execute([$id]);
    $pdo->prepare('DELETE FROM bot_nodes WHERE id=?')->execute([$id]);
    header('Location: nodes.php');
    exit;
}

$rows = $pdo->query('SELECT id, key_name, title, updated_at FROM bot_nodes ORDER BY id ASC')->fetchAll();
?>
<div class="card">
  <div class="row" style="justify-content:space-between">
    <h2>Menús / Nodos</h2>
    <a class="btn primary" href="node_edit.php">+ Nuevo nodo</a>
  </div>
  <table>
    <thead>
      <tr>
        <th>ID</th><th>Key</th><th>Título</th><th>Actualizado</th><th></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($rows as $r): ?>
        <tr>
          <td><?php echo (int)$r['id']; ?></td>
          <td><code><?php echo h($r['key_name']); ?></code></td>
          <td><?php echo h($r['title']); ?></td>
          <td class="muted"><?php echo h((string)$r['updated_at']); ?></td>
          <td>
            <div class="row">
              <a class="btn" href="node_edit.php?id=<?php echo (int)$r['id']; ?>">Editar</a>
              <a class="btn" href="options.php?node_id=<?php echo (int)$r['id']; ?>">Opciones</a>
              <a class="btn danger" href="nodes.php?delete=<?php echo (int)$r['id']; ?>" onclick="return confirm('¿Borrar nodo y sus opciones?')">Borrar</a>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
