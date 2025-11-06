# Task ID: API-TASK-156
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:14 | **Создатель:** AI Agent | **Зависимости:** none

---

## 📋 Описание

Создать API для системы ценообразования. Формулы, multipliers, dynamic pricing, modifiers.

---

## 📚 Источник

**Документ:** `.BRAIN/02-gameplay/economy/economy-pricing-detailed.md` (v2.0.0, ready)

**Ключевые механики:**
- Pricing формулы
- Multipliers (quality, rarity, level)
- Dynamic pricing (supply/demand)
- Regional/faction modifiers
- Auction House mechanics
- Trade routes pricing
- Vendor prices

---

## 📁 Целевой файл

`api/v1/economy/pricing.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/economy/pricing/item/{item_id}** - Цена предмета
2. **GET /api/v1/economy/pricing/vendor/{vendor_id}** - Цены у vendor
3. **GET /api/v1/economy/pricing/market-data** - Рыночные данные
4. **POST /api/v1/economy/pricing/calculate** - Рассчитать цену

**Models:** ItemPrice, PriceModifiers, MarketData, VendorPricing

---

**Источник:** `.BRAIN/02-gameplay/economy/economy-pricing-detailed.md`

