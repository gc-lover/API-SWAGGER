# Task ID: API-TASK-206
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 23:45
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию системы жилья игроков (`housing-system`).

**Что нужно сделать:** Разработать `api/v1/gameplay/housing/housing-system.yaml`, описав управление апартаментами, кастомизацию интерьера, социальные функции, хранилище и апгрейды.

---

## 🎯 Цель задания

Предоставить игрокам и социальным сервисам API для жилья: покупка, настройка, приглашения друзей, хранение предметов, функциональные улучшения и аналитика посещаемости.

**Зачем это нужно:**
- Создать социальный хаб и персонализацию для игроков
- Интегрировать жильё с экономикой (покупка мебели, апгрейды)
- Обеспечить хранение предметов, крафтовые станции, бонусы
- Собирать данные для LiveOps (популярные районы, посещаемость)

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/housing/housing-system.md`
**Версия:** v1.0.0 (2025-11-07 02:34)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Процесс покупки апартаментов, выбор локации/уровня
- Каталог мебели/декора, размещение в слотах/ячейках
- Функциональные апгрейды (крафт, хранение, тренировочные зоны)
- Социальные функции (приглашения друзей, access control, мероприятия)
- Prestige рейтинг, бухгалтерия жилья, апгрейды уровня
- Взаимодействие с инвентарём, крафтом, экономикой, уведомлениями

### Дополнительные источники

- `.BRAIN/05-technical/backend/economy-system.md` (стоимость, аренда, налоги)
- `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`
- `.BRAIN/05-technical/backend/party-system.md` (приглашения/группы)
- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`

### Связанные документы

- `.BRAIN/05-technical/backend/companion/companion-system.md` (宠 для жилья)
- `.BRAIN/05-technical/backend/progression-backend.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/housing/housing-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/housing/
 └── housing-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/housing`
- **Зависимости:** auth-service, economy-service, inventory-service, notification-service, analytics-service, progression-service, incident-service

