# Task ID: API-TASK-234
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-08 06:10
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-215, API-TASK-227, API-TASK-232

---

## 📋 Краткое описание

Разработать OpenAPI спецификацию базовой системы инвентаря: управление слотами, стекованием, весом, экипировкой, банком и передачей предметов.

**Что нужно сделать:** Создать `api/v1/inventory/inventory-core.yaml`, покрывая REST/WS контракты из `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`.

---

## 🎯 Цель задания

Обеспечить центральный бекенд для предметов игроков, который интегрируется со всеми игровыми системами (лут, квесты, торговля, почта).

**Зачем это нужно:**
- Управлять складом предметов игрока и экипировкой
- Поддерживать вес, стекование, ограничения, банк/хранилище
- Предоставить API для выдачи/изъятия предметов сервисами прогрессии, лута, квестов
- Интегрироваться с торговлей, почтой, клановыми банками и достижениями

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`
**Версия:** v1.0.1 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Структура инвентаря, слоты, типы контейнеров
- Стекование, вес, перегрузка, расчёт capacity
- Pickup/drop, перемещение между контейнерами, quick transfer
- Экипировка: weapon/armor/implant, проверка требований
- Bank/Stash, разделение на char/account
- Hooks для других систем (quests, loot, trade, mail)

### Дополнительные источники

- `.BRAIN/05-technical/backend/loot-system/part1-loot-generation.md`
- `.BRAIN/05-technical/backend/quest-engine-backend.md`
- `.BRAIN/05-technical/backend/trade-system.md`
- `.BRAIN/05-technical/backend/mail-system.md`
- `.BRAIN/05-technical/backend/progression-backend.md`
- `.BRAIN/05-technical/backend/economy-system.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-215-loot-advanced-api.md`
- `API-SWAGGER/tasks/active/queue/task-227-combat-session-api.md`
- `API-SWAGGER/tasks/active/queue/task-232-mail-system-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/inventory/inventory-core.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/inventory/
 ├── inventory-core.yaml      ← создать/обновить
 ├── inventory-components.yaml
 └── inventory-examples.yaml
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** inventory-service
- **Порт:** 8096
- **API Base Path:** `/api/v1/inventory`
- **Зависимости:**
  - auth-service – проверка персонажа/аккаунта
  - item-service (если отдельный) – получение метаданных предметов
  - loot-service – выдача предметов
  - trade-service – перемещение в/из trade escrow
  - mail-service – вложения/изъятия
  - quest-service – предметы квестов, автозачёт
  - progression-service – бонусы carry weight, unlock slots
  - analytics-service – статистика предметов
  - notification-service – уведомления об overload, новых предметах

