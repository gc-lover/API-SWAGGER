## Metadata
- **Task ID:** API-TASK-001  
- **Type:** API Generation  
- **Priority:** medium  
- **Status:** queued  
- **Created:** 2025-11-09 11:20  
- **Author:** AI Task Creator Agent  
- **Dependencies:** none  

## Summary
Сформировать новую спецификацию narrative-service для управления гибридными медиа-отсылками, охватывающими кампании, эвенты, PvP/PvE активности и предметные награды, чтобы обеспечить контролируемое подключение культурных референсов без нарушения авторских прав и с синхронизацией между доменами мира, социального рейтинга и экономики.

## Source Documents
| Поле | Значение |
| --- | --- |
| Repository | `.BRAIN` |
| Path | `.BRAIN/06-tasks/ideas/2025-11-07-IDEA-hybrid-media-references.md` |
| Version | v1.0.0 |
| Status | completed |
| API readiness | ready (2025-11-09 04:28) |

**Key points:**
- Выделены контентные слои: основная кампания, побочные квесты, социальные эвенты, PvP/PvE режимы, предметы, импланты, узлы памяти.
- Требуется поддержка визуальных и аудио пасхалок для городских пространств и AR/VR окружения.
- Необходимо указывать кросс-сервисные зависимости (world, social, economy, gameplay, auth) и условия активации.
- Важна модульная система наград и альтернативных таймлайнов для сюжетных узлов.
- Нужно балансировать доступность пасхалок между PvE и PvP прогрессией без перегрузки игроков.

**Related docs:**
- `CURRENT-WORK/archive/2025-11-07-hybrid-media-references-expansion.md` (архив с таблицами NPC, визуальными референсами и квестовыми цепочками — упомянут в исходном документе).
- `.BRAIN/02-gameplay/world/world-state/player-impact-systems.md` (для стыковки мировых эффектов).
- `.BRAIN/02-gameplay/combat/combat-implants-types.md` (для имплантов-носителей пасхалок).

## Target Architecture (⚠️ Обязательно)
- **Microservice:** narrative-service  
- **Port:** 8087  
- **Domain:** narrative  
- **API directory:** `api/v1/narrative/hybrid-media-references/hybrid-media-references.yaml`  
- **base-path:** `/api/v1/narrative/hybrid-media-references`  
- **Java package:** `com.necpgame.narrative`  
- **Frontend module:** `modules/narrative/hybrid-media-references`  
- **Shared UI/Form components:** `@shared/ui/QuestCard`, `@shared/ui/EventCard`, `@shared/ui/RewardBadge`, `@shared/ui/TimelineHeatmap`, `@shared/forms/NarrativeEventForm`, `@shared/forms/RewardMatrixForm`, `@shared/layouts/GameLayout`, `@shared/layouts/ContentSplitLayout`, `@shared/hooks/useDebouncedSearch`, `@shared/hooks/useContentGating`.

## Scope of Work
1. Проанализировать исходный документ и архив расширения, собрать перечень контентных слоёв и факторов активации.
2. Сформировать структуру OpenAPI файла, определить `info`, `servers`, `tags`, базовые security схемы и ссылки на общие компоненты (`api/v1/shared/common/`).
3. Описать полный набор REST endpoint'ов для CRUD управления гибридными отсылками, их активацией, визуальными и наградными профилями, а также предпросмотром интеграций.
4. Проработать схемы данных (summary, detail, scope, trigger, reward, visual cue, localization, activation), указать enum, required поля, валидации, примеры и связь с пагинацией через `$ref`.
5. Задокументировать интеграции с world-service, social-service, economy-service, gameplay-service и auth-service, включая события и REST зависимости.
6. Подготовить примеры запросов/ответов, типовые ошибки, критерии безопасности и указать обязательное использование общих ответов.
7. Проверить задание по чеклисту, синхронизировать маппинг и очереди, подготовить инструкции для обновления `.BRAIN`.

