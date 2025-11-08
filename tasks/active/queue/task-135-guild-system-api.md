# Task ID: API-TASK-135
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:30 | **Создатель:** AI Agent | **Зависимости:** API-TASK-133

---

## 📋 Описание

Создать API для системы гильдий. Guild creation, membership, ranks/permissions, guild bank, progression.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/guild-system-backend.md` (v1.0.0, ready)

**Ключевые механики:**
- Guild creation/deletion
- Membership (invite/join/leave/kick)
- Ranks & Permissions (guild master, officers, members)
- Guild bank (общий склад)
- Guild progression (levels, perks)
- Guild events (календарь событий)
- Guild wars support (PvP между гильдиями)
- Max members: scalable (50-500 зависит от уровня)

---

## 📁 Целевой файл

`api/v1/guilds/guild-system.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** social-service  
**Порт:** 8084  
**API пути:** /api/v1/guilds/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** social  
**Путь:** modules/social/guild  
**State Store:** useSocialStore (guild, guildMembers, guildBank, permissions)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Card, GuildCard, CharacterCard (members), ProgressBar (guild level), ItemCard (bank)

**Готовые формы (@shared/forms):**
- GuildCreationForm, GuildInviteForm, GuildBankForm

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useRealtime (для guild events)
- useDebounce

---

## ✅ Endpoints (план)

1. **POST /api/v1/guilds** - Создать гильдию
2. **GET /api/v1/guilds/{guild_id}** - Информация о гильдии
3. **POST /api/v1/guilds/{guild_id}/invite** - Пригласить игрока
4. **POST /api/v1/guilds/{guild_id}/join** - Вступить в гильдию
5. **POST /api/v1/guilds/{guild_id}/leave** - Покинуть гильдию
6. **POST /api/v1/guilds/{guild_id}/kick** - Выгнать участника
7. **PATCH /api/v1/guilds/{guild_id}/rank** - Изменить ранг участника
8. **GET /api/v1/guilds/{guild_id}/members** - Список участников
9. **GET /api/v1/guilds/{guild_id}/bank** - Guild bank inventory
10. **POST /api/v1/guilds/{guild_id}/bank/deposit** - Пожертвовать в банк
11. **POST /api/v1/guilds/{guild_id}/bank/withdraw** - Забрать из банка (permissions)

**Models:**
- Guild, GuildMember, GuildRank, GuildBank, GuildPermissions

---

## 🔍 Критерии

✅ Ranks/permissions ✅ Guild bank ✅ Progression ✅ Max members scaling ✅ Events calendar

---

**Источник:** `.BRAIN/05-technical/backend/guild-system-backend.md`

