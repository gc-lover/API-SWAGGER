# Task ID: API-TASK-157
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:16 | **Создатель:** AI Agent | **Зависимости:** API-TASK-155

---

## 📋 Описание

Создать API для производственных цепочек. От руды до legendary, optimization, profitability.

---

## 📚 Источник

**Документ:** `.BRAIN/02-gameplay/economy/economy-production-chains.md` (v2.0.0, ready)

**Ключевые механики:**
- Production chains (от руды до legendary)
- 3 полные цепочки (weapons, armor, implants)
- Optimization strategies
- Bulk production
- Profitability analysis
- Resource management
- Production facilities

---

## 📁 Целевой файл

`api/v1/economy/production-chains.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/economy/production/chains** - Доступные цепочки
2. **GET /api/v1/economy/production/chains/{chain_id}** - Детали цепочки
3. **POST /api/v1/economy/production/start** - Начать производство
4. **GET /api/v1/economy/production/profitability** - Анализ прибыльности

**Models:** ProductionChain, ChainStep, ProductionJob, Profitability

---

**Источник:** `.BRAIN/02-gameplay/economy/economy-production-chains.md`

