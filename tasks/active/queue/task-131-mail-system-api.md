# Task ID: API-TASK-131
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:22 | **Создатель:** AI Agent | **Зависимости:** API-TASK-128

---

## 📋 Описание

Создать API для почтовой системы. Send/receive mail, item/gold attachments, COD, system mail.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/mail-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Send mail (text + до 10 items + gold)
- Receive mail, read mail
- Inbox pagination
- Item/Gold attachments
- COD (Cash on Delivery) - оплата при получении
- System mail (награды, уведомления от системы)
- Expiration (30 дней auto-delete)
- Return to sender (если не забрали)

---

## 📁 Целевой файл

`api/v1/mail/mail-system.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** social-service  
**Порт:** 8084  
**API пути:** /api/v1/mail/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** social  
**Путь:** modules/social/mail  
**State Store:** useSocialStore (inbox, unreadCount)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Card, ItemCard, Button, ProgressBar (expiration timer)

**Готовые формы (@shared/forms):**
- MailComposeForm (send mail with attachments)

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useDebounce
- useRealtime (для новых писем)

---

## ✅ Endpoints (план)

1. **GET /api/v1/mail/inbox** - Список писем (pagination)
2. **GET /api/v1/mail/{mail_id}** - Прочитать письмо
3. **POST /api/v1/mail/send** - Отправить письмо
4. **POST /api/v1/mail/{mail_id}/claim** - Забрать attachments
5. **DELETE /api/v1/mail/{mail_id}** - Удалить письмо
6. **POST /api/v1/mail/system** - Отправить system mail (admin)

**Models:**
- MailMessage, MailAttachment, MailInbox, CODPayment

---

## 🔍 Критерии

✅ Max 10 attachments ✅ COD payment ✅ System mail ✅ 30 days expiration ✅ Return to sender

---

**Источник:** `.BRAIN/05-technical/backend/mail-system.md`

