# Task ID: API-TASK-195
**Тип:** API Generation
**Приоритет:** высокий
**Статус:** queued
**Создано:** 2025-11-07 16:20
**Создатель:** GPT-5 Codex (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

Создать спецификацию Voice Chat API (каналы, подключение, проксимити, модерация).

**Что нужно сделать:** Описать OpenAPI для управления голосовыми каналами, выдачи WebRTC токенов, контроля качества и модерации, используя документ `voice-chat-system.md`.

---

## 🎯 Цель задания

Обеспечить полноценный REST API для серверной части голосового чата, покрывающий управление каналами разных типов (party, guild, proximity, raid), подключение игроков, контроль состояния и интеграцию с выбранным голосовым провайдером.

**Зачем это нужно:**
- Централизовать выдачу токенов и управление каналами для всех игровых режимов
- Обеспечить синхронизацию голосовых каналов с party/guild системами и voice lobby service
- Предоставить фронтенду инструменты модерации, качества звука и пространственного аудио

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/voice-chat/voice-chat-system.md`
**Версия документа:** v1.0.0
**Дата последнего обновления:** 2025-11-07
**Статус документа:** approved

**Что важно из этого документа:**
- Типы голосовых каналов (party, guild, proximity, raid) и параметры качества
- Схемы БД (`voice_channels`, `voice_participants`) и управление подключениями
- WebRTC интеграция, генерация токенов, ICE серверы
- Логика пространственного аудио и falloff, mute/deafen, модерация
- Перечень базовых API действий (`join`, `leave`, `mute`, `deafen`, `participants`)

### Дополнительные источники

- `.BRAIN/05-technical/backend/voice-lobby/voice-lobby-system.md` – взаимодействие с лобби
- `.BRAIN/05-technical/backend/party-system.md` – auto-join по party
- `.BRAIN/05-technical/backend/guild-system-backend.md` – права доступа по ролям
- `.BRAIN/05-technical/backend/matchmaking/matchmaking-algorithm.md` – рейтинговые ограничения (для raid каналов)
- `.BRAIN/05-technical/backend/chat/chat-channels.md` – единая модель каналов

### Связанные документы

- `.BRAIN/05-technical/backend/realtime-server/part1-architecture-zones.md`
- `.BRAIN/05-technical/backend/clan-war/clan-war-system.md`
- `.BRAIN/05-technical/backend/incident-response/incident-response.md` (голосовые инциденты)

---

## 📁 Целевая структура API

### Репозиторий: `API-SWAGGER`

**Целевой файл:** `api/v1/social/voice/voice-chat.yaml`
**API версия:** v1
**Тип файла:** OpenAPI 3.0 Specification (YAML)

**Структура директории:**
```
API-SWAGGER/
└── api/
    └── v1/
        └── social/
            └── voice/
                └── voice-chat.yaml  ← создать/заполнить этот файл
```

**Если файл уже существует:**
- Расширить его в рамках задания, соблюдая версионирование (`info.version` ≥ 1.0.0)

---

## 🏗️ Целевая архитектура (⚠️ ОБЯЗАТЕЛЬНО)

### Backend (микросервисная архитектура)

- **Целевой микросервис:** social-service
- **Порт:** 8084
- **API Base Path:** `/api/v1/social/voice`
- **Домен:** Голосовое общение, управление каналами, выдача токенов
- **Зависимости:**
  - auth-service (BearerAuth, проверка прав модерации)
  - party-service (auto-join для party каналов)
  - guild-service (ролевая модель доступа)
  - matchmaking-service (валидатор рейтингов при raid)
  - realtime-service (события о подключениях)
  - voice-provider-adapter (WebRTC токены, mute/unmute)

### Frontend (модульная архитектура)

- **Модуль:** `modules/social/voice`
- **State Store:** `useSocialStore`
- **State сегменты:** `voiceChannels`, `voiceSessions`, `proximityVoice`
- **UI компоненты:** `VoiceChannelPanel`, `VoiceParticipantList`, `VoiceControls`, `SpatialAudioVisualizer`
- **Формы:** `VoiceChannelSettingsForm`, `VoiceQualityForm`
- **Layouts:** `GameLayout`, `SocialHubLayout`
- **Хуки:** `useVoiceConnection`, `useRealtime`, `useDebounce`

### Комментарий для OpenAPI файла

В начало `voice-chat.yaml` добавить блок:

```yaml
# Target Architecture:
# - Microservice: social-service (port 8084)
# - API Base: /api/v1/social/voice
# - Dependencies: auth-service, party-service, guild-service, matchmaking-service, realtime-service, voice-provider-adapter
# - Frontend Module: modules/social/voice (useSocialStore.voiceChannels)
# - UI: VoiceChannelPanel, VoiceParticipantList, VoiceControls, SpatialAudioVisualizer
# - Forms: VoiceChannelSettingsForm, VoiceQualityForm
# - Layouts: GameLayout, SocialHubLayout
# - Hooks: useVoiceConnection, useRealtime, useDebounce
```

---

## ✅ Что нужно сделать (детальный план)

### Шаг 1: Декомпозиция функционала
- Зафиксировать типы каналов, настройки качества, схему БД
- Определить необходимые сущности (канал, участник, токен, настройки proximity)

### Шаг 2: Проектирование маршрутов
- Структурировать `paths` для управления каналами, подключением, статусами
- Учесть сценарии party/guild/raid, proximity и модерацию

### Шаг 3: Описание моделей данных
- Создать схемы: `VoiceChannel`, `VoiceChannelSummary`, `VoiceParticipant`, `JoinVoiceRequest`, `JoinVoiceResponse`, `VoiceMuteRequest`, `VoiceQualityConfig`, `ProximitySettings`, `VoiceEvent`
- Определить enum значений (channel_type, audio_quality, participant_status)

### Шаг 4: Наполнение спецификации
- Добавить `requestBody` и `responses` с примерами JSON
- Описать ошибки (`CHANNEL_FULL`, `INSUFFICIENT_PERMISSIONS`, `VOICE_PROVIDER_ERROR`)
- Указать ссылки на общие компоненты (`api/v1/shared/common/responses.yaml`, `security.yaml`)

### Шаг 5: Интеграции и события
- Описать взаимодействие с voice-provider (через `x-integration` или раздел Events)
- Добавить схемы событий (`voice.channel.joined`, `voice.channel.left`, `voice.channel.muted`, `voice.proximity.updated`)

### Шаг 6: Проверки качества
- Пройти чеклист `tasks/config/checklist.md`
- Подготовить FAQ и рекомендации по тестированию (WebRTC, мобильные клиенты)

---

## 🔀 Endpoints

### 1. POST `/api/v1/social/voice/channels`
- **Назначение:** Создать голосовой канал (party, guild, raid, custom)
- **Тело:** `CreateVoiceChannelRequest`
- **Ответ 201:** `VoiceChannel`
- **Ошибки:** `400`, `401`, `403`, `409`

### 2. GET `/api/v1/social/voice/channels`
- **Назначение:** Список каналов по владельцу/типу (фильтры: `ownerType`, `ownerId`, `channelType`, `isActive`)
- **Ответ 200:** `VoiceChannelList`
- **Ошибки:** `401`, `403`

### 3. GET `/api/v1/social/voice/channels/{channelId}`
- **Назначение:** Детали канала, настройки качества, статистика
- **Ответ 200:** `VoiceChannel`
- **Ошибки:** `401`, `403`, `404`

### 4. PATCH `/api/v1/social/voice/channels/{channelId}`
- **Назначение:** Обновить настройки (quality, max participants, permissions)
- **Тело:** `UpdateVoiceChannelRequest`
- **Ответ 200:** `VoiceChannel`
- **Ошибки:** `400`, `401`, `403`, `404`

### 5. DELETE `/api/v1/social/voice/channels/{channelId}`
- **Назначение:** Закрыть канал, отключить всех участников
- **Ответ 204:** пусто
- **Ошибки:** `401`, `403`, `404`

### 6. POST `/api/v1/social/voice/channels/{channelId}/join`
- **Назначение:** Подключить игрока, выдать WebRTC токен
- **Тело:** `JoinVoiceRequest`
- **Ответ 200:** `JoinVoiceResponse` (token, iceServers, участники)
- **Ошибки:** `400`, `401`, `403`, `404`, `409` (`CHANNEL_FULL`), `422` (уровень/рейтинг)

### 7. POST `/api/v1/social/voice/channels/{channelId}/leave`
- **Назначение:** Выйти из канала
- **Ответ 200:** `LeaveVoiceResponse`
- **Ошибки:** `401`, `403`, `404`

### 8. GET `/api/v1/social/voice/channels/{channelId}/participants`
- **Назначение:** Получить список активных участников, их статусы
- **Ответ 200:** `VoiceParticipantList`
- **Ошибки:** `401`, `403`, `404`

### 9. POST `/api/v1/social/voice/channels/{channelId}/participants/{playerId}/mute`
- **Назначение:** Самомут или модерационный mute
- **Тело:** `VoiceMuteRequest`
- **Ответ 200:** `VoiceParticipant`
- **Ошибки:** `401`, `403`, `404`, `409`

### 10. POST `/api/v1/social/voice/channels/{channelId}/participants/{playerId}/deafen`
- **Назначение:** Переключить деафен, обновить mute статус
- **Ответ 200:** `VoiceParticipant`
- **Ошибки:** `401`, `403`, `404`

### 11. POST `/api/v1/social/voice/channels/{channelId}/quality`
- **Назначение:** Изменить пресет качества (LOW/MEDIUM/HIGH/ULTRA), параметры WebRTC
- **Тело:** `VoiceQualityRequest`
- **Ответ 200:** `VoiceQualityConfig`
- **Ошибки:** `400`, `401`, `403`, `404`

### 12. POST `/api/v1/social/voice/proximity/update`
- **Назначение:** Обновить координаты игрока (сервер→клиент) для расчёта громкости
- **Тело:** `ProximityUpdateRequest`
- **Ответ 202:** `ProximityUpdateAccepted`
- **Ошибки:** `400`, `401`, `404`

### 13. GET `/api/v1/social/voice/metrics`
- **Назначение:** Получить метрики качества (latency, packetLoss, speakTime)
- **Параметры Query:** `channelId`, `ownerType`, `range`
- **Ответ 200:** `VoiceMetrics`
- **Ошибки:** `401`, `403`

### 14. POST `/api/v1/social/voice/channels/{channelId}/events`
- **Назначение:** Отправить событие от провайдера (webhook): mute, network issue
- **Тело:** `ProviderEvent`
- **Ответ 202:** `EventAck`
- **Ошибки:** `400`, `401`, `404`, `422`

---

## 🧱 Модели данных

- **VoiceChannel** – id, channelType (`PARTY|GUILD|PROXIMITY|RAID|CUSTOM`), owner, qualityPreset, maxParticipants, permissions, proximitySettings, status
- **VoiceChannelSummary** – компактная информация для списков
- **VoiceParticipant** – playerId, username, role, isSpeaking, isMuted, isDeafened, audioQuality, joinedAt, connectionId
- **CreateVoiceChannelRequest** – тип, ownerType/Id, initialSettings, proximityConfig
- **UpdateVoiceChannelRequest** – поля частичного обновления (qualityPreset, maxParticipants, allowedRoles)
- **JoinVoiceRequest** – playerId, preferredQuality, clientInfo (platform, device), location (для proximity)
- **JoinVoiceResponse** – token, expiresAt, iceServers, channel, participants snapshot
- **VoiceMuteRequest** – reason, durationSeconds, moderatorId (optional)
- **VoiceQualityRequest / VoiceQualityConfig** – sampleRate, bitrate, mode, profile, allowedPresets
- **ProximityUpdateRequest** – playerId, worldId, coordinates (x,y,z), velocity, timestamp
- **ProximityUpdateAccepted** – trackingId, nextUpdateHint
- **VoiceMetrics** – latencyAvg, packetLossAvg, activeSpeakers, totalSpeakTime, peakConcurrent
- **ProviderEvent** – eventType (`PLAYER_MUTED`, `NETWORK_DEGRADED`, `CHANNEL_CLOSED`), payload
- **EventAck** – acknowledgementId, processedAt

Все схемы должны описывать `required`, ограничения (`minimum`, `maximum`, `pattern`), а также содержать примеры.

---

## 🧭 Принципы и правила

- Соблюдать SOLID/DRY/KISS, переиспользовать общие компоненты из `api/v1/shared/common/`
- OpenAPI `openapi: 3.0.3`, `info.title: Voice Chat API`, `servers` для prod/stage
- Авторизация через `BearerAuth` (использовать общий security схему)
- Все ID в формате UUID, даты в ISO 8601
- Для ошибок использовать стандартные ответы (`BadRequest`, `Unauthorized`, `Forbidden`, `NotFound`, `Conflict`, `TooManyRequests`, `InternalServerError`)

---

## 🧪 Примеры

- Пример создания guild-канала с разрешёнными ролями и quality `MEDIUM`
- Пример join-ответа с ICE серверами и списком участников
- Пример mute-запроса от модератора с duration 15 минут
- Пример proximity update (distance falloff)
- Пример webhook события `NETWORK_DEGRADED`

Каждый пример оформить в `application/json`, значение полей валидировать.

---

## 🔗 Связности и зависимости

- Указать в описаниях, что party/guild системы автоматически создают каналы (ссылки на соответствующие API)
- Описать, что Voice Lobby Service использует этот API для фактического подключения после матчмейкинга
- Отметить интеграцию с voice provider (Agora/Twilio) и webhook маршруты (`/events`)
- Предусмотреть синхронизацию с realtime-service для UI обновлений (через события)

---

## ✅ Критерии приемки

1. Создан файл `api/v1/social/voice/voice-chat.yaml` (или обновлён) в OpenAPI 3.0.3
2. Архитектурный комментарий добавлен в начале файла
3. Все 14 описанных endpoints присутствуют с методами, параметрами, описаниями и примерами
4. Определены все перечисленные модели данных в `components/schemas`
5. Используются общие ответы и схема безопасности из `api/v1/shared/common/`
6. Прописаны enum/валидации для каналов, ролей, качества звука
7. Задокументированы события и интеграция с провайдером/token сервисом
8. Добавлены примеры JSON для ключевых запросов/ответов и вебхуков
9. Указаны зависимости от party/guild/voice-lobby систем в описаниях
10. Спецификация проходит линтер (spectral/openapi) без ошибок
11. В задании присутствуют FAQ и рекомендации по тестированию

---

## ❓ FAQ

- **Как управлять proximity на сервере?** – Использовать `proximity/update` для обновления координат и рассчёта громкости, события рассылаются через realtime-service.
- **Что делать при переполнении канала?** – Возвращать `409 Conflict` с кодом `CHANNEL_FULL` и ссылкой на voice lobby для создания sub-channel.
- **Как выдаются WebRTC токены?** – Через voice-provider-adapter, указать required поля (`channelKey`, `uid`, `role`).
- **Нужен ли ULTRA пресет всем?** – Нет, требуется проверка привилегий (например, премиум аккаунты или турниры).
- **Можно ли кикнуть игрока из голосового канала?** – Использовать mute/deafen и при необходимости интеграцию с voice lobby для перекидывания.
- **Как логируются голосовые инциденты?** – Через webhook events и интеграцию с incident-response API.

---

## 🕓 История выполнения

- 2025-11-07 16:20 — Задание создано (GPT-5 Codex)

---

**Примечание:** Перед handoff пройти чеклист `tasks/config/checklist.md`.

