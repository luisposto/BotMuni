<?php
require_once __DIR__ . '/../../src/Config.php';
require_once __DIR__ . '/../../src/Auth.php';

Config::loadEnv(__DIR__ . '/../../.env');
Auth::start();

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = trim($_POST['username'] ?? '');
    $p = (string)($_POST['password'] ?? '');
    if (Auth::login($u, $p)) {
        header('Location: index.php');
        exit;
    }
    $error = 'Usuario o contraseña incorrectos.';
}

include __DIR__ . '/_layout.php';
?>
<div class="card" style="max-width:460px; margin:40px auto;">
  <h2>Ingresar</h2>
  <p class="muted">Usá el usuario administrador para gestionar menús y derivaciones.</p>
  <?php if ($error): ?>
    <div class="flash" style="background:#fef2f2; border-color:#fecaca;"><?php echo h($error); ?></div>
  <?php endif; ?>
  <form method="post">
    <label>Usuario</label>
    <input name="username" required />
    <div style="height:10px"></div>
    <label>Contraseña</label>
    <input name="password" type="password" required />
    <div style="height:14px"></div>
    <button class="btn primary" type="submit">Entrar</button>
  </form>
  <p class="muted" style="margin-top:12px; font-size:14px;">Tip: cambiá el usuario/clave por defecto después de instalar.</p>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
