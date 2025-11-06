# Task ID: API-TASK-155
**Тип:** API Generation | **Приоритет:** средний | **Статус:** queued
**Создано:** 2025-11-07 11:12 | **Создатель:** AI Agent | **Зависимости:** API-TASK-128

---

## 📋 Описание

Создать API для рецептов крафта. 13 детальных рецептов, components, success rates, progression T1-T5.

---

## 📚 Источник

**Документ:** `.BRAIN/02-gameplay/economy/economy-crafting-recipes.md` (v2.0.0, ready)

**Ключевые механики:**
- 13 детальных рецептов (weapons, armor, implants, mods, consumables)
- Components и costs
- Crafting time
- Success rates (зависит от skills)
- Progression tiers (T1-T5)
- Rare materials
- Blueprint system

---

## 📁 Целевой файл

`api/v1/economy/crafting-recipes.yaml`

---

## ✅ Endpoints

1. **GET /api/v1/economy/crafting/recipes** - Список рецептов
2. **GET /api/v1/economy/crafting/recipes/{recipe_id}** - Детали рецепта
3. **POST /api/v1/economy/crafting/craft** - Крафт предмета
4. **GET /api/v1/economy/crafting/recipes/known** - Известные рецепты персонажа
5. **POST /api/v1/economy/crafting/recipes/learn** - Изучить рецепт

**Models:** CraftingRecipe, RecipeComponent, CraftingResult

---

**Источник:** `.BRAIN/02-gameplay/economy/economy-crafting-recipes.md`

