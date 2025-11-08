# Task ID: API-TASK-WORLD-PO-Validation
**Тип:** API Generation  
**Приоритет:** высокий  
**Статус:** queued  
**Создано:** 2025-11-08 12:45  
**Создатель:** GPT-5 Codex  
**Зависимости:** API-TASK-SOC-PO-Create, API-TASK-ECON-PO-Budget

---

## 📋 Краткое описание

Создать OpenAPI спецификацию `world-service`, описывающую валидацию заказов игроков по зонам, правовым ограничениям, репутации фракций и уровню риска.

**Что нужно сделать:** Подготовить `api/v1/world/player-orders/validation.yaml` с полным набором REST endpoints и моделей, которые social-service вызывает перед публикацией заказа и при проверке брифа в мастере.

---

## 🎯 Цель задания

Установить единый валидатор мировых и юридических ограничений для системы заказов, чтобы исключить запрещённые действия, несанкционированные зоны и нарушителей санкций.

**Зачем это нужно:**
- Гарантировать соответствие заказов правовым нормам и фракционным отношениям.
- Обеспечить консистентные проверки на каждом шаге мастера (Draft → Review → Publish).
- Снизить нагрузку social-service, вынеся сложные справочники и правила в world-service.

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`  
**Путь к документу:** `.BRAIN/_02-gameplay/social/player-orders-creation-детально.md`  
**Версия документа:** 1.0.0  
**Дата последнего обновления:** 2025-11-08 09:53  
**Статус документа:** approved  

**Ключевые моменты:**
- Проверки: юридический фильтр, санкции, токсичная лексика, риск зон, соответствие бюджету.
- Интеграции: world-service (территории, правовой статус), factions-service (репутация), content-service (токсичные формулировки).
- Kafka события об ошибках: `social.player-orders.validation.failed`.
- UX: мастер должен подсвечивать этап валидации и выдавать подробный отчёт по ошибкам.

### Дополнительные источники

- `.BRAIN/_02-gameplay/social/player-orders-system-детально.md` — полный процесс, статусы заказов.
- `.BRAIN/_02-gameplay/social/player-orders-world-impact-детально.md` — влияние заказов на мир и фракции.
- `.BRAIN/_02-gameplay/social/relationships-system-детально.md` — адресные приглашения, уровни доверия.
- `.BRAIN/_02-gameplay/social/player-orders-reputation-детально.md` — последствия нарушений.
- JSON схемы: `schemas/social/player-order-validation.schema.json`, `schemas/social/player-order-create.schema.json`.
- Существующие спецификации: `api/v1/social/player-orders.yaml`, `api/v1/world/cities/population.yaml` (пример стиля world-service).

### Связанные документы

- [player-orders-creation-детально](../../../../.BRAIN/_02-gameplay/social/player-orders-creation-детально.md)
- [player-orders-world-impact-детально](../../../../.BRAIN/_02-gameplay/social/player-orders-world-impact-детально.md)
- [relationships-system-детально](../../../../.BRAIN/_02-gameplay/social/relationships-system-детально.md)
- [player-orders-reputation-детально](../../../../.BRAIN/_02-gameplay/social/player-orders-reputation-детально.md)

---

## 📁 Целевая структура API

**Репозиторий:** `API-SWAGGER`  
**Целевой файл:** `api/v1/world/player-orders/validation.yaml`  
**API версия:** v1  
**Тип файла:** OpenAPI 3.0.3 (YAML)

```
API-SWAGGER/
└── api/
    └── v1/
        └── world/
            └── player-orders/
                ├── validation.yaml        ← создать
                └── validation-components.yaml (при необходимости, ≤400 строк)
