<?php
require_once __DIR__ . '/Config.php';

class MetaWhatsAppClient {
    private static function apiVersion(): string {
        return Config::get('META_GRAPH_VERSION', 'v20.0') ?: 'v20.0';
    }

    private static function endpoint(): string {
        $phoneNumberId = Config::get('META_PHONE_NUMBER_ID', '');
        return 'https://graph.facebook.com/' . self::apiVersion() . '/' . $phoneNumberId . '/messages';
    }

    public static function normalizePhone(string $phone): string {
        $phone = trim($phone);
        if (str_starts_with($phone, 'whatsapp:')) {
            $phone = substr($phone, 9);
        }
        return preg_replace('/[^0-9]/', '', $phone) ?? '';
    }

    public static function sendText(string $to, string $body): array {
        $to = self::normalizePhone($to);
        $body = trim($body);

        if ($to === '') {
            return ['ok' => false, 'error' => 'Falta destinatario WhatsApp'];
        }
        if ($body === '') {
            return ['ok' => true, 'skipped' => 'Mensaje vacío'];
        }

        return self::sendPayload([
            'messaging_product' => 'whatsapp',
            'recipient_type' => 'individual',
            'to' => $to,
            'type' => 'text',
            'text' => [
                'preview_url' => false,
                'body' => $body,
            ],
        ]);
    }

    public static function sendImage(string $to, string $imageUrl, string $caption = ''): array {
        $to = self::normalizePhone($to);
        $imageUrl = trim($imageUrl);

        if ($to === '') {
            return ['ok' => false, 'error' => 'Falta destinatario WhatsApp'];
        }
        if ($imageUrl === '') {
            return ['ok' => true, 'skipped' => 'Imagen vacía'];
        }

        $image = ['link' => $imageUrl];
        if (trim($caption) !== '') {
            $image['caption'] = trim($caption);
        }

        return self::sendPayload([
            'messaging_product' => 'whatsapp',
            'recipient_type' => 'individual',
            'to' => $to,
            'type' => 'image',
            'image' => $image,
        ]);
    }

    public static function sendMessageArray(string $to, array $message): array {
        $body = trim((string)($message['body'] ?? ''));
        $mediaUrl = trim((string)($message['media_url'] ?? ''));

        if ($mediaUrl !== '') {
            return self::sendImage($to, $mediaUrl, $body);
        }

        return self::sendText($to, $body);
    }

    private static function sendPayload(array $payload): array {
        $token = Config::get('META_ACCESS_TOKEN', '');
        $phoneNumberId = Config::get('META_PHONE_NUMBER_ID', '');

        if (!$token || !$phoneNumberId) {
            return [
                'ok' => false,
                'error' => 'Falta META_ACCESS_TOKEN / META_PHONE_NUMBER_ID en .env',
            ];
        }

        $ch = curl_init(self::endpoint());
        curl_setopt_array($ch, [
            CURLOPT_POST => true,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'Authorization: Bearer ' . $token,
                'Content-Type: application/json',
            ],
            CURLOPT_POSTFIELDS => json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
            CURLOPT_TIMEOUT => 20,
        ]);

        $resp = curl_exec($ch);
        $err = curl_error($ch);
        $code = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($resp === false) {
            return ['ok' => false, 'error' => $err ?: 'Error llamando a Meta Cloud API'];
        }

        $json = json_decode($resp, true);
        if ($code < 200 || $code >= 300) {
            return [
                'ok' => false,
                'error' => $json['error']['message'] ?? ('HTTP ' . $code),
                'http_code' => $code,
                'raw' => $resp,
                'payload' => $payload,
            ];
        }

        return [
            'ok' => true,
            'http_code' => $code,
            'response' => $json,
        ];
    }
}