### Frontend
- **Модуль:** `modules/gameplay/housing`
- **State Store:** `useHousingStore`
- **State:** `properties`, `layouts`, `furnitureCatalog`, `storage`, `guests`, `prestige`
- **UI компоненты:** `HousingMap`, `ApartmentPreview`, `InteriorEditor`, `FurnitureInventory`, `GuestList`, `PrestigeMeter`
- **Формы:** `PurchaseApartmentForm`, `InviteGuestForm`, `FurniturePlacementForm`, `UpgradeApartmentForm`
- **Layouts:** `HousingHubLayout`, `ApartmentInteriorLayout`
- **Хуки:** `useHousingProperties`, `useInteriorEditor`, `useHousingGuests`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/housing
# - Dependencies: auth-service, economy-service, inventory-service, notification-service, analytics-service, progression-service, incident-service
# - Frontend Module: modules/gameplay/housing (useHousingStore)
# - UI: HousingMap, ApartmentPreview, InteriorEditor, FurnitureInventory, GuestList, PrestigeMeter
# - Forms: PurchaseApartmentForm, InviteGuestForm, FurniturePlacementForm, UpgradeApartmentForm
# - Layouts: HousingHubLayout, ApartmentInteriorLayout
# - Hooks: useHousingProperties, useInteriorEditor, useHousingGuests
```

---

## ✅ Что нужно сделать (детальный план)

1. CRUD для апартаментов (покупка, список, детали, обновления, продажа/переезд).
2. Управление интерьером: установка мебели, перестановка, предустановки (layouts).
3. Структура каталога мебели/декора, фильтры, редкость и стоимости.
4. Функции хранения (storage slots), инвентарь, крафтовые станки.
5. Социальные функции: приглашения, списки гостей, приватность.
6. Prestige и прогресс жилья (уровни, бонусы).
7. Аналитика/отчёты: популярность зон, посещаемость, top prestige.
8. События и уведомления (приглашения, апгрейды, завершение строительства).
9. Подготовить примеры, FAQ, тест-план; пройти чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/gameplay/housing/apartments`** – купить/арендовать жильё (локация, тип, начальный уровень).
2. **GET `/api/v1/gameplay/housing/apartments`** – список владений игрока (фильтры по локации/уровню).
3. **GET `/api/v1/gameplay/housing/apartments/{apartmentId}`** – детали: планировка, апгрейды, аренда, состояние.
4. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/upgrade`** – повышение уровня, покупка дополнительных комнат/слотов.
5. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/layouts`** – сохранить/загрузить набор размещения мебели.
6. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/furniture`** – разместить/переместить/удалить предмет (slot, координаты).
7. **GET `/api/v1/gameplay/housing/catalog`** – каталог мебели/декора, фильтры по типу, редкости, источнику.
8. **POST `/api/v1/gameplay/housing/catalog/purchase`** – купить предмет (валюта, проверка наличия).
9. **GET `/api/v1/gameplay/housing/storage`** – содержимое хранилища (stack, capacity, upgrades).
10. **POST `/api/v1/gameplay/housing/storage/transfer`** – переместить предметы между жильём и инвентарём.
11. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/guests`** – пригласить/удалить гостя, установить список доступа.
12. **GET `/api/v1/gameplay/housing/apartments/{apartmentId}/guests`** – текущие гости, приглашения, лог посещений.
13. **GET `/api/v1/gameplay/housing/analytics`** – популярность локаций, usage rate, престиж, время онлайна.
14. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/events`** – запланировать мероприятие (вечеринка, торговля).
15. **POST `/api/v1/gameplay/housing/apartments/{apartmentId}/sell`** – продать/переехать (сводка, штрафы, логистику).

---

## 🧱 Модели данных

- **Apartment** – id, playerId, location, tier, rooms, prestige, status (`ACTIVE|RENOVATION|FOR_SALE`), createdAt.
- **ApartmentPurchaseRequest/Response** – locationId, type, price, paymentMethod, initialLayout.
- **ApartmentUpgradeRequest** – upgradeType (`ROOM`, `STORAGE`, `FUNCTIONAL`), cost, buildTime.
- **LayoutPreset** – presetId, name, furniturePlacement[], lastUpdated.
- **FurniturePlacement** – itemId, slotId, position (x,y,z), rotation, customizationOptions.
- **FurnitureItem** – cosmeticId, name, type (`furniture|decor|functional`), rarity, price, currency, tags.
- **StorageStatus** – capacity, usedSlots, storedItems[], upgrades.
- **StoredItem** – itemId, quantity, quality, source.
- **GuestInvite** – guestPlayerId, status (`PENDING|ACCEPTED|DECLINED`), invitedAt, expiresAt.
- **GuestLogEntry** – playerId, joinedAt, leftAt, actions.
- **HousingEvent** – eventId, eventType (`party|trade|raid`), startAt, endAt, participants, rewards.
- **HousingAnalyticsResponse** – visitsPerDay, popularLocations, topPrestigeApartments, dwellTime, revenue.
- **SellApartmentRequest** – price, toNpc/buyerPlayerId, includeFurniture bool.
- **Error schemas** – `HousingError` (`APARTMENT_LIMIT_REACHED`, `INSUFFICIENT_FUNDS`, `INVALID_SLOT`, `INVITE_LIMIT`, `ITEM_NOT_OWNED`).
- **Event payloads** – `ApartmentPurchasedEvent`, `HousingFurniturePlacedEvent`, `HousingGuestInvitedEvent`, `HousingEventScheduledEvent`, `HousingPrestigeChangedEvent`.

Все модели должны иметь описания, `required`, валидации, примеры.

---

## 🧭 Принципы и правила

- Безопасность: `BearerAuth` для игроков, `ServiceToken` для системных сервисов.
- Стандартные ответы/ошибки использовать из `api/v1/shared/common/responses.yaml`.
- Указать лимиты: max apartments per player, guest limit, cooldown на перестановку мебели.
- Интеграция с incident-service (эксплойты, подозрительные передачи имущества).
- Согласовать валюты/цены с economy-service.

---

## 🧪 Примеры

- Покупка апартаментов в районе Watson.
- Размещение мебели (JSON расположения).
- Приглашение друга в квартиру и лог посещений.
- Аналитика популярности локаций за неделю.
- Продажа апартаментов и переселение.

---

## 🔗 Связности и зависимости

- Работает с inventory (перемещение предметов), economy (покупки/аренда), notification (приглашения/мероприятия).
- Синхронизация с progression (prestige, достижения), companion system (pet slots дома).
- Может инициировать world events (housing tours, конкурсы).

---

## ✅ Критерии приемки

1. Файл `housing-system.yaml` создан с архитектурным комментарием.
2. Все ключевые эндпоинты задокументированы с примерами.
3. Описаны модели для апартаментов, мебели, гостей, хранилища, событий и аналитики.
4. Сформулированы ограничения, интеграции, события.
5. Подготовлены примеры JSON и тест-план.
6. Пройден чеклист `tasks/config/checklist.md`, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли делиться квартирой с кланом?** – Нет, только гостевой доступ (описать в FAQ).
- **Что происходит при переезде?** – Все предметы возвращаются в storage, престиж частично переносится.
- **Можно ли сравнивать престиж с другими?** – Да, через аналитику и лидерборд (экстра).
- **Как обновляются furniture-комплекты?** – Через shop/events (описать ожидание).

---

## 🕓 История выполнения

- 2025-11-07 23:45 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

