# Task ID: API-TASK-132
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:24 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы уведомлений. In-game notifications, WebSocket push, email, preferences.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/notification-system.md` (v1.0.0, ready)

**Ключевые механики:**
- In-game notifications (popup, toast)
- WebSocket push (real-time)
- Email notifications
- Types (quest, achievement, friend, guild, trade, mail, event)
- User preferences (какие уведомления показывать)
- History (30 дней хранение)
- Priority levels (low, medium, high, critical)
- Mark as read/unread

---

## 📁 Целевой файл

`api/v1/notifications/notifications.yaml`

---

## ✅ Endpoints (план)

1. **GET /api/v1/notifications** - Список уведомлений (pagination)
2. **POST /api/v1/notifications/{id}/read** - Отметить как прочитанное
3. **POST /api/v1/notifications/read-all** - Отметить все как прочитанные
4. **DELETE /api/v1/notifications/{id}** - Удалить уведомление
5. **GET /api/v1/notifications/preferences** - Настройки уведомлений
6. **PATCH /api/v1/notifications/preferences** - Обновить настройки
7. **WebSocket: /ws/notifications** - Real-time push уведомлений

**Models:**
- Notification, NotificationPreferences, NotificationType

---

## 🔍 Критерии

✅ WebSocket push ✅ Email integration ✅ Preferences ✅ Priority levels ✅ 30 days history

---

**Источник:** `.BRAIN/05-technical/backend/notification-system.md`

