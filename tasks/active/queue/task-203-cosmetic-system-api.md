# Task ID: API-TASK-203
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 22:45
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию косметической системы (`cosmetic-system`), включая магазин, инвентарь и кастомизацию.

**Что нужно сделать:** Спроектировать `api/v1/gameplay/cosmetics/cosmetic-system.yaml`, покрыв CRUD косметики, магазин ротаций, экипировку, эмоты, лидерборды и аналитики.

---

## 🎯 Цель задания

Дать игрокам и администрации полноценный API для управления косметическими предметами и монетизацией, синхронизируя магазин, награды и кастомизацию персонажа.

**Зачем это нужно:**
- Поддержать персонализацию персонажей и оружия
- Обеспечить ежедневные/еженедельные ротации магазина и специальные предложения
- Вести аналитику покупок, употребление косметики, satisfaction рейтинг
- Интегрировать косметические награды с battle pass, событиями и прогрессией

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/cosmetic/cosmetic-system.md`
**Версия:** v1.0.0 (2025-11-07)
**Статус:** approved, api-readiness: ready

**Важные разделы:**
- Типы косметики (skins, emotes, titles, name plates, victory poses)
- Таблицы `cosmetic_items`, `player_cosmetics`, `player_equipped_cosmetics`
- Магазин (daily/weekly rotation, featured items, bundles)
- Награды: battle pass, события, достижения, покупки
- Ограничения: rarity tiers, эксклюзивы, limited-time, коллекции
- Anti-abuse: self-trade запрет, region lock, duplicate handling

### Дополнительные источники

- `.BRAIN/05-technical/backend/economy-system.md` (валюты/цены)
- `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`
- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/achievement-system.md` (косметические награды)

### Связанные документы

- `.BRAIN/05-technical/backend/trade-system.md` (ограничения торговли)
- `.BRAIN/05-technical/backend/mail-system.md` (доставка подарков)

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/cosmetics/cosmetic-system.yaml`
- **Версия API:** v1
- **Тип:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/cosmetics/
 └── cosmetic-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/cosmetics`
- **Зависимости:** auth-service, inventory-service, economy-service, notification-service, analytics-service, incident-service

