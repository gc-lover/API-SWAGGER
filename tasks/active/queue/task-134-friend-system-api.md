# Task ID: API-TASK-134
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:28 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы друзей. Friend list, requests, online status, ignore/block.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/friend-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Friend list (add/remove)
- Friend requests (send/accept/decline)
- Online status tracking
- Ignore/Block list (отдельный от friends)
- Recent players (кто встречался недавно)
- Friend notifications
- Max friends: unlimited (reasonable limit ~500)

---

## 📁 Целевой файл

`api/v1/social/friends.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** social-service  
**Порт:** 8084  
**API пути:** /api/v1/social/friends*, /api/v1/social/block*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** social  
**Путь:** modules/social/friends  
**State Store:** useSocialStore (friends, friendRequests, onlineStatus)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Card, CharacterCard, Badge (online status), Button

**Готовые формы (@shared/forms):**
- FriendRequestForm

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useRealtime (для online status)
- useDebounce (для поиска друзей)

---

## ✅ Endpoints (план)

1. **GET /api/v1/social/friends** - Список друзей с online status
2. **POST /api/v1/social/friends/request** - Отправить friend request
3. **POST /api/v1/social/friends/accept** - Принять запрос
4. **DELETE /api/v1/social/friends/{friend_id}** - Удалить из друзей
5. **GET /api/v1/social/friends/requests** - Входящие запросы
6. **GET /api/v1/social/friends/online** - Только online друзья
7. **POST /api/v1/social/block** - Заблокировать игрока
8. **GET /api/v1/social/recent-players** - Недавние игроки

**Models:**
- Friend, FriendRequest, BlockedPlayer, RecentPlayer

---

## 🔍 Критерии

✅ Online status ✅ Friend requests ✅ Block list ✅ Recent players ✅ Notifications

---

**Источник:** `.BRAIN/05-technical/backend/friend-system.md`

