# Task ID: API-TASK-360
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-08 21:25
**Создатель:** AI Agent (GPT-5 Codex)
**Зависимости:** [API-TASK-173], [API-TASK-241]

---

## 📋 Краткое описание

Создать OpenAPI спецификацию административного API, которое описывает конфигурацию, наблюдаемость и интеграции MVP backend микросервисов проекта NECPGAME.

**Что нужно сделать:** Спроектировать REST API для управления и аудита архитектуры микросервисов (службы, порты, интеграции, observability, безопасность, CI/CD) согласно документу `.BRAIN/05-technical/architecture/mvp-backend-architecture.md`.

---

## 🎯 Цель задания

Обеспечить `admin-service` набором административных endpoints, предоставляющих достоверную информацию о составе MVP микросервисов, их интеграциях и статусе, а также инструменты синхронизации описаний между архитектурой и реализацией.

**Зачем это нужно:**
- Дать операционным и девопс-командам единый источник правды по микросервисам MVP.
- Формализовать связи REST/Kafka, хранилищ и observability для автоматизированных проверок.
- Подготовить основу для UI модулей админ-консоли и автоматического обновления Helm/Argo конфигураций.

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`

**Путь к документу:** `.BRAIN/05-technical/architecture/mvp-backend-architecture.md`

**Версия документа:** v1.0.0

**Дата последнего обновления:** 2025-11-08

**Статус документа:** ready

**Что важно из этого документа:**
- Перечень MVP микросервисов (`auth`, `character`, `gameplay`, `social`, `economy`, `world`) с портами и зонами ответственности.
- Интеграционные каналы (REST через gateway, Kafka топики, outbox, Redis).
- Наблюдаемость (OpenTelemetry, Loki, Prometheus, Grafana, Jaeger).
- Требования по безопасности (Keycloak, RBAC, Vault) и CI/CD (GitHub Actions, ArgoCD).

### Дополнительные источники

- `.BRAIN/05-technical/architecture/mvp-frontend-architecture.md` — соответствие административного UI.
- `.BRAIN/05-technical/gameplay/2025-11-08-gameplay-backend-sync.md` — Kafka топики и синхронизация сервисов.
- `.BRAIN/05-technical/database/schema.md` — схемы PostgreSQL (`auth`, `mvp_core`, `mvp_meta`).
- `.BRAIN/05-technical/observability/observability-playbook.md` — стандарты метрик и логирования.

### Связанные документы

- `API-SWAGGER/tasks/active/queue/task-173-split-documents-batch1-api.md` — общие системные эндпоинты.
- `API-SWAGGER/tasks/active/queue/task-241-world-interaction-suite-api.md` — интеграции world-service и dashboard.
- `API-SWAGGER/api/v1/shared/common/security.yaml` — стандартные схемы безопасности.

---

## 📁 Целевая структура API

### Репозиторий: `API-SWAGGER`

**Целевой файл:** `api/v1/admin/architecture/mvp-backend.yaml`
> ⚠️ Точка входа должна описывать административные endpoints управления архитектурой. Использовать только gateway URL `https://api.necp.game/v1` и dev `http://localhost:8080/api/v1`.

**API версия:** v1

**Тип файла:** OpenAPI 3.0.3 (YAML)

**Структура директории:**
```
API-SWAGGER/
└── api/
    └── v1/
        └── admin/
            └── architecture/
                └── mvp-backend.yaml
```

**Если файл уже существует:**
- Создать новую минорную версию (`info.version` ↑) и сохранить обратную совместимость путей.
- Обновить описания интеграций и микросервисов согласно актуальным данным.

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервисная архитектура)

- **Целевой микросервис:** `admin-service`
- **Порт:** 8088
- **API Base Path:** `/api/v1/admin/architecture/*`
- **Домен:** административные операции и инфраструктурный аудит
- **Зависимости:** `auth-service` (валидация JWT), `api-gateway` (rate limiting), `gameplay-service` / `world-service` (поставщики интеграционных данных), Kafka cluster, Vault

### Frontend (модульная архитектура)

- **Целевой модуль:** `modules/admin/architecture`
- **State Store:** `useAdminStore` (architectureDashboard state)
- **UI компоненты (@shared/ui):** `ServiceCard`, `IntegrationMatrix`, `MetricSparkline`, `SecurityBadge`, `PipelineStatusTile`
- **Формы (@shared/forms):** `ServiceMetadataForm`, `KafkaTopicForm`, `ObservabilityConfigForm`
- **Layouts (@shared/layouts):** `AdminConsoleLayout`
- **Хуки (@shared/hooks):** `useRealtime`, `usePolling`, `useDebounce`

