<?php
require_once __DIR__ . '/Db.php';

class Auth {
    public static function start(): void {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    public static function isLoggedIn(): bool {
        self::start();
        return isset($_SESSION['admin_id']);
    }

    public static function requireLogin(): void {
        if (!self::isLoggedIn()) {
            header('Location: login.php');
            exit;
        }
    }

    public static function login(string $username, string $password): bool {
        self::start();
        $pdo = Db::pdo();
        $stmt = $pdo->prepare('SELECT id, username, password_hash FROM admin_users WHERE username=? LIMIT 1');
        $stmt->execute([$username]);
        $row = $stmt->fetch();
        if (!$row) return false;
        if (!password_verify($password, $row['password_hash'])) return false;
        $_SESSION['admin_id'] = (int)$row['id'];
        $_SESSION['admin_username'] = $row['username'];
        return true;
    }

    public static function logout(): void {
        self::start();
        session_destroy();
    }
}
