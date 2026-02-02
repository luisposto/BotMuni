<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Db.php';
require_once __DIR__ . '/../../src/TwilioClient.php';
Auth::requireLogin();
$pdo = Db::pdo();

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$stmt = $pdo->prepare('SELECT * FROM handoff_requests WHERE id=?');
$stmt->execute([$id]);
$h = $stmt->fetch();
if (!$h) {
    echo "<div class='card'>Derivación no encontrada. <a class='btn' href='handoff.php'>Volver</a></div>";
    include __DIR__ . '/_footer.php';
    exit;
}

$flash = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $reply = trim($_POST['reply'] ?? '');
    $fromWa = trim($_POST['from_wa'] ?? '');

    if ($reply === '' || $fromWa === '') {
        $error = 'Completá el mensaje y el From de Twilio WhatsApp.';
    } else {
        $res = TwilioClient::sendWhatsApp($h['wa_from'], $fromWa, $reply);
        if (!$res['ok']) {
            $error = 'Error enviando por Twilio: ' . ($res['error'] ?? '');
        } else {
            // guardar mensaje agente
            $stmt = $pdo->prepare('INSERT INTO handoff_messages (handoff_id, sender, body, created_at) VALUES (?, "AGENT", ?, NOW())');
            $stmt->execute([$id, $reply]);
            $flash = 'Mensaje enviado ✅';
        }
    }
}

$msgs = $pdo->prepare('SELECT sender, body, created_at FROM handoff_messages WHERE handoff_id=? ORDER BY id ASC');
$msgs->execute([$id]);
$messages = $msgs->fetchAll();

$defaultFromWa = Config::get('TWILIO_WHATSAPP_FROM', 'whatsapp:+14155238886');
// Nota: el "From" real debe ser tu número de WhatsApp de Twilio (o el Sandbox)

?>
<div class="card">
  <div class="row" style="justify-content:space-between">
    <div>
      <h2>Derivación #<?php echo (int)$h['id']; ?></h2>
      <div class="muted">Usuario: <code><?php echo h($h['wa_from']); ?></code> · Derivado a: <code><?php echo h((string)($h['target_wa'] ?? '')); ?></code> · Estado: <strong><?php echo h($h['status']); ?></strong></div>
    </div>
    <div class="row">
      <a class="btn" href="handoff.php">Volver</a>
      <?php if ($h['status'] === 'OPEN'): ?>
        <a class="btn danger" href="handoff.php?close=<?php echo (int)$h['id']; ?>" onclick="return confirm('¿Cerrar derivación?')">Cerrar</a>
      <?php endif; ?>
    </div>
  </div>

  <?php if ($flash): ?>
    <div class="flash" style="margin-top:10px"><?php echo h($flash); ?></div>
  <?php endif; ?>
  <?php if ($error): ?>
    <div class="flash" style="margin-top:10px; background:#fef2f2; border-color:#fecaca;"><?php echo h($error); ?></div>
  <?php endif; ?>

  <div class="card" style="background:#f9fafb; border-style:dashed; margin-top:12px">
    <strong>Mensajes</strong>
    <div style="margin-top:10px">
      <?php if (!$messages): ?>
        <p class="muted">Todavía no hay mensajes guardados. (Se registran cuando el usuario escribe estando en modo HUMANO.)</p>
      <?php endif; ?>
      <?php foreach ($messages as $m): ?>
        <div class="card" style="margin:10px 0; background:#fff">
          <div class="row" style="justify-content:space-between">
            <strong><?php echo h($m['sender']); ?></strong>
            <span class="muted" style="font-size:13px"><?php echo h($m['created_at']); ?></span>
          </div>
          <div style="white-space:pre-wrap; margin-top:8px"><?php echo h($m['body']); ?></div>
        </div>
      <?php endforeach; ?>
    </div>
  </div>

  <div class="card" style="margin-top:12px">
    <h3>Responder por WhatsApp (opcional)</h3>
    <p class="muted">Esto usa la API de Twilio (requiere <code>TWILIO_ACCOUNT_SID</code> y <code>TWILIO_AUTH_TOKEN</code> en .env). El From debe ser tu número habilitado en Twilio (o el Sandbox).</p>
    <form method="post">
      <label><strong>From (Twilio WhatsApp)</strong></label>
      <input name="from_wa" value="<?php echo h($defaultFromWa); ?>" placeholder="whatsapp:+1415..." />
      <div style="height:10px"></div>
      <label><strong>Mensaje</strong></label>
      <textarea name="reply" placeholder="Hola, te atiende Tránsito..." required></textarea>
      <div style="height:12px"></div>
      <button class="btn primary" type="submit">Enviar</button>
    </form>
  </div>
</div>
<?php include __DIR__ . '/_footer.php'; ?>