### Frontend
- **Модуль:** `modules/gameplay/cosmetics`
- **State Store:** `useCosmeticsStore`
- **State:** `ownedItems`, `equippedLoadout`, `shopRotations`, `bundles`, `collections`
- **UI компоненты:** `CosmeticInventoryGrid`, `CosmeticDetailModal`, `ShopRotationCarousel`, `BundlePreview`, `EmoteWheel`
- **Формы:** `PurchaseCosmeticForm`, `EquipCosmeticForm`, `GiftCosmeticForm`
- **Layouts:** `GameLayout`, `CosmeticHubLayout`
- **Хуки:** `useCosmeticInventory`, `useShopRotations`, `useCollections`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/cosmetics
# - Dependencies: auth-service, inventory-service, economy-service, notification-service, analytics-service, incident-service
# - Frontend Module: modules/gameplay/cosmetics (useCosmeticsStore)
# - UI: CosmeticInventoryGrid, CosmeticDetailModal, ShopRotationCarousel, BundlePreview, EmoteWheel
# - Forms: PurchaseCosmeticForm, EquipCosmeticForm, GiftCosmeticForm
# - Layouts: GameLayout, CosmeticHubLayout
# - Hooks: useCosmeticInventory, useShopRotations, useCollections
```

---

## ✅ Что нужно сделать (детальный план)

1. Определить CRUD эндпоинты для каталога косметики и инвентаря игрока.
2. Задокументировать магазин: ежедневные/еженедельные ротации, featured, bundles, flash sale.
3. Реализовать выдачу наград из различных источников (achievements, battle pass, events, purchase).
4. Добавить управление экипировкой (основные слоты + избранные эмоты).
5. Описать gifting/promo codes при необходимости.
6. Добавить аналитику/репорты (популярность, продажи, коллекции).
7. Учесть ограничения и анти-абуз (region lock, duplicates, inventory capacity).
8. Подготовить примеры и тест-план; пройти чеклист.

---

## 🔀 Endpoints

1. **GET `/api/v1/gameplay/cosmetics/catalog`** – каталог предметов (фильтры: тип, редкость, доступность).
2. **GET `/api/v1/gameplay/cosmetics/items/{itemId}`** – детали предмета (описание, эффекты, источники).
3. **POST `/api/v1/gameplay/cosmetics/purchase`** – покупка косметики (валюта/цена/регион проверки).
4. **POST `/api/v1/gameplay/cosmetics/redeem`** – получение косметики (achievement/event/battle pass).
5. **GET `/api/v1/gameplay/cosmetics/inventory`** – инвентарь игрока (owned items, источники).
6. **POST `/api/v1/gameplay/cosmetics/equip`** – экипировать предмет/эмоту/титул.
7. **POST `/api/v1/gameplay/cosmetics/unequip`** – снять предмет.
8. **GET `/api/v1/gameplay/cosmetics/equipped`** – текущий loadout (скины, эмоты, титулы).
9. **GET `/api/v1/gameplay/cosmetics/shop/rotations`** – текущая ротация (daily/weekly, featured, bundles).
10. **POST `/api/v1/gameplay/cosmetics/shop/rotations`** – обновить ротацию (админ, cron job).
11. **POST `/api/v1/gameplay/cosmetics/bundles`** – купить bundle (несколько предметов).
12. **POST `/api/v1/gameplay/cosmetics/gift`** – подарить косметику другому игроку.
13. **GET `/api/v1/gameplay/cosmetics/collections`** – прогресс коллекций (сет из нескольких предметов).
14. **GET `/api/v1/gameplay/cosmetics/analytics`** – продажи, популярность, владеют/используют.
15. **POST `/api/v1/gameplay/cosmetics/items`** – админ добавление/обновление предмета.

---

## 🧱 Модели данных

- **CosmeticItem** – id, code, name, description, type, category, rarity, price, currency, exclusivity, assets, availability.
- **CosmeticCatalogFilter** – type, rarity, source, purchasable, search.
- **PurchaseRequest/Response** – itemId, paymentMethod, price, taxation, bonus, updatedBalance.
- **RedeemRequest** – source (`achievement`, `event`, `battle_pass`, `promo_code`), referenceId.
- **PlayerInventoryItem** – itemId, acquiredAt, source, usageStats, favorite.
- **EquipRequest** – slotType (`character_skin`, `weapon_skin`, `title`, `emote_slot`), itemId.
- **ShopRotation** – rotationId, type (`daily|weekly|featured|bundle`), startAt, endAt, items[], bundlePrice.
- **BundlePurchaseRequest** – bundleId, items[], discount, currency.
- **GiftRequest** – targetPlayerId, itemId, message.
- **CollectionProgress** – collectionId, name, totalItems, ownedItems, rewards.
- **AnalyticsResponse** – topItems, revenue, usageRate, conversionRate, rarityDistribution.
- **AdminItemRequest** – create/update поля (rarity, assets, availability, tags).
- **Error schemas** – `CosmeticError` (`ITEM_NOT_FOUND`, `INSUFFICIENT_FUNDS`, `REGION_LOCKED`, `HOTFIX_LOCK`, `ALREADY_OWNED`).
- **Event payloads** – `CosmeticPurchasedEvent`, `CosmeticEquippedEvent`, `CosmeticRotationUpdatedEvent`, `CosmeticGiftedEvent`.

Все модели снабдить описаниями, `required`, ограничениями, примерами.

---

## 🧭 Принципы и правила

- Безопасность: `BearerAuth` для игроков, `ServiceToken` для cron/admin.
- Использовать `api/v1/shared/common/responses.yaml` для стандартных ответов.
- Согласовать лимиты: макс. подарков/день, ограничения на покупки (region lock), double-spend защита.
- Указать взаимодействие с incident-service для расследования подозрительных транзакций.
- Хранить ссылки на ассеты (CDN) и размер/тип.

---

## 🧪 Примеры

- Покупка легендарного скина (просьба/ответ + обновление баланса).
- Ротация магазина (daily + featured список).
- Экипировка эмоты в слот.
- Прогресс коллекции (4/6 предметов, награда за completion).
- Аналитика продаж за неделю (JSON отчёт).

---

## 🔗 Связности и зависимости

- Получает данные о валюте из economy-service.
- Отправляет уведомления игрокам (новые предметы, подарки).
- Публикует события для analytics и incident.
- Интегрируется с inventory-service (storage), также с progression/achievement для наград.

---

## ✅ Критерии приемки

1. Файл `cosmetic-system.yaml` создан с архитектурным комментарием.
2. Все 15 endpoints задокументированы с request/response и примерами.
3. Модели данных покрывают каталог, инвентарь, магазин, награды и аналитику.
4. Описаны события и интеграции с другими сервисами.
5. Указаны бизнес-правила (лимиты, эксклюзивы, region lock).
6. Подготовлен FAQ и тест-план; пройден чеклист.

---

## ❓ FAQ

- **Можно ли вернуть косметику?** – Нет, покупки final (описать политику возврата).
- **Как обрабатываются промокоды?** – Через endpoint `redeem`, валидируются economy-service.
- **Что делать при дубликате?** – Авто-превратить в валюту/чармы (описать в responses).
- **Как часто обновляется магазин?** – Daily/weekly cron + featured; описать в `settings`.
- **Поддерживаются ли region-specific магазины?** – Да, добавить поле `regions` в ротации.

---

## 🕓 История выполнения

- 2025-11-07 22:45 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

