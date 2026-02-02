-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 02-02-2026 a las 17:14:25
-- Versión del servidor: 11.8.3-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u729363490_transito_bot`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password_hash`, `created_at`) VALUES
(1, 'admin', '$2y$10$TDTQlW/LUxKSeK1/6RkzZO4Sl5xswd/jnHlmJY1hxC6imHxl8Yx22', '2026-01-20 16:42:22');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bot_nodes`
--

CREATE TABLE `bot_nodes` (
  `id` int(11) NOT NULL,
  `key_name` varchar(80) NOT NULL,
  `title` varchar(120) NOT NULL,
  `message` text NOT NULL,
  `media_url` varchar(255) DEFAULT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `bot_nodes`
--

INSERT INTO `bot_nodes` (`id`, `key_name`, `title`, `message`, `media_url`, `is_terminal`, `updated_at`) VALUES
(1, 'MAIN', 'Menú Principal', 'Elegí una opción:\n', 'https://gold-barracuda-164083.hostingersite.com/media/bienvenida.webp', 0, '2026-01-29 14:56:59'),
(2, 'LICENSE_MENU', 'Licencias', 'Licencias 🚗🪪 — elegí una opción:', NULL, 0, '2026-01-20 16:42:22'),
(3, 'FINES_MENU', 'Multas', 'Multas 🧾 — elegí una opción:', NULL, 0, '2026-01-20 16:42:22'),
(4, 'TURNS_MENU', 'Turnos', 'Turnos 📅 — elegí una opción:', NULL, 0, '2026-01-20 16:42:22'),
(5, 'CONTACT_MENU', 'Contacto', 'Contacto 📍☎️ — elegí una opción:', NULL, 0, '2026-01-22 01:04:51'),
(6, 'DELEGACION_MENU', 'Delegacaciones Municipales', 'Delegacaciones Municipales 🏫  — elegí una opción:', NULL, 0, '2026-01-22 01:05:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bot_options`
--

