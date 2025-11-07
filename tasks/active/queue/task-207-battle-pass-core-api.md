# Task ID: API-TASK-207
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 23:58
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию ядра Battle Pass (`battle-pass-core`) с управлением сезонами, прогрессом игроков и премиум-доступом.

**Что нужно сделать:** Подготовить `api/v1/gameplay/battle-pass/battle-pass-core.yaml`, описав управление сезонами, отслеживание прогресса, выдачу опыта, покупку премиума и отчётность.

---

## 🎯 Цель задания

Сформировать единый API для сезонной системы Battle Pass, покрывающий жизненный цикл сезона и прогресс игроков.

**Зачем это нужно:**
- Поддержать запуск сезонного контента и монетизации (premium track)
- Синхронизировать прогресс игроков между источниками XP и выдачей наград
- Предоставить игровому клиенту прозрачный доступ к статусу уровня и XP
- Сформировать базу для расширений (Rewards & Challenges из Part 2)

---

## 📚 Источники информации

### Основной документ

**Путь:** `.BRAIN/05-technical/backend/battle-pass/part1-core-progression.md`
**Версия:** v1.0.1 (2025-11-07 02:40)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Схемы БД `battle_pass_seasons`, `battle_pass_rewards`, `player_battle_pass_progress`
- Логика начисления XP (метод `awardXP`, enum `BattlePassXPSource`)
- Процедура покупки премиума `purchasePremium`
- Требования к аналитике прогресса и событиям

### Дополнительные источники

- `.BRAIN/05-technical/backend/battle-pass/part2-rewards-challenges.md` – задачи для последующей интеграции наград и испытаний
- `.BRAIN/05-technical/backend/progression-backend.md` – интеграция с общей системой прогресса
- `.BRAIN/05-technical/backend/daily-weekly-reset-system.md` – расписание сбросов и начисление XP
- `.BRAIN/05-technical/backend/economy-system.md` – проверка валют и списание при покупке премиума

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-158-social-mechanics-detailed-api.md` – общие социальные события
- `API-SWAGGER/tasks/active/queue/task-159-progression-detailed-api.md` – глобальные правила прогрессии

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/battle-pass/battle-pass-core.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/battle-pass/
 └── battle-pass-core.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/battle-pass`
- **Зависимости:** auth-service, economy-service, analytics-service, notification-service, quest-service, match-service, progression-service

