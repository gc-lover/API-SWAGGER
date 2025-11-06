# Task ID: API-TASK-152
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:06 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для контрактов между игроками. 4 типа контрактов, escrow, collateral, арбитраж.

---

## 📚 Источник

**Документ:** `.BRAIN/02-gameplay/economy/economy-contracts.md` (v1.0.0, ready)

**Ключевые механики:**
- 4 типа контрактов (exchange, service, courier, auction)
- Escrow system (третья сторона держит деньги)
- Collateral (залог)
- Репутационная система
- Арбитраж и dispute resolution
- Условия выполнения
- Автоматическое исполнение

---

## 📁 Целевой файл

`api/v1/economy/contracts.yaml`

---

## ✅ Endpoints

1. **POST /api/v1/economy/contracts** - Создать контракт
2. **POST /api/v1/economy/contracts/{id}/accept** - Принять контракт
3. **POST /api/v1/economy/contracts/{id}/complete** - Завершить контракт
4. **POST /api/v1/economy/contracts/{id}/dispute** - Открыть спор
5. **GET /api/v1/economy/contracts/available** - Доступные контракты

**Models:** Contract, Escrow, ContractTerms, Dispute

---

**Источник:** `.BRAIN/02-gameplay/economy/economy-contracts.md`

