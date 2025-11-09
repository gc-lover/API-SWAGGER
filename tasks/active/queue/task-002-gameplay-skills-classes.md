# API Generation Task Template

## Metadata
- **Task ID:** API-TASK-002  
- **Type:** API Generation  
- **Priority:** high  
- **Status:** queued  
- **Created:** 2025-11-09 12:30  
- **Author:** API Task Creator Agent  
- **Dependencies:** none  

## Summary
Подготовить спецификацию для `gameplay-service`, описывающую классовые и подклассовые модификаторы навыков, эксклюзивные способности, правила разблокировок и телеметрию, чтобы фронтенд и аналитика могли синхронно отображать прогрессию и проверять условия разблокировки.

## Source Documents
| Поле | Значение |
| --- | --- |
| Repository | `.BRAIN` |
| Path | `.BRAIN/02-gameplay/progression/progression-skills-classes.md` |
| Version | v1.1.0 |
| Status | approved |
| API readiness | ready (2025-11-09 11:21) |

**Key points:**
- Матрица коэффициентов для 13 классов и их ключевых навыков, включая подклассовые модификаторы.
- Эксклюзивные активные/аурные навыки с требованиями по рангу, ресурсу и условиям использования.
- Структура таблиц хранения модификаторов, разблокировок и эксклюзивов для gameplay-service.
- REST endpoints: получение списков классов, деталей, подклассов, запуск разблокировок и сбор телеметрии.
- События `progression.classes.*` и правила баланса через `balance_overrides.yaml`.

**Related docs:**
- `.BRAIN/02-gameplay/progression/progression-skills.md`
- `.BRAIN/02-gameplay/progression/progression-attributes.md`
- `.BRAIN/02-gameplay/progression/classes-abilities.md`

## Target Architecture (⚠️ Обязательно)
- **Microservice:** gameplay-service  
- **Port:** 8083  
- **Domain:** gameplay  
- **API directory:** `api/v1/gameplay/progression/skills-classes/skills-classes.yaml`  
- **base-path:** `/api/v1/gameplay/progression/skills-classes`  
- **Java package:** `com.necpgame.gameplay`  
- **Frontend module:** `modules/progression/skills`  
- **Shared UI/Form components:** `@shared/ui/SkillTree`, `@shared/ui/StatBlock`, `@shared/ui/ClassBadge`, `@shared/ui/UnlockTimeline`, `@shared/forms/SkillUnlockForm`, `@shared/forms/ModifierAdjustForm`, `@shared/layouts/GameLayout`, `@shared/layouts/ProgressionLayout`, `@shared/hooks/useProgressionStore`, `@shared/hooks/useRealtimeTelemetry`.

## Scope of Work
1. Проанализировать базовые и подклассовые модификаторы, эксклюзивы и требования разблокировок из исходных документов.
2. Описать структуру OpenAPI с корректными `info`, `servers`, тегами, security и ссылками на общие компоненты.
3. Детализировать endpoints для листинга классов, получения деталей, работы с подклассами, запуска разблокировок и запроса телеметрии.
4. Сформировать схемы данных: матрицы модификаторов, уровней, эксклюзивов, запросов на разблокировку, ответы телеметрии и балансировок.
5. Указать интеграции с character-service, analytics pipeline и событиями Kafka, описать бизнес-правила валидации.
6. Подготовить примеры запросов/ответов, указать стандартные ошибки, провести валидацию шаблоном `validate-swagger.ps1`.

## Endpoints
- **GET `/api/v1/gameplay/progression/skills-classes`**  
  Назначение: пагинированный список классов с базовыми модификаторами, доступными подклассами и метками эксклюзивов.  
  Параметры: query `page`, `size`, `classType` (enum), `hasExclusive`, `supportsCrossClass`, `sort`.  
  Ответы: `200` (Paginated `ClassSummary`), `400`, `401`, `403`, `500` из shared responses.

- **GET `/api/v1/gameplay/progression/skills-classes/{classCode}`**  
  Назначение: детальное описание класса с матрицей навыков, требованиями по уровням и списком эксклюзивов.  
  Параметры: path `classCode` (slug, kebab-case).  
  Ответы: `200` (`ClassDetail`), `400`, `401`, `403`, `404`, `500`.

