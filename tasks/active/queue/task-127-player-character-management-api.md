# Task ID: API-TASK-127
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 10:05
**Создатель:** AI Agent (API Task Creator)
**Зависимости:** API-TASK-126

---

## 📋 Краткое описание

**MVP БЛОКЕР!** Создать API спецификацию для системы управления игроками и персонажами. БЕЗ ЭТОЙ СИСТЕМЫ ИГРА НЕ МОЖЕТ ЗАПУСТИТЬСЯ.

**Что нужно сделать:** Создать OpenAPI спецификацию для Player & Character Management System на основе документации из .BRAIN.

---

## 🎯 Цель задания

Разработать полный REST API для управления профилями игроков и их персонажами, включая создание/удаление персонажей, переключение между ними, кастомизацию внешности и управление слотами.

**Зачем это нужно:**
- БЕЗ ЭТОГО ИГРА НЕ ЗАПУСТИТСЯ (MVP блокер)
- Обеспечивает создание и хранение персонажей
- Управляет переключением между персонажами
- Хранит данные прогресса каждого персонажа

---

## 📚 Источники информации

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/player-character-management.md`
**Версия документа:** v1.0.0
**API Readiness:** ready

**Ключевые концепции:**
- Player profiles (account-wide данные)
- Character creation/deletion
- Character switching (active character)
- Character slots (3 base + 2 premium = max 5)
- Character data (attributes, skills, inventory IDs, level, experience)
- Appearance customization (body, face, cyberware visibility)
- Naming validation (unique, 3-20 chars)
- Soft delete (30 days grace period)
- Character stats snapshot

---

## 📁 Целевая структура API

**Целевые файлы:**
```
api/v1/players/
├── players.yaml       ← Player profiles (account-wide)
└── characters.yaml    ← Character CRUD operations
```

---

## ✅ Что нужно сделать (план)

### Файл 1: players.yaml

**Endpoints:**

1. **GET /api/v1/players/me**
   - Получить свой player profile
   - Response: player_id, account_id, premium_currency, settings

2. **PATCH /api/v1/players/me**
   - Обновить player profile (settings)
   - Body: ui_settings?, audio_settings?, graphics_settings?, language?

3. **GET /api/v1/players/me/statistics**
   - Статистика аккаунта (total_playtime, characters_count)

**Models:**
- PlayerProfile (id, account_id, premium_currency, settings, created_at)
- PlayerSettings (ui_settings, audio_settings, graphics_settings, language, timezone)
- PlayerStatistics (total_playtime, characters_count, achievement_points)

### Файл 2: characters.yaml

**Endpoints:**

1. **GET /api/v1/characters**
   - Получить список всех персонажей игрока
   - Response: Character[] (id, name, class, level, is_active)

2. **POST /api/v1/characters**
   - Создать нового персонажа
   - Body: name, class_id, appearance, origin_id
   - Validation: max 5 characters, unique name
   - Response: Character (full data)

3. **GET /api/v1/characters/{character_id}**
   - Получить детальную информацию о персонаже
   - Response: CharacterDetails (full data)

4. **DELETE /api/v1/characters/{character_id}**
   - Удалить персонажа (soft delete)
   - Action: deleted_at = now, deleted = true
   - Response: 204 No Content

5. **POST /api/v1/characters/{character_id}/restore**
   - Восстановить удаленного персонажа (в течение 30 дней)
   - Response: Character

6. **POST /api/v1/characters/{character_id}/switch**
   - Переключиться на персонажа (сделать активным)
   - Action: active_character_id = character_id
   - Response: 200 OK

7. **PATCH /api/v1/characters/{character_id}/appearance**
   - Обновить внешность персонажа
   - Body: appearance (body, face, cyberware)

8. **PATCH /api/v1/characters/{character_id}/name**
   - Переименовать персонажа (premium feature?)
   - Body: new_name
   - Validation: unique, 3-20 chars

**Models:**
- Character (id, player_id, name, class_id, origin_id, level, experience, appearance, created_at, last_played_at, deleted, is_active)
- CharacterDetails (extends Character + attributes, skills, current_location, faction_id)
- CharacterCreateRequest (name, class_id, appearance, origin_id)
- CharacterAppearance (body_type, skin_color, hair_style, face_options, cyberware_visibility)
- CharacterSlots (used_slots, max_slots, can_create_more)

---

## 🔍 Критерии приемки

1. ✅ 2 файла созданы (players.yaml, characters.yaml)
2. ✅ Character creation включает выбор класса и origin
3. ✅ Валидация имени (unique, 3-20 chars, no special chars)
4. ✅ Soft delete с grace period 30 дней
5. ✅ Character switching обновляет active_character_id
6. ✅ Ограничение: max 5 characters per player
7. ✅ Appearance customization задокументирована
8. ✅ Связь с Authentication System (account_id)
9. ✅ Связь с Session Management (active character при login)
10. ✅ Error responses стандартизированы

---

## 📝 Дополнительная информация

### Character Slots

- Base: 3 slots (бесплатно)
- Premium: +2 slots (покупка за premium currency)
- Maximum: 5 slots per account

### Character Lifecycle

```
CREATE → ACTIVE → PLAY → SWITCH → INACTIVE
                     ↓
                  DELETE (soft) → RESTORE (30 days) → ACTIVE
                     ↓
                  PERMANENT DELETE (after 30 days)
```

### Naming Rules

- Length: 3-20 characters
- Allowed: a-z, A-Z, 0-9, underscore, dash
- Must start with letter
- Unique globally (not just per player)
- No offensive words (blacklist check)

---

## 🔗 Связи

**Backend зависимости:**
- Authentication System - account_id для player profile
- Session Management - active_character_id при входе
- Progression System - class_id, attributes, skills
- Inventory System - character inventory
- Quest System - quest progress per character

**Frontend зависимости:**
- Character Creation Screen
- Character Selection Screen
- Appearance Editor
- Character Management UI

---

**Источник:** `.BRAIN/05-technical/backend/player-character-management.md`