### Комментарий для OpenAPI файла

В начале спецификации добавить комментарий:
```
# Target Architecture:
# - Microservice: admin-service (port 8088)
# - Base Path: /api/v1/admin/architecture
# - Frontend Module: modules/admin/architecture
# - UI: @shared/ui (ServiceCard, IntegrationMatrix, MetricSparkline, SecurityBadge, PipelineStatusTile)
# - Forms: @shared/forms (ServiceMetadataForm, KafkaTopicForm, ObservabilityConfigForm)
# - Layout: AdminConsoleLayout | Hooks: useAdminStore, useRealtime, usePolling
# - WebSocket: wss://api.necp.game/v1/admin/architecture/stream
```

Обязательно заполнить `info.x-microservice`:
```
info:
  x-microservice:
    name: admin-service
    port: 8088
    domain: admin
    base-path: /api/v1/admin/architecture
    package: com.necpgame.adminservice
```

---

## ✅ Что нужно сделать (детальный план)

1. **Синхронизация требований**  
   Изучить `.BRAIN/05-technical/architecture/mvp-backend-architecture.md` и связанные документы, сформировать перечень ресурсов (services, integrations, observability, security, ciCd).  
   _Результат:_ перечень сущностей и связей, список Kafka topics, хранилищ, инструментов наблюдаемости.

2. **Проектирование моделей данных**  
   Описать схемы `ServiceDescriptor`, `IntegrationDescriptor`, `ObservabilityProfile`, `SecurityProfile`, `PipelineStatus`, `SyncRequest/Response`, учесть обязательные поля, enum статусов и связи между сущностями.  
   _Результат:_ финальный список `components/schemas` с валидацией и примерами.

3. **Определение REST endpoints**  
   Сконструировать CRUD эндпоинты для служб, интеграций и наблюдаемости, а также операции синхронизации/валидации архитектуры. Прописать параметры, фильтры, ответы, ссылки на общие ошибки (`shared/common/responses.yaml#/Error`).  
   _Результат:_ секция `paths` со всеми маршрутами и примерами запросов/ответов.

4. **Учёт realtime и безопасности**  
   Добавить описание WebSocket канала `wss://api.necp.game/v1/admin/architecture/stream` (через `x-websocket`), задокументировать OAuth2 scopes из `shared/security.yaml`, указать требования RBAC.  
   _Результат:_ секции `security` и `components/securitySchemes`, описание событий потока.

5. **Валидация спецификации**  
   Проверить OpenAPI через `scripts/validate-swagger.ps1`, убедиться в корректных `$ref`, отсутствии дублирования и соблюдении лимита строк.  
   _Результат:_ валидный YAML ≤400 строк, готовый к генерации клиентов и синхронизации с `generate-openapi-microservices.ps1`.

---

## 🔀 Endpoints

- **GET `/admin/architecture/services`**  
  Возвращает список всех зарегистрированных микросервисов MVP. Поддерживает фильтры `status`, `domain`, `hasKafka`.  
  **Ответы:** `200` с массивом `ServiceDescriptor`; ошибки `400`, `401`, `403`, `500` через `$ref: ../../shared/common/responses.yaml#/Error`.  
  **Пример ответа:**
  ```json
  {
    "services": [
      {
        "key": "gameplay-service",
        "name": "Gameplay Service",
        "port": 8083,
        "domain": "gameplay",
        "responsibilities": ["combat", "skills"],
        "status": "operational",
        "dependencies": ["auth-service", "character-service"],
        "storage": [
          {"type": "postgres", "schema": "mvp_core"},
          {"type": "redis", "purpose": "combat-cache"}
        ],
        "kafkaTopics": ["gameplay.events", "world.unrest.updates"],
        "lastDeploy": "2025-11-08T18:20:00Z"
      }
    ]
  }
  ```

- **POST `/admin/architecture/services`**  
  Регистрирует новую службу или обновляет метаданные из Helm chart. Тело принимает `ServiceUpsertRequest` с валидацией портов и домена. Возвращает `201` с `ServiceDescriptor`.  
  Ошибки: `400` (валидация), `409` (дубликат key), `401/403`.

