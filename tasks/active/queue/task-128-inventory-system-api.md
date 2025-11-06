# Task ID: API-TASK-128
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 10:10
**Создатель:** AI Agent (API Task Creator)
**Зависимости:** API-TASK-127

---

## 📋 Краткое описание

**MVP БЛОКЕР!** Создать API спецификацию для системы инвентаря. БЕЗ ЭТОГО ИГРА НЕ РАБОТАЕТ.

**Что нужно сделать:** Создать OpenAPI спецификацию для Inventory System на основе документации из .BRAIN.

---

## 🎯 Цель задания

Разработать полный REST API для системы инвентаря, включая управление предметами, экипировку, банковское хранилище и перемещение предметов.

**Зачем это нужно:**
- БЕЗ ЭТОГО ИГРА НЕ РАБОТАЕТ (MVP блокер)
- Управление предметами персонажа
- Система экипировки (weapons, armor, implants)
- Банковское хранилище (shared между персонажами)

---

## 📚 Источники информации

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/inventory-system.md`
**Версия документа:** v1.0.0
**API Readiness:** ready

**Ключевые концепции:**
- Inventory slots (50 slots per character)
- Item stacking (stackable items)
- Weight/encumbrance system
- Equipment slots (weapons, armor, implants, cyberware)
- Bank/Stash storage (100 slots, shared account-wide)
- Item transfer (trade, mail, auction)
- Item durability
- Bind-on-pickup/Bind-on-equip

---

## 📁 Целевая структура API

**Целевые файлы:**
```
api/v1/inventory/
├── inventory.yaml     ← Character inventory CRUD
├── equipment.yaml     ← Equip/unequip items
└── bank.yaml          ← Bank/stash storage
```

---

## ✅ Что нужно сделать (план)

### Файл 1: inventory.yaml

**Endpoints:**

1. **GET /api/v1/characters/{character_id}/inventory**
   - Получить инвентарь персонажа
   - Response: InventoryItem[] (id, item_id, quantity, slot, durability)

2. **POST /api/v1/characters/{character_id}/inventory/add**
   - Добавить предмет в инвентарь
   - Body: item_id, quantity
   - Auto-stack if possible

3. **DELETE /api/v1/characters/{character_id}/inventory/{item_instance_id}**
   - Удалить/выбросить предмет
   - Action: remove from inventory

4. **POST /api/v1/characters/{character_id}/inventory/{item_instance_id}/split**
   - Разделить стак предметов
   - Body: split_quantity

5. **POST /api/v1/characters/{character_id}/inventory/{item_instance_id}/use**
   - Использовать предмет (consumables)
   - Response: effects applied

6. **GET /api/v1/characters/{character_id}/inventory/capacity**
   - Информация о заполненности
   - Response: used_slots, max_slots, current_weight, max_weight

**Models:**
- InventoryItem (instance_id, item_id, quantity, slot_index, durability, bound_type, acquired_at)
- InventoryCapacity (used_slots, max_slots, current_weight, max_weight, encumbrance_level)
- ItemAddRequest (item_id, quantity, source)
- ItemSplitRequest (split_quantity)

### Файл 2: equipment.yaml

**Endpoints:**

1. **GET /api/v1/characters/{character_id}/equipment**
   - Получить экипировку персонажа
   - Response: EquipmentSlots (all equipped items)

2. **POST /api/v1/characters/{character_id}/equipment/equip**
   - Экипировать предмет
   - Body: item_instance_id, slot_type
   - Validation: class requirements, level requirements

3. **POST /api/v1/characters/{character_id}/equipment/unequip**
   - Снять предмет
   - Body: slot_type
   - Action: move to inventory

4. **POST /api/v1/characters/{character_id}/equipment/swap**
   - Поменять экипированные предметы местами
   - Body: slot_type_1, slot_type_2

**Models:**
- EquipmentSlots (weapon_main, weapon_off, armor_head, armor_chest, armor_legs, implant_neural, implant_ocular, cyberware_arms, cyberware_legs)
- EquippedItem (item_instance_id, item_id, slot_type, stats_bonus, durability)
- EquipRequest (item_instance_id, slot_type)

### Файл 3: bank.yaml

**Endpoints:**

1. **GET /api/v1/players/me/bank**
   - Получить содержимое банка
   - Response: BankItem[] (shared между персонажами)

2. **POST /api/v1/players/me/bank/deposit**
   - Положить предмет в банк
   - Body: character_id, item_instance_id, quantity

3. **POST /api/v1/players/me/bank/withdraw**
   - Забрать предмет из банка
   - Body: character_id (кому), bank_item_id, quantity

4. **GET /api/v1/players/me/bank/capacity**
   - Информация о банке
   - Response: used_slots, max_slots (100)

**Models:**
- BankItem (bank_item_id, item_id, quantity, deposited_by, deposited_at)
- BankCapacity (used_slots, max_slots, can_expand)
- BankDepositRequest (character_id, item_instance_id, quantity)
- BankWithdrawRequest (character_id, bank_item_id, quantity)

---

## 🔍 Критерии приемки

1. ✅ 3 файла созданы (inventory, equipment, bank)
2. ✅ Inventory slots: 50 per character
3. ✅ Bank slots: 100 shared account-wide
4. ✅ Item stacking работает автоматически
5. ✅ Weight/encumbrance system задокументирован
6. ✅ Equipment slots соответствуют игровой механике
7. ✅ Bind-on-pickup/equip механика описана
8. ✅ Item durability tracking
9. ✅ Validation: level requirements, class requirements
10. ✅ Error responses стандартизированы

---

## 📝 Дополнительная информация

### Equipment Slots

**Weapons:**
- weapon_main - основное оружие
- weapon_off - второе оружие/щит

**Armor:**
- armor_head - шлем
- armor_chest - нагрудник
- armor_legs - штаны
- armor_feet - обувь

**Implants:**
- implant_neural - нейроимплант
- implant_ocular - глазной имплант
- implant_cardio - сердечный имплант

**Cyberware:**
- cyberware_arms - руки
- cyberware_legs - ноги

### Item Binding

- **None** - можно торговать
- **Bind on Pickup** - привязывается при получении
- **Bind on Equip** - привязывается при экипировке
- **Account Bound** - можно передавать между своими персонажами

### Weight System

- Encumbrance levels: Normal → Heavy → Overencumbered
- Penalties: движение slower, stamina drain faster
- Max weight = STR * 10 kg

---

## 🔗 Связи

**Backend зависимости:**
- Character Management - character_id
- Item Database - item templates
- Loot System - источник предметов
- Trading System - перемещение предметов между игроками

**Frontend зависимости:**
- Inventory UI
- Equipment Screen
- Bank/Stash UI
- Item tooltips

---

**Источник:** `.BRAIN/05-technical/backend/inventory-system.md`

