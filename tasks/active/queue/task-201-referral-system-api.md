# Task ID: API-TASK-201
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 22:05
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию для реферальной программы игроков (`referral-system`).

**Что нужно сделать:** Спроектировать `api/v1/social/referrals/referral-system.yaml`, покрыв генерацию кодов, регистрацию рефералов, трекинг milestones, выдачу наград и аналитику.

---

## 🎯 Цель задания

Обеспечить полный REST API для реферальной программы NECPGAME, чтобы игроки могли приглашать друзей, получать награды, а команда могла мониторить эффективность.

**Зачем это нужно:**
- Формализовать процессы invite‐кодов и бонусов (двусторонние награды)
- Позволить Ops отслеживать milestones и топ-реферальные рейтинги
- Интегрировать выдачу наград, уведомления и анти-абуз проверки
- Подготовить аналитику для маркетинга и LiveOps

---

## 📚 Источники информации

### Основной источник

**Репозиторий:** `.BRAIN`
**Путь:** `.BRAIN/05-technical/backend/referral/referral-system.md`
**Версия:** v1.0.0
**Дата последнего обновления:** 2025-11-07 02:40
**Статус документа:** approved (api-readiness: ready)

**Ключевые элементы:**
- Таблицы `referral_codes`, `referrals`, milestone поля, статусы
- Генерация уникального кода, регистрация нового игрока с кодом
- Милestones (level 10, первая покупка, серия 5/10/25/50/100)
- Расчет и выдача наград (welcome bonus, referrer rewards, exclusive items)
- Referral leaderboard, анти-абуз проверки (self-referral, max uses)
- Уведомления, email, audit лог

### Дополнительные источники

- `.BRAIN/05-technical/backend/progression-backend.md` (события level up)
- `.BRAIN/05-technical/backend/economy-system.md` (награды/баланс)
- `.BRAIN/05-technical/backend/notification-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md`
- `.BRAIN/05-technical/backend/anti-cheat/anti-cheat-compact.md`

### Связанные документы

- `.BRAIN/05-technical/backend/realtime-server/part2-protocol-optimization.md` (event bus)
- `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md` (уведомления)

---

## 📁 Целевая структура API