```

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервис)
- **Микросервис:** world-service  
- **Порт:** 8086  
- **API Base Path:** `/api/v1/world/player-orders/*`  
- **Домен:** Геополитические, юридические и средовые проверки.  
- **Зависимости:** factions-service (репутация), economy-service (бюджетные лимиты), content-service (NLP фильтр), telemetry-service (аудит), auth-service (scopes).

### Frontend (модуль)
- **Модуль:** `modules/social/player-orders`  
- **Путь:** `modules/social/player-orders/validation`  
- **State Store:** `useSocialStore` (`playerOrders.validationState`)  
- **UI компоненты (@shared/ui):** `ValidationSummary`, `ViolationList`, `RiskBadge`, `PolicyReferenceLink`  
- **Формы (@shared/forms):** `OrderValidationForm`, `InviteeWhitelistForm`  
- **Layouts:** `GameLayout`  
- **Хуки:** `useWorldPolicies`, `useRealtime`, `useDebounce`

### Комментарий в OpenAPI:
```
# Target Architecture:
# - Microservice: world-service (port 8086)
# - Base Path: /api/v1/world/player-orders/*
# - Frontend Module: modules/social/player-orders/validation
# - UI: ValidationSummary, ViolationList, RiskBadge
# - Forms: OrderValidationForm, InviteeWhitelistForm
# - Hooks: useWorldPolicies, useRealtime
# - Integrations: factions-service, content-service
```

---

## ✅ Что нужно сделать (детальный план)

### Шаг 1: Сбор требований
1. Каталогизировать все проверки из документа (юридический фильтр, санкции, токсичный текст, зоны риска).
2. Определить уровни серьёзности (error, warning, info) и коды нарушений.
3. Определить требования к audit trail (идентификаторы проверок, таймстемпы, источники данных).

### Шаг 2: Спроектировать endpoints
Минимальный набор:
1. `POST /world/player-orders/validation/full` — агрегированная валидация (возвращает отчёт).
2. `POST /world/player-orders/validation/location` — проверка зон, правового статуса, конфликтов событий.
3. `POST /world/player-orders/validation/factions` — проверка санкций, репутационных ограничений.
4. `POST /world/player-orders/validation/content` — проверка токсичных формулировок, запрещённых терминов.
5. `GET /world/player-orders/validation/policies` — справочник политик и статусов зон (с версионированием).
6. (Опционально) `POST /world/player-orders/validation/preview` — лёгкая проверка для автосохранений.

### Шаг 3: Описать модели данных
- `PlayerOrderValidationRequest` — общие данные (бриф, цели, участники, бюджет, шаблон, регион).
- `ValidationResult` — массив `violations[]`, `warnings[]`, `recommendations[]`.
- `Violation` — `code`, `severity`, `message`, `source`, `affectedFields`, `mitigation`.
- `ZonePolicy` / `PolicyVersion` — справочники.
- `FactionRestriction` — требования доверия, минимальный рейтинг, наложенные санкции.
- `ContentCheckResult` — детектор токсичных выражений.
- `ValidationMetrics` — время выполнения, источники, версии правил.

### Шаг 4: Составить спецификацию
1. `openapi: 3.0.3`, `info`, `servers` (prod/staging).  
2. `securitySchemes` → `shared/common/security.yaml` + scopes `world.player-orders.read`, `world.player-orders.validate`.  
3. `tags`: `Player Order Validation`, `Zone Policies`, `Faction Compliance`.  
4. `paths`: описать все endpoints, примеры запросов/ответов, `operationId`.  
5. В `components` разместить схемы, перечисления (`ValidationSeverity`, `ViolationCode`).  
6. Добавить `x-kafka-topics`:  
   - `world.player-orders.validation.completed`  
   - `world.player-orders.validation.failed`  
   - `world.player-orders.policies.updated`

### Шаг 5: Проверки
1. `npx swagger-cli validate api/v1/world/player-orders/validation.yaml`.  
2. Проверить соответствие JSON схеме (`player-order-validation.schema.json`).  
3. Убедиться, что все ошибки используют `shared/common/responses.yaml`.  
4. Проверить ≤400 строк (иначе разделить).  
5. Пройти чеклист `tasks/config/checklist.md`.

---

## 🧩 Endpoints (детализация)

1. **POST `/api/v1/world/player-orders/validation/full`**  
   - **Назначение:** Выполнить полную валидацию заказа (зоны, санкции, контент, бюджетные ограничения).  
   - **Request Body:** `PlayerOrderValidationRequest` (includes brief, budget, participants).  
   - **Response `200`:** `PlayerOrderValidationReport` (violations, warnings, metrics).  
   - **Ошибки:** `400` (некорректные данные), `401`, `403`, `409` (конфликт политик), `500`.  
   - **Примечания:** Возвращает `recommendations[]` для UI.  

2. **POST `/api/v1/world/player-orders/validation/location`**  
   - Проверяет правовой статус зон, наличие боевых конфликтов, ограничений времени суток.  
   - Параметры в теле: `locationId`, `zoneTier`, `timeWindow`, `hazardLevel`.  
   - Ответ: `LocationValidationResult` c `restrictedReasons`.  

3. **POST `/api/v1/world/player-orders/validation/factions`**  
   - Проверка санкций, конфликтов репутаций, требований доверия для адресных приглашений.  
   - В теле: массив `invitees[]`, `factionCodes[]`, `requiredTrust`.  
   - Ответ: `FactionValidationResult` (нарушения, рекомендованные замены).  

4. **POST `/api/v1/world/player-orders/validation/content`**  
   - Запускает NLP фильтр контента (`content-service`).  
   - Возвращает `ContentCheckResult` с `toxicityScore`, `blockedTerms`.  
   - Специальные ошибки: `422` (обнаружены запрещённые термины).  

5. **GET `/api/v1/world/player-orders/validation/policies`**  
   - Возвращает справочник политик (`PolicyVersionList`).  
   - Поддерживает параметры: `zone`, `faction`, `effectiveAt`.  
   - Ответ включает `etag`/`version` для кэширования.  

6. **POST `/api/v1/world/player-orders/validation/preview`**  
   - Лёгкая проверка для автосохранения (без тяжёлых справочников).  
   - Возвращает только `warnings` и `preflightViolations`.  

---

## 🧱 Модели данных

- `PlayerOrderValidationRequest`: поля `orderId?`, `ownerId`, `brief`, `objectives[]`, `budget`, `templateId`, `location`, `invitees`, `documents[]`.  
- `PlayerOrderValidationReport`: `status`, `violations[]`, `warnings[]`, `metrics`, `policyVersion`, `nextReviewAt`.  
- `Violation`: `code`, `severity`, `message`, `source`, `affectedFields`, `links`.  
- `ValidationSeverity` enum: `critical`, `high`, `medium`, `low`.  
- `LocationValidationResult`: `zoneStatus`, `restrictedReasons[]`, `legalReferences[]`.  
- `FactionValidationResult`: `blockedInvitees[]`, `requiredTrust`, `diplomaticWarnings[]`.  
- `ContentCheckResult`: `toxicityScore`, `blockedTerms[]`, `replacementSuggestions[]`.  
- `PolicyVersion`: `policyId`, `version`, `publishedAt`, `checksum`.  
- `ValidationMetrics`: `durationMs`, `rulesEvaluated`, `externalSources[]`.  
- Добавить примеры для критического отказа, предупреждения и успешной валидации.

---

## 📌 Принципы и правила

- Придерживаться `API-SWAGGER/api-swagger-rules` (≤400 строк, $ref).
- Все коды ошибок подключать из `shared/common/responses.yaml`.
- Security: `BearerAuth` + scopes (`world.player-orders.read`, `world.player-orders.validate`).  
- Соблюдать SOLID/DRY: вынести общие схемы в `validation-components.yaml`, если нужно.
- Зафиксировать версии политик (`policyVersion`) в ответах.
- Описать `x-kafka-topics` с payload схемами.
- Добавить указание логирования в telemetry-service (`x-audit` extension — описать в тексте).

---

## ✅ Критерии приемки

1. Все шесть endpoints описаны, включая параметры и ответы.
2. В `PlayerOrderValidationReport` есть поля `violations`, `warnings`, `metrics`, `policyVersion`.
3. Реализованы схемы `Violation`, `ValidationSeverity`, `ViolationCode`.
4. Добавлены примеры (`example`) минимум для `full` и `content` операций.
5. Подключены стандартные ответы (401, 403, 404, 409, 422, 500) через `$ref`.
6. Определены Kafka события в `x-kafka-topics` и payload схемы.
7. Прописаны требования к аутентификации и ролям (`world.validator`, `social-service`).
8. Файл проходит `npx swagger-cli validate` без ошибок.
9. Структура файла ≤400 строк или разбита на несколько логичных файлов.
10. Указан `policyVersion` и механизм кеширования (`ETag`, `Cache-Control`) в ответах справочника.
11. FAQ покрывает типовые вопросы по интеграции.

---

## ❓ FAQ

- **Q:** Нужно ли world-service самостоятельно вызывать content-service?  
  **A:** Да, world-service агрегирует результат. В спецификации описать, что `contentCheck` выполняется синхронно и возвращает `toxicityScore`.

- **Q:** Как обрабатывать обновления политик?  
  **A:** При обновлении `policies` публикуется Kafka `world.player-orders.policies.updated`; UI должен перезапрашивать справочник по `policyVersion`.

- **Q:** Что происходит при критическом нарушении?  
  **A:** Endpoint `validation/full` возвращает `status: failed` и список `violations` с `severity=critical`; social-service блокирует публикацию.

- **Q:** Требуется ли локализация сообщений?  
  **A:** Да, `message` — ключ локализации. В ответе указывать `defaultMessage` для отладки и `messageKey` для UI.

- **Q:** Можно ли пропустить проверку при черновом сохранении?  
  **A:** Использовать `/validation/preview`, который возвращает только soft warnings и не блокирует сохранение.

---

## 🧭 История выполнения

- 2025-11-08 12:45 — задача создана (GPT-5 Codex), статус `queued`.

---

**Следующие действия:** После подготовки спецификации обновить `brain-mapping.yaml`, добавить связь с документом `.BRAIN/_02-gameplay/social/player-orders-creation-детально.md`, уведомить команды social и economy о доступных валидаторах.

