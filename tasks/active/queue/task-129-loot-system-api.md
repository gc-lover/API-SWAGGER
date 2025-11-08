# Task ID: API-TASK-129
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 10:15
**Создатель:** AI Agent (API Task Creator)
**Зависимости:** API-TASK-128

---

## 📋 Краткое описание

**MVP БЛОКЕР!** Создать API спецификацию для системы генерации и распределения лута. БЕЗ ЭТОГО НЕТ PROGRESSION!

**Что нужно сделать:** Создать OpenAPI спецификацию для Loot System на основе документации из .BRAIN.

---

## 🎯 Цель задания

Разработать полный REST API для системы лута, включая генерацию из loot tables, распределение между игроками, roll system и loot history.

**Зачем это нужно:**
- БЕЗ ЭТОГО НЕТ PROGRESSION (MVP блокер)
- Генерация предметов из loot tables
- Распределение лута в группах
- Roll system (need/greed/pass)

---

## 📚 Источники информации

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/loot-system.md`
**Версия документа:** v1.0.0
**API Readiness:** ready

**Ключевые концепции:**
- Loot generation из weighted loot tables
- Loot drops (NPC death, container open, quest reward)
- Distribution modes (solo, party, raid)
- Loot modes (personal, shared, need/greed/pass, master looter)
- Roll system (60s timer)
- Boss loot (guaranteed + random)
- Auto-loot settings
- Loot history tracking

---

## 📁 Целевая структура API

**Целевые файлы:**
```
api/v1/loot/
├── loot-generation.yaml   ← Generate loot from tables
├── loot-distribution.yaml ← Distribute loot in party/raid
└── loot-rolls.yaml        ← Need/greed/pass rolling system
```

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** gameplay-service  
**Порт:** 8083  
**API пути:** /api/v1/loot/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** combat (лут после боя)  
**Путь:** modules/combat/loot  
**State Store:** useCombatStore (loot, lootRolls)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- ItemCard, LootCard, RollButton, ProgressBar (timer)

**Готовые формы (@shared/forms):**
- N/A (простые кнопки need/greed/pass)

**Layouts (@shared/layouts):**
- GameLayout, CombatLayout (лут после боя)

**Хуки (@shared/hooks):**
- useDebounce
- useRealtime (для обновления roll timer)

---

## ✅ Что нужно сделать (план)

### Файл 1: loot-generation.yaml

**Endpoints:**

1. **POST /api/v1/loot/generate**
   - Генерировать лут из loot table
   - Body: loot_table_id, player_level, zone_tier, modifiers
   - Response: GeneratedItem[] (item_id, quantity, rarity)

2. **GET /api/v1/loot/tables/{loot_table_id}**
   - Получить loot table (dev/debug)
   - Response: LootTable (entries with weights)

3. **POST /api/v1/loot/drop**
   - Создать лут при событии (NPC death, container open)
   - Body: source_type, source_id, loot_table_id, participants[]
   - Response: drop_id, items[]

**Models:**
- LootGenerateRequest (loot_table_id, player_level, zone_tier, luck_modifier, quantity_modifier)
- GeneratedItem (item_id, quantity, rarity, durability, stats)
- LootTable (id, name, entries: [{item_id, weight, min_qty, max_qty}])
- LootDropRequest (source_type, source_id, loot_table_id, participants[])
- LootDrop (drop_id, items[], created_at, expires_at)

### Файл 2: loot-distribution.yaml

**Endpoints:**

1. **GET /api/v1/loot/drops/{drop_id}**
   - Получить информацию о дропе лута
   - Response: drop details + items + eligible players

2. **POST /api/v1/loot/drops/{drop_id}/claim**
   - Забрать лут (solo или personal loot)
   - Response: items added to inventory

3. **GET /api/v1/loot/drops/nearby**
   - Получить список доступных дропов рядом
   - Query: character_id, radius (default 10m)
   - Response: LootDrop[]

4. **POST /api/v1/loot/settings**
   - Обновить настройки auto-loot
   - Body: auto_loot_enabled, auto_loot_quality_threshold, auto_loot_types[]

**Models:**
- LootDropDetails (drop_id, items[], eligible_players[], loot_mode, expires_at)
- LootClaimResponse (items_added[], inventory_full)
- LootSettings (auto_loot_enabled, quality_threshold, item_types[])

### Файл 3: loot-rolls.yaml

**Endpoints:**

1. **POST /api/v1/loot/drops/{drop_id}/roll**
   - Сделать roll на предмет (need/greed/pass)
   - Body: item_id, roll_type
   - Response: roll_id, roll_value (1-100)

2. **GET /api/v1/loot/drops/{drop_id}/rolls**
   - Получить все rolls для дропа
   - Response: LootRoll[] (player, roll_type, roll_value)

3. **GET /api/v1/loot/drops/{drop_id}/winner**
   - Получить победителя roll (автоматически через 60s)
   - Response: winner_character_id, item_id

4. **POST /api/v1/loot/drops/{drop_id}/pass-all**
   - Pass на все предметы в дропе
   - Response: 200 OK

**Models:**
- LootRollRequest (item_id, roll_type: need|greed|pass)
- LootRoll (roll_id, character_id, item_id, roll_type, roll_value, timestamp)
- LootRollWinner (character_id, character_name, item_id, roll_value)

---

## 🔍 Критерии приемки

1. ✅ 3 файла созданы
2. ✅ Loot generation использует weighted tables
3. ✅ Distribution modes: solo, party, raid
4. ✅ Roll system: need/greed/pass с 60s timer
5. ✅ Auto-loot настройки
6. ✅ Boss loot (guaranteed + random)
7. ✅ Loot history tracking
8. ✅ Loot expiration (10 minutes)
9. ✅ Personal loot instancing
10. ✅ Master looter mode поддержка

---

## 📝 Дополнительная информация

### Loot Modes

**Personal Loot:**
- Каждый игрок получает свой лут
- Нет конфликтов

**Shared Loot:**
- Общий пул лута для группы
- Need/Greed/Pass rolling

**Master Looter:**
- Лидер группы распределяет вручную

### Roll Priority

1. **Need** - нужен для класса/билда
2. **Greed** - можно использовать/продать
3. **Pass** - отказ

Если несколько Need rolls → winner = max(random 1-100)

### Auto-Loot Thresholds

- **Quality:** Common, Uncommon, Rare, Epic, Legendary
- **Types:** Weapons, Armor, Consumables, Materials, Quest Items
- **Auto-pickup:** Money, Quest Items (всегда)

---

## 🔗 Связи

**Backend зависимости:**
- Combat System - NPC death triggers loot
- Inventory System - add items to inventory
- Party System - determine eligible players
- Loot Tables - weighted item generation

---

**Источник:** `.BRAIN/05-technical/backend/loot-system.md`

