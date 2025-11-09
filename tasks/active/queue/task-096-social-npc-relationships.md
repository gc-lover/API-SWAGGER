# API Generation Task Template

> Обязательно сверяйся с `GLOBAL-RULES.md`, `API-SWAGGER/CORE.md`, `tasks/config/task-creation-guide.md` и `tasks/config/checklist.md`.  
> Размер задания ≤ 500 строк. При превышении создавай продолжения (`task-XXX-description_0001.md`).

## Metadata
- **Task ID:** API-TASK-096  
- **Type:** API Generation  
- **Priority:** high  
- **Status:** queued  
- **Created:** 2025-11-09 16:40  
- **Author:** API Task Creator Agent  
- **Dependencies:** none  

## Summary
Создать полноценную OpenAPI спецификацию `api/v1/gameplay/social/npc-relationships.yaml`, охватывающую REST, события и аналитические модели системы отношений с NPC, чтобы социальный сервис мог обрабатывать шкалы симпатии, доверия, романтики и связанных мировых событий без пробелов.

## Source Documents
| Поле | Значение |
| --- | --- |
| Repository | `.BRAIN` |
| Path | `.BRAIN/02-gameplay/social/npc-relationships-system-детально.md` |
| Version | v1.0.0 |
| Status | approved |
| API readiness | ready (2025-11-09 12:15) |

**Key points:** система многослойных шкал (симпатия, доверие, лояльность, эмоции, романтика); типология NPC и классовые/фракционные модификаторы; механики изменения отношений (квесты, подарки, события, предательство); Kafka события `social.npc-relationship.changed`, `social.npc-romance.state`, `world.npc-relationship.event`; UX требования к карточкам NPC и журналу взаимодействий.  
**Related docs:** `.BRAIN/02-gameplay/social/personal-npc-tool.md`, `.BRAIN/02-gameplay/world/world-state/player-impact-systems.md`, `.BRAIN/02-gameplay/social/npc-hiring-world-impact-детально.md`, `.BRAIN/02-gameplay/economy/economy-contracts.md`, `.BRAIN/03-lore/_03-lore/factions/factions-overview-детально.md`, `.BRAIN/05-technical/backend/social-service-overview.md`.

## Target Architecture (⚠️ Обязательно)
- **Microservice:** social-service  
- **Port:** 8084  
- **Domain:** gameplay/social  
- **API directory:** `api/v1/gameplay/social/npc-relationships.yaml`  
- **base-path:** `/api/v1/gameplay/social/npc-relationships`  
- **Java package:** `com.necpgame.social`  
- **Frontend module:** `modules/social/npc-relations` (secondary: `modules/world/insights`)  
- **Shared UI/Form components:** `@shared/ui/PersonalNpcCard`, `@shared/ui/RelationshipMeter`, `@shared/ui/EventTimeline`, `@shared/forms/NpcInteractionForm`, `@shared/forms/RomanceConsentForm`, `@shared/layouts/GameLayout`, `@shared/state/useSocialStore`, `@shared/state/useWorldStore`.

> Все значения должны соответствовать таблице микросервисов в `GLOBAL-RULES.md`.

## Scope of Work
1. Проанализировать исходный документ и связанные материалы для уточнения шкал, событий и UX требований.
2. Определить полный набор REST endpoints (статусы, журнал, корректировки, романтические статусы, мировые события).
3. Спроектировать JSON схемы для статусов, корректировок, логов, романтики, событий и аудита с учётом классовых и фракционных модификаторов.
4. Описать Kafka события и очереди, включая payload, ключи и contract ссылку на потребителей/производителей.
5. Зафиксировать требования аналитики и метрик, добавить примеры ответов/запросов и ошибки с ссылками на `api/v1/shared/common/*`.
6. Проверить соответствие шаблону, обновить очереди, `brain-mapping.yaml` и документ `.BRAIN`, провести валидацию `validate-swagger.ps1`.

## Endpoints
- `GET /{npcId}` — вернуть текущее состояние отношений, эмоций, доверия, лояльности и романтических флагов; поддержать фильтрацию по слоям (`include[]=trust`).
- `POST /adjust` — пакетно изменить шкалы отношений на основе взаимодействий (квесты, подарки, события) с валидацией cooldown и лимитов.
- `POST /interactions` — записать взаимодействие игрока с NPC (ролевая сцена, подарок, предательство) и инициировать перерасчёт эмоций.
- `POST /romance` — управлять романтическим статусом (interest→bond), фиксировать двустороннее согласие, ограничения по репутации и фракциям.
- `GET /history/{npcId}` — предоставить аудит взаимодействий, изменения шкал, источники триггеров, включая фильтрацию по типам событий.
- `GET /events` (proxy из world-service) — отдать мировые события, влияющие на отношения, с возможностью пагинации и фильтрации по регионам.
- `POST /moderation/review` — отправить кейс в очередь модерации `npc-relationship-review` с причинами жалобы или подозрения.
- `GET /metrics/summary` — агрегированные метрики `NpcTrustStability`, `InteractionQualityScore`, `RomanceProgressRate`, `NpcDefectionRisk`.

