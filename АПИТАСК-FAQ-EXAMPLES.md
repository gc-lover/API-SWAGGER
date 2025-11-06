# АПИТАСК-FAQ-EXAMPLES.md

**Примеры команд и инструменты для проверки**

📖 **Навигация:** [АПИТАСК.MD](./АПИТАСК.MD) | [АПИТАСК-FAQ.md](./АПИТАСК-FAQ.md) | [АПИТАСК-PROCESS.md](./АПИТАСК-PROCESS.md) | [АПИТАСК-REQUIREMENTS.md](./АПИТАСК-REQUIREMENTS.md) | [АПИТАСК-ARCHITECTURE.md](./АПИТАСК-ARCHITECTURE.md)

---

## Примеры команд для агента

### Пример 1: Одно задание

```
Делай API для tasks/active/queue/task-001-personal-npc-tool-api.md
```

### Пример 2: Все задания

```
Делай API для всех заданий из tasks/active/queue/
```

### Пример 3: По ID задания

```
Делай API для задания API-TASK-001
```

### Пример 4: Несколько конкретных заданий

```
Делай API для:
- tasks/active/queue/task-001-personal-npc-tool-api.md
- tasks/active/queue/task-002-equipment-matrix-api.md
```

### Пример 5: С приоритетом

```
Делай API для всех заданий с приоритетом "высокий" из tasks/active/queue/
```

---

## Примеры использования общих компонентов

### Пример использования стандартных ответов:

```yaml
paths:
  /api/v1/resource:
    get:
      responses:
        '200':
          description: Успешный ответ
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Resource'
        '400':
          $ref: '../../shared/common/responses.yaml#/components/responses/BadRequest'
        '401':
          $ref: '../../shared/common/responses.yaml#/components/responses/Unauthorized'
        '404':
          $ref: '../../shared/common/responses.yaml#/components/responses/NotFound'
        '500':
          $ref: '../../shared/common/responses.yaml#/components/responses/InternalServerError'
```

### Пример использования пагинации:

```yaml
parameters:
  - $ref: '../../shared/common/pagination.yaml#/components/parameters/Page'
  - $ref: '../../shared/common/pagination.yaml#/components/parameters/PageSize'

paths:
  /api/v1/resource:
    get:
      parameters:
        - $ref: '../../shared/common/pagination.yaml#/components/parameters/Page'
        - $ref: '../../shared/common/pagination.yaml#/components/parameters/PageSize'
      responses:
        '200':
          description: Список ресурсов
          content:
            application/json:
              schema:
                $ref: '../../shared/common/pagination.yaml#/components/schemas/PaginatedResponse'
```

### Пример использования безопасности:

```yaml
paths:
  /api/v1/resource:
    get:
      security:
        - BearerAuth: []
      responses:
        '200':
          description: Успешный ответ
        '401':
          $ref: '../../shared/common/responses.yaml#/components/responses/Unauthorized'

components:
  securitySchemes:
    BearerAuth:
      $ref: '../../shared/common/security.yaml#/components/securitySchemes/BearerAuth'
```

---

## Инструменты для проверки

### Валидация OpenAPI:

- [Swagger Editor](https://editor.swagger.io/) - онлайн валидатор OpenAPI
- [Swagger Validator](https://validator.swagger.io/) - валидация API спецификации

### Примеры команд для проверки:

```bash
# Проверка синтаксиса YAML (если установлен yamllint)
yamllint api/v1/gameplay/social/personal-npc-tool.yaml

# Проверка через npm swagger-cli (если установлен)
swagger-cli validate api/v1/gameplay/social/personal-npc-tool.yaml
```

---

📖 **Навигация:** [АПИТАСК.MD](./АПИТАСК.MD) | [АПИТАСК-FAQ.md](./АПИТАСК-FAQ.md) | [АПИТАСК-PROCESS.md](./АПИТАСК-PROCESS.md) | [АПИТАСК-REQUIREMENTS.md](./АПИТАСК-REQUIREMENTS.md) | [АПИТАСК-ARCHITECTURE.md](./АПИТАСК-ARCHITECTURE.md)

