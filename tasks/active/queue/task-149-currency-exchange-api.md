# Task ID: API-TASK-149
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:00 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для валютной биржи. 12 региональных валют, обмен, арбитраж, leverage trading.

---

## 📚 Источник

**Документ:** `.BRAIN/02-gameplay/economy/economy-currency-exchange.md` (v1.0.0, ready)

**Ключевые механики:**
- 12 региональных валют
- Валютные пары (major/minor/exotic)
- Спреды и комиссии
- Арбитраж (региональный, triangular)
- Hedging (страхование рисков)
- Carry trade
- Leverage trading
- Real-time курсы

---

## 📁 Целевой файл

`api/v1/economy/currency-exchange.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/economy/currency-exchange/rates** - Текущие курсы
2. **POST /api/v1/economy/currency-exchange/convert** - Обменять валюту
3. **GET /api/v1/economy/currency-exchange/pairs** - Доступные пары
4. **GET /api/v1/economy/currency-exchange/history** - История курсов

**Models:** CurrencyPair, ExchangeRate, ConversionRequest, ArbitrageOpportunity

---

**Источник:** `.BRAIN/02-gameplay/economy/economy-currency-exchange.md`

