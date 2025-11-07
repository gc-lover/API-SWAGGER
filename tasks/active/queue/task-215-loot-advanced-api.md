# Task ID: API-TASK-215
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 01:52
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** API-TASK-129, API-TASK-214

---

## 📋 Краткое описание

Расширить API системы лута, добавив поддержку продвинутых механик Part 2: roll-система Need/Greed, smart loot, boss loot, bad luck protection, анти-дюпы, история и автолут.

**Что нужно сделать:** Создать `api/v1/loot/loot-advanced.yaml`, описав REST и событийнyе контракты для распределения лута, управления роллами и алгоритмов smart loot.

---

## 🎯 Цель задания

Обеспечить честное и гибкое распределение добычи в группах и соло, снизив факторы случайности и фрустрации.

**Зачем это нужно:**
- Реализовать механики Need/Greed/Priority rolls
- Повысить релевантность добычи через smart loot и гарантии
- Управлять босcовыми наградами, защитой от невезения и дубликатов
- Интегрировать события лута с инвентарём, прогрессией, ачивками

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/loot-system/part2-advanced-loot.md`
**Версия:** v1.0.1 (2025-11-07 02:19)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Структура таблиц `loot_rolls`, статус PENDING/COMPLETED
- Smart Loot Service (class/spec релевантность)
- Boss loot гарантии, party distribution, achievements
- Anti-duplicate, bad luck protection, legendary гарантия
- API endpoints summary (rolls, settings, history)

### Дополнительные источники

- `.BRAIN/05-technical/backend/loot-system/part1-loot-generation.md`
- `.BRAIN/05-technical/backend/inventory-system/part2-advanced-features.md`
- `.BRAIN/05-technical/backend/party-system.md`
- `.BRAIN/05-technical/backend/achievement-system.md`
- `.BRAIN/05-technical/backend/notification-system.md`

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-129-loot-system-api.md`
- `API-SWAGGER/tasks/active/queue/task-214-inventory-advanced-api.md`

---

## 📁 Целевая структура API

- **Файл:** `api/v1/loot/loot-advanced.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3 (REST + Events)

```
API-SWAGGER/api/v1/loot/
 ├── loot-generation.yaml      (core Part 1)
 └── loot-advanced.yaml        ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service (loot module)
- **Порт:** 8083
- **API Base Path:** `/api/v1/loot`
- **Зависимости:**
  - auth-service – удостоверение игроков
  - party-service – состав групп
  - inventory-service – выдача предметов, проверки дубликатов
  - economy-service – оценка стоимости/налоги
  - achievement-service – отслеживание босcовых наград
  - notification-service – уведомления о роллах, победителях

