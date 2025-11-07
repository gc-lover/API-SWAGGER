# Task ID: API-TASK-202
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 22:25
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать OpenAPI спецификацию для системы компаньонов (pets/drones) игроков.

**Что нужно сделать:** Разработать `api/v1/gameplay/companions/companion-system.yaml`, описывающий создание, управление, прогрессию и кастомизацию компаньонов, а также взаимодействие в бою и миссиях.

---

## 🎯 Цель задания

Дать игровому сервису и фронтенду единый API для companion-механик: от генерации спутников до их прокачки, способностей и участия в миссиях.

**Зачем это нужно:**
- Обеспечить игрокам полноценный UI для управления спутниками
- Синхронизировать боевые способности компаньонов с боевой системой
- Поддержать progression (уровни, навыки, лояльность) и кастомизацию
- Позволить аналитике отслеживать использование компаньонов и баланс наград

---

## 📚 Источники информации

### Основной источник

**Документ:** `.BRAIN/05-technical/backend/companion/companion-system.md`
**Версия:** v1.0.0 (2025-11-07 02:34)
**Статус:** approved, api-readiness: ready

**Ключевые разделы:**
- Типы компаньонов (боевые, утилитарные, социальные) и их способности
- Прокачка (уровни, навыки, синергии), лояльность и бонусы
- Слоты экипировки, моды, кастомизация визуала
- Миссии и поручения, календарь заданий, добыча
- Companion AI режимы (assist/defend/sentry), synergy с классами игрока
- Анти-абуз ограничения (макс. активных, cooldown смены)

### Дополнительные источники

- `.BRAIN/05-technical/backend/combat-session-backend.md` – взаимодействие в бою
- `.BRAIN/05-technical/backend/progression-backend.md` – таблицы XP и навыков
- `.BRAIN/05-technical/backend/economy-system.md` – награды и стоимость контрактов
- `.BRAIN/05-technical/backend/notification-system.md` – уведомления о миссиях
- `.BRAIN/05-technical/backend/anti-cheat/anti-cheat-compact.md` – проверки использования

### Связанные документы

- `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md` (команды компаньону голосом)
- `.BRAIN/05-technical/backend/party-system.md` (слоты в группе)

---

## 📁 Целевая структура API

- **Файл:** `api/v1/gameplay/companions/companion-system.yaml`
- **Версия API:** v1
- **Формат:** OpenAPI 3.0.3