- **Файл:** `api/v1/social/referrals/referral-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/social/referrals/
 └── referral-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend
- **Микросервис:** social-service (порт 8084)
- **API Base Path:** `/api/v1/social/referrals/*`
- **Зависимости:** auth-service (валидация аккаунтов), account-service (player profiles), reward-service (выдача наград), progression-service (level events), notification-service, analytics-service, anti-cheat-service

### Frontend
- **Модуль:** `modules/social/referrals`
- **State Store:** `useSocialStore`
- **State:** `referralProfile`, `referralStats`, `leaderboard`, `milestones`, `rewards`
- **UI компоненты:** `ReferralDashboard`, `ReferralCodeCard`, `MilestoneProgress`, `ReferralRewardsList`, `ReferralLeaderboard`
- **Формы:** `GenerateCodeForm`, `ShareReferralForm`, `ManualRewardGrantForm`
- **Layouts:** `SocialHubLayout`, `AccountDashboard`
- **Хуки:** `useReferralCode`, `useReferralProgress`, `useReferralLeaderboard`

### Комментарий для YAML

```yaml
# Target Architecture:
# - Microservice: social-service (port 8084)
# - API Base: /api/v1/social/referrals
# - Dependencies: auth-service, account-service, reward-service, progression-service, notification-service, analytics-service, anti-cheat-service
# - Frontend Module: modules/social/referrals (useSocialStore)
# - UI: ReferralDashboard, ReferralCodeCard, MilestoneProgress, ReferralRewardsList, ReferralLeaderboard
# - Forms: GenerateCodeForm, ShareReferralForm, ManualRewardGrantForm
# - Layouts: SocialHubLayout, AccountDashboard
# - Hooks: useReferralCode, useReferralProgress, useReferralLeaderboard
```

---

## ✅ Что нужно сделать (детальный план)

1. Зафиксировать сущности (ReferralCode, Referral, MilestoneProgress, RewardGrant, LeaderboardEntry).
2. Спроектировать REST endpoints для генерации/управления кодами, регистрации рефералов, выдачи наград и аналитики.
3. Описать workflow milestones и события (level up, first purchase, login streak).
4. Задокументировать анти-абуз проверки и лимиты (max uses, self-referral).
5. Добавить endpoints leaderboard и статистики.
6. Описать уведомления/воркфлоу (email, push, in-game message) через события.
7. Подготовить примеры JSON для основных операций и отчетов.
8. Проработать FAQ, тест-план, чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/social/referrals/codes`** – сгенерировать/получить активный код для игрока.
2. **GET `/api/v1/social/referrals/codes/{playerId}`** – получить код, статистику использования, QR/share links.
3. **POST `/api/v1/social/referrals/register`** – зарегистрировать нового игрока с кодом.
4. **GET `/api/v1/social/referrals/{referralId}`** – посмотреть статус реферала, milestones, rewards.
5. **GET `/api/v1/social/referrals/milestones`** – прогресс referrer (counts, next reward).
6. **POST `/api/v1/social/referrals/{referralId}/milestones/complete`** – вручную отметить milestone (админ).
7. **POST `/api/v1/social/referrals/{referralId}/rewards`** – выдать награды (ручная или автоматическая проверка).
8. **GET `/api/v1/social/referrals/leaderboard`** – топ N рефереров (фильтры по периоду, региону).
9. **GET `/api/v1/social/referrals/analytics`** – агрегаты (конверсия, retention, revenue per referral).
10. **POST `/api/v1/social/referrals/anti-cheat/review`** – пометить подозрительные рефералы, запросить проверки.
11. **POST `/api/v1/social/referrals/codes/{code}/deactivate`** – деактивировать код.
12. **GET `/api/v1/social/referrals/referred/{playerId}`** – получить данные для приглашённого игрока (rewards, status).
13. **POST `/api/v1/social/referrals/events/level-up`** – endpoint для progression-service (webhook) для отметки milestone.
14. **POST `/api/v1/social/referrals/events/purchase`** – отметить первую покупку.
15. **GET `/api/v1/social/referrals/settings`** – текущие правила программы (дивиденды, лимиты).

Использовать стандартные ответы (`200`, `201`, `202`, `204`, `400`, `401`, `403`, `404`, `409`, `422`, `429`, `500`).

---

## 🧱 Модели данных

- **ReferralCode** – id, playerId, code, usesCount, maxUses, isActive, createdAt, expiresAt.
- **GenerateCodeResponse** – code, shareUrl, qrcodeUrl, stats.
- **ReferralRegistrationRequest** – newPlayerId, referralCode, sourceChannel, deviceInfo.
- **Referral** – referralId, referrerId, referredPlayerId, status (`PENDING|ACTIVE|COMPLETED|FLAGGED`), milestones, rewards.
- **MilestoneProgress** – milestoneId, name, target, current, status, completedAt, rewards.
- **RewardGrant** – rewardId, type (currency/item/title), amount, grantedTo, grantedAt, status.
- **LeaderboardEntry** – rank, playerId, referralsCount, activeReferrals, rewardsEarned, region.
- **AnalyticsResponse** – totals, conversionRates, revenuePerReferral, churnRates, topChannels.
- **AntiCheatReviewRequest** – referralIds, suspicionType, notes.
- **ReferralSettings** – welcomeBonus, referrerRewards, milestonesConfig, limits (maxUses, cooldown, dailyCap).
- **Event payloads** – `ReferralCreatedEvent`, `ReferralMilestoneReachedEvent`, `ReferralRewardGrantedEvent`, `ReferralFlaggedEvent`.
- **Error schemas** – `ReferralError` (`CODE_NOT_FOUND`, `SELF_REFERRAL`, `CODE_INACTIVE`, `LIMIT_REACHED`, `MILESTONE_NOT_MET`).

Каждую модель снабдить `description`, `required`, валидациями, примерами.

---

## 🧭 Принципы и правила

- Безопасность: использовать `BearerAuth` + `ServiceToken` (для событий) из `api/v1/shared/common/security.yaml`.
- Общие ответы/ошибки из `api/v1/shared/common/responses.yaml`.
- Указать rate limits (генерация кода, регистрация, события).
- Указать бизнес-правила (один код активен, запрет самореферала, max invites/day).
- Согласовать интеграции с progression, rewards, notification сервисами.

---

## 🧪 Примеры

- Генерация кода (ответ с share ссылками).
- Регистрация реферала (с welcome bonus).
- Милestone отчёт (referrer 12 referrals, следующий бонус).
- Лидерборд (топ 10, фильтрация по месяцу).
- Анти-абуз запрос (flagged referrals).

---

## 🔗 Связности и зависимости

- Использует события progression-service (`level-up`, `first-purchase`).
- Взаимодействует с reward-service для выдачи наград.
- Отправляет уведомления через notification/email service.
- Публикует события для analytics/incident (подозрительные рефералы).

---

## ✅ Критерии приемки

1. Создан файл `referral-system.yaml` с архитектурным комментарием.
2. Определены все описанные endpoints, модели и события.
3. Прописаны бизнес-правила (лимиты, анти-абуз, milestones).
4. Добавлены примеры JSON и отчёты.
5. Описаны интеграции и уведомления.
6. Включён тест-план (нагрузка, злоупотребления, лидерборд).
7. Пройден чеклист, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли переиспользовать код после деактивации?** – Нет, создаётся новый (указать в FAQ).
- **Как ограничить спам?** – Rate limit + max referrals/day + анти-абуз проверка.
- **Как учитывать region?** – `AnalyticsResponse` включает сегментацию, добавить комментарий.
- **Что делать при ложном флаге?** – Endpoint для снятия блокировки (опционально описать).
- **Нужен ли leaderboard в реальном времени?** – Да, описать кэш/refresh (каждые X минут).

---

## 🕓 История выполнения

- 2025-11-07 22:05 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

