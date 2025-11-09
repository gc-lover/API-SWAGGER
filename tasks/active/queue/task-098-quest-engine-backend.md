# API Generation Task Template

> Обязательно сверяйся с `GLOBAL-RULES.md`, `API-SWAGGER/CORE.md`, `tasks/config/task-creation-guide.md` и `tasks/config/checklist.md`.  
> Размер задания ≤ 500 строк. При превышении создавай продолжения (`task-XXX-description_0001.md`).

## Metadata
- **Task ID:** API-TASK-098  
- **Type:** API Generation  
- **Priority:** critical  
- **Status:** queued  
- **Created:** 2025-11-09 17:28  
- **Author:** API Task Creator Agent  
- **Dependencies:** none  

## Summary
Сформировать спецификацию `api/v1/gameplay/quests/quest-engine.yaml`, описывающую backend движок квестов: state machine, диалоги, D&D skill checks, ветвления и события, чтобы gameplay-service получил полноценный API для запуска и сопровождения квестов с интеграциями в combat, economy, social.

## Source Documents
| Поле | Значение |
| --- | --- |
| Repository | `.BRAIN` |
| Path | `.BRAIN/05-technical/backend/quest-engine-backend.md` |
| Version | v1.0.0 |
| Status | approved |
| API readiness | ready (2025-11-09 01:03) |

**Key points:** state machine квестов (start→progress→complete/fail/abandon), объектная модель диалогов и ветвлений, обработка D&D skill checks, публикация событий `quest:*`, подписка на `combat`, `item`, `npc` события, таблицы `quest_instances`, `dialogue_state`, `skill_check_results`.  
**Related docs:** `.BRAIN/04-narrative/quests/quest-system.md`, `.BRAIN/02-gameplay/combat/combat-dnd-core.md`, `.BRAIN/05-technical/backend/player-character-mgmt/character-management.md`, `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`, `.BRAIN/05-technical/backend/progression-backend.md`, `.BRAIN/04-narrative/dialogues/dialogue-engine.md` (при наличии).

## Target Architecture (⚠️ Обязательно)
- **Microservice:** gameplay-service  
- **Port:** 8083  
- **Domain:** gameplay/quests  
- **API directory:** `api/v1/gameplay/quests/quest-engine.yaml`  
- **base-path:** `/api/v1/gameplay/quests/quest-engine`  
- **Java package:** `com.necpgame.gameplay`  
- **Frontend module:** `modules/quests/engine`  
- **Shared UI/Form components:** `@shared/ui/QuestCard`, `@shared/ui/ObjectiveList`, `@shared/ui/DialogueTree`, `@shared/forms/QuestDecisionForm`, `@shared/forms/SkillCheckForm`, `@shared/layouts/GameLayout`, `@shared/state/useQuestsStore`.

> Все значения должны соответствовать таблице микросервисов в `GLOBAL-RULES.md`.

## Scope of Work
1. Проанализировать исходный документ и связанные материалы по квестам, диалогам и D&D интеграции.
2. Определить полный набор REST endpoints: запуск квестов, обновление прогресса, диалоговые выборы, skill checks, завершение/отказ, аудит.
3. Смоделировать `components.schemas` для квестовых сущностей (QuestInstance, DialogueState, SkillCheckResult, Branch, Objective, DecisionOutcome).
4. Описать события EventBus (publish/subscribe), их payload, ключи, retry политики.
5. Зафиксировать зависимости на character, economy, social, combat, inventory сервисы и механизм валидации условий.
6. Добавить требования по UX/телеметрии: структура прогресса, логи, метрики; обновить маппинг, очередь и документ `.BRAIN`.

## Endpoints
- `POST /start` — запуск квеста по шаблону с проверкой требований; возвращает `QuestInstance`.
- `GET /instances` — список активных/завершённых квестов игрока с фильтрацией по статусу и категории.
- `GET /instances/{instanceId}` — детальное состояние квеста, текущие ветки, диалоговый узел, активные цели.
- `POST /instances/{instanceId}/dialogue/choice` — обработка выбора в диалоге, включая skill checks и ветвления.
- `GET /instances/{instanceId}/dialogue` — текущий диалоговый узел с доступными опциями и условиями.
- `POST /instances/{instanceId}/progress` — обновление цели (objective) на основе внешних событий (combat, item, npc).
- `POST /instances/{instanceId}/complete` — завершение квеста, выдача наград, публикация `quest:completed`.
- `POST /instances/{instanceId}/fail` — фиксация провала квеста, последствия, событие `quest:failed`.
- `POST /instances/{instanceId}/abandon` — добровольный отказ с логированием.
- `GET /instances/{instanceId}/history` — аудит действий, outcomes, результаты skill checks.
- `POST /templates/{templateId}/simulate` — опциональная симуляция ветвления/skill check для тестов (feature flag).