### Frontend
- **Модуль:** `modules/progression/battle-pass`
- **State Store:** `useBattlePassStore`
- **State:** `season`, `progress`, `xpSources`, `premium`, `seasonTimeline`
- **UI компоненты:** `BattlePassOverview`, `LevelProgressBar`, `SeasonTimeline`, `PremiumUpsellCard`, `XPSourcesList`
- **Формы:** `PurchasePremiumForm`, `XpGrantDebugForm`, `SeasonConfigForm`
- **Layouts:** `ProgressionHubLayout`
- **Хуки:** `useBattlePassProgress`, `usePremiumStatus`, `useSeasonAnalytics`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/battle-pass
# - Dependencies: auth-service, economy-service, analytics-service, notification-service, quest-service, match-service, progression-service
# - Frontend Module: modules/progression/battle-pass (useBattlePassStore)
# - UI: BattlePassOverview, LevelProgressBar, SeasonTimeline, PremiumUpsellCard, XPSourcesList
# - Forms: PurchasePremiumForm, XpGrantDebugForm, SeasonConfigForm
# - Layout: ProgressionHubLayout
# - Hooks: useBattlePassProgress, usePremiumStatus, useSeasonAnalytics
```

---

## ✅ Что нужно сделать (детальный план)

1. Описать CRUD сезонов: создание, обновление, публикация, архивирование.
2. Формализовать структуру премиальных настроек: стоимость, валюта, лимиты, скидки.
3. Задокументировать механики прогресса: получение текущего статуса, синхронизация XP, лимиты.
4. Добавить безопасные операции начисления XP из различных источников (quests, матчи, события).
5. Реализовать API покупки премиума с валидацией валют и событиями уведомлений.
6. Подготовить аналитические срезы: активные игроки, распределение уровней, удержание.
7. Задокументировать события (event bus) и взаимосвязи с progression/economy/notification.
8. Приложить примеры запросов/ответов, ошибки, ограничения и тест-план.
9. Проверить чеклист `tasks/config/checklist.md` и отметить выполнение.

---

## 🔀 Endpoints

1. **POST `/api/v1/gameplay/battle-pass/seasons`** – создать сезон (номер, длительность, настройки XP).
2. **GET `/api/v1/gameplay/battle-pass/seasons`** – получить список сезонов с фильтрами по статусу.
3. **GET `/api/v1/gameplay/battle-pass/seasons/current`** – вернуть активный сезон и таймер.
4. **PUT `/api/v1/gameplay/battle-pass/seasons/{seasonId}`** – обновить параметры сезона (даты, XP за уровень, лимиты).
5. **POST `/api/v1/gameplay/battle-pass/seasons/{seasonId}/status`** – переключить статус (`SCHEDULED|ACTIVE|ENDED|ARCHIVED`).
6. **POST `/api/v1/gameplay/battle-pass/seasons/{seasonId}/premium`** – обновить цену, валюту и скидки премиум-трека.
7. **GET `/api/v1/gameplay/battle-pass/progress`** – получить прогресс текущего игрока (уровень, XP, флаги премиума).
8. **POST `/api/v1/gameplay/battle-pass/progress/xp`** – начислить XP (источник, множитель, инициатор) с сервисным токеном.
9. **POST `/api/v1/gameplay/battle-pass/progress/sync`** – синхронизировать прогресс при входе (создание записи, перенос старых данных).
10. **POST `/api/v1/gameplay/battle-pass/progress/reset`** – сброс прогресса при старте нового сезона (batch operation, audit).
11. **POST `/api/v1/gameplay/battle-pass/premium/purchase`** – покупка премиума (валидировать баланс, списать валюту, события).
12. **GET `/api/v1/gameplay/battle-pass/premium/status`** – проверить статус премиума, дату покупки, права.
13. **GET `/api/v1/gameplay/battle-pass/xp-sources`** – список доступных источников XP, базовые значения, лимиты по времени.
14. **POST `/api/v1/gameplay/battle-pass/levels/skip`** – покупка пропуска уровней (разовая или пакетная операция, лимиты).
15. **GET `/api/v1/gameplay/battle-pass/analytics/progression`** – отчёт по распределению уровней, удержанию и premium conversion.

---

## 🧱 Модели данных

- **BattlePassSeason** – id, seasonNumber, name, theme, description, startDate, endDate, maxLevel, xpPerLevel, premiumPrice, premiumCurrency, status.
- **SeasonStatusChangeRequest** – status, reason, initiatedBy.
- **PremiumConfigRequest** – premiumPrice, premiumCurrency, discounts[], effectiveFrom.
- **PlayerBattlePassProgress** – playerId, seasonId, currentLevel, currentXP, totalXPEarned, hasPremium, premiumPurchasedAt, claimedFreeLevels[], claimedPremiumLevels[], lastXPEarnedAt.
- **XpGrantRequest** – playerId, source (`DAILY_QUEST|MATCH_WIN|ACHIEVEMENT|PLAYTIME|EVENT`), amount, multiplier, metadata.
- **XpGrantResponse** – newLevel, currentXP, totalXPEarned, xpAdded, levelUps[] (timestamp, level).
- **PremiumPurchaseRequest** – playerId, paymentMethod (`CURRENCY|TOKEN|BUNDLE`), currency, amount, platform.
- **PremiumStatusResponse** – hasPremium, premiumPurchasedAt, expiresAt, entitlementSource.
- **LevelSkipRequest** – playerId, levelsToSkip, paymentMethod, cost, auditId.
- **BattlePassAnalyticsResponse** – activePlayers, premiumConversionRate, averageLevel, xpDistribution[], retentionMetrics.
- **Error Schema (`BattlePassErrorResponse`)** – code (`SEASON_NOT_FOUND`, `XP_SOURCE_DISABLED`, `INSUFFICIENT_FUNDS`, `ALREADY_PREMIUM`, `LEVEL_CAP_REACHED`), message, traceId.
- **Events** – `battle-pass:xp-earned`, `battle-pass:level-up`, `battle-pass:premium-purchased`, `battle-pass:season-status-changed`.

---

## 🧭 Принципы и правила

- Авторизация: `BearerAuth` для игроков, `ServiceToken` для внутренних вызовов (XP начисление, resets).
- Ограничения: дневные лимиты XP на источник, проверка maxLevel, cooldown на покупку skip.
- Валидация валют через economy-service, журналирование операций в analytics-service.
- События публикуются в event bus для уведомлений, progression и LiveOps.
- Ответы и ошибки ссылаться на общие схемы `api/v1/shared/common/responses.yaml`.

---

## 🧪 Примеры

- Начисление XP за матч с множителем 2 (match-service → battle-pass).
- Покупка премиума игроком с проверкой валюты и публикацией события.
- Переключение сезона в статус `ACTIVE` с расписанием сброса прогресса.
- Аналитический отчёт по распределению уровней за последние 7 дней.

---

## 🔗 Связности и зависимости

- Получает данные о заданиях и матчах из quest-service и match-service для источников XP.
- Интегрируется с economy-service (списание валюты) и notification-service (уведомления о level up и премиуме).
- Передаёт события в progression-service и analytics-service для статистики и удержания.
- Координируется с будущей задачей Part 2 (Rewards & Challenges) для выдачи наград.

---

## ✅ Критерии приемки

1. Файл `battle-pass-core.yaml` создан с архитектурным комментарием и всеми эндпоинтами.
2. Описаны CRUD сезонов, операции прогресса, покупка премиума, аналитика и ограничения.
3. Все модели содержат обязательные поля, типы, примеры и статусы ошибок.
4. Прописаны события, интеграции и требования к безопасности.
5. Подготовлены примеры запросов/ответов и тест-план; пройден чеклист `tasks/config/checklist.md`.

---

## 📎 Checklist

- [ ] Структура задания соответствует `tasks/templates/api-generation-task-template.md`
- [ ] Проведён анализ зависимостей и указаны сервисы/модули
- [ ] Список эндпоинтов отражает все требования документа
- [ ] Добавлены модели данных, примеры, события и критерии приёмки
- [ ] Обновить `tasks/config/brain-mapping.yaml` после сохранения файла

---

## ❓FAQ

**Q:** Чем эта задача отличается от Part 2?
**A:** Part 1 фокусируется на ядре прогресса (сезоны, XP, премиум). Part 2 опишет награды, квесты и испытания, используя данные, подготовленные в этом API.

**Q:** Кто может вызывать начисление XP?
**A:** Только авторизованные сервисы с `ServiceToken` (quests, matches, events). Игровой клиент получает прогресс только через GET-эндпоинты.

**Q:** Как обрабатываются уровни выше капа?
**A:** Endpoint XP начисления должен возвращать ошибку `LEVEL_CAP_REACHED` и не повышать уровень, фиксируя событие в журнале аудита.


