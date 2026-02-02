<?php
require_once __DIR__ . '/Config.php';

class TwilioClient {
    public static function sendWhatsApp(string $toWa, string $fromWa, string $body): array {
        $sid = Config::get('TWILIO_ACCOUNT_SID');
        $token = Config::get('TWILIO_AUTH_TOKEN');
        if (!$sid || !$token) {
            return ['ok' => false, 'error' => 'Falta TWILIO_ACCOUNT_SID / TWILIO_AUTH_TOKEN en .env'];
        }

        $url = "https://api.twilio.com/2010-04-01/Accounts/{$sid}/Messages.json";
        $post = http_build_query([
            'To' => $toWa,
            'From' => $fromWa,
            'Body' => $body,
        ]);

        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_USERPWD, $sid . ':' . $token);
        curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);

        $resp = curl_exec($ch);
        $err = curl_error($ch);
        $code = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($resp === false) {
            return ['ok' => false, 'error' => $err ?: 'Error al llamar a Twilio'];
        }

        $json = json_decode($resp, true);
        if ($code < 200 || $code >= 300) {
            $msg = $json['message'] ?? ('HTTP ' . $code);
            return ['ok' => false, 'error' => $msg, 'http_code' => $code, 'raw' => $resp];
        }

        return ['ok' => true, 'sid' => $json['sid'] ?? null];
    }
}
