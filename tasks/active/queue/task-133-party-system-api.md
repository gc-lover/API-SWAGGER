# Task ID: API-TASK-133
**Тип:** API Generation | **Приоритет:** высокий | **Статус:** queued
**Создано:** 2025-11-07 10:26 | **Создатель:** AI Agent | **Зависимости:** API-TASK-129

---

## 📋 Описание

Создать API для системы групп (party). Party creation, invites, loot settings, shared quest progress.

---

## 📚 Источник

**Документ:** `.BRAIN/05-technical/backend/party-system.md` (v1.0.0, ready)

**Ключевые механики:**
- Party creation/dissolution
- Invites (send/accept/decline)
- Party leader (смена лидера)
- Kick members
- Party composition tracking (roles)
- Loot settings (need/greed/personal/master looter)
- Shared quest progress
- Party chat integration
- Max size: 5 players

---

## 📁 Целевой файл

`api/v1/party/party-system.yaml`

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** social-service  
**Порт:** 8084  
**API пути:** /api/v1/party/*

### Frontend (модуль):

**Модуль:** social  
**Путь:** modules/social/party  
**State Store:** useSocialStore (party, partyMembers, partySettings)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Card, CharacterCard (для party members), HealthBar (HP party members), Button

**Готовые формы (@shared/forms):**
- PartyInviteForm, PartySettingsForm

**Layouts (@shared/layouts):**
- GameLayout (party UI в sidebar)

**Хуки (@shared/hooks):**
- useRealtime (для обновления party state)
- useCharacter (для отображения party members)

---

## ✅ Endpoints (план)

1. **POST /api/v1/party** - Создать party
2. **POST /api/v1/party/invite** - Пригласить игрока
3. **POST /api/v1/party/join** - Принять приглашение
4. **POST /api/v1/party/leave** - Покинуть party
5. **POST /api/v1/party/kick** - Выгнать участника (leader)
6. **POST /api/v1/party/leader/transfer** - Передать лидерство
7. **PATCH /api/v1/party/settings** - Обновить настройки (loot mode)
8. **GET /api/v1/party** - Информация о своей party

**Models:**
- Party, PartyMember, PartySettings, PartyInvite

---

## 🔍 Критерии

✅ Max 5 players ✅ Leader transfer ✅ Loot modes ✅ Shared quest progress ✅ Party chat link

---

**Источник:** `.BRAIN/05-technical/backend/party-system.md`