### Frontend
- **Модуль:** `modules/gameplay/loot`
- **State Store:** `useLootStore`
- **State:** `nearbyDrops`, `activeRolls`, `history`, `settings`, `bossLoot`, `filters`
- **UI компоненты:** `LootDropList`, `NeedGreedPanel`, `SmartLootSettings`, `BossLootSummary`, `LootHistory`, `BadLuckIndicator`
- **Формы:** `RollSubmissionForm`, `AutoLootSettingsForm`, `LootFilterForm`
- **Layouts:** `GameLayout`
- **Хуки:** `useLootRolls`, `useSmartLoot`, `useLootHistory`, `useBadLuckProtection`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/loot
# - Dependencies: auth, party, inventory, economy, achievement, notification
# - Frontend Module: modules/gameplay/loot (useLootStore)
# - UI: LootDropList, NeedGreedPanel, SmartLootSettings, BossLootSummary, LootHistory, BadLuckIndicator
# - Forms: RollSubmissionForm, AutoLootSettingsForm, LootFilterForm
# - Hooks: useLootRolls, useSmartLoot, useLootHistory, useBadLuckProtection
```

---

## ✅ Что нужно сделать (детальный план)

1. Расширить модели лута: roll entries, smart loot metadata, boss loot структуры.
2. Описать эндпоинты роллов (start, submit, resolve), историю, настройки автолута.
3. Внести механизмы анти-дюпов и bad luck protection, включая отчётность.
4. Описать выдачу гарантированных наград (boss loot) и party распределение.
5. Настроить события event bus (roll started, roll completed, loot assigned).
6. Указать лимиты времени (60 сек на roll), проверку ролей, таймеры.
7. Добавить примеры JSON для roll submissions, boss loot, smart loot.
8. Согласовать интеграции с инвентарём, ачивками, уведомлениями, analytics.
9. Пройти чеклист и добавить тестовый план.

---

## 🔀 Endpoints

1. **GET `/api/v1/loot/drops/nearby`** – список доступного лута рядом с игроком/группой.
2. **POST `/api/v1/loot/drops/{dropId}/claim`** – начать распределение дропа (Need/Greed/Auto).
3. **GET `/api/v1/loot/rolls/{rollId}`** – получить состояние ролла (участники, таймер, ставки).
4. **POST `/api/v1/loot/rolls/{rollId}/submit`** – отправить Need/Greed/Pass/Auto ставку.
5. **POST `/api/v1/loot/rolls/{rollId}/resolve`** – принудительно завершить ролл (пати лидер, таймер истёк).
6. **GET `/api/v1/loot/rolls/active`** – список активных роллов игрока.
7. **GET `/api/v1/loot/settings`** – получить настройки smart loot/auto loot.
8. **PUT `/api/v1/loot/settings`** – обновить настройки (минимальная редкость, классовые предпочтения).
9. **GET `/api/v1/loot/boss/{bossId}`** – информация о гарантированном и случайном босcовом луте.
10. **POST `/api/v1/loot/boss/{bossId}/distribute`** – распределить босcовый дроп (party или solo).
11. **GET `/api/v1/loot/history`** – журнал полученных предметов, роллов, источников (пагинация, фильтры).
12. **GET `/api/v1/loot/bad-luck`** – состояние bad luck protection (последний legendary, прогресс).
13. **POST `/api/v1/loot/duplicate-check`** – проверка дубликата (inventory + bank) перед выдачей.
14. **POST `/api/v1/loot/admin/reroll`** – административная команда на перераспределение (audit).
15. **WS `/api/v1/loot/stream`** – события: `roll-started`, `roll-updated`, `roll-completed`, `loot-assigned`, `bad-luck-triggered`, `duplicate-blocked`.

---

## 🧱 Модели данных

- **LootDrop** – `dropId`, `source` (`BOSS|CHEST|WORLD`), `items[]`, `expiresAt`, `location`, `partyId`.
- **LootRoll** – `rollId`, `dropId`, `items[]`, `participants[]`, `status`, `expiresAt`, `winner`, `rollHistory[]`.
- **RollSubmission** – `rollType` (`NEED|GREED|PASS|AUTO`), `value`, `bonus`, `submittedAt`.
- **SmartLootSetting** – `classPreferences`, `minRarity`, `autoAssign`, `blacklist`.
- **BossLootInfo** – `guaranteedItems[]`, `randomTable`, `partyDistribution`, `achievements[]`.
- **BadLuckProtection** – `lastLegendaryAt`, `protectionActive`, `nextGuaranteedIn`, `progress`.
- **DuplicateCheckResponse** – `hasDuplicate`, `locations[]`, `suggestedAction`.
- **LootHistoryEntry** – `timestamp`, `item`, `rarity`, `source`, `rollType`, `rollValue`, `participants`, `result`.
- **RealtimeEventPayload** – типизированные payloads (rollStarted, rollUpdated, rollCompleted, lootAssigned, badLuckTriggered, duplicateBlocked).
- **Error Schema (`LootAdvancedError`)** – codes (`ROLL_EXPIRED`, `PARTY_REQUIRED`, `NEED_NOT_ALLOWED`, `DUPLICATE_FOUND`, `BOSS_LOCKED`, `BAD_LUCK_INACTIVE`).

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth`; `ServiceToken` для внутренних вызовов (loot generator).
- Таймеры: roll длится 60 сек, auto-submit PASS по истечении.
- Anti-abuse: Need доступен только для подходящих классов (smart loot проверки).
- Bad luck: гарантированный legendary каждые X часов активной игры.
- Дубликаты: перед выдачей legendary проверять инвентарь/банк, при наличии → альтернатива.
- Логи: все роллы/решения логируются для аудита (anti-cheat).
- Events: публиковать `loot:roll-completed`, `loot:bad-luck-triggered`.
- Кэширование: `settings`, `bad-luck` – низкое (max-age=5); `history` пагинирован.

---

## 🧪 Примеры

- Ролл Need/Greed: JSON запрос на submit со значением.
- Ответ boss loot distribution (гарантии + shared drop).
- Событие WebSocket `roll-completed` с победителем и участниками.
- Bad luck status после 7 дней без legendary.
- Дубликат чек для legendary и альтернатива.

---

## 🔗 Связности и зависимости

- Требует выполнения `API-TASK-129` (core loot) и `API-TASK-214` (inventory advanced).
- Интеграция с party-service, achievement-service, notification-service.
- События должны быть доступны progression/analytics для метрик.

---

## ✅ Критерии приемки

1. Файл `loot-advanced.yaml` создан, включает архитектурный комментарий и все расширенные эндпоинты.
2. Реализованы модели роллов, smart loot, boss loot, bad luck, дубликатов.
3. Прописаны правила анти-абуза, таймеры, события и интеграции.
4. Примеры запросов/ответов охватывают ключевые кейсы.
5. Чеклист выполнен, задание самодостаточно.

---

## 📎 Checklist

- [ ] Использован шаблон `api-generation-task-template.md`
- [ ] Определены микросервис, фронтенд модуль, зависимости, UI компоненты
- [ ] Эндпоинты и события покрывают документ Part 2
- [ ] Добавлены модели, ошибки, примеры, критерии
- [ ] После сохранения обновить `tasks/config/brain-mapping.yaml`

---

## ❓FAQ

**Q:** Можно ли объединить с core loot API?
**A:** Нет, чтобы разделить базовую генерацию и продвинутые механики, а также уложиться в лимит 400 строк.

**Q:** Кто может принудительно завершить ролл?
**A:** Party leader или система по таймеру. API должен проверять роль и логировать действие.

**Q:** Как уведомлять о bad luck защите?
**A:** Через websocket событие `bad-luck-triggered` + уведомление из notification-service.


