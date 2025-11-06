# Task ID: API-TASK-158
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:20 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для детализации социальных механик (22 документа). Mentorship, NPC hiring, Player orders детализации.

---

## 📚 Источники (22 документа)

**Mentorship (6):**
- mentorship-types.md, mentorship-mechanics.md, mentorship-abilities.md
- mentorship-relationships.md, mentorship-special.md, mentorship-world-impact.md

**NPC Hiring (8):**
- npc-hiring-types.md, npc-hiring-process.md, npc-hiring-management.md, npc-hiring-effectiveness.md
- npc-hiring-limits.md, npc-hiring-economy.md, npc-hiring-advanced.md, npc-hiring-world-impact.md

**Player Orders (8):**
- player-orders-types.md, player-orders-creation.md, player-orders-execution.md, player-orders-via-npc.md
- player-orders-economy.md, player-orders-reputation.md, player-orders-advanced.md, player-orders-world-impact.md

---

## 📁 Целевая структура

```
api/v1/social/
├── mentorship/
│   ├── mentorship-types.yaml
│   ├── mentorship-mechanics.yaml
│   └── mentorship-abilities.yaml
├── npc-hiring/
│   ├── npc-hiring-types.yaml
│   ├── npc-hiring-process.yaml
│   └── npc-hiring-management.yaml
└── player-orders/
    ├── player-orders-types.yaml
    ├── player-orders-creation.yaml
    └── player-orders-execution.yaml
```

---

## ✅ Задача

Создать детальные API для социальных механик, разбить по логическим файлам (не более 400 строк каждый).

**Models:** Mentorship, NPCHire, PlayerOrder, SocialImpact

---

**Источники:** 22 социальных документа

