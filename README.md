# Bot Tránsito (Twilio WhatsApp + PHP + MySQL)

Proyecto listo para correr un chatbot de WhatsApp para la Dirección de Tránsito de un municipio.

Este paquete viene **pre-cargado (seed)** con menús para **San Fernando (Provincia de Buenos Aires)**:
- Dirección: Colectora (Ex Combatiente Juan C. Reguera) 1447
- Turnos: https://www1.diphot.com.ar/san-fernando-transito/
- Info oficial licencias: https://www.sanfernando.gob.ar/Area-de-licencias-de-conducir
- Charla ANSV: https://curso.seguridadvial.gob.ar

Si lo querés para otro municipio, solo cambiás los textos/links desde el Admin o editando `sql/seed.sql`.

- **Webhook** en PHP que responde con TwiML
- Menús (nodos/opciones) configurables desde **MySQL**
- Panel **Admin** para editar menús, ver logs y derivaciones
- Modo **HUMANO** (handoff) para derivar a un agente

## 1) Requisitos

- PHP 8.0+ (recomendado 8.1+)
- Extensiones PHP: `pdo_mysql`, `curl`
- MySQL 5.7+ / MariaDB 10.3+
- Cuenta Twilio con WhatsApp (Sandbox o número habilitado)

## 2) Instalación local (XAMPP)

1. Copiá la carpeta del proyecto a tu `htdocs`, por ejemplo:
   - `C:\xampp\htdocs\transito-bot`

2. Copiá el archivo `.env.example` a `.env` y editá credenciales:
   - DB_HOST, DB_NAME, DB_USER, DB_PASS
   - APP_URL (importante para validar firma de Twilio)
   - TWILIO_* (opcional, solo si querés validar firma y/o enviar mensajes desde el admin)

3. Creá la base:

```sql
CREATE DATABASE transito_bot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE transito_bot;
SOURCE sql/schema.sql;
SOURCE sql/seed.sql;
```

Si ya tenías una base creada con una versión anterior, agregá la columna nueva para guardar el destino de derivación:

```sql
ALTER TABLE handoff_requests ADD COLUMN target_wa VARCHAR(64) NULL AFTER wa_from;
CREATE INDEX idx_handoff_target ON handoff_requests (target_wa);
```

4. Abrí:
- `http://localhost/transito-bot/public/`
- Admin: `http://localhost/transito-bot/public/admin/login.php`

**Credenciales por defecto (CAMBIAR):**
- usuario: `admin`
- clave: `admin123`

## 3) Instalación en Hostinger (o similar)

Opción recomendada:
- Publicar solo la carpeta `public/` como docroot (o dentro de `public_html/transito-bot/public`).

Ejemplo:
- `public_html/transito-bot/`  (todo el proyecto)
- configurar dominio/subcarpeta para que el docroot apunte a `public_html/transito-bot/public`

Si tu hosting no permite cambiar docroot, podés mover el contenido de `public/` a `public_html/transito-bot/` y ajustar rutas `../src` si hiciera falta.

## 4) Configurar Twilio (WhatsApp)

En Twilio, en la configuración del Sandbox o del número de WhatsApp:
- **WHEN A MESSAGE COMES IN** → apuntá a:
  - `APP_URL/webhook.php`

Ejemplo:
- `https://tudominio.com/transito-bot/public/webhook.php`

## 5) Menús en base de datos

- `bot_nodes` = pantallas/menús
- `bot_options` = opciones que el usuario elige escribiendo un `option_key` (1,2,9,0, etc)

Acciones disponibles:
- `GOTO_NODE` → navega al nodo cuyo ID está en `action_value`
- `SHOW_TEXT` → responde el texto de `action_value` y vuelve a mostrar el menú
- `HUMAN_HANDOFF` → pone la sesión en modo HUMANO y crea un registro en `handoff_requests`
- `RESET` → vuelve a `MAIN`

## 6) Derivación a humano (handoff)

Cuando el usuario elige “Chateá con un agente”, la sesión pasa a `mode=HUMAN`.

En este paquete, la derivación está configurada para el número:
- `+5491140678136`

- El bot deja de navegar menús y responde con un link directo (wa.me) al número del agente y la opción de volver enviando `MENU`.
- Los mensajes del usuario se guardan en `handoff_messages`.
- En el Admin (`Derivaciones`) podés ver y cerrar la derivación.

Opcional:
- Desde `handoff_view.php` podés **responder por WhatsApp** usando la API de Twilio, si configuraste:
  - `TWILIO_ACCOUNT_SID`
  - `TWILIO_AUTH_TOKEN`
  - `TWILIO_WHATSAPP_FROM` (tu From real)

Nota sobre base de datos:
- Se agregó el campo `target_wa` en `handoff_requests` para guardar a qué número se deriva.
- Si ya tenías una DB creada con una versión anterior, aplicá:
```sql
ALTER TABLE handoff_requests ADD COLUMN target_wa VARCHAR(64) NULL AFTER wa_from;
CREATE INDEX idx_handoff_target_wa ON handoff_requests (target_wa);
```

## 7) Seguridad

- Cambiá usuario/clave del admin.
- Limitá el acceso a `/admin` por IP si el hosting lo permite.
- Si vas a validar firma Twilio, asegurate de setear `APP_URL` con el dominio correcto.

## 8) Próximas mejoras (si querés escalar)

- Plantillas ricas (botones interactivos), catálogos, etc.
- Multi-municipio (tabla `tenants` + `tenant_id` por menú)
- Integración con sistemas reales (turnos, multas) vía APIs
- Panel de agentes con bandeja, asignación, etiquetas