## Endpoints
- **GET `/api/v1/narrative/hybrid-media-references`**  
  Назначение: пагинированный список пакетов отсылок с фильтрами по `scopeType`, `faction`, `season`, `status`, `requiresAlternateTimeline`.  
  Параметры: query (`page`, `size`, `scopeType`, `season`, `contentTag`, `status`, `requiresAlternateTimeline`, `sort`).  
  Ответы: `200` (список `HybridReferenceSummary` + пагинация `$ref`), `400` (BadRequest), `401`, `403`, `500` из shared responses.

- **POST `/api/v1/narrative/hybrid-media-references`**  
  Назначение: создание пакета отсылок с указанием контентных слоёв, наград, визуальных ссылок и условий активации.  
  Тело: `HybridReferenceUpsertRequest`.  
  Ответы: `201` (созданный `HybridReferenceDetail`), `400`, `401`, `403`, `409`, `422`, `500`.

- **GET `/api/v1/narrative/hybrid-media-references/{referenceId}`**  
  Назначение: получение подробного описания пакета, включая связи с событиями, NPC и предметами.  
  Параметры: path `referenceId` (UUID).  
  Ответы: `200` (`HybridReferenceDetail`), `400`, `401`, `403`, `404`, `500`.

- **PATCH `/api/v1/narrative/hybrid-media-references/{referenceId}`**  
  Назначение: частичное обновление статуса, расписания активаций, локализаций, наград.  
  Тело: `HybridReferencePatchRequest` (JSON Merge Patch).  
  Ответы: `200` (`HybridReferenceDetail`), `400`, `401`, `403`, `404`, `409`, `422`, `500`.

- **POST `/api/v1/narrative/hybrid-media-references/{referenceId}/activation`**  
  Назначение: планирование или запуск активации отсылки, привязка к сезонному событию, определение лимитов участников и триггеров.  
  Тело: `HybridReferenceActivationRequest`.  
  Ответы: `202` (`ActivationScheduleSummary`), `400`, `401`, `403`, `404`, `409`, `422`, `500`.

- **POST `/api/v1/narrative/hybrid-media-references/{referenceId}/preview`**  
  Назначение: генерация агрегированного предпросмотра влияния на мир, социальные рейтинги, экономику и награды.  
  Тело: `HybridReferencePreviewRequest`.  
  Ответы: `200` (`HybridReferencePreview`), `400`, `401`, `403`, `404`, `422`, `500`.

- **POST `/api/v1/narrative/hybrid-media-references/{referenceId}/localizations`**  
  Назначение: пакетное обновление локализованных текстов, визуальных подсказок и аудио-лейблов для UI.  
  Тело: `HybridReferenceLocalizationBatch`.  
  Ответы: `200` (`HybridReferenceDetail`), `400`, `401`, `403`, `404`, `409`, `422`, `500`.

- **GET `/api/v1/narrative/hybrid-media-references/{referenceId}/timeline`**  
  Назначение: получение временной шкалы активностей, альтернативных таймлайнов и связанных событий.  
  Ответы: `200` (`HybridReferenceTimeline`), `400`, `401`, `403`, `404`, `500`.

