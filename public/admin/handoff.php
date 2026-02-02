<?php
require_once __DIR__ . '/_layout.php';
require_once __DIR__ . '/../../src/Config.php';
require_once __DIR__ . '/../../src/Db.php';

Config::loadEnv(__DIR__ . '/.env');

$db = Db::pdo();
$rows = $db->query("
    SELECT id, wa_from, target_wa, status, created_at
    FROM handoff_requests
    ORDER BY id DESC
")->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Derivaciones a Agente</title>

    <!-- MISMOS CSS QUE nodes.php -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/style.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">

    <h2 class="mb-3">📞 Derivaciones a Agente</h2>

    <?php if (!$rows): ?>
        <div class="alert alert-info">
            No hay derivaciones registradas todavía.<br>
            Probá desde WhatsApp enviar <b>9 – Chateá con agente</b>.
        </div>
    <?php else: ?>
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-striped mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>WhatsApp Usuario</th>
                            <th>Agente</th>
                            <th>Estado</th>
                            <th>Fecha</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($rows as $r): ?>
                            <tr>
                                <td><?= $r['id'] ?></td>
                                <td><?= htmlspecialchars($r['wa_from']) ?></td>
                                <td><?= htmlspecialchars($r['target_wa']) ?></td>
                                <td>
                                    <span class="badge <?= $r['status']==='open' ? 'bg-warning' : 'bg-success' ?>">
                                        <?= $r['status'] ?>
                                    </span>
                                </td>
                                <td><?= $r['created_at'] ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    <?php endif; ?>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- auto refresh cada 15s (opcional, queda muy bien) -->
<script>
setTimeout(() => location.reload(), 15000);
</script>

</body>
</html>
