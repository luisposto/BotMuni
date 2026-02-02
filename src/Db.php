<?php
require_once __DIR__ . '/Config.php';

class Db {
    private static ?PDO $pdo = null;

    public static function pdo(): PDO {
        if (self::$pdo) return self::$pdo;

        $host = Config::get('DB_HOST', 'localhost');
        $port = Config::get('DB_PORT', '3306');
        $db   = Config::get('DB_NAME', 'u729363490_transito_bot');
        $user = Config::get('DB_USER', 'u729363490_transito_bot');
        $pass = Config::get('DB_PASS', 'Hosting01-++');

        $dsn = "mysql:host={$host};port={$port};dbname={$db};charset=utf8mb4";
        $opt = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ];
        self::$pdo = new PDO($dsn, $user, $pass, $opt);
        return self::$pdo;
    }
}