### Frontend
- **Модуль:** `modules/inventory/core`
- **State Store:** `useInventoryStore`
- **State:** `backpack`, `equipment`, `stash`, `filters`, `weight`, `selectedItem`
- **UI компоненты:** `InventoryGrid`, `EquipmentPanel`, `WeightIndicator`, `ItemTooltip`, `StashPanel`, `ItemContextMenu`
- **Формы:** `ItemTransferForm`, `ItemSplitForm`, `EquipItemForm`, `DropItemConfirm`
- **Хуки:** `useInventory`, `useEquipment`, `useItemFilters`, `useWeightCalc`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: inventory-service (port 8096)
# - API Base: /api/v1/inventory
# - Dependencies: auth, item, loot, trade, mail, quest, progression, analytics, notification
# - Frontend Module: modules/inventory/core (useInventoryStore)
# - UI: InventoryGrid, EquipmentPanel, WeightIndicator, ItemTooltip, StashPanel, ItemContextMenu
# - Forms: ItemTransferForm, ItemSplitForm, EquipItemForm, DropItemConfirm
# - Hooks: useInventory, useEquipment, useItemFilters, useWeightCalc
```

---

## ✅ Что нужно сделать (детальный план)

1. Определить модели инвентаря, слотов, предметов, контейнеров, веса, требований.
2. Реализовать CRUD для контейнеров (backpack, stash, equipment).
3. Добавить операции pickup/drop, move, split stack, merge stack.
4. Описать equip/unequip с проверкой требований и последствий (stats updates).
5. Реализовать расчёт веса, перегрузки, penalties, события overload.
6. Добавить API для bank/stash, сортировки, фильтров, quick transfer.
7. Настроить события (новый предмет, перегрузка, место освободилось).
8. Предусмотреть интеграцию с trade/mail/quest/loot (webhooks, резервирование).
9. Подготовить примеры, чеклист, тестовые сценарии и анти-дубликаты.

---

## 🔀 Endpoints

1. **GET `/api/v1/inventory/players/{playerId}`** – текущее состояние инвентаря (backpack, equipment, stash summary).
2. **GET `/api/v1/inventory/players/{playerId}/containers/{containerId}`** – содержимое указанного контейнера (slots, filters).
3. **POST `/api/v1/inventory/players/{playerId}/items/pickup`** – добавить предмет (loot, quest, grant) с проверкой места.
4. **POST `/api/v1/inventory/players/{playerId}/items/drop`** – сбросить предмет в мир (payload для world/spawn-service).
5. **POST `/api/v1/inventory/players/{playerId}/items/move`** – переместить предмет между контейнерами/слотами.
6. **POST `/api/v1/inventory/players/{playerId}/items/split`** – разделить стек.
7. **POST `/api/v1/inventory/players/{playerId}/items/merge`** – объединить стеки.
8. **POST `/api/v1/inventory/players/{playerId}/items/equip`** – экипировать предмет (slot, requirements, overrides).
9. **POST `/api/v1/inventory/players/{playerId}/items/unequip`** – снять предмет.
10. **POST `/api/v1/inventory/players/{playerId}/items/consume`** – использовать предмет (charges, cooldown).
11. **GET `/api/v1/inventory/players/{playerId}/weight`** – информация о весе, лимитах, модификаторах.
12. **POST `/api/v1/inventory/players/{playerId}/stash/transfer`** – перемещение между backpack и stash/bank.
13. **GET `/api/v1/inventory/players/{playerId}/history`** – журнал изменений (source, reason, delta).
14. **POST `/api/v1/inventory/players/{playerId}/reserve`** – резервирование предметов для trade/mail/quest.
15. **POST `/api/v1/inventory/players/{playerId}/release`** – снятие резерва.
16. **GET `/api/v1/inventory/players/{playerId}/filters`** – список активных фильтров, presets.
17. **POST `/api/v1/inventory/players/{playerId}/auto-sort`** – автоматическая сортировка.
18. **POST `/api/v1/inventory/players/{playerId}/cleanup`** – удаление мусора (junk sell), если есть разрешение.
19. **GET `/api/v1/inventory/templates/items/{itemId}`** – метаданные предмета (для UI).
20. **WS `/api/v1/inventory/players/{playerId}/stream`** – события: `item-added`, `item-removed`, `item-updated`, `container-updated`, `weight-updated`, `reservation-updated`, `equipment-changed`.

---

## 🧱 Модели данных

- **Inventory** – `playerId`, `containers[]`, `weight`, `capacity`, `overloaded`, `modifiers`.
- **Container** – `containerId`, `type` (`BACKPACK|EQUIPMENT|STASH|COSMETIC`), `slots[]`, `capacity`, `filters`.
- **Slot** – `slotId`, `index`, `item`, `locked`, `metadata`.
- **Item** – `itemInstanceId`, `itemId`, `name`, `rarity`, `type`, `quantity`, `weight`, `boundType`, `durability`, `stats`, `expiresAt`, `metadata`.
- **EquipmentSlot** – `slotType`, `item`, `requirements`, `status`.
- **WeightInfo** – `current`, `capacity`, `encumbrancePercent`, `penalty`, `modifiers`.
- **Reservation** – `reservationId`, `context`, `items[]`, `expiresAt`, `status`.
- **InventoryHistoryEntry** – `entryId`, `event`, `source`, `delta`, `timestamp`, `relatedEntity`.
- **RealtimeEventPayload** – `itemAdded`, `itemRemoved`, `itemUpdated`, `containerUpdated`, `weightUpdated`, `reservationUpdated`, `equipmentChanged`.
- **Error Schema (`InventoryError`)** – codes (`CONTAINER_FULL`, `SLOT_LOCKED`, `ITEM_NOT_FOUND`, `WEIGHT_LIMIT`, `REQUIREMENT_FAILED`, `RESERVATION_CONFLICT`, `RESERVATION_NOT_FOUND`, `AUTO_SORT_DISABLED`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth` (player), `ServiceToken` (system services), `GMToken` (GM operations).
- Consistency: операция атомарна, использовать транзакции/саги; при ошибке rollback.
- Weight & Limits: всегда проверять перед pickup/move/equip; возвращать подробные ошибки.
- Reservations: обязательны для trade/mail/auction; enforce при попытке drop/trade.
- Localization: UI тексты/tooltip через item-service (не хранить в API).
- Event-driven: публиковать события в analytics и progression (item milestone).
- Security: валидация ID предметов (anti-duplication), проверка ownership.

---

## 🧪 Примеры

- Подбор оружия с автоматическим перемещением в свободный слот и уведомлением о весе.
- Экипировка брони с проверкой требований уровня и класса.
- Перемещение предметов в клановый банк через резервирование.
- Разделение стека боеприпасов и быстрая передача в почту.
- WebSocket событие `item-added` после завершения рейда.

---

## 🔗 Связности и зависимости

- Интегрировано с loot generation, quest rewards, trade, mail, progression, analytics.
- Используется UI Inventory и Equipment панелями, а также mobile companion.
- Сообщает в notification-service об overload и новых предметах.

---

## ✅ Критерии приемки

1. `inventory-core.yaml` описывает все контейнеры, операции и события.
2. Модели покрывают слоты, предметы, вес, резервы, историю.
3. Прописаны ограничения, авторизация, события, интеграции.
4. Примеры и тест-кейсы подготовлены, чеклист выполнен.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, UI модуль, зависимости
- [ ] Эндпоинты и события покрывают весь функционал инвентаря
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] Обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Как обрабатывать временные контейнеры (event bags)?**
**A:** Предусмотреть тип `TEMPORARY` с временем истечения; описать в `Container` и очистку после события.

**Q:** Поддерживаются ли модульные предметы (сокеты)?**
**A:** Да, добавить ссылку на `inventory-advanced` (Part 2) и в модели `Item.metadata` предусмотреть `modules[]`.


