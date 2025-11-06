# Task ID: API-TASK-142
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:45 | **Создатель:** AI Agent | **Зависимости:** API-TASK-138

---

## 📋 Описание

Создать API для D&D проверок в квестах. Categories проверок, DC levels, modifiers.

---

## 📚 Источник

**Документ:** `.BRAIN/04-narrative/quest-dnd-checks.md` (v1.0.0, ready)

**Категории проверок:**
- Social (Persuasion, Deception, Intimidation)
- Combat (Weapons, Tactics)
- Hacking (Cyberdeck, Protocol)
- Tech (Crafting, Engineering)
- Stealth (Sneaking, Lockpicking)
- Physical (Athletics, Acrobatics)
- Mental (Intelligence, Willpower)

---

## 📁 Целевой файл

`api/v1/narrative/quest-dnd-checks.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/narrative/quest-checks/categories** - Категории проверок
2. **POST /api/v1/narrative/quest-checks/perform** - Выполнить проверку
3. **GET /api/v1/narrative/quest-checks/{check_id}** - Детали проверки

**Models:** QuestCheck, CheckCategory, CheckResult, CheckModifiers

---

**Источник:** `.BRAIN/04-narrative/quest-dnd-checks.md`

