# Task ID: API-TASK-130
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:20 | **Создатель:** AI Agent | **Зависимости:** API-TASK-128

---

## 📋 Описание

Создать API для P2P торговли между игроками. Trade window, offers, dual confirmation, anti-scam.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/trade-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Trade window (2 игрока face-to-face)
- Trade offers (items + gold)
- Dual confirmation (оба подтверждают)
- Distance check (max 10m)
- Trade history
- Anti-scam protection (show all items before accept)
- Restrictions (bound items нельзя торговать)

---

## 📁 Целевой файл

`api/v1/trade/trade-system.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** economy-service  
**Порт:** 8085  
**API пути:** /api/v1/trade/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** economy  
**Путь:** modules/economy/trade  
**State Store:** useEconomyStore (tradeSession, offers)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- ItemCard, TradeWindow, ConfirmButton, PriceDisplay

**Готовые формы (@shared/forms):**
- TradeForm (offer items + gold)

**Layouts (@shared/layouts):**
- GameLayout

**Хуки (@shared/hooks):**
- useDebounce
- useRealtime (для обновления trade session)

---

## ✅ Endpoints (план)

1. **POST /api/v1/trade/sessions** - Создать trade session
2. **POST /api/v1/trade/sessions/{session_id}/offer** - Предложить items/gold
3. **POST /api/v1/trade/sessions/{session_id}/accept** - Подтвердить сделку
4. **POST /api/v1/trade/sessions/{session_id}/cancel** - Отменить торговлю
5. **GET /api/v1/trade/sessions/{session_id}** - Статус сделки
6. **GET /api/v1/trade/history** - История торговли

**Models:**
- TradeSession, TradeOffer, TradeParticipant, TradeHistory

---

## 🔍 Критерии

✅ Dual confirmation ✅ Distance validation ✅ Bound items blocked ✅ Trade history ✅ Anti-scam (show items)

---

**Источник:** `.BRAIN/05-technical/backend/trade-system.md`

