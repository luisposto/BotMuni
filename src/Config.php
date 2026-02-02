<?php

/**
 * Config loader sencillo.
 * Lee .env con formato KEY=VALUE.
 */
class Config {
    private static array $env = [];

    public static function loadEnv(string $path): void {
        if (!file_exists($path)) {
            return;
        }
        $lines = file($path, FILE_IGNORE_NEW_LINES);
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line === '' || str_starts_with($line, '#')) {
                continue;
            }
            $pos = strpos($line, '=');
            if ($pos === false) {
                continue;
            }
            $key = trim(substr($line, 0, $pos));
            $val = trim(substr($line, $pos + 1));
            // strip quotes
            if ((str_starts_with($val, '"') && str_ends_with($val, '"')) || (str_starts_with($val, "'") && str_ends_with($val, "'"))) {
                $val = substr($val, 1, -1);
            }
            self::$env[$key] = $val;
            // also set to $_ENV for convenience
            $_ENV[$key] = $val;
        }
    }

    public static function get(string $key, ?string $default = null): ?string {
        if (array_key_exists($key, self::$env)) {
            return self::$env[$key];
        }
        if (isset($_ENV[$key])) {
            return (string)$_ENV[$key];
        }
        $v = getenv($key);
        if ($v !== false) {
            return (string)$v;
        }
        return $default;
    }
}