## Data Models
- `QuestInstance` — состояние квеста (`id`, `characterId`, `questTemplateId`, `status`, `currentBranchId`, `currentDialogueNodeId`, timestamps).
- `QuestProgress` — активные цели, выполненные задачи, таймеры, внешние зависимости.
- `DialogueNode`, `DialogueChoice`, `DialogueState` — структура диалогов, пройденные узлы, сделанные выборы.
- `SkillCheckRequest` / `SkillCheckResult` — параметры проверки (skill, dc, dice, modifiers) и результат.
- `ChoiceOutcome` — последствия выбора (флаги, награды, изменения отношений, переходы).
- `QuestObjectiveEvent` — payload внешних событий (`combat:enemy-killed`, `item:collected`, `npc:talked`).
- `QuestReward` — награды (exp, валюты, предметы, репутация) с ссылками на economy/inventory сервисы.
- `QuestAuditEntry` — журнал действий (timestamp, actor, action, outcome, metadata).
- Общие компоненты: `api/v1/shared/common/responses.yaml`, `pagination.yaml`, `security.yaml`.

## Integrations & Events
- Publish events: `quest.started`, `quest.objective-updated`, `quest.completed`, `quest.failed`, `quest.abandoned`.
- Subscribe events: `combat.enemy-killed`, `combat.boss-defeated`, `item.collected`, `npc.talked`, `world.event-triggered`.
- Kafka topics: `gameplay.quests.lifecycle`, `gameplay.quests.progress`, указать ключи (characterId), консьюмеры (narrative-service, economy-service, telemetry, notification-service).
- REST dependencies: character-service (skill stats, flags), economy-service (rewards), social-service (reputation), inventory-service (items), notification-service (updates).
- WebSocket/SignalR: уведомления клиентов о прогрессе и диалогах (опционально, указать как расширение).
- Метрики: `QuestCompletionRate`, `QuestFailRate`, `AverageBranchDepth`, `SkillCheckSuccessRate`.

## Acceptance Criteria
1. В `api/v1/gameplay/quests/quest-engine.yaml` описаны все перечисленные endpoints с параметрами, ответами, примерами и ссылками на общие компоненты.
2. `info.x-microservice` указывает на `gameplay-service` (порт 8083, base-path `/api/v1/gameplay/quests/quest-engine`).
3. Модели диалогов, ветвлений, skill checks и наград включены с обязательными полями, enum и валидацией.
4. Kafka события и подписки на внешние события документированы с payload и контрактами повторной попытки.
5. Описаны ограничения: лимиты на одновременные квесты, требования к stat/flag проверкам, обработка fail/success.
6. Добавлены UX требования: `modules/quests/engine`, компоненты UI, state store `useQuestsStore`, Orval клиент.
7. Указаны интеграции с economy, combat, inventory, social (REST/Kafka), описаны взаимные зависимости.
8. Добавлены примеры JSON для старт/выбор/skill check/завершение, включая ошибки (condition unmet, skill check fail).
9. `tasks/config/brain-mapping.yaml` пополнен записью `API-TASK-098`, статус `queued`, приоритет `critical`.
10. `.BRAIN/05-technical/backend/quest-engine-backend.md` содержит секцию `API Tasks Status` с созданной задачей.
11. `tasks/queues/queued.md` обновлён новой записью.
12. После реализации спецификации команда запускает `pwsh -NoProfile -File ..\scripts\validate-swagger.ps1 -ApiDirectory API-SWAGGER\api\v1\gameplay\quests\`.

## FAQ / Notes
- **Нужно ли делить на несколько файлов?** Пока спецификация укладывается в 400 строк; если превысит — разбить на `quest-engine-core`, `quest-dialogue`, `quest-skill-checks`.
- **Как обрабатывать TODO в документе?** Quest sharing/hints пока не реализуем, отметить как не входящее в scope.
- **Что с симуляцией?** Endpoint `/templates/{templateId}/simulate` помечается как internal/testing с флагом.
- **Требуются ли миграции?** Ссылку на DDL таблиц включить в примечания; сами миграции остаются в backend.

## Change Log
- 2025-11-09 17:28 — Задание создано (API Task Creator Agent)


