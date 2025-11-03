# Equipment Matrix API

**Версия:** 1.0.0  
**Источник:** `.BRAIN/02-gameplay/economy/equipment-matrix.md` (v1.0.0)  
**Задание:** `API-SWAGGER/tasks/active/queue/task-002-equipment-matrix-api.md`  
**Task ID:** API-TASK-002

## Структура API

API разбито на несколько файлов для удобства поддержки и следования принципам SOLID, KISS, DRY:

1. **`equipment-matrix.yaml`** - Главный файл с общей информацией и ссылками на остальные компоненты
2. **`equipment-matrix-models.yaml`** - Базовые модели данных (ItemBase, StatsCore, StatsExtended)
3. **`equipment-matrix-stats.yaml`** - Статы по типам предметов (WeaponStats, ArmorStats, ImplantStats, CyberdeckStats, ModStats)
4. **`equipment-matrix-brands-affixes.yaml`** - Бренды и аффиксы (Brand, SignatureBonuses, Affix, AffixPool)
5. **`equipment-matrix-generation.yaml`** - Генерация и крафт (GenerationRules, RarityWeights, CraftingRecipe, CraftResult, RerollResult)
6. **`equipment-matrix-markets.yaml`** - Рынки и заказные сборки (MarketItem, Auction, CustomOrder, FulfillResult)
7. **`equipment-matrix-items.yaml`** - Объединенные модели предметов (GeneratedItem, Item, ValidationResult)
8. **`equipment-matrix-requests.yaml`** - Request/Response модели для всех endpoints
9. **`equipment-matrix-generation-endpoints.yaml`** - Endpoints генерации и правил генерации (7 endpoints)
10. **`equipment-matrix-brands-endpoints.yaml`** - Endpoints брендов и аффиксов (8 endpoints)
11. **`equipment-matrix-crafting-endpoints.yaml`** - Endpoints крафта и реролла (7 endpoints)
12. **`equipment-matrix-markets-endpoints.yaml`** - Endpoints рынков, аукционов и заказных сборок (8 endpoints)

## Использование

Для использования API импортируйте главный файл `equipment-matrix.yaml`. Все остальные файлы подключены через `$ref`.

## Общие компоненты

API использует общие компоненты из `shared/common/`:
- `responses.yaml` - стандартные ответы (400, 401, 403, 404, 409, 422, 500)
- `pagination.yaml` - компоненты пагинации
- `security.yaml` - схемы безопасности

## Endpoints

API содержит 30 endpoints, разбитых по группам:

### Генерация предметов (4 endpoints)
- POST `/gameplay/economy/items/generate` - Сгенерировать предмет
- POST `/gameplay/economy/items/generate/batch` - Сгенерировать несколько предметов
- GET `/gameplay/economy/items/{item_id}` - Получить информацию о предмете
- POST `/gameplay/economy/items/generate/validate` - Валидировать генерацию

### Правила генерации (3 endpoints)
- GET `/gameplay/economy/generation-rules` - Получить правила генерации
- GET `/gameplay/economy/generation-rules/rarity-weights` - Получить веса редкостей
- POST `/gameplay/economy/generation-rules/calculate-rarity` - Рассчитать редкость

### Управление брендами (5 endpoints)
- GET `/gameplay/economy/brands` - Получить список брендов
- POST `/gameplay/economy/brands` - Создать пользовательский бренд
- GET `/gameplay/economy/brands/{brand_id}` - Получить информацию о бренде
- PUT `/gameplay/economy/brands/{brand_id}` - Обновить бренд
- GET `/gameplay/economy/brands/{brand_id}/signatures` - Получить сигнатурные бонусы

### Управление аффиксами (3 endpoints)
- GET `/gameplay/economy/affixes` - Получить список аффиксов
- GET `/gameplay/economy/affixes/{affix_id}` - Получить информацию об аффиксе
- GET `/gameplay/economy/affixes/pools` - Получить пулы аффиксов

### Крафт (4 endpoints)
- POST `/gameplay/economy/items/craft` - Создать предмет через крафт
- GET `/gameplay/economy/recipes` - Получить список рецептов
- GET `/gameplay/economy/recipes/{recipe_id}` - Получить информацию о рецепте
- POST `/gameplay/economy/items/craft/validate` - Валидировать крафт

### Реролл (3 endpoints)
- POST `/gameplay/economy/items/{item_id}/reroll` - Выполнить реролл
- POST `/gameplay/economy/items/{item_id}/reroll/validate` - Валидировать реролл
- GET `/gameplay/economy/items/{item_id}/reroll/history` - Получить историю рероллов

### Рынки и аукционы (5 endpoints)
- GET `/gameplay/economy/markets/items` - Получить список предметов на рынке
- POST `/gameplay/economy/markets/items/{item_id}/list` - Выставить предмет на рынок
- GET `/gameplay/economy/auctions` - Получить список аукционов
- POST `/gameplay/economy/auctions` - Создать аукцион
- POST `/gameplay/economy/auctions/{auction_id}/bid` - Сделать ставку

### Заказные сборки (3 endpoints)
- GET `/gameplay/economy/custom-orders` - Получить список заказов
- POST `/gameplay/economy/custom-orders` - Создать заказ
- POST `/gameplay/economy/custom-orders/{order_id}/accept` - Принять заказ
- POST `/gameplay/economy/custom-orders/{order_id}/fulfill` - Выполнить заказ

## Модели данных

API содержит 27+ моделей данных, разбитых по файлам:

- **Базовые модели**: ItemBase, StatsCore, StatsExtended
- **Статы по типам**: WeaponStats, ArmorStats, ImplantStats, CyberdeckStats, ModStats
- **Бренды и аффиксы**: Brand, SignatureBonuses, Affix, AffixPool
- **Генерация и крафт**: GenerationRules, RarityWeights, RarityCalculation, CraftingRecipe, CraftResult, RerollResult, RerollHistory
- **Рынки**: MarketItem, ListingResult, Auction, BidResult, CustomOrder, FulfillResult
- **Объединенные модели**: GeneratedItem, Item, ValidationResult
- **Request/Response**: Все модели запросов и ответов для endpoints

## Интеграции

API интегрируется с:
- `api/v1/gameplay/combat/implants.yaml` - импланты (совместимость)
- `api/v1/gameplay/combat/cyberpsychosis.yaml` - киберпсихоз (влияние предметов)
- `api/v1/gameplay/economy/economy-crafting.yaml` - крафт (детали)
- `api/v1/gameplay/economy/economy-trading.yaml` - торговля (рынки)
- `api/v1/lore/factions/factions.yaml` - фракции (бренды)

