# Personal NPC Tool API

**Версия:** 1.0.0  
**Источник:** `.BRAIN/02-gameplay/social/personal-npc-tool.md` (v1.0.0)  
**Задание:** `API-SWAGGER/tasks/active/queue/task-001-personal-npc-tool-api.md`  
**Task ID:** API-TASK-001

## Структура API

API разбито на несколько файлов для удобства поддержки и следования принципам SOLID, KISS, DRY:

1. **`personal-npc-tool.yaml`** - Главный файл с общей информацией и ссылками на остальные компоненты
2. **`personal-npc-tool-models.yaml`** - Основные модели данных (Owner, PersonalNPC, RoleAssignment, NPCStats, NPCCosts, RoleSet, Limits)
3. **`personal-npc-tool-models-2.yaml`** - Модели сценариев и контрактов (ScenarioBlueprint, ScenarioStep, ScenarioInstance, ScenarioKPI, Contract, ContractTerms)
4. **`personal-npc-tool-models-3.yaml`** - Модели лицензий, сертификатов и аудита (License, Certificate, AuditLog, Ledger, Event, Subscription)
5. **`personal-npc-tool-requests.yaml`** - Request/Response модели для всех endpoints
6. **`personal-npc-tool-npc.yaml`** - Управление NPC (10 endpoints)
7. **`personal-npc-tool-owners.yaml`** - Управление владельцами и ролями (5 endpoints)
8. **`personal-npc-tool-scenarios.yaml`** - Управление сценариями (13 endpoints)
9. **`personal-npc-tool-contracts.yaml`** - Управление контрактами (7 endpoints)
10. **`personal-npc-tool-licenses.yaml`** - Лицензии и сертификаты (6 endpoints)
11. **`personal-npc-tool-audit.yaml`** - Аудит, события и журнал операций (5 endpoints)

## Использование

Для использования API импортируйте главный файл `personal-npc-tool.yaml`. Все остальные файлы подключены через `$ref`.

## Общие компоненты

API использует общие компоненты из `shared/common/`:
- `responses.yaml` - стандартные ответы (400, 401, 403, 404, 409, 422, 500)
- `pagination.yaml` - компоненты пагинации
- `security.yaml` - схемы безопасности

