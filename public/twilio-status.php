<?php
file_put_contents(__DIR__ . '/../logs/twilio_status.txt',
  date('Y-m-d H:i:s') . " - " . json_encode($_POST) . PHP_EOL,
  FILE_APPEND
);
http_response_code(200);
echo "OK";