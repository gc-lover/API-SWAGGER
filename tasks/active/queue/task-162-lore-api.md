# Task ID: API-TASK-162
**Тип:** API Generation | **Приоритет:** низкий | **Статус:** queued
**Создано:** 2025-11-07 11:28 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для лора (4 документа). Universe, factions, locations, characters.

---

## 📚 Источники (4 документа)

- `.BRAIN/03-lore/universe.md` (v1.1.0)
- `.BRAIN/03-lore/factions/factions-overview.md` (v1.1.0)
- `.BRAIN/03-lore/locations/locations-overview.md` (v1.2.0)
- `.BRAIN/03-lore/characters/characters-overview.md` (v1.2.0)

**Содержит:**
- Universe: временная шкала 2020-2093, лор симуляции
- Factions: 28 корпораций, 27 банд, 29 организаций
- Locations: 27 городов по регионам
- Characters: 30+ категорий NPC

---

## 📁 Целевая структура

```
api/v1/lore/
├── universe.yaml
├── factions.yaml
├── locations.yaml
└── characters.yaml
```

---

## ✅ Endpoints

1. **GET /api/v1/lore/universe/timeline** - Временная шкала
2. **GET /api/v1/lore/factions** - Список фракций
3. **GET /api/v1/lore/locations** - Список локаций
4. **GET /api/v1/lore/characters** - Категории NPC

**Models:** UniverseTimeline, Faction, Location, CharacterCategory

---

**Источники:** 4 lore документа