- **GET `/admin/architecture/services/{serviceKey}`**  
  Детализированная информация по сервису: зависимости, health checks, связанные pipelines. Ответ `200` с `ServiceDetail`. Ошибки `404` при отсутствии.

- **PATCH `/admin/architecture/services/{serviceKey}`**  
  Частичное обновление (например, список Kafka topics, observability меток). Тело `ServicePatchRequest`. Ответ `200` с обновлённым `ServiceDetail`.

- **GET `/admin/architecture/integrations`**  
  Сводка REST/Kafka интеграций, включая направление, SLA и транспорт. Поддерживает query `type` (`rest`, `kafka`, `outbox`). Ответ `200` с массивом `IntegrationDescriptor`.

- **GET `/admin/architecture/integrations/{integrationId}`**  
  Возвращает подробности интеграции, включая требуемые схемы (`schemaRegistry`, `payloadSchemaRef`) и связанные сервисы. Ответ `200` с `IntegrationDetail`.

- **POST `/admin/architecture/integrations/validate`**  
  Проверяет, что интеграция соответствует соглашениям (например, presence в Schema Registry, наличие consumer group). Тело `IntegrationValidationRequest`, ответ `202` с `ValidationTicket` (async результат через WebSocket). Ошибки `422`, `503`.

- **GET `/admin/architecture/observability`**  
  Возвращает профиль observability (`otelCollector`, `grafanaDashboards`, `alertPolicies`). Ответ `200` с `ObservabilityProfile` и ссылками на Grafana. Использует `If-None-Match` для кеша. Ошибки стандартные.

- **GET `/admin/architecture/security`**  
  Детализирует Keycloak realm, Vault секреты, RBAC policy. Ответ `200` с `SecurityProfile`, включает список scopes (`admin.architecture:read`, `admin.architecture:write`).

- **GET `/admin/architecture/ci-cd`**  
  Статусы пайплайнов GitHub Actions и ArgoCD. Возвращает `PipelineStatusList` с текущими ревизиями, commit SHA, ссылками на Helm release.

- **POST `/admin/architecture/sync`**  
  Запускает синхронизацию архитектурных данных с реестром (обновляет Helm values). Тело `SyncRequest` (указание source `helm`/`git`), ответ `202` с `SyncJob` и ссылкой на трекинг (`/sync/{jobId}`). WebSocket stream `admin/architecture/stream` публикует прогресс.

- **GET `/admin/architecture/sync/{jobId}`**  
  Возвращает статус синхронизации. Ответ `200` с `SyncJob`. Ошибка `404` при неизвестном job.

Все ошибки должны ссылаться на `#/components/responses/BadRequest` и др., проксируя `shared/common/responses.yaml`.

---

## 🧱 Модели данных (components/schemas)

- **ServiceDescriptor** — ключ, название, домен (enum: `gateway`, `auth`, `character`, `gameplay`, `social`, `economy`, `world`, `admin`), порт (8080–8090), список ответственностей (min 1), storage (массив `StorageBinding`), `kafkaTopics` (pattern `^[a-z0-9_.-]+$`), `status` (enum: `operational`, `degraded`, `maintenance`, `offline`), timestamp `lastDeploy`.
- **ServiceDetail** — расширяет `ServiceDescriptor` полями `dependencies` (array of service keys), `restEndpoints` (array `EndpointSummary`), `outboxEnabled` (boolean), `alertPolicyIds` (array UUID), `ciPipelines` (array `PipelineSummary`).
- **StorageBinding** — `type` (enum: `postgres`, `redis`, `kafka`, `vault`), `schema`, `purpose`, `replicas` (integer ≥1).
- **IntegrationDescriptor** — `id` (UUID), `sourceService`, `targetService`, `channel` (enum: `rest`, `kafka`, `outbox`), `topicOrPath`, `slaMs`, `payloadSchemaRef`, `enabled`.
- **IntegrationDetail** — включает `retryPolicy`, `deadLetterTopic`, `consumerGroups`, `schemaRegistryUrl`, `lastValidation`.
- **IntegrationValidationRequest** — `integrationId`, optional `schemaOverride`, `runConnectivityCheck` (boolean).
- **ValidationTicket** — `ticketId`, `status` (enum: `pending`, `running`, `completed`, `failed`), `startedAt`, `completedAt`, `issues` (array `ValidationIssue`).
- **ObservabilityProfile** — `otelCollector`, `grafanaDashboards` (array URL), `prometheusJobs`, `lokiLabels`, `jaegerServiceName`, `sloTargets` (array `SloTarget`).
- **SecurityProfile** — `realm`, `jwksUri`, `requiredScopes`, `rbacPolicies`, `vaultPaths`, `lastAudit`.
- **PipelineStatusList** — массив `PipelineStatus` (`id`, `type` enum: `github-actions`, `argocd`, `helm`, `status`, `lastRun`, `link`).
- **SyncRequest** — `source` (enum: `helm`, `git`, `manual`), optional `forceReconciliation`, `notes` (max 500 chars).
- **SyncJob** — `jobId`, `status` (enum: `queued`, `running`, `succeeded`, `failed`), `startedAt`, `updatedAt`, `summary`, `diffUrl`.
- **SecurityPolicy** — `role`, `permissions`, `scope`.

