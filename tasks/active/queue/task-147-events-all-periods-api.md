# Task ID: API-TASK-147
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 10:56 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для Random Events All Periods. 73 события перемещений 2020-2093.

---

## 📚 Источник

**Документ:** `.BRAIN/04-narrative/quests/side/EVENTS-ALL-PERIODS.md` (v1.0.0, ready)

**Содержит:** 73 события перемещений с триггерами, условиями, исходами.

---

## 📁 Целевой файл

`api/v1/narrative/random-events-all.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/narrative/random-events** - Список событий
2. **POST /api/v1/narrative/random-events/trigger** - Trigger event (internal)
3. **GET /api/v1/narrative/random-events/{event_id}** - Детали события

**Models:** RandomEvent, EventTrigger, EventOutcome

---

**Источник:** `.BRAIN/04-narrative/quests/side/EVENTS-ALL-PERIODS.md`

