-- Usuario admin por defecto (CAMBIAR!)
INSERT INTO admin_users (username, password_hash) VALUES
('admin', '$2y$10$TDTQlW/LUxKSeK1/6RkzZO4Sl5xswd/jnHlmJY1hxC6imHxl8Yx22')
ON DUPLICATE KEY UPDATE username=username;

-- Nodos base (San Fernando)
INSERT INTO bot_nodes (key_name, title, message) VALUES
('MAIN', 'Menú Principal', 'Hola 👋 Soy el asistente de Tránsito de San Fernando. Elegí una opción:'),
('LICENSE_MENU', 'Licencias', 'Licencias 🚗🪪 — elegí una opción:'),
('FINES_MENU', 'Multas', 'Multas 🧾 — elegí una opción:'),
('TURNS_MENU', 'Turnos', 'Turnos 📅 — elegí una opción:'),
('CONTACT_MENU', 'Contacto', 'Contacto 📍☎️ — elegí una opción:')
ON DUPLICATE KEY UPDATE key_name=key_name;

-- Variables con IDs
SET @MAIN := (SELECT id FROM bot_nodes WHERE key_name='MAIN' LIMIT 1);
SET @LIC := (SELECT id FROM bot_nodes WHERE key_name='LICENSE_MENU' LIMIT 1);
SET @FIN := (SELECT id FROM bot_nodes WHERE key_name='FINES_MENU' LIMIT 1);
SET @TUR := (SELECT id FROM bot_nodes WHERE key_name='TURNS_MENU' LIMIT 1);
SET @CON := (SELECT id FROM bot_nodes WHERE key_name='CONTACT_MENU' LIMIT 1);

-- Limpiar opciones (solo las de estos nodos)
DELETE FROM bot_options WHERE node_id IN (@MAIN, @LIC, @FIN, @TUR, @CON);

-- Links oficiales
SET @URL_LIC := 'https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir';
SET @URL_TUR := 'https://www1.diphot.com.ar/san-fernando-transito/';
SET @URL_ANSV := 'https://curso.seguridadvial.gob.ar';

