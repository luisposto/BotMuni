<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();
$pdo = Db::pdo();

$nodeId = isset($_GET['node_id']) ? (int)$_GET['node_id'] : 0;
$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

$stmt = $pdo->prepare('SELECT id, key_name, title FROM bot_nodes WHERE id=?');
$stmt->execute([$nodeId]);
$node = $stmt->fetch();
if (!$node) {
    echo "<div class='card'>Nodo no encontrado. <a class='btn' href='nodes.php'>Volver</a></div>";
    include __DIR__ . '/_footer.php';
    exit;
}

$data = ['option_key'=>'','label'=>'','action_type'=>'GOTO_NODE','action_value'=>'','sort_order'=>0];
if ($id) {
    $stmt = $pdo->prepare('SELECT * FROM bot_options WHERE id=? AND node_id=?');
    $stmt->execute([$id, $nodeId]);
    $row = $stmt->fetch();
    if ($row) $data = $row;
}

$actionTypes = ['GOTO_NODE','SHOW_TEXT','HUMAN_HANDOFF','RESET'];

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $okey = trim($_POST['option_key'] ?? '');
    $label = trim($_POST['label'] ?? '');
    $atype = trim($_POST['action_type'] ?? 'GOTO_NODE');
    $aval = trim($_POST['action_value'] ?? '');
    $order = (int)($_POST['sort_order'] ?? 0);

    if ($okey === '' || $label === '') {
        $error = 'Completá key y label.';
    } elseif (!in_array($atype, $actionTypes, true)) {
        $error = 'Tipo de acción inválida.';
    } else {
        if ($id) {
            $stmt = $pdo->prepare('UPDATE bot_options SET option_key=?, label=?, action_type=?, action_value=?, sort_order=? WHERE id=? AND node_id=?');
            $stmt->execute([$okey, $label, $atype, $aval, $order, $id, $nodeId]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES (?, ?, ?, ?, ?, ?)');
            $stmt->execute([$nodeId, $okey, $label, $atype, $aval, $order]);
        }
        header('Location: options.php?node_id=' . $nodeId);
        exit;
    }

    $data = ['option_key'=>$okey,'label'=>$label,'action_type'=>$atype,'action_value'=>$aval,'sort_order'=>$order];
}

// lista de nodos para GOTO_NODE
$allNodes = $pdo->query('SELECT id, key_name, title FROM bot_nodes ORDER BY id ASC')->fetchAll();
?>
<div class="card">
  <h2><?php echo $id ? 'Editar opción' : 'Nueva opción'; ?></h2>
  <div class="muted">Nodo: <code><?php echo h($node['key_name']); ?></code> — <?php echo h($node['title']); ?></div>
  <?php if ($error): ?>
    <div class="flash" style="background:#fef2f2; border-color:#fecaca; margin-top:10px;"><?php echo h($error); ?></div>
  <?php endif; ?>

  <form method="post" style="margin-top:12px">
    <div class="grid" style="grid-template-columns:1fr 2fr">
      <div>
        <label><strong>Key</strong> (lo que el usuario escribe)</label>
        <input name="option_key" value="<?php echo h($data['option_key']); ?>" placeholder="1" required />
        <p class="muted" style="font-size:13px; margin:8px 0 0">Ej: 1, 2, 9, 0, MENU</p>
      </div>
      <div>
        <label><strong>Label</strong> (lo que se muestra en el menú)</label>
        <input name="label" value="<?php echo h($data['label']); ?>" placeholder="Sacar licencia" required />
      </div>
    </div>

    <div style="height:10px"></div>
    <div class="grid" style="grid-template-columns:1fr 1fr">
      <div>
        <label><strong>Tipo de acción</strong></label>
        <select name="action_type" id="action_type">
          <?php foreach ($actionTypes as $t): ?>
            <option value="<?php echo h($t); ?>" <?php echo $data['action_type']===$t ? 'selected' : ''; ?>><?php echo h($t); ?></option>
          <?php endforeach; ?>
        </select>
        <p class="muted" style="font-size:13px; margin:8px 0 0">
          GOTO_NODE: navega a otro menú · SHOW_TEXT: muestra texto · HUMAN_HANDOFF: deriva · RESET: vuelve a MAIN
        </p>
      </div>
      <div>
        <label><strong>Valor</strong> (según acción)</label>
        <input name="action_value" value="<?php echo h((string)$data['action_value']); ?>" placeholder="ID del nodo o texto" />
        <p class="muted" style="font-size:13px; margin:8px 0 0">
          Para GOTO_NODE poné el ID del nodo destino (ej: 2). Para SHOW_TEXT poné el texto a mostrar.
        </p>
      </div>
    </div>

    <div style="height:10px"></div>
    <div>
      <label><strong>Orden</strong></label>
      <input type="number" name="sort_order" value="<?php echo (int)$data['sort_order']; ?>" />
    </div>

    <div style="height:12px"></div>
    <div class="row">
      <button class="btn primary" type="submit">Guardar</button>
      <a class="btn" href="options.php?node_id=<?php echo (int)$nodeId; ?>">Volver</a>
    </div>

    <div class="card" style="background:#f9fafb; border-style:dashed; margin-top:14px">
      <strong>Ayuda rápida para GOTO_NODE</strong>
      <p class="muted" style="margin-top:6px">Estos son los nodos disponibles y su ID:</p>
      <table>
        <thead><tr><th>ID</th><th>Key</th><th>Título</th></tr></thead>
        <tbody>
          <?php foreach ($allNodes as $n): ?>
            <tr>
              <td><?php echo (int)$n['id']; ?></td>
              <td><code><?php echo h($n['key_name']); ?></code></td>
              <td><?php echo h($n['title']); ?></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </form>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