CREATE TABLE `bot_options` (
  `id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `option_key` varchar(20) NOT NULL,
  `label` varchar(200) NOT NULL,
  `action_type` varchar(30) NOT NULL,
  `action_value` text DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `bot_options`
--

INSERT INTO `bot_options` (`id`, `node_id`, `option_key`, `label`, `action_type`, `action_value`, `sort_order`) VALUES
(53, 1, '1', 'Licencias (sacar / renovar)', 'GOTO_NODE', '2', 10),
(54, 1, '2', 'Multas (consulta / pago / descargo)', 'GOTO_NODE', '3', 20),
(55, 1, '3', 'Turnos online', 'GOTO_NODE', '4', 30),
(56, 1, '4', 'Contacto / ubicación / horarios', 'GOTO_NODE', '5', 40),
(57, 1, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(58, 1, '0', 'Volver al menú principal', 'RESET', '', 99),
(59, 2, '1', 'Primera licencia (original / principiante)', 'SHOW_TEXT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir', 10),
(60, 2, '2', 'Renovación de licencia (particular)', 'SHOW_TEXT', 'RENOVACIÓN (PARTICULAR)\n📌 Si el vencimiento supera 90 días: teórico + práctico (el municipio no provee vehículo para exámenes).\n🧾 Requisitos y casos (licencia local / nacional / otras provincias): ver detalle oficial acá:\nhttps://www.sanfernando.gob.ar/Area-de-licencias-de-conducir', 20),
(61, 2, '3', 'Licencia vencida +90 días (original con vencida)', 'SHOW_TEXT', 'LICENCIA VENCIDA +90 DÍAS\n• DNI con domicilio en San Fernando + licencia vencida (originales + 1 fotocopia)\n• Rinde teórico y práctico (sin vehículo provisto por el municipio)\n\nDetalle oficial: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir', 30),
(62, 2, '4', 'Dónde queda / horarios del área', 'SHOW_TEXT', '📍 Centro de Tránsito y Gestión: Colectora (Ex Combatiente Juan C. Reguera) 1447, San Fernando.\n⏰ Trámite de licencias: Lun a Vie 7:30 a 12:30 y 2° sábado de cada mes 8:00 a 12:00 (con turno).\n🔗 Turnos: https://www1.diphot.com.ar/san-fernando-transito/\n🔗 Info oficial: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir', 40),
(63, 2, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(64, 2, '0', 'Menú principal', 'RESET', '', 99),
(65, 3, '1', 'Consultar multas (qué necesitás)', 'SHOW_TEXT', '🔎 Para consultar multas normalmente necesitás: patente y/o DNI, o el nro de acta (según sistema).\n\nSi querés que te lo gestione un agente, elegí 9.', 10),
(66, 3, '2', 'Pago / planes', 'SHOW_TEXT', '🧾 Pago: puede ser online o presencial según el tipo de infracción.\nSi te falta un dato o querés un descargo, te conviene hablar con un agente (opción 9).', 20),
(67, 3, '3', 'Descargo / infracción', 'SHOW_TEXT', '✍️ Descargo: presentá documentación y fundamento dentro del plazo.\nSi tenés nro de acta o patente, te deriva un agente (opción 9).', 30),
(68, 3, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(69, 3, '0', 'Menú principal', 'RESET', '', 99),
(70, 4, '1', 'Solicitar turno online (Licencias)', 'SHOW_TEXT', '📅 Turnos online (San Fernando): https://www1.diphot.com.ar/san-fernando-transito/\n\nTe pide DNI + email. Te llega un correo para entrar al sistema y elegir fecha/hora.\nInfo del área de licencias: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir', 10),
(71, 4, '2', 'No me llegó el mail / problemas con el turno', 'SHOW_TEXT', '📩 Revisá spam/no deseado. Si no llega o te da error, elegí 9 y te deriva a un agente.', 20),
(72, 4, '9', 'Chateá con un agente', 'HUMAN_HANDOFF', 'whatsapp:+5491140678136', 90),
(73, 4, '0', 'Menú principal', 'RESET', '', 99),
(74, 5, '1', 'Ubicación', 'SHOW_TEXT', '📍 Centro de Tránsito y Gestión (Licencias): Colectora (Ex Combatiente Juan C. Reguera) 1447, San Fernando.\n(Al lado del nuevo Cuartel de Bomberos).', 10),
(75, 5, '2', 'Horarios', 'SHOW_TEXT', '⏰ Licencias: Lun a Vie 7:30 a 12:30hs; y 2° sábado de cada mes 8:00 a 12:00hs (con turno).\n\n🚗 Retiro de autos acarreados: Lun a Vie 7:30 a 18:50hs.\n\n📦 Permisos (carga/descarga, volquetes, mudanzas, etc.): Lun a Vie 8:00 a 14:00hs.', 20),
(76, 5, '3', 'Atención vecinal', 'SHOW_TEXT', '☎️ Atención vecinal: 0800-777-6864\n✉️ vecinos@sanfernando.gov.ar', 30),
(77, 5, '4', 'Links oficiales', 'SHOW_TEXT', '🔗 Área de Licencias: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n🔗 Turnos: https://www1.diphot.com.ar/san-fernando-transito/\n🔗 Charla ANSV: https://curso.seguridadvial.gob.ar', 40),
(78, 5, '0', 'Menú principal', 'RESET', '', 99),
(82, 1, '6', 'Delegaciones Municipales', 'GOTO_NODE', '6', 80),
(83, 6, '0', 'Volver al menú principal', 'RESET', '', 99);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bot_settings`
--

CREATE TABLE `bot_settings` (
  `id` int(11) NOT NULL,
  `k` varchar(50) NOT NULL,
  `v` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `bot_settings`
--

INSERT INTO `bot_settings` (`id`, `k`, `v`) VALUES
(1, 'BUSINESS_HOURS', '{\r\n  \"tz\": \"America/Argentina/Buenos_Aires\",\r\n  \"mon\": [\"09:00\",\"18:00\"],\r\n  \"tue\": [\"09:00\",\"18:00\"],\r\n  \"wed\": [\"09:00\",\"18:00\"],\r\n  \"thu\": [\"09:00\",\"18:00\"],\r\n  \"fri\": [\"09:00\",\"18:00\"],\r\n  \"sat\": null,\r\n  \"sun\": null\r\n}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `handoff_messages`
--

CREATE TABLE `handoff_messages` (
  `id` int(11) NOT NULL,
  `handoff_id` int(11) NOT NULL,
  `sender` varchar(10) NOT NULL,
  `body` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `handoff_requests`
--

CREATE TABLE `handoff_requests` (
  `id` int(11) NOT NULL,
  `wa_from` varchar(64) NOT NULL,
  `target_wa` varchar(64) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `trigger_text` text DEFAULT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'OPEN',
  `created_at` datetime DEFAULT current_timestamp(),
  `closed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `message_logs`
--

CREATE TABLE `message_logs` (
  `id` int(11) NOT NULL,
  `wa_from` varchar(64) NOT NULL,
  `direction` varchar(8) NOT NULL,
  `body` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `message_logs`
--

INSERT INTO `message_logs` (`id`, `wa_from`, `direction`, `body`, `created_at`) VALUES
(115, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 00:42:38'),
(116, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:42:38'),
(117, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-22 00:43:03'),
(118, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:43:03'),
(119, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 00:44:26'),
(120, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:44:26'),
(121, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 00:48:35'),
(122, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:48:35'),
(123, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 00:48:58'),
(124, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:48:58'),
(125, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-22 00:49:27'),
(126, 'whatsapp:+5491140678136', 'OUT', 'Listo ✅ Te paso con un agente.\n\n👉 Para chatear directo por WhatsApp con el agente: https://wa.me/:5491140678136\n\nDejá tu consulta con el mayor detalle posible (DNI, patente, nro de acta, etc si aplica).\n\nPara volver al menú, enviá: MENU', '2026-01-22 00:49:28'),
(127, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 00:49:38'),
(128, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:49:38'),
(129, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 00:50:49'),
(130, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n6) Delegaciones Municipales\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:50:49'),
(131, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 00:51:23'),
(132, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n6) Delegaciones Municipales\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:51:23'),
(133, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 00:51:31'),
(134, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 00:52:21'),
(135, 'whatsapp:+5491140678136', 'OUT', 'PROBANDO\n\n👉 Escribí MENU para volver.', '2026-01-22 00:52:21'),
(136, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-22 00:54:22'),
(137, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n9) Chateá con un agente\n6) Delegaciones Municipales\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:54:22'),
(138, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-22 00:55:15'),
(139, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:55:15'),
(140, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 00:56:25'),
(141, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:56:25'),
(142, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 00:57:08'),
(143, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:57:08'),
(144, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 00:57:15'),
(145, 'whatsapp:+5491140678136', 'OUT', 'Delegacaciones Municipales\n\n👉 Escribí MENU para volver.', '2026-01-22 00:57:15'),
(146, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 00:58:55'),
(147, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\n🏫 Delegacaciones Municipales — elegí una opción:\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:58:55'),
(148, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 00:59:08'),
(149, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 00:59:08'),
(150, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-22 01:00:33'),
(151, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:00:33'),
(152, 'whatsapp:+5491140678136', 'IN', 'Bot', '2026-01-22 01:01:36'),
(153, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:01:36'),
(154, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 01:05:43'),
(155, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:05:43'),
(156, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 01:07:21'),
(157, 'whatsapp:+5491140678136', 'OUT', 'Delegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:07:21'),
(158, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-22 01:07:23'),
(159, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nDelegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:07:23'),
(160, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 01:07:40'),
(161, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nDelegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:07:40'),
(162, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 01:08:20'),
(163, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nDelegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:08:20'),
(164, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 01:10:25'),
(165, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nDelegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:10:25'),
(166, 'whatsapp:+5491140678136', 'IN', '🏫', '2026-01-22 01:11:40'),
(167, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nDelegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:11:40'),
(168, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 01:12:49'),
(169, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:12:49'),
(170, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 01:14:53'),
(171, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:14:53'),
(172, 'whatsapp:+5491140678136', 'IN', 'MENU', '2026-01-22 01:17:07'),
(173, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:17:07'),
(174, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 01:18:36'),
(175, 'whatsapp:+5491140678136', 'OUT', 'Delegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:18:36'),
(176, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-22 01:18:49'),
(177, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:18:49'),
(178, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-22 01:19:11'),
(179, 'whatsapp:+5491140678136', 'OUT', 'Delegacaciones Municipales 🏫  — elegí una opción:\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:19:11'),
(180, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-22 01:19:20'),
(181, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:19:20'),
(182, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-22 01:20:21'),
(183, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-22 01:20:21'),
(184, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-23 00:06:58'),
(185, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 00:06:58'),
(186, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-23 00:07:09'),
(187, 'whatsapp:+5491140678136', 'OUT', 'Hola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 00:07:09'),
(188, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 17:39:46'),
(189, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nHola 👋 \r\nSoy el asistente de Tránsito de San Fernando. \r\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 17:39:46'),
(190, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 17:41:46'),
(191, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 17:41:46'),
(192, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-23 17:45:32'),
(193, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 17:45:32'),
(194, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-23 17:45:40'),
(195, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-23 17:45:40'),
(196, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-23 17:45:55'),
(197, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 17:45:55'),
(198, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 17:53:42'),
(199, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 17:53:42'),
(200, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 18:49:39'),
(201, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 18:49:39'),
(202, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 19:12:53'),
(203, 'whatsapp:+5491140678136', 'OUT', '[MEDIA] https://gold-barracuda-164083.hostingersite.com/bienvenida7.jpg', '2026-01-23 19:12:53'),
(204, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.', '2026-01-23 19:12:53'),
(205, 'whatsapp:+5491140678136', 'OUT', 'Soy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 19:12:53'),
(206, 'whatsapp:+5491140678136', 'IN', 'hol', '2026-01-23 19:50:56'),
(207, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 19:50:56'),
(208, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 19:51:04'),
(209, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 19:51:04'),
(210, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 19:53:04'),
(211, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 19:53:04'),
(212, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 19:54:59'),
(213, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 19:54:59'),
(214, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 20:16:52'),
(215, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.', '2026-01-23 20:16:52'),
(216, 'whatsapp:+5491140678136', 'OUT', 'Soy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 20:16:52'),
(217, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 20:22:32'),
(218, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 20:22:32'),
(219, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 20:41:31'),
(220, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 20:41:31'),
(221, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 20:42:20'),
(222, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 20:42:20'),
(223, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 20:43:53'),
(224, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nSoy el asistente de Tránsito de San Fernando. \n\nElegí una opción:\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 20:43:53'),
(225, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 21:11:44'),
(226, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:11:44'),
(227, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 21:17:22'),
(228, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:17:22'),
(229, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 21:24:18'),
(230, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:24:18'),
(231, 'whatsapp:+5491140678136', 'IN', 'HOLA', '2026-01-23 21:27:34'),
(232, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:27:34'),
(233, 'whatsapp:+5491140678136', 'IN', 'HOLA', '2026-01-23 21:38:54'),
(234, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:38:54'),
(235, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 21:40:42'),
(236, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy SanFer el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:40:42'),
(237, 'whatsapp:+5491140678136', 'IN', 'HOLA', '2026-01-23 21:59:16'),
(238, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 21:59:16'),
(239, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 22:00:42'),
(240, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:00:42'),
(241, 'whatsapp:+5491140678136', 'IN', 'HOLA', '2026-01-23 22:00:55'),
(242, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:00:55'),
(243, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 22:07:26'),
(244, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:07:26'),
(245, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:18:21'),
(246, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:18:21'),
(247, 'whatsapp:+5491140678136', 'IN', 'ha', '2026-01-23 22:18:33'),
(248, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:18:33'),
(249, 'whatsapp:+5491161985262', 'IN', 'Hola', '2026-01-23 22:20:33'),
(250, 'whatsapp:+5491161985262', 'OUT', '👋 ¡Hola, Dani! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:20:33'),
(251, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:20:51'),
(252, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:20:51'),
(253, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:21:14'),
(254, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:21:14'),
(255, 'whatsapp:+5491140678136', 'IN', 'ho', '2026-01-23 22:22:29'),
(256, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:22:29'),
(257, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:22:45'),
(258, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:22:45'),
(259, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:33:54'),
(260, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:33:54'),
(261, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:39:12'),
(262, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:39:12'),
(263, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:42:23'),
(264, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:42:23'),
(265, 'whatsapp:+5491140678136', 'IN', 'hola', '2026-01-23 22:44:02'),
(266, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:44:02'),
(267, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:44:52'),
(268, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:44:52'),
(269, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:48:13'),
(270, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:48:13'),
(271, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-23 22:49:52'),
(272, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-23 22:49:52'),
(273, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 00:27:41'),
(274, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:27:41'),
(275, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 00:28:05'),
(276, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:28:05'),
(277, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-24 00:28:19'),
(278, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:28:19'),
(279, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-24 00:28:28'),
(280, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:28:28'),
(281, 'whatsapp:+5491140678136', 'IN', '6', '2026-01-24 00:28:41'),
(282, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:28:41'),
(283, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-24 00:28:49'),
(284, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:28:49'),
(285, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-24 00:29:09'),
(286, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:29:09'),
(287, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-24 00:29:26'),
(288, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:29:26'),
(289, 'whatsapp:+5491140678136', 'IN', '3', '2026-01-24 00:29:35'),
(290, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:29:35'),
(291, 'whatsapp:+5491140678136', 'IN', 'Licencia', '2026-01-24 00:30:05'),
(292, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 00:30:05'),
(293, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 01:58:46'),
(294, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 01:58:46'),
(295, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-24 01:58:53'),
(296, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 01:58:53'),
(297, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-24 01:59:32'),
(298, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 01:59:32'),
(299, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-24 01:59:40'),
(300, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 01:59:40'),
(301, 'whatsapp:+5491140678136', 'IN', '2', '2026-01-24 01:59:48'),
(302, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 01:59:48'),
(303, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:16:02'),
(304, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:16:02'),
(305, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-24 02:16:11'),
(306, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:16:11'),
(307, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-24 02:16:17'),
(308, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:16:17'),
(309, 'whatsapp:+5491140678136', 'IN', '2', '2026-01-24 02:16:25'),
(310, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:16:25'),
(311, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:29:14'),
(312, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:29:14'),
(313, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-24 02:29:23'),
(314, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:29:23'),
(315, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-24 02:29:30'),
(316, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:29:30'),
(317, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-24 02:29:39'),
(318, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:29:39'),
(319, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-24 02:29:49'),
(320, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:29:49'),
(321, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-24 02:30:01'),
(322, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:30:01'),
(323, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:31:02'),
(324, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:31:02'),
(325, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-24 02:31:52'),
(326, 'whatsapp:+5491140678136', 'OUT', '⏰ En este momento estamos fuera de horario.\n\n👉 Escribí MENU para ver opciones.', '2026-01-24 02:31:52'),
(327, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-24 02:32:01'),
(328, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:32:01'),
(329, 'whatsapp:+5491140678136', 'IN', 'MENU', '2026-01-24 02:32:20'),
(330, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:32:20'),
(331, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-24 02:32:29'),
(332, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:32:29'),
(333, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-24 02:36:14'),
(334, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:36:14'),
(335, 'whatsapp:+5491140678136', 'IN', '3', '2026-01-24 02:36:30'),
(336, 'whatsapp:+5491140678136', 'OUT', 'Turnos 📅 — elegí una opción:\n1) Solicitar turno online (Licencias)\n2) No me llegó el mail / problemas con el turno\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:36:30'),
(337, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:39:58'),
(338, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nTurnos 📅 — elegí una opción:\n1) Solicitar turno online (Licencias)\n2) No me llegó el mail / problemas con el turno\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:39:58'),
(339, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:40:56'),
(340, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:40:56'),
(341, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:52:34'),
(342, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:52:34'),
(343, 'whatsapp:+5491140678136', 'IN', 'Bot', '2026-01-24 02:53:01'),
(344, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:53:01'),
(345, 'whatsapp:+5491140678136', 'IN', 'Jajaja', '2026-01-24 02:55:13'),
(346, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:55:13'),
(347, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 02:58:44'),
(348, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 02:58:44'),
(349, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 13:23:49');
INSERT INTO `message_logs` (`id`, `wa_from`, `direction`, `body`, `created_at`) VALUES
(350, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 13:23:49'),
(351, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 13:24:13'),
(352, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 13:24:13'),
(353, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 13:24:19'),
(354, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 13:24:19'),
(355, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 17:26:53'),
(356, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 17:26:53'),
(357, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 17:31:16'),
(358, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 17:31:16'),
(359, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-24 17:40:02'),
(360, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-24 17:40:02'),
(361, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 03:49:44'),
(362, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:49:44'),
(363, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 03:49:55'),
(364, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:49:55'),
(365, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 03:50:15'),
(366, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:50:15'),
(367, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 03:50:22'),
(368, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:50:22'),
(369, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 03:50:29'),
(370, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 03:50:29'),
(371, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 03:50:38'),
(372, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:50:38'),
(373, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-25 03:51:14'),
(374, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:51:14'),
(375, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-25 03:51:21'),
(376, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:51:21'),
(377, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-25 03:51:42'),
(378, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 03:51:42'),
(379, 'whatsapp:+5491140678136', 'IN', 'MENU', '2026-01-25 04:01:35'),
(380, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n\nEnviá MENU para volver al inicio.', '2026-01-25 04:01:35'),
(381, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-25 04:16:16'),
(382, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 04:16:16'),
(383, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-25 04:16:25'),
(384, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 04:16:25'),
(385, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 04:16:33'),
(386, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 04:16:33'),
(387, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 04:17:41'),
(388, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 04:17:41'),
(389, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 04:17:54'),
(390, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 04:17:54'),
(391, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 04:18:04'),
(392, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 04:18:04'),
(393, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 04:18:17'),
(394, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 04:18:17'),
(395, 'whatsapp:+5491140678136', 'IN', 'MENU', '2026-01-25 04:18:30'),
(396, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 04:18:30'),
(397, 'whatsapp:+5491140678136', 'IN', 'O', '2026-01-25 04:54:35'),
(398, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 04:54:35'),
(399, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-25 04:54:39'),
(400, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 04:54:39'),
(401, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-25 04:54:47'),
(402, 'whatsapp:+5491140678136', 'OUT', '⏰ En este momento estamos fuera de horario.\n\n👉 Escribí MENU para ver opciones.', '2026-01-25 04:54:47'),
(403, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 04:54:57'),
(404, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 04:54:57'),
(405, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 05:18:23'),
(406, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú o poné MENUElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:18:23'),
(407, 'whatsapp:+5491140678136', 'IN', 'MENU', '2026-01-25 05:18:38'),
(408, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú o poné MENUElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:18:38'),
(409, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 05:19:20'),
(410, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:19:20'),
(411, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 05:19:39'),
(412, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:19:39'),
(413, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 05:20:05'),
(414, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:20:05'),
(415, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 05:20:18'),
(416, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 05:20:18'),
(417, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 05:20:24'),
(418, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 05:20:24'),
(419, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 05:20:38'),
(420, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nLicencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 05:20:38'),
(421, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-25 05:55:10'),
(422, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:55:10'),
(423, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 05:55:20'),
(424, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 05:55:20'),
(425, 'whatsapp:+5491140678136', 'IN', '2', '2026-01-25 05:55:32'),
(426, 'whatsapp:+5491140678136', 'OUT', 'RENOVACIÓN (PARTICULAR)\n📌 Si el vencimiento supera 90 días: teórico + práctico (el municipio no provee vehículo para exámenes).\n🧾 Requisitos y casos (licencia local / nacional / otras provincias): ver detalle oficial acá:\nhttps://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 05:55:32'),
(427, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 05:55:41'),
(428, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:55:41'),
(429, 'whatsapp:+5491140678136', 'IN', '2', '2026-01-25 05:55:50'),
(430, 'whatsapp:+5491140678136', 'OUT', 'Multas 🧾 — elegí una opción:\n1) Consultar multas (qué necesitás)\n2) Pago / planes\n3) Descargo / infracción\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 05:55:50'),
(431, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 05:56:05'),
(432, 'whatsapp:+5491140678136', 'OUT', '🔎 Para consultar multas normalmente necesitás: patente y/o DNI, o el nro de acta (según sistema).\n\nSi querés que te lo gestione un agente, elegí 9.\n\n👉 Escribí MENU para volver.', '2026-01-25 05:56:05'),
(433, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 05:56:13'),
(434, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nMultas 🧾 — elegí una opción:\n1) Consultar multas (qué necesitás)\n2) Pago / planes\n3) Descargo / infracción\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 05:56:13'),
(435, 'whatsapp:+5491140678136', 'IN', '0', '2026-01-25 05:56:29'),
(436, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 05:56:29'),
(437, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-25 13:16:27'),
(438, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 13:16:27'),
(439, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 13:16:39'),
(440, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-25 13:16:39'),
(441, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-25 13:16:47'),
(442, 'whatsapp:+5491140678136', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-25 13:16:47'),
(443, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-25 13:17:00'),
(444, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-25 13:17:00'),
(445, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-25 13:17:18'),
(446, 'whatsapp:+5491140678136', 'OUT', '⏰ En este momento estamos fuera de horario.\n\n👉 Escribí MENU para ver opciones.', '2026-01-25 13:17:18'),
(447, 'whatsapp:+5491140678136', 'IN', 'Holandesas', '2026-01-26 00:35:04'),
(448, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-26 00:35:04'),
(449, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-26 00:35:13'),
(450, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-26 00:35:13'),
(451, 'whatsapp:+5491140678136', 'IN', '4', '2026-01-26 00:35:24'),
(452, 'whatsapp:+5491140678136', 'OUT', '📍 Centro de Tránsito y Gestión: Colectora (Ex Combatiente Juan C. Reguera) 1447, San Fernando.\n⏰ Trámite de licencias: Lun a Vie 7:30 a 12:30 y 2° sábado de cada mes 8:00 a 12:00 (con turno).\n🔗 Turnos: https://www1.diphot.com.ar/san-fernando-transito/\n🔗 Info oficial: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-26 00:35:24'),
(453, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-26 00:35:33'),
(454, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-26 00:35:33'),
(455, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-26 13:22:00'),
(456, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-26 13:22:00'),
(457, 'whatsapp:+5491131566645', 'IN', 'Hola', '2026-01-26 18:26:31'),
(458, 'whatsapp:+5491131566645', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-26 18:26:31'),
(459, 'whatsapp:+5491131566645', 'IN', 'Menú', '2026-01-26 18:26:42'),
(460, 'whatsapp:+5491131566645', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-26 18:26:42'),
(461, 'whatsapp:+5491140678136', 'IN', 'Confirm', '2026-01-27 22:57:48'),
(462, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-27 22:57:48'),
(463, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-27 22:57:52'),
(464, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-27 22:57:52'),
(465, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:19:59'),
(466, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:19:59'),
(467, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-28 02:23:26'),
(468, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:23:26'),
(469, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:24:57'),
(470, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:24:57'),
(471, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:25:23'),
(472, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:25:23'),
(473, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:28:29'),
(474, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:28:29'),
(475, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:30:17'),
(476, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:30:17'),
(477, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:36:20'),
(478, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:36:20'),
(479, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:41:34'),
(480, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:41:34'),
(481, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 02:56:45'),
(482, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 02:56:52'),
(483, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 02:56:52'),
(484, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 02:56:58'),
(485, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 03:40:27'),
(486, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 03:41:27'),
(487, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-28 03:41:35'),
(488, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 03:41:35'),
(489, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 03:41:41'),
(490, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 03:47:10'),
(491, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-28 03:47:16'),
(492, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 03:47:16'),
(493, 'whatsapp:+5491140678136', 'ERR', 'SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_greeted_at\' in \'SET\'', '2026-01-28 03:48:24'),
(494, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-28 03:59:25'),
(495, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 03:59:25'),
(496, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-28 03:59:35'),
(497, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-28 03:59:35'),
(498, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-28 03:59:54'),
(499, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-28 03:59:54'),
(500, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 05:44:22'),
(501, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 05:44:22'),
(502, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 14:52:03'),
(503, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 14:52:03'),
(504, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-29 14:52:10'),
(505, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 14:52:10'),
(506, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 14:53:20'),
(507, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 14:53:20'),
(508, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 14:59:27'),
(509, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 14:59:27'),
(510, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:00:29'),
(511, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:00:29'),
(512, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-29 15:00:38'),
(513, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:00:38'),
(514, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:14:24'),
(515, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:14:24'),
(516, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:21:47'),
(517, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:21:47'),
(518, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:37:54'),
(519, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:37:54'),
(520, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-29 15:38:18'),
(521, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:38:18'),
(522, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:38:36'),
(523, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:38:36'),
(524, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:39:40'),
(525, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:39:40'),
(526, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:43:00'),
(527, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:43:00'),
(528, 'whatsapp:+5491140678136', 'IN', 'Licencia', '2026-01-29 15:43:44'),
(529, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:43:44'),
(530, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:44:26'),
(531, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:44:26'),
(532, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:45:54'),
(533, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:45:54'),
(534, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 15:52:04'),
(535, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 15:52:04'),
(536, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 16:25:19'),
(537, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 16:25:19'),
(538, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 16:25:35'),
(539, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 16:25:35'),
(540, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 16:25:44'),
(541, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 16:25:44'),
(542, 'whatsapp:+5491140678136', 'IN', 'Menu', '2026-01-29 16:25:57'),
(543, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 16:25:57'),
(544, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-29 16:26:11'),
(545, 'whatsapp:+5491140678136', 'OUT', 'No te entendí 😅\nEscribí una opción del menú\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-29 16:26:11'),
(546, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 12:54:02'),
(547, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 12:54:02'),
(548, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 14:25:36'),
(549, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 14:25:36'),
(550, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 14:25:47'),
(551, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 14:25:47'),
(552, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 14:25:54'),
(553, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 14:25:54'),
(554, 'whatsapp:+5491140678136', 'IN', 'Menú', '2026-01-30 14:26:02'),
(555, 'whatsapp:+5491140678136', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 14:26:02'),
(556, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 14:38:32'),
(557, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 14:38:32'),
(558, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 16:18:20'),
(559, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.\nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 16:18:20'),
(560, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 16:18:43'),
(561, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 16:18:43'),
(562, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-30 23:42:24'),
(563, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.🚦🤖 \nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 23:42:24'),
(564, 'whatsapp:+5491126340798', 'IN', 'Hola', '2026-01-30 23:48:45'),
(565, 'whatsapp:+5491126340798', 'OUT', '👋 ¡Hola, Nico!\nSoy Nandito el asistente de Tránsito de San Fernando.🚦🤖 \nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 23:48:45'),
(566, 'whatsapp:+5491126340798', 'IN', '1', '2026-01-30 23:49:00'),
(567, 'whatsapp:+5491126340798', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-30 23:49:00'),
(568, 'whatsapp:+5491126340798', 'IN', '1', '2026-01-30 23:49:06'),
(569, 'whatsapp:+5491126340798', 'OUT', 'ORIGINAL / PRINCIPIANTE\n✅ Charla de Educación Vial (ANSV) gratuita: https://curso.seguridadvial.gob.ar\n📌 Luego pedí turno online: https://www1.diphot.com.ar/san-fernando-transito/\n\nDocumentación (según info municipal):\n• DNI (original + 1 fotocopia)\n• Certificado ANSV impreso (se valida mostrando el mail recibido)\n• Menores (16/17): autorización de escribano o juez de paz\n\nInfo completa y categorías/edades: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir\n\n👉 Escribí MENU para volver.', '2026-01-30 23:49:06'),
(570, 'whatsapp:+5491126340798', 'IN', 'Menu', '2026-01-30 23:49:28'),
(571, 'whatsapp:+5491126340798', 'OUT', 'Elegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-30 23:49:28'),
(572, 'whatsapp:+5491126340798', 'IN', '2', '2026-01-30 23:49:35'),
(573, 'whatsapp:+5491126340798', 'OUT', 'Multas 🧾 — elegí una opción:\n1) Consultar multas (qué necesitás)\n2) Pago / planes\n3) Descargo / infracción\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-30 23:49:35'),
(574, 'whatsapp:+5491126340798', 'IN', '1', '2026-01-30 23:49:41'),
(575, 'whatsapp:+5491126340798', 'OUT', '🔎 Para consultar multas normalmente necesitás: patente y/o DNI, o el nro de acta (según sistema).\n\nSi querés que te lo gestione un agente, elegí 9.\n\n👉 Escribí MENU para volver.', '2026-01-30 23:49:41'),
(576, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-01-31 02:06:59'),
(577, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-31 02:06:59'),
(578, 'whatsapp:+5491140678136', 'IN', '1', '2026-01-31 02:07:16'),
(579, 'whatsapp:+5491140678136', 'OUT', 'Licencias 🚗🪪 — elegí una opción:\n1) Primera licencia (original / principiante)\n2) Renovación de licencia (particular)\n3) Licencia vencida +90 días (original con vencida)\n4) Dónde queda / horarios del área\n9) Chateá con un agente\n0) Menú principal\n', '2026-01-31 02:07:16'),
(580, 'whatsapp:+5491140678136', 'IN', '9', '2026-01-31 02:07:31'),
(581, 'whatsapp:+5491140678136', 'OUT', '⏰ En este momento estamos fuera de horario.\n\n👉 Escribí MENU para ver opciones.', '2026-01-31 02:07:31'),
(582, 'whatsapp:+5491131566645', 'IN', 'Hola', '2026-01-31 20:28:10'),
(583, 'whatsapp:+5491131566645', 'OUT', '👋 ¡Hola, Luis A Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-01-31 20:28:10'),
(584, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-02-02 01:26:34'),
(585, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.🚦🤖 \nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-02-02 01:26:34'),
(586, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-02-02 01:27:13'),
(587, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-02-02 01:27:13'),
(588, 'whatsapp:+5491140678136', 'IN', 'Hola', '2026-02-02 16:02:21'),
(589, 'whatsapp:+5491140678136', 'OUT', '👋 ¡Hola, Luis Postorivo!\nSoy Nandito el asistente de Tránsito de San Fernando.🚦🤖 \nEstoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-02-02 16:02:21'),
(590, 'whatsapp:+5491131566645', 'IN', 'Hola', '2026-02-02 16:58:02'),
(591, 'whatsapp:+5491131566645', 'OUT', '👋 ¡Hola, Luis A Postorivo! Estoy acá para ayudarte.\n\nElegí una opción:\n\n1) Licencias (sacar / renovar)\n2) Multas (consulta / pago / descargo)\n3) Turnos online\n4) Contacto / ubicación / horarios\n6) Delegaciones Municipales\n9) Chateá con un agente\n0) Volver al menú principal\n', '2026-02-02 16:58:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_sessions`
--

CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL,
  `wa_from` varchar(64) NOT NULL,
  `current_node_id` int(11) NOT NULL,
  `mode` varchar(12) NOT NULL DEFAULT 'BOT',
  `last_message` text DEFAULT NULL,
  `greet_variant` char(1) DEFAULT NULL,
  `media_sent` tinyint(1) NOT NULL DEFAULT 0,
  `suppress_greeting` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_greeted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `user_sessions`
--

INSERT INTO `user_sessions` (`id`, `wa_from`, `current_node_id`, `mode`, `last_message`, `greet_variant`, `media_sent`, `suppress_greeting`, `updated_at`, `last_greeted_at`) VALUES
(1, 'whatsapp:+5491140678136', 1, 'BOT', NULL, NULL, 0, 0, '2026-02-02 16:58:46', NULL),
(5, 'whatsapp:+5491126340798', 3, 'BOT', NULL, NULL, 0, 0, NULL, NULL),
(6, 'whatsapp:+5491131566645', 1, 'BOT', NULL, 'A', 0, 0, NULL, NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `bot_nodes`
--
ALTER TABLE `bot_nodes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key_name` (`key_name`);

--
-- Indices de la tabla `bot_options`
--
ALTER TABLE `bot_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indices de la tabla `bot_settings`
--
ALTER TABLE `bot_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `k` (`k`);

--
-- Indices de la tabla `handoff_messages`
--
ALTER TABLE `handoff_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `handoff_id` (`handoff_id`);

--
-- Indices de la tabla `handoff_requests`
--
ALTER TABLE `handoff_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wa_from` (`wa_from`),
  ADD KEY `target_wa` (`target_wa`),
  ADD KEY `status` (`status`),
  ADD KEY `fk_handoff_node` (`node_id`);

--
-- Indices de la tabla `message_logs`
--
ALTER TABLE `message_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wa_from` (`wa_from`),
  ADD KEY `created_at` (`created_at`);

--
-- Indices de la tabla `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wa_from` (`wa_from`),
  ADD KEY `current_node_id` (`current_node_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `bot_nodes`
--
ALTER TABLE `bot_nodes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `bot_options`
--
ALTER TABLE `bot_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT de la tabla `bot_settings`
--
ALTER TABLE `bot_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `handoff_messages`
--
ALTER TABLE `handoff_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `handoff_requests`
--
ALTER TABLE `handoff_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `message_logs`
--
ALTER TABLE `message_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=592;

--
-- AUTO_INCREMENT de la tabla `user_sessions`
--
ALTER TABLE `user_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bot_options`
--
ALTER TABLE `bot_options`
  ADD CONSTRAINT `fk_bot_options_node` FOREIGN KEY (`node_id`) REFERENCES `bot_nodes` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `handoff_messages`
--
ALTER TABLE `handoff_messages`
  ADD CONSTRAINT `fk_handoff_messages` FOREIGN KEY (`handoff_id`) REFERENCES `handoff_requests` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `handoff_requests`
--
ALTER TABLE `handoff_requests`
  ADD CONSTRAINT `fk_handoff_node` FOREIGN KEY (`node_id`) REFERENCES `bot_nodes` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD CONSTRAINT `fk_user_sessions_node` FOREIGN KEY (`current_node_id`) REFERENCES `bot_nodes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