- **GET `/api/v1/gameplay/progression/skills-classes/{classCode}/subclasses/{subclassCode}`**  
  Назначение: получить конкретный подкласс, его модификаторы, эксклюзивные навыки и совместимость с кросс-класс перками.  
  Ответы: `200` (`SubclassDetail`), `400`, `401`, `403`, `404`, `500`.

- **POST `/api/v1/gameplay/progression/skills-classes/{classCode}/unlock`**  
  Назначение: проверка и запись события разблокировки уровня навыка для персонажа (Tier validation).  
  Тело: `UnlockAttemptRequest` с параметрами персонажа, атрибутов и выполненных условий.  
  Ответы: `202` (`UnlockAttemptResponse`), `400`, `401`, `403`, `404`, `409`, `422`, `500`.

- **GET `/api/v1/gameplay/progression/skills-classes/{classCode}/metrics`**  
  Назначение: агрегированная телеметрия использования навыков, win-rate дельт, флагов гипериспользования.  
  Параметры: query `period` (enum), `metricType`, `subclassCode`, `includeOverrides`.  
  Ответы: `200` (`ClassMetricsDashboard`), `400`, `401`, `403`, `404`, `500`.

- **POST `/api/v1/gameplay/progression/skills-classes/{classCode}/balance-overrides`**  
  Назначение: применить временные балансные корректировки для модификаторов и эксклюзивов (админ/дизайнер API).  
  Тело: `BalanceOverrideRequest`.  
  Ответы: `200` (`ClassDetail`), `400`, `401`, `403`, `404`, `409`, `422`, `500`.

- **GET `/api/v1/gameplay/progression/skills-classes/{classCode}/events`**  
  Назначение: получить журнал событий `progression.classes.*` для аналитики и отладки UI.  
  Параметры: query `eventType`, `from`, `to`, `limit`.  
  Ответы: `200` (`ClassEventFeed`), `400`, `401`, `403`, `404`, `500`.

## Data Models
- `ClassSummary`: `classCode`, `displayName`, `primarySkills` (array), `secondarySkills`, `lockedSkills`, `baselineModifiers` (array `SkillModifier`), `availableSubclasses` (array `SubclassAnchor`), `exclusiveSkillCodes` (array), `supportsCrossClass` (boolean), `updatedAt`.
- `ClassDetail`: включает `ClassSummary` и блоки `subclasses` (array `SubclassDetail`), `unlockMatrix` (array `TierRequirement`), `exclusiveSkills` (array `ExclusiveSkill`), `balanceOverrides` (array `BalanceOverrideSnapshot`).
- `SubclassDetail`: `subclassCode`, `displayName`, `modifiers` (array `SkillModifier`), `exclusiveSkills`, `crossClassCompatibility`, `notes`.
- `SkillModifier`: `skillCode`, `attributeCode`, `bonus`, `scalesWithRank` (boolean), `maxBonus`.
- `TierRequirement`: `tier`, `requiredLevel`, `attributeThresholds` (map), `questCode`, `reputation`, `uniqueItemCode`, `crossClassPenalty`.
- `ExclusiveSkill`: `skillCode`, `name`, `type` (enum: `active`, `support`, `aura`), `unlockTier`, `resourceCost` (object), `cooldownSeconds`, `description`, `limitations`.
- `UnlockAttemptRequest`: `characterId` (UUID), `classCode`, `tier`, `attributeSnapshot`, `completedQuests`, `reputation`, `inventoryItems`, `perks`, `crossClassEnabled`.
- `UnlockAttemptResponse`: `status` (enum: `approved`, `denied`, `pending_review`), `unlockedAt`, `failureReasons`, `appliedModifiers`, `eventsPublished`.
- `ClassMetricsDashboard`: `classCode`, `period`, `usageShare`, `winRateDelta`, `overuseFlags`, `exclusiveSkillUsage`, `telemetryVersion`.
- `BalanceOverrideRequest`: `effectiveFrom`, `effectiveUntil`, `modifiers` (array `OverrideModifier`), `exclusiveAdjustments` (array `ExclusiveOverride`), `reason`, `author`.
- `OverrideModifier`: `skillCode`, `attributeCode`, `bonusDelta`, `duration`, `notes`.
- `ExclusiveOverride`: `skillCode`, `cooldownDelta`, `resourceCostDelta`, `activationLimit`.
- `ClassEventFeed`: `events` (array `ClassEvent`), `nextCursor`.
- `ClassEvent`: `eventId`, `eventType` (enum: `unlock_attempted`, `unlock_success`, `modifier_applied`, `balance_override_applied`), `occurredAt`, `payload`.
- Общие ошибки, пагинация и security подключать через `$ref` на `api/v1/shared/common/*.yaml`.