Все модели должны включать `examples`, поля `required`, использовать `format` (`uuid`, `uri`, `date-time`), и ссылаться на общие (`components/responses` через shared).

---

## ⚖️ Принципы и правила

- Соблюдать SOLID/DRY/KISS, избегать дублирования компонентов.
- OpenAPI 3.0.3, все ошибки — через `api/v1/shared/common/responses.yaml`.
- Использовать `shared/common/security.yaml` для OAuth2/Keycloak схем.
- Обязательный `servers` блок: только `https://api.necp.game/v1` и `http://localhost:8080/api/v1`.
- Размер файла ≤400 строк; при необходимости вынести схемы в `api/v1/admin/architecture/components/*.yaml`.
- Все enum значения документировать и давать примеры.
- Для WebSocket указать описание канала (`x-websocket` секция) и payload `ArchitectureEvent`.

---

## ✅ Критерии приемки

1. Файл `api/v1/admin/architecture/mvp-backend.yaml` создан/обновлён, валидируется `validate-swagger.ps1` без ошибок.
2. В `info.x-microservice` указаны `admin-service`, порт 8088, домен `admin`, base-path `/api/v1/admin/architecture`.
3. Описаны минимум 8 REST endpoints, включая CRUD по сервисам, интеграциям, observability, security, ci/cd и sync.
4. Все ошибки используют `$ref` на `shared/common/responses.yaml` (без дублирования моделей ошибок).
5. Схемы данных (`ServiceDescriptor`, `IntegrationDescriptor`, `ObservabilityProfile`, `SecurityProfile`, `PipelineStatus`, `SyncJob`) содержат `required`, `enum`, `format`, `example`.
6. Документирована WebSocket трансляция `wss://api.necp.game/v1/admin/architecture/stream` и события `ArchitectureEvent`.
7. Указаны OAuth2 scopes и RBAC требования согласно `shared/security.yaml`.
8. Прописываются связи с Kafka топиками (строго `^[a-z0-9_.-]+$`) и ссылками на Schema Registry.
9. `servers` раздел содержит только gateway URLs, без прямых портов сервисов.
10. Добавлен комментарий с целевой архитектурой, фронтенд модулем, UI компонентами и hooks.
11. Спецификация описывает синхронизацию Helm/Argo (endpoint `/sync`, модель `SyncJob`).
12. Все примеры соответствуют реальным данным из документа (`mvp_core`, `world.unrest.updates`, `admin.architecture:read`).

---

## ❓ FAQ

**Q:** Нужно ли включать health-check endpoints?  
**A:** Нет, health-check покрывается другими сервисами. Укажите ссылку на существующие health маршруты в `ServiceDetail.restEndpoints`.

**Q:** Как описывать Kafka интеграции?  
**A:** Используйте `IntegrationDescriptor.channel = kafka`, перечислите топики (`gameplay.events`, `world.unrest.updates`) и укажите `schemaRegistryUrl` + `consumerGroups`.

**Q:** Требуется ли поддержка окружений (dev/stage/prod)?  
**A:** Да, добавьте параметр `environment` в `ServiceDescriptor` (enum: `dev`, `stage`, `prod`) и фильтр в GET `/services`.

**Q:** Можно ли расширить список UI компонентов?  
**A:** Допустимо, но компоненты должны быть из `@shared/ui`. Новые компоненты согласовываются с фронтенд-гильдией; добавьте их в комментарий при необходимости.

**Q:** Как обрабатывать длительные sync операции?  
**A:** Возвращайте `SyncJob` со статусом `queued`/`running` и транслируйте прогресс через WebSocket. При ошибке указывайте `errorCode` и ссылку на лог пайплайна.
