# Task ID: API-TASK-168
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:48 | **Создатель:** AI Agent | **Зависимости:** API-TASK-138

---

## 📋 Описание

Создать API для региональных и daily/weekly квестов (9 документов).

---

## 📚 Источники (9 документов)

**Daily/Weekly (2):**
- asia-daily-weekly.md
- europe-daily-weekly.md

**World Regional (7):**
- africa/west-africa-quests.md
- america/south-america-quests.md
- asia/east-asia-quests.md
- cis/russia-quests.md
- europe/western-europe-quests.md
- middle-east/gulf-quests.md
- oceania/oceania-quests.md

**+ Faction world quests:**
- arasaka-world-quests.md

---

## 📁 Целевой файл

```
api/v1/narrative/world-quests/
├── daily-weekly.yaml
└── regional-quests.yaml
```

---

## ✅ Endpoints

1. **GET /api/v1/narrative/world-quests/daily** - Daily quests по региону
2. **GET /api/v1/narrative/world-quests/weekly** - Weekly quests
3. **GET /api/v1/narrative/world-quests/regional** - Региональные квесты

**Models:** DailyQuest, WeeklyQuest, RegionalQuest

---

**Источники:** 9 world/regional quest документов