-- Opciones MAIN
INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES
(@MAIN, '1', 'Licencias (sacar / renovar)', 'GOTO_NODE', @LIC, 10),
(@MAIN, '2', 'Multas (consulta / pago / descargo)', 'GOTO_NODE', @FIN, 20),
(@MAIN, '3', 'Turnos online', 'GOTO_NODE', @TUR, 30),
(@MAIN, '4', 'Contacto / ubicación / horarios', 'GOTO_NODE', @CON, 40),
(@MAIN, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(@MAIN, '0', 'Volver al menú principal', 'RESET', '', 99);

-- LICENCIAS
INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES
(@LIC, '1', 'Primera licencia (original / principiante)', 'SHOW_TEXT', CONCAT(
'ORIGINAL / PRINCIPIANTE\n',
'✅ Charla de Educación Vial (ANSV) gratuita: ', @URL_ANSV, '\n',
'📌 Luego pedí turno online: ', @URL_TUR, '\n\n',
'Documentación (según info municipal):\n',
'• DNI (original + 1 fotocopia)\n',
'• Certificado ANSV impreso (se valida mostrando el mail recibido)\n',
'• Menores (16/17): autorización de escribano o juez de paz\n\n',
'Info completa y categorías/edades: ', @URL_LIC
), 10),
(@LIC, '2', 'Renovación de licencia (particular)', 'SHOW_TEXT', CONCAT(
'RENOVACIÓN (PARTICULAR)\n',
'📌 Si el vencimiento supera 90 días: teórico + práctico (el municipio no provee vehículo para exámenes).\n',
'🧾 Requisitos y casos (licencia local / nacional / otras provincias): ver detalle oficial acá:\n',
@URL_LIC
), 20),
(@LIC, '3', 'Licencia vencida +90 días (original con vencida)', 'SHOW_TEXT', CONCAT(
'LICENCIA VENCIDA +90 DÍAS\n',
'• DNI con domicilio en San Fernando + licencia vencida (originales + 1 fotocopia)\n',
'• Rinde teórico y práctico (sin vehículo provisto por el municipio)\n\n',
'Detalle oficial: ', @URL_LIC
), 30),
(@LIC, '4', 'Dónde queda / horarios del área', 'SHOW_TEXT', CONCAT(
'📍 Centro de Tránsito y Gestión: Colectora (Ex Combatiente Juan C. Reguera) 1447, San Fernando.\n',
'⏰ Trámite de licencias: Lun a Vie 7:30 a 12:30 y 2° sábado de cada mes 8:00 a 12:00 (con turno).\n',
'🔗 Turnos: ', @URL_TUR, '\n',
'🔗 Info oficial: ', @URL_LIC
), 40),
(@LIC, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(@LIC, '0', 'Menú principal', 'RESET', '', 99);

-- MULTAS
INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES
(@FIN, '1', 'Consultar multas (qué necesitás)', 'SHOW_TEXT',
'🔎 Para consultar multas normalmente necesitás: patente y/o DNI, o el nro de acta (según sistema).\n\nSi querés que te lo gestione un agente, elegí 9.', 10),
(@FIN, '2', 'Pago / planes', 'SHOW_TEXT',
'🧾 Pago: puede ser online o presencial según el tipo de infracción.\nSi te falta un dato o querés un descargo, te conviene hablar con un agente (opción 9).', 20),
(@FIN, '3', 'Descargo / infracción', 'SHOW_TEXT',
'✍️ Descargo: presentá documentación y fundamento dentro del plazo.\nSi tenés nro de acta o patente, te deriva un agente (opción 9).', 30),
(@FIN, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(@FIN, '0', 'Menú principal', 'RESET', '', 99);

-- TURNOS
INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES
(@TUR, '1', 'Solicitar turno online (Licencias)', 'SHOW_TEXT', CONCAT(
'📅 Turnos online (San Fernando): ', @URL_TUR, '\n\n',
'Te pide DNI + email. Te llega un correo para entrar al sistema y elegir fecha/hora.\n',
'Info del área de licencias: ', @URL_LIC
), 10),
(@TUR, '2', 'No me llegó el mail / problemas con el turno', 'SHOW_TEXT',
'📩 Revisá spam/no deseado. Si no llega o te da error, elegí 9 y te deriva a un agente.', 20),
(@TUR, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(@TUR, '0', 'Menú principal', 'RESET', '', 99);

-- CONTACTO
INSERT INTO bot_options (node_id, option_key, label, action_type, action_value, sort_order) VALUES
(@CON, '1', 'Ubicación', 'SHOW_TEXT',
'📍 Centro de Tránsito y Gestión (Licencias): Colectora (Ex Combatiente Juan C. Reguera) 1447, San Fernando.\n(Al lado del nuevo Cuartel de Bomberos).', 10),
(@CON, '2', 'Horarios', 'SHOW_TEXT',
'⏰ Licencias: Lun a Vie 7:30 a 12:30hs; y 2° sábado de cada mes 8:00 a 12:00hs (con turno).\n\n🚗 Retiro de autos acarreados: Lun a Vie 7:30 a 18:50hs.\n\n📦 Permisos (carga/descarga, volquetes, mudanzas, etc.): Lun a Vie 8:00 a 14:00hs.', 20),
(@CON, '3', 'Atención vecinal', 'SHOW_TEXT',
'☎️ Atención vecinal: 0800-777-6864\n✉️ vecinos@sanfernando.gov.ar', 30),
(@CON, '4', 'Links oficiales', 'SHOW_TEXT', CONCAT(
'🔗 Área de Licencias: ', @URL_LIC, '\n',
'🔗 Turnos: ', @URL_TUR, '\n',
'🔗 Charla ANSV: ', @URL_ANSV
), 40),
(@CON, '0', 'Menú principal', 'RESET', '', 99);
