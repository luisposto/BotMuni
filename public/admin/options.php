<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();
$pdo = Db::pdo();

$nodeId = isset($_GET['node_id']) ? (int)$_GET['node_id'] : 0;
$stmt = $pdo->prepare('SELECT id, key_name, title FROM bot_nodes WHERE id=?');
$stmt->execute([$nodeId]);
$node = $stmt->fetch();
if (!$node) {
    echo "<div class='card'>Nodo no encontrado. <a class='btn' href='nodes.php'>Volver</a></div>";
    include __DIR__ . '/_footer.php';
    exit;
}

if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare('DELETE FROM bot_options WHERE id=? AND node_id=?')->execute([$id, $nodeId]);
    header('Location: options.php?node_id=' . $nodeId);
    exit;
}

$rows = $pdo->prepare('SELECT * FROM bot_options WHERE node_id=? ORDER BY sort_order ASC, id ASC');
$rows->execute([$nodeId]);
$options = $rows->fetchAll();
?>
<div class="card">
  <div class="row" style="justify-content:space-between">
    <div>
      <h2>Opciones</h2>
      <div class="muted">Nodo: <code><?php echo h($node['key_name']); ?></code> — <?php echo h($node['title']); ?></div>
    </div>
    <div class="row">
      <a class="btn" href="nodes.php">Volver a nodos</a>
      <a class="btn primary" href="option_edit.php?node_id=<?php echo (int)$nodeId; ?>">+ Nueva opción</a>
    </div>
  </div>
  <table>
    <thead>
      <tr>
        <th>Key</th><th>Label</th><th>Acción</th><th>Valor</th><th>Orden</th><th></th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($options as $o): ?>
        <tr>
          <td><code><?php echo h($o['option_key']); ?></code></td>
          <td><?php echo h($o['label']); ?></td>
          <td><code><?php echo h($o['action_type']); ?></code></td>
          <td class="muted"><?php echo h((string)$o['action_value']); ?></td>
          <td><?php echo (int)$o['sort_order']; ?></td>
          <td>
            <div class="row">
              <a class="btn" href="option_edit.php?node_id=<?php echo (int)$nodeId; ?>&id=<?php echo (int)$o['id']; ?>">Editar</a>
              <a class="btn danger" href="options.php?node_id=<?php echo (int)$nodeId; ?>&delete=<?php echo (int)$o['id']; ?>" onclick="return confirm('¿Borrar opción?')">Borrar</a>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
