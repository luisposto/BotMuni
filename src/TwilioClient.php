<?php
require_once __DIR__ . '/MetaWhatsAppClient.php';

class TwilioClient {
    /**
     * Compatibilidad para no romper el BotEngine actual.
     * Internamente usa Meta Cloud API.
     */
    public static function sendWhatsApp(string $toWa, string $fromWa, string $body): array {
        return MetaWhatsAppClient::sendText($toWa, $body);
    }
}