## Data Models
- `HybridReferenceSummary`: `id`, `slug`, `title`, `scopeTypes` (enum: `main_campaign`, `side_quest`, `social_event`, `pvp_mode`, `pve_raid`, `world_environment`, `item_implant`, `narrative_node`), `status` (enum: `draft`, `planned`, `active`, `archived`), `season`, `primaryFaction`, `requiresAlternateTimeline` (boolean), `spotlightRating` (0–100), `createdAt`, `updatedAt`.
- `HybridReferenceDetail`: расширяет summary полями `description`, `inspirationSources` (array строк), `narrativeBeats`, `worldLocations`, `npcCarriers`, `rewardBundles`, `visualCues`, `triggerMatrix`, `integrationLinks`, `accessibilityNotes`, `complianceTags`.
- `HybridReferenceUpsertRequest`: поля `title`, `slug`, `status`, `season`, `scope` (array `ReferenceContentScope`), `triggerMatrix` (array `ReferenceTriggerConfig`), `rewardBundles` (array `ReferenceRewardBundle`), `visualCues` (array `ReferenceVisualCue`), `alternateTimelineSettings`, `integrationLinks`.
- `ReferenceContentScope`: `scopeType`, `description`, `targetIds` (UUID array), `progressionRequirements`, `pvpGate`, `pveGate`.
- `ReferenceTriggerConfig`: `triggerType` (enum: `world_event`, `social_threshold`, `economy_index`, `combat_stat`, `auth_flag`), `conditionExpression`, `cooldownMinutes`, `maxConcurrentActivations`, `fallbackPlan`.
- `ReferenceRewardBundle`: `bundleId`, `rarity` (enum: `common`, `rare`, `epic`, `legendary`, `mythic`), `rewards` (objects со ссылками на economy items, implants, cosmetics), `pveWeight`, `pvpWeight`, `marketingTag`.
- `ReferenceVisualCue`: `cueId`, `medium` (enum: `environment`, `ui`, `audio`, `ar_overlay`), `assetId`, `caption`, `unlockHint`, `inWorldLocation`.
- `HybridReferenceActivationRequest`: `activationType` (enum: `scheduled`, `immediate`, `seasonal`), `startAt`, `endAt`, `targetSegments` (array), `maxParticipants`, `worldImpactProfile`, `notificationTemplateId`.
- `ActivationScheduleSummary`: `activationId`, `startsAt`, `endsAt`, `status`, `worldImpactScore`, `linkedEvents`.
- `HybridReferencePreviewRequest`: фильтры `worldStateSnapshotId`, `includeRewards`, `includeNpcBriefings`.
- `HybridReferencePreview`: агрегированные блоки `worldImpact`, `socialRipple`, `economyInfluence`, `combatAdjustments`, `uiHighlights`.
- `HybridReferenceLocalizationBatch`: массив объектов `LocalizationEntry` (язык, заголовок, описание, uiTokens, audioCueIds).
- `HybridReferenceTimeline`: `segments` (array с полями `startAt`, `endAt`, `timelineType`, `linkedEventId`, `playerFacingSummary`, `alternateTimelineDiff`), `nextWindow`, `lastUpdatedBy`.
- `ReferenceIntegrationLink`: `service` (enum: `world`, `social`, `economy`, `gameplay`, `auth`), `externalId`, `syncMode` (enum: `push`, `pull`, `bidirectional`), `eventTopics`, `restEndpoints`.
- `ErrorResponse`: использовать `$ref` на `api/v1/shared/common/responses.yaml#/components/responses/BadRequest` и другие стандартные ошибки.
- Все коллекции должны ссылаться на `api/v1/shared/common/pagination.yaml` для `PageableRequest` и `PaginatedResponse`.

## Integrations & Events
- REST подтягивание локаций и мировых событий из world-service (`GET /api/v1/world/events/{eventId}`) и публикация `world.hybrid-reference.activated`.  
- Социальные рейтинги через social-service (`POST /api/v1/social/ratings/apply`) и событие `social.reputation.modified` при активации пасхалки.  
- Экономические награды через economy-service (`POST /api/v1/economy/rewards/disburse`), синхронизация биржевых индексов для триггеров.  
- Комбат-режимы через gameplay-service (`POST /api/v1/gameplay/combat/modes/attach-reference`) для PvP/PvE арен.  
- Auth-service предоставляет временные идентификаторы и маскировку персонажей (`POST /api/v1/auth/personas/temporary`) при альтернативных таймлайнах.  
- Kafka темы: `narrative.hybrid-reference.created`, `narrative.hybrid-reference.updated`, `narrative.hybrid-reference.activated`, слушатели: `world.hybrid-reference.timeline-updated`, `social.hybrid-reference.reputation-snapshot`, `economy.hybrid-reference.reward-claimed`.  
- WebSocket канал `ws://api.necp.game/v1/narrative/hybrid-media-references/{referenceId}/live` для превью UI (описать протокол в отдельной задаче, но указать необходимость сигнала по событию активации).