## Data Models
- `NpcRelationshipStatus` — базовые шкалы (`affinity`, `trust`, `loyalty`, `mood`, `romanceLevel`, `tags`, `classModifiers`, `factionState`).
- `NpcRelationshipAdjustRequest` — массив изменений с источником (`quest`, `gift`, `betrayal`, `world-event`), пределы по дельте и cooldown.
- `NpcInteractionLogRequest` — запись взаимодействия (`timestamp`, `interactionType`, `location`, `outcome`, `reputationImpact`, `visibility`, `notes`).
- `NpcRomanceRequest` — управление романтическим состоянием (`desiredLevel`, `consentFlags`, `requirements`, `cooldown`).
- `NpcRelationshipHistory` — пагинированный список событий со ссылками на источники (`questId`, `economyTransactionId`, `worldEventId`).
- `NpcRelationshipEvent` — мировые события (producer world-service) с полями `severity`, `region`, `effectVector`.
- `NpcRelationshipModerationCase` — для очереди модерации (жалоба, статус, assignedModerator).
- `NpcRelationshipMetrics` — агрегированные показатели по NPC/игроку, включающие `EventImpactIndex`.
- Общие компоненты: ссылки на `api/v1/shared/common/responses.yaml`, `pagination.yaml`, `security.yaml`.

## Integrations & Events
- REST зависимости: потребление `world-service` (`GET /api/v1/world/events/npc-relationships`), публикация в `notification-service` (webhooks о ключевых изменениях), обращение к `economy-service` для подарков/контрактов.
- Kafka topics: `social.npc-relationship.changed` (producer social-service, consumers world-service, gameplay-service, telemetry), `social.npc-romance.state` (producer social-service, consumers quest-service, narrative-service, telemetry), `world.npc-relationship.event` (producer world-service, consumer social-service, notification-service).
- Очереди: `npc-relationship-review` (модерация контента), `npc-romance-validation` (проверка условий романтики).
- Синхронизация с `modules/social/npc-relations` (UI), `modules/world/insights` (world impact dashboard) и Orval клиентом `@api/social/npcRelationships`.

## Acceptance Criteria
1. В репозитории создан файл `api/v1/gameplay/social/npc-relationships.yaml` (≤ 500 строк) с полной структурой OpenAPI 3.0.3.
2. Раздел `info.x-microservice` описывает `social-service` (порт 8084, base-path `/api/v1/gameplay/social/npc-relationships`).
3. Все указанные REST endpoints задокументированы с параметрами, примерами и ссылками на общие компоненты.
4. Kafka события и очереди описаны в разделе `components/schemas` и `components/messages`, указаны продюсеры и консьюмеры.
5. Модели включают классовые, фракционные и романтические модификаторы, свойства снабжены валидациями и примерами.
6. Используются `$ref` на `api/v1/shared/common/responses.yaml`, `pagination.yaml`, `security.yaml` без дублирования.
7. Добавлены требования к фронтенду: модуль, UI компоненты, state store и Orval клиент.
8. В задании задокументированы зависимости на world-service, economy-service и notification-service, включая fallback сценарии.
9. `tasks/config/brain-mapping.yaml` обновлён записью для API-TASK-096, статус `queued`, приоритет `high`.
10. `.BRAIN/02-gameplay/social/npc-relationships-system-детально.md` содержит секцию `API Tasks Status` с ссылкой на задание и датой.
11. Файл очереди `tasks/queues/queued.md` дополнен записью о задаче.
12. Проверка `pwsh -NoProfile -File ..\scripts\validate-swagger.ps1 -ApiDirectory API-SWAGGER\api\v1\gameplay\social\` проходит после реализации.

## FAQ / Notes
- **Можно ли разделить REST и события на разные спецификации?** Пока нет — документ формирует единый пакет отношений; дробление допускается только при превышении лимита строк.
- **Как учитываются разные микросервисы?** Основная реализация в `social-service`; взаимодействия с `world-service` и `economy-service` оформляются как зависимости через REST/Kafka.
- **Нужно ли описывать подарки/экономику подробно?** Детализация ссылками на `economy-contracts` и `inventory` достаточно, но указать поля `giftId`, `contractId` обязательно.
- **Какие требования к безопасности?** Использовать схемы OAuth2/PlayerSession из `api/v1/shared/common/security.yaml`, предусмотреть RBAC для модераторов.

## Change Log
- 2025-11-09 16:40 — Задание создано (API Task Creator Agent)