```
API-SWAGGER/api/v1/gameplay/companions/
 └── companion-system.yaml  ← создать/заполнить
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервис)
- **Микросервис:** gameplay-service
- **Порт:** 8083
- **API Base Path:** `/api/v1/gameplay/companions`
- **Зависимости:** auth-service, combat-service, progression-service, inventory-service, notification-service, analytics-service

### Frontend (модуль)
- **Модуль:** `modules/gameplay/companions`
- **State Store:** `useCompanionStore`
- **State:** `companions`, `loadouts`, `missions`, `bonding`, `abilities`
- **UI компоненты:** `CompanionRoster`, `CompanionDetailCard`, `AbilityLoadoutGrid`, `BondingProgressBar`, `CompanionMissionBoard`
- **Формы:** `CreateCompanionForm`, `AssignLoadoutForm`, `MissionDeploymentForm`, `AbilityUpgradeForm`
- **Layouts:** `GameLayout`, `CompanionHubLayout`
- **Хуки:** `useCompanionRoster`, `useCompanionMissions`, `useCompanionAbilities`

### Комментарий для OpenAPI файла

```yaml
# Target Architecture:
# - Microservice: gameplay-service (port 8083)
# - API Base: /api/v1/gameplay/companions
# - Dependencies: auth-service, combat-service, progression-service, inventory-service, notification-service, analytics-service
# - Frontend Module: modules/gameplay/companions (useCompanionStore)
# - UI: CompanionRoster, CompanionDetailCard, AbilityLoadoutGrid, BondingProgressBar, CompanionMissionBoard
# - Forms: CreateCompanionForm, AssignLoadoutForm, MissionDeploymentForm, AbilityUpgradeForm
# - Layouts: GameLayout, CompanionHubLayout
# - Hooks: useCompanionRoster, useCompanionMissions, useCompanionAbilities
```

---

## ✅ Что нужно сделать (детальный план)

1. Отразить CRUD операции для компаньонов: создание, просмотр, обновление слотов, удаление/архив.
2. Описать прогрессию: XP, уровни, навыки, лояльность, синергии.
3. Задокументировать миссии/поручения: планирование, результаты, награды, таймеры.
4. Добавить управление loadout/abilities: активные/пассивные способности, cooldown, моды.
5. Описать социальные функции: кастомизация, bonding events, эмоции, взаимодействия с игроком.
6. Указать лимиты и анти-абуз проверки (максимум активных, cooldown смены, запрещено в PvP).
7. Включить endpoints аналитики/leaderboard по компаньонам.
8. Прописать события (event bus) и уведомления.
9. Подготовить примеры JSON и тест-план; пройти чеклист.

---

## 🔀 Endpoints

1. **POST `/api/v1/gameplay/companions`** – создать нового компаньона (тип, роль, стартовые способности).
2. **GET `/api/v1/gameplay/companions`** – список компаньонов игрока (фильтры по типу, активности).
3. **GET `/api/v1/gameplay/companions/{companionId}`** – детали (статы, навыки, лояльность, экипировка).
4. **PATCH `/api/v1/gameplay/companions/{companionId}`** – обновить имя, визуал, режим AI.
5. **DELETE `/api/v1/gameplay/companions/{companionId}`** – архивировать/удалить компаньона (с подтверждением).
6. **POST `/api/v1/gameplay/companions/{companionId}/loadout`** – назначить/обновить способности и моды.
7. **POST `/api/v1/gameplay/companions/{companionId}/abilities/{abilityId}/activate`** – активировать способность (валидировать кулдаун, энергию).
8. **POST `/api/v1/gameplay/companions/{companionId}/missions`** – отправить на миссию (тип, длительность, награды).
9. **GET `/api/v1/gameplay/companions/missions`** – текущие и завершённые миссии, таймеры, результаты.
10. **POST `/api/v1/gameplay/companions/{companionId}/bonding`** – отметить bonding activity (диалог, подарок, тренировка).
11. **GET `/api/v1/gameplay/companions/analytics`** – статистика (использование типов, winrate, xp gain).
12. **POST `/api/v1/gameplay/companions/{companionId}/xp`** – вручную скорректировать XP (админ/GM).
13. **POST `/api/v1/gameplay/companions/{companionId}/promote`** – повышение ранга/редкости при выполнении условий.
14. **GET `/api/v1/gameplay/companions/leaderboard`** – рейтинг по активным компаньонам (пвп победы, миссии).
15. **POST `/api/v1/gameplay/companions/{companionId}/suspend`** – временно отключить компаньона (анти-абуз, cooldown).

---

## 🧱 Модели данных

- **Companion** – id, playerId, type (`combat|utility|social`), subType, rarity, level, xp, loyalty, bonding, status, createdAt, lastUsedAt.
- **CreateCompanionRequest/Response** – type, loadout, initial abilities, cosmetics.
- **CompanionLoadout** – abilitySlots, modSlots, passiveEffects, cooldowns.
- **AbilityActivationRequest** – abilityId, targetId, context (pve/pvp), energyCost.
- **MissionRequest/Result** – missionId, duration, difficulty, rewards, successChance, status, completionTime.
- **BondingActivityRequest** – activityType, itemId (если подарок), outcome, bondingDelta.
- **CompanionProgression** – level, xp, xpToNext, skillPoints, unlockedAbilities.
- **RewardGrant** – rewardType (item/currency/title), amount, grantedAt, sourceMission.
- **AnalyticsResponse** – usageStats, missionSuccessRate, abilityUsage, topCompanionTypes.
- **LeaderboardEntry** – rank, playerId, companionId, score, metrics (wins, missions, bonding).
- **SuspendRequest** – reason, duration, initiatedBy.
- **Error schemas** – `CompanionError` (codes: `COMPANION_NOT_FOUND`, `MAX_ACTIVE_REACHED`, `ABILITY_ON_COOLDOWN`, `MISSION_SLOT_FULL`, `BONDING_LIMIT_REACHED`).
- **Event payloads** – `CompanionCreatedEvent`, `CompanionMissionStartedEvent`, `CompanionMissionCompletedEvent`, `CompanionAbilityUsedEvent`, `CompanionBondingChangedEvent`.

Каждую схему снабдить описанием, `required`, ограничениями (`enum`, `min`, `max`) и примерами.

---

## 🧭 Принципы и правила

- Использовать `BearerAuth` (игрок), `ServiceToken` для событий (см. `api/v1/shared/common/security.yaml`).
- Общие ответы (404, 409, 422, 429, 500) брать из `api/v1/shared/common/responses.yaml`.
- Указать rate limits (активация способностей, запуск миссий).
- Учесть PvP ограничения (некоторые компаньоны запрещены в аренах).
- Прописать анти-абуз (само-фарм через многократные миссии).

---

## 🧪 Примеры

- Создание боевого дрона (запрос/ответ).
- Обновление loadout (abilities/mods) с проверкой ограничения.
- Миссия сопровождения: запуск и результат с наградами.
- Bonding activity (подарок, увеличение лояльности).
- Лидерборд компаньонов за неделю.

---

## 🔗 Связности и зависимости

- Подписывается на `PlayerLevelUpEvent` / `CombatSessionResultEvent` для роста XP.
- Триггерит награды через reward-service.
- Отправляет уведомления игроку при завершении миссий.
- Логирует события в analytics-service.

---

## ✅ Критерии приемки

1. Файл `companion-system.yaml` создан с архитектурным комментарием.
2. Все описанные endpoints включены и документированы.
3. Модели данных покрывают компаньонов, миссии, прогрессию, награды и аналитику.
4. Прописаны события, интеграции и anti-abuse правила.
5. Подготовлены примеры JSON и тест-план.
6. Пройден чеклист `tasks/config/checklist.md`, задание самодостаточно.

---

## ❓ FAQ

- **Можно ли иметь несколько активных компаньонов?** – Да, но ограничение N (описать в `settings`).
- **Как работают миссии, если игрок оффлайн?** – Миссии завершаются сервером, уведомления идут при логине/по почте.
- **Можно ли торговать компаньонами?** – Нет, привязаны к аккаунту (описать ограничение).
- **Как работает восстановление после suspend?** – `suspend` endpoint задаёт длительность, по окончании статус сменится на `INACTIVE` и можно восстановить.

---

## 🕓 История выполнения

- 2025-11-07 22:25 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

