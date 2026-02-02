<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
Auth::requireLogin();
$pdo = Db::pdo();

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$data = ['key_name' => '', 'title' => '', 'message' => ''];

if ($id) {
    $stmt = $pdo->prepare('SELECT id, key_name, title, message FROM bot_nodes WHERE id=?');
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    if ($row) {
        $data = $row;
    }
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $key = strtoupper(trim($_POST['key_name'] ?? ''));
    $title = trim($_POST['title'] ?? '');
    $message = trim($_POST['message'] ?? '');

    if ($key === '' || $title === '' || $message === '') {
        $error = 'Completá key, título y mensaje.';
    } else {
        if ($id) {
            $stmt = $pdo->prepare('UPDATE bot_nodes SET key_name=?, title=?, message=?, updated_at=NOW() WHERE id=?');
            $stmt->execute([$key, $title, $message, $id]);
        } else {
            $stmt = $pdo->prepare('INSERT INTO bot_nodes (key_name, title, message, updated_at) VALUES (?, ?, ?, NOW())');
            $stmt->execute([$key, $title, $message]);
            $id = (int)$pdo->lastInsertId();
        }
        header('Location: nodes.php');
        exit;
    }

    $data = ['key_name' => $key, 'title' => $title, 'message' => $message];
}
?>
<div class="card">
  <h2><?php echo $id ? 'Editar nodo' : 'Nuevo nodo'; ?></h2>
  <?php if ($error): ?>
    <div class="flash" style="background:#fef2f2; border-color:#fecaca;"><?php echo h($error); ?></div>
  <?php endif; ?>
  <form method="post">
    <div class="grid" style="grid-template-columns:1fr 1fr">
      <div>
        <label><strong>Key (única)</strong></label>
        <input name="key_name" value="<?php echo h($data['key_name']); ?>" placeholder="MAIN" required />
        <p class="muted" style="font-size:13px; margin:8px 0 0">Ejemplos: MAIN, LICENSE_MENU, FINES_MENU</p>
      </div>
      <div>
        <label><strong>Título</strong></label>
        <input name="title" value="<?php echo h($data['title']); ?>" placeholder="Menú Principal" required />
      </div>
    </div>
    <div style="height:10px"></div>
    <label><strong>Mensaje</strong></label>
    <textarea name="message" required><?php echo h($data['message']); ?></textarea>
    <div style="height:12px"></div>
    <div class="row">
      <button class="btn primary" type="submit">Guardar</button>
      <a class="btn" href="nodes.php">Volver</a>
      <?php if ($id): ?>
        <a class="btn" href="options.php?node_id=<?php echo (int)$id; ?>">Editar opciones</a>
      <?php endif; ?>
    </div>
  </form>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