## Integrations & Events
- Проверка атрибутов и прогресса персонажа через `character-service` (`GET /api/v1/characters/{characterId}/progression-snapshot`) перед подтверждением разблокировки.
- Публикация событий Kafka `progression.classes.unlock_attempted`, `progression.classes.unlock_success`, `progression.classes.balance_override_applied` для analytics и фронтенд сигналов.
- Подписка на `analytics.gameplay.balance_alert` для обновления `overuseFlags` и `balanceOverrides`.
- Интеграция с UI телеметрией через WebSocket канал gameplay-service (описать как зависимость) и Orval-клиенты в `modules/progression/skills`.

## Acceptance Criteria
1. Создан файл `api/v1/gameplay/progression/skills-classes/skills-classes.yaml` ≤ 400 строк с корректными `info.x-microservice` и `servers`.
2. Все перечисленные endpoints оформлены с тегами, security, параметрами и стандартными ответами (через `$ref`).
3. Схемы `ClassSummary`, `ClassDetail`, `SubclassDetail`, `SkillModifier`, `TierRequirement`, `ExclusiveSkill`, `UnlockAttemptRequest`, `UnlockAttemptResponse`, `ClassMetricsDashboard`, `BalanceOverrideRequest`, `OverrideModifier`, `ExclusiveOverride`, `ClassEventFeed`, `ClassEvent` присутствуют и соответствуют описанию.
4. Использованы общие компоненты `responses.yaml`, `pagination.yaml`, `security.yaml` без дублирования.
5. Все enum значения, диапазоны коэффициентов и форматы идентификаторов задокументированы, числовые поля имеют ограничения (`minimum`, `maximum`).
6. Минимум два примера: успешное получение класса и успешная разблокировка Tier 2, плюс пример телеметрии.
7. Endpoint разблокировки описывает публикацию событий и возможные конфликты (409 при несоответствии условий).
8. Метрики включают поля для win-rate и usage share с описанием вычисления и ссылкой на analytics события.
9. Интеграции с character-service и Kafka перечислены в разделе `Integrations & Events`.
10. Чеклист `tasks/config/checklist.md` пройден, задание не содержит TODO, размер ≤ 500 строк.
11. `tasks/config/brain-mapping.yaml` и `tasks/queues/queued.md` обновлены, `.BRAIN` документ содержит секцию `API Tasks Status`.
12. `validate-swagger.ps1` для итоговой спецификации должен завершаться без ошибок.

## FAQ / Notes
- **Нужно ли включать кросс-классовые перки?** Да, указать флаг `supportsCrossClass` и коэффициент снижения эффективности при использовании чужих веток.  
- **Как обрабатывать эксклюзивные навыки с ресурсами?** Использовать объект `resourceCost` с полями `stamina`, `focus`, `cyberdeckLoad`, допускается расширение через `additionalProperties: false`.  
- **Как учитывать временные балансировки?** Через `balanceOverrides` и endpoint `/balance-overrides`, включая время действия и автора изменения.  
- **Что делать с телеметрией win-rate?** В `ClassMetricsDashboard` описать `winRateDelta` и `overuseFlags`, а в FAQ уточнить, что расчёт выполняет analytics pipeline.  
- **Какой auth требуется?** Все endpoints требуют `BearerAuth`; только балансные операции доступны ролям `designer`, `admin`.

## Change Log
- 2025-11-09 12:30 — Задание создано (AI Task Creator Agent)


