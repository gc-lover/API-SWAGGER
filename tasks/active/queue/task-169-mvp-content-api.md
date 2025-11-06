# Task ID: API-TASK-169
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 11:50 | **Создатель:** AI Agent | **Зависимости:** API-TASK-127

---

## 📋 Описание

Создать API для MVP контента (6 документов). MVP endpoints, data models, initial data, content overview, text version plan, ui-main-game.

---

## 📚 Источники (6 документов)

- `mvp-endpoints.md` - список MVP endpoints
- `mvp-data-models.md` - модели данных для MVP
- `mvp-initial-data.md` - начальные данные игры
- `mvp-content/content-overview-2020-2093.md` - обзор контента
- `mvp-text-version-plan.md` - план текстовой версии
- `ui-main-game.md` - основной UI игры

---

## 📁 Целевой файл

```
api/v1/mvp/
├── mvp-endpoints.yaml
├── mvp-models.yaml
└── mvp-content.yaml
```

---

## ✅ Endpoints

1. **GET /api/v1/mvp/endpoints** - Список MVP endpoints
2. **GET /api/v1/mvp/models** - Data models для MVP
3. **GET /api/v1/mvp/initial-data** - Начальные данные

**Models:** MVPEndpoint, MVPModel, InitialGameData

---

**Источники:** 6 MVP документов

