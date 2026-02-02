<?php
require_once __DIR__ . '/Config.php';

class TwilioValidator {
    public static function validateRequest(string $url, array $params, string $signature): bool {
        $token = Config::get('TWILIO_AUTH_TOKEN');
        if (!$token) {
            // si no hay token, no valida
            return true;
        }
        ksort($params);
        $data = $url;
        foreach ($params as $key => $value) {
            $data .= $key . $value;
        }
        $expected = base64_encode(hash_hmac('sha1', $data, $token, true));
        // comparación segura
        return hash_equals($expected, $signature);
    }
}
