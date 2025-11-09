# API Generation Task Template

> Обязательно сверяйся с `GLOBAL-RULES.md`, `API-SWAGGER/CORE.md`, `tasks/config/task-creation-guide.md` и `tasks/config/checklist.md`.  
> Размер задания ≤ 500 строк. При превышении создавай продолжения (`task-XXX-description_0001.md`).

## Metadata
- **Task ID:** API-TASK-097  
- **Type:** API Generation  
- **Priority:** critical  
- **Status:** queued  
- **Created:** 2025-11-09 17:05  
- **Author:** API Task Creator Agent  
- **Dependencies:** none  

## Summary
Подготовить OpenAPI спецификацию `api/v1/characters/players.yaml`, закрывающую полный жизненный цикл персонажей: создание, удаление, восстановление, переключение активного персонажа, управление слотами и аудит, с учётом интеграций с auth, gameplay, economy и inventory сервисами.

## Source Documents
| Поле | Значение |
| --- | --- |
| Repository | `.BRAIN` |
| Path | `.BRAIN/05-technical/backend/player-character-mgmt/character-management.md` |
| Version | v1.1.0 |
| Status | approved |
| API readiness | ready (2025-11-09 02:47) |

**Key points:** три слота персонажей по умолчанию с расширением через economy; soft-delete с 30-дневным восстановлением; переключение только вне боя; подробный аудит действий; обязательные Kafka события `CharacterCreated`, `CharacterDeleted`, `CharacterRestored`, `CharacterSwitched`, `CharacterStatsUpdated`.  
**Related docs:** `.BRAIN/05-technical/backend/player-character-mgmt/part1-creation-deletion.md`, `.BRAIN/05-technical/backend/player-character-mgmt/part2-switching-management.md`, `.BRAIN/05-technical/backend/inventory-system/part1-core-system.md`, `.BRAIN/05-technical/backend/progression-backend.md`, `.BRAIN/02-gameplay/economy/economy-contracts.md`, `.BRAIN/05-technical/backend/session-management.md`.

## Target Architecture (⚠️ Обязательно)
- **Microservice:** character-service  
- **Port:** 8082  
- **Domain:** characters  
- **API directory:** `api/v1/characters/players.yaml`  
- **base-path:** `/api/v1/characters/players`  
- **Java package:** `com.necpgame.characters`  
- **Frontend module:** `modules/characters/management`  
- **Shared UI/Form components:** `@shared/ui/CharacterCard`, `@shared/ui/SlotMeter`, `@shared/ui/StateBadge`, `@shared/forms/CharacterCreateForm`, `@shared/forms/CharacterAppearanceForm`, `@shared/forms/CharacterSwitchForm`, `@shared/layouts/GameLayout`, `@shared/state/useCharactersStore`.

> Все значения должны соответствовать таблице микросервисов в `GLOBAL-RULES.md`.

## Scope of Work
1. Проанализировать сводный документ и связанные части (Part1/Part2) для уточнения состояний и таблиц.
2. Определить набор REST endpoints по CRUD, восстановлению, переключению, расширению слотов и аудиту.
3. Спроектировать `components.schemas` для игрока, персонажа, слотов, очереди восстановления, снапшотов и событий.
4. Описать Kafka события `characters.lifecycle.*`, их payload и потребителей; зафиксировать зависимости на economy, gameplay, inventory.
5. Добавить в спецификацию ошибки, валидации, rate-limits, security (OAuth2 PlayerSession) и ссылки на общие компоненты.
6. Подготовить примеры запросов/ответов, обновить очереди и маппинг, после реализации прогнать `validate-swagger.ps1`.

## Endpoints
- `POST /accounts/{accountId}/characters` — создание персонажа на свободном слоте, генерация origin статов, публикация `CharacterCreated`.
- `GET /accounts/{accountId}/characters` — список персонажей с состояниями, слотами, признаками soft-delete и доступностью восстановления.
- `DELETE /accounts/{accountId}/characters/{characterId}` — soft-delete с записью `deleted`, `canRestoreUntil`, журналом и событием `CharacterDeleted`.
- `POST /accounts/{accountId}/characters/{characterId}/restore` — восстановление персонажа из очереди, проверки слотов и платежей.
- `POST /accounts/{accountId}/switch` — переключение активного персонажа, сохранение снапшота, публикация `CharacterSwitched`.
- `PATCH /accounts/{accountId}/characters/{characterId}/appearance` — изменение внешности с валидацией списков и синхронизацией с progression.
- `POST /accounts/{accountId}/characters/{characterId}/recalculate` — пересчёт derived stats, публикация `CharacterStatsUpdated`.
- `GET /accounts/{accountId}/activity` — аудит действий по персонажам с фильтрацией по типам операций и диапазонам дат.
- `POST /accounts/{accountId}/slots/purchase` — расширение слотов через economy-service, обработка транзакций и обновление `character_slots`.
- `GET /accounts/{accountId}/slots` — текущие лимиты слотов, прогресс расширения, требования для следующего уровня.