## Acceptance Criteria
1. Создан новый файл `api/v1/narrative/hybrid-media-references/hybrid-media-references.yaml` ≤ 400 строк с корректным `info.x-microservice` и `servers`.  
2. Все описанные endpoint'ы включены с полным набором методов, параметров, тегов, security и ссылками на общие ответы.  
3. Схемы `HybridReferenceSummary`, `HybridReferenceDetail`, `ReferenceContentScope`, `ReferenceTriggerConfig`, `ReferenceRewardBundle`, `ReferenceVisualCue`, `HybridReferenceActivationRequest`, `ActivationScheduleSummary`, `HybridReferencePreview`, `HybridReferenceLocalizationBatch`, `HybridReferenceTimeline`, `ReferenceIntegrationLink` присутствуют и соответствуют ограничениям.  
4. Использованы компоненты пагинации из `api/v1/shared/common/pagination.yaml` и стандартные ответы из `api/v1/shared/common/responses.yaml`.  
5. Предоставлены минимум два рабочих примера запрос/ответ (листинг и создание) и один пример активации с альтернативным таймлайном.  
6. Описаны все необходимые enum значения, диапазоны и обязательные поля, включая уникальные идентификаторы и временные метки.  
7. В секции `components.securitySchemes` задекларирована ссылка на `api/v1/shared/common/security.yaml#/components/securitySchemes/BearerAuth` и применена ко всем защищённым endpoint'ам.  
8. Для каждой интеграции перечислены внешние REST вызовы или события, указано, какие данные синхронизируются.  
9. Включены описания бизнес-правил: баланс PvE/PvP, compliance теги, ограничения по альтернативным таймлайнам.  
10. Запуск `pwsh -NoProfile -File ..\scripts\validate-swagger.ps1 -ApiSpec api/v1/narrative/hybrid-media-references/hybrid-media-references.yaml` выполняется без ошибок.  
11. Файл задания ссылается на актуальные документы, не содержит TODO и соответствует шаблону.  
12. `tasks/config/brain-mapping.yaml` обновлён для связи `API-TASK-001` с исходным документом, `tasks/queues/queued.md` содержит запись, `.BRAIN` документ дополнен секцией статуса.  
13. FAQ содержит ответы на ключевые вопросы агента-исполнителя, включая распределение обязанностей между сервисами.  
14. Все поля дат/времени представлены в ISO 8601, идентификаторы — UUID v4, slug — kebab-case с проверкой уникальности.  
15. Для локализаций описан формат хранения токенов (`uiTokens`) и привязка к фронтенд модулю.

## FAQ / Notes
- **Как распределяются обязанности между сервисами?** Narrative-service отвечает за авторские сценарии и хранение пасхалок, world/social/economy/gameplay предоставляют контекст и исполняют действия по событиям; спецификация должна описать внешние REST/Kafka вызовы, но реализация останется за соответствующими сервисами.  
- **Нужно ли включать все примеры из архива?** Нет, достаточно репрезентативных примеров (по одному для кампании, социального эвента и PvP/PvE); остальные детали останутся в narrative базе данных.  
- **Как обрабатывать ограничения по авторским правам?** Добавить поле `complianceTags` и описание процесса ручного аудита; API не хранит оригинальные названия, только производные термины из документа.  
- **Какие UI компоненты должны поддерживаться?** Указать перечисленные модули и компоненты, чтобы фронтенд мог сделать орвал-клиенты, карточки с визуальными подсказками и редактор расписаний.  
- **Как учитывать альтернативные таймлайны?** Через флаг `requiresAlternateTimeline` и блок `alternateTimelineSettings`, который задаёт маскировку персонажей (интеграция с auth-service) и связанный комментарий в предварительном просмотре.

## Change Log
- 2025-11-09 11:20 — Задание создано (AI Task Creator Agent)