## Data Models
- `PlayerProfile` — сведения о аккаунте, настройках, лимитах, связанных сервисах.
- `CharacterSummary` — ключевые поля персонажа (`origin`, `class`, `status`, `level`, `currentLocation`, `lastActiveAt`, `deleted`, `canRestoreUntil`).
- `CharacterCreateRequest` / `CharacterCreateResponse` — входные данные для создания (имя, origin, класс, seed) и результат с идентификаторами.
- `CharacterRestoreRequest` — подтверждение восстановления с указанием причины, optional payment reference.
- `CharacterSwitchRequest` — идентификатор персонажа, метаданные текущей сессии, обязательные проверки combat/quests.
- `CharacterAppearancePatch` — список допустимых параметров внешности с enum/constraints.
- `CharacterStatsRecalculateRequest` — триггеры пересчёта (equipmentChange, skillChange, externalModifier).
- `CharacterActivityEntry` — запись аудита (type, actor, timestamp, metadata, ip, location).
- `CharacterSlotState` / `CharacterSlotPurchaseRequest` — представление слотов и операции расширения.
- `RestoreQueueEntry`, `StateSnapshotRef` — ссылки на таблицы восстановления и снапшотов.
- Использовать общие компоненты: `api/v1/shared/common/responses.yaml`, `pagination.yaml`, `security.yaml`.

## Integrations & Events
- REST зависимости: economy-service (`POST /api/v1/economy/wallets/transactions`), inventory-service (`GET /api/v1/inventory/characters/{characterId}`), gameplay-service (`GET /api/v1/gameplay/session/{characterId}/status`), auth-service (валидация токена через `X-Player-Session`), notification-service (webhooks о статусе персонажа).
- Kafka topics: `characters.lifecycle.created`, `characters.lifecycle.deleted`, `characters.lifecycle.restored`, `characters.lifecycle.switched`, `characters.lifecycle.stats-updated`; указать producer (character-service) и consumers (gameplay-service, economy-service, social-service, notification-service, telemetry).
- Очереди/cron: `character-restore-queue` (обработка восстановления), `character-soft-delete-expirer` (cron), взаимодействие с session-service для invalidate старой сессии.
- Frontend интеграция: модуль `modules/characters/management`, хук `useCharactersStore`, Orval клиент `@api/characters/players`.

## Acceptance Criteria
1. Создана спецификация `api/v1/characters/players.yaml` не длиннее 500 строк с OpenAPI 3.0.3 и `info.x-microservice` для character-service.
2. Все перечисленные endpoints описаны с параметрами, ответами, примерами и ссылками на общие компоненты.
3. Модели `PlayerProfile`, `CharacterSummary`, `CharacterActivityEntry`, события lifecycle и структуры слотов оформлены с типами и валидацией.
4. Kafka события документации включают payload, ключи и список потребителей, приведены контракты ошибок и ретраев.
5. В спецификации отражены ограничения: soft-delete 30 дней, лимит переключения (combat check), rate-limit 3 создания за короткий период (`429`).
6. Security блока использует схемы из `api/v1/shared/common/security.yaml`, описаны роли (`player`, `moderator`, `admin`).
7. Прописаны зависимости на economy, gameplay, inventory, notification, session сервисы и fallback сценарии.
8. Добавлены фронтенд требования (модуль, UI компоненты, формы, Orval клиент) и тестовые данные для UX.
9. `tasks/config/brain-mapping.yaml` пополнен записью об API-TASK-097 со статусом `queued`, приоритетом `critical`.
10. `.BRAIN/05-technical/backend/player-character-mgmt/character-management.md` включает секцию `API Tasks Status` с новой задачей.
11. `tasks/queues/queued.md` дополнен записью о задаче.
12. После реализации команда запускает `pwsh -NoProfile -File ..\scripts\validate-swagger.ps1 -ApiDirectory API-SWAGGER\api\v1\characters\`.

## FAQ / Notes
- **Нужно ли сразу дробить на несколько спецификаций?** Нет, текущая задача охватывает общий CRUD/управление. При переполнении создадим дочерние задания (`player-management`, `character-switching`) из списка target спецификаций.
- **Как описывать расширение слотов?** Указать зависимость на economy-service, требовать транзакцию и возврат информации о новом лимите; предусмотреть async подтверждение.
- **Что с восстановлением после 30 дней?** Спецификация фиксирует ошибку `410 Gone` и рекомендует workflow через саппорт (не часть API).
- **Как учитывать прогрессию?** `CharacterStatsUpdated` передаёт payload для progression-service; детали прогрессии описываются через ссылки на соответствующий документ.

## Change Log
- 2025-11-09 17:05 — Задание создано (API Task Creator Agent)


