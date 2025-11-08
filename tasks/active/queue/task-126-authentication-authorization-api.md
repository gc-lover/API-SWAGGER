# Task ID: API-TASK-126
**Тип:** API Generation
**Приоритет:** критический
**Статус:** queued
**Создано:** 2025-11-07 10:00
**Создатель:** AI Agent (API Task Creator)
**Зависимости:** none

---

## 📋 Краткое описание

**MVP БЛОКЕР!** Создать API спецификацию для системы аутентификации и авторизации. БЕЗ ЭТОЙ СИСТЕМЫ ИГРА НЕ МОЖЕТ ЗАПУСТИТЬСЯ.

**Что нужно сделать:** Создать OpenAPI спецификацию для Authentication & Authorization System на основе документации из .BRAIN.

---

## 🎯 Цель задания

Разработать полный REST API для системы аутентификации и авторизации игроков, включая регистрацию, вход, управление токенами, OAuth интеграцию, 2FA и управление ролями.

**Зачем это нужно:**
- БЕЗ ЭТОГО ИГРА НЕ ЗАПУСТИТСЯ (MVP блокер)
- Обеспечивает безопасный доступ игроков к игре
- Управляет правами доступа (player, moderator, admin)
- Интегрируется с Session Management System

---

## 📚 Источники информации

### Основной источник концепции

**Репозиторий:** `.BRAIN`
**Путь к документу:** `.BRAIN/05-technical/backend/authentication-authorization-system.md`
**Версия документа:** v1.0.0
**Дата последнего обновления:** 2025-11-07 05:20
**Статус документа:** approved
**API Readiness:** ready

**Ключевые концепции из документа:**
- Регистрация аккаунтов (email/password + OAuth)
- Login/Logout flow с JWT tokens
- Access token (15 min) + Refresh token (7 days)
- Password recovery через email
- Two-Factor Authentication (TOTP)
- Roles & Permissions (PLAYER, MODERATOR, ADMIN, SUPER_ADMIN)
- Account linking (Steam, Google, Discord)
- Brute force protection
- Token blacklist для logout

### Database Schema (из источника)

**Таблицы:**
1. `accounts` - основные аккаунты
2. `account_roles` - роли и права
3. `password_reset_tokens` - токены восстановления пароля
4. `email_verification_tokens` - токены верификации email
5. `login_history` - история входов

### Связанные документы

- `.BRAIN/05-technical/backend/session-management-system.md` - создание сессий после login

---

## 📁 Целевая структура API

### Репозиторий: `API-SWAGGER`

**Целевой файл:** `api/v1/auth/authentication.yaml`
**API версия:** v1
**Тип файла:** OpenAPI 3.0 Specification (YAML)

**Структура директории:**
```
API-SWAGGER/
└── api/
    └── v1/
        └── auth/
            ├── authentication.yaml  ← Создать
            ├── authorization.yaml   ← Создать
            ├── oauth.yaml           ← Создать
            └── tokens.yaml          ← Создать
```

**Разбиение по файлам (не более 400 строк каждый):**
1. `authentication.yaml` - register, login, logout, password recovery
2. `authorization.yaml` - roles, permissions, check access
3. `oauth.yaml` - OAuth providers integration
4. `tokens.yaml` - refresh token, verify token, blacklist

---

## 🏗️ Целевая архитектура

### Backend (микросервис):

**Микросервис:** auth-service  
**Порт:** 8081  
**API пути:** /api/v1/auth/*

### OpenAPI (обязательно)

- Заполни `info.x-microservice` (name, port, domain, base-path, package) по данным целевого микросервиса.
- В секции `servers` оставь Production gateway `https://api.necp.game/v1` и пример локальной разработки `http://localhost:8080/api/v1`.
- WebSocket маршруты публикуй только через `wss://api.necp.game/v1/...`.

### Frontend (модуль):

**Модуль:** N/A (это базовая аутентификация, не игровой модуль)  
**Путь:** src/features/auth/  
**State Store:** useAuthStore (currentUser, tokens, loginStatus)

### Frontend (библиотеки):

**UI компоненты (@shared/ui):**
- Button, Input, Card, Checkbox

**Готовые формы (@shared/forms):**
- LoginForm, RegistrationForm, PasswordResetForm, TwoFactorForm

**Layouts (@shared/layouts):**
- AuthLayout (центрированная форма без game navigation)

**Хуки (@shared/hooks):**
- useDebounce (для валидации email)
- useLocalStorage (для remember me)

---

## ✅ Что нужно сделать (детальный план)

### Шаг 1: Создать authentication.yaml

**Endpoints:**

1. **POST /api/v1/auth/register**
   - Регистрация нового аккаунта
   - Body: email, password, username
   - Response: account_id, access_token, refresh_token
   - Errors: 400 (validation), 409 (email exists)

2. **POST /api/v1/auth/login**
   - Вход в аккаунт
   - Body: email, password, (optional) two_factor_code
   - Response: access_token, refresh_token, expires_in
   - Errors: 401 (invalid credentials), 423 (account locked)

3. **POST /api/v1/auth/logout**
   - Выход из аккаунта
   - Body: refresh_token
   - Action: добавить токен в blacklist
   - Response: 204 No Content

4. **POST /api/v1/auth/password/forgot**
   - Запрос восстановления пароля
   - Body: email
   - Action: отправить email с токеном
   - Response: 200 OK (всегда, безопасность)

5. **POST /api/v1/auth/password/reset**
   - Сброс пароля по токену
   - Body: reset_token, new_password
   - Response: 200 OK
   - Errors: 400 (invalid/expired token)

6. **POST /api/v1/auth/email/verify**
   - Верификация email адреса
   - Body: verification_token
   - Response: 200 OK

7. **POST /api/v1/auth/email/resend**
   - Повторная отправка verification email
   - Body: email
   - Response: 200 OK

**Models:**
- RegisterRequest (email, password, username)
- LoginRequest (email, password, two_factor_code?)
- LoginResponse (access_token, refresh_token, expires_in, token_type)
- PasswordForgotRequest (email)
- PasswordResetRequest (reset_token, new_password)
- EmailVerifyRequest (verification_token)

### Шаг 2: Создать authorization.yaml

**Endpoints:**

1. **GET /api/v1/auth/me**
   - Получить информацию о текущем пользователе
   - Headers: Authorization: Bearer <access_token>
   - Response: UserProfile (id, email, username, roles, permissions)

2. **POST /api/v1/auth/roles/assign**
   - Назначить роль пользователю (admin only)
   - Body: account_id, role, permissions[]
   - Response: 200 OK

3. **DELETE /api/v1/auth/roles/revoke**
   - Отозвать роль (admin only)
   - Body: account_id, role
   - Response: 204 No Content

4. **POST /api/v1/auth/permissions/check**
   - Проверить наличие разрешения
   - Body: account_id, permission
   - Response: {has_permission: true/false}

**Models:**
- UserProfile (id, email, username, display_name, roles[], permissions[], created_at)
- RoleAssignRequest (account_id, role, permissions[]?, granted_until?)
- RoleRevokeRequest (account_id, role)
- PermissionCheckRequest (account_id, permission)
- PermissionCheckResponse (has_permission)

### Шаг 3: Создать oauth.yaml

**Endpoints:**

1. **GET /api/v1/auth/oauth/{provider}/authorize**
   - Инициировать OAuth flow
   - Params: provider (google, steam, discord, twitch)
   - Response: redirect_url

2. **POST /api/v1/auth/oauth/{provider}/callback**
   - OAuth callback обработка
   - Body: code, state
   - Response: access_token, refresh_token (аналогично login)

3. **POST /api/v1/auth/oauth/link**
   - Привязать OAuth провайдера к существующему аккаунту
   - Body: provider, oauth_token
   - Response: 200 OK

4. **DELETE /api/v1/auth/oauth/unlink**
   - Отвязать OAuth провайдера
   - Body: provider
   - Response: 204 No Content

**Models:**
- OAuthAuthorizeResponse (redirect_url, state)
- OAuthCallbackRequest (code, state)
- OAuthLinkRequest (provider, oauth_token)

### Шаг 4: Создать tokens.yaml

**Endpoints:**

1. **POST /api/v1/auth/token/refresh**
   - Обновить access token используя refresh token
   - Body: refresh_token
   - Response: new access_token, new refresh_token
   - Errors: 401 (invalid/expired refresh token)

2. **POST /api/v1/auth/token/verify**
   - Проверить валидность токена
   - Body: token
   - Response: {valid: true/false, expires_at, account_id}

3. **POST /api/v1/auth/token/revoke**
   - Отозвать refresh token (добавить в blacklist)
   - Body: refresh_token
   - Response: 204 No Content

4. **POST /api/v1/auth/token/revoke-all**
   - Отозвать все refresh tokens пользователя
   - Response: 204 No Content (logout everywhere)

**Models:**
- TokenRefreshRequest (refresh_token)
- TokenRefreshResponse (access_token, refresh_token, expires_in)
- TokenVerifyRequest (token)
- TokenVerifyResponse (valid, expires_at, account_id, roles[])
- TokenRevokeRequest (refresh_token)

### Шаг 5: Создать общие компоненты

**Security Schemas (используй $ref из shared/common/security.yaml):**
- BearerAuth - JWT token в Authorization header

**Error Responses (используй $ref из shared/common/responses.yaml):**
- 400 Bad Request (VAL_INVALID_INPUT)
- 401 Unauthorized (AUTH_INVALID_CREDENTIALS, AUTH_TOKEN_EXPIRED)
- 403 Forbidden (AUTH_INSUFFICIENT_PERMISSIONS)
- 409 Conflict (BIZ_EMAIL_EXISTS, BIZ_USERNAME_EXISTS)
- 423 Locked (AUTH_ACCOUNT_LOCKED)
- 500 Internal Server Error (INT_DATABASE_ERROR)

---

## 🔍 Критерии приемки

**Обязательные проверки:**

1. ✅ Все 4 файла созданы (authentication, authorization, oauth, tokens)
2. ✅ Каждый файл не превышает 400 строк
3. ✅ Все endpoints документированы с примерами запросов/ответов
4. ✅ Используются общие компоненты из shared/common/ через $ref
5. ✅ Все models содержат validation rules (required, minLength, pattern)
6. ✅ Security schemas применены ко всем защищенным endpoints
7. ✅ Error responses стандартизированы (используют ErrorCode enum)
8. ✅ JWT tokens используют стандартный формат (access 15min, refresh 7days)
9. ✅ Rate limiting указан для критичных endpoints (login, register)
10. ✅ Есть примеры для всех endpoints (request + response)
11. ✅ Документация содержит описание OAuth flow
12. ✅ Указаны связи с Session Management System
13. ✅ Brute force protection документирован
14. ✅ 2FA flow задокументирован
15. ✅ OpenAPI спецификация валидна (можно проверить через Swagger Editor)

---

## 📝 Дополнительная информация

### JWT Token Structure

```json
{
  "sub": "account_id",
  "email": "user@example.com",
  "roles": ["PLAYER"],
  "permissions": [],
  "iat": 1699564800,
  "exp": 1699565700,
  "type": "access"
}
```

### Roles Hierarchy

- PLAYER - базовая роль (default)
- CONTENT_CREATOR - создание контента
- TESTER - тестирование фич
- MODERATOR - модерация чата, игроков
- ADMIN - управление сервером
- SUPER_ADMIN - полный доступ

### OAuth Providers

Поддерживаемые провайдеры:
- Google (`google`)
- Steam (`steam`)
- Discord (`discord`)
- Twitch (`twitch`)

### Rate Limiting

**Критичные endpoints:**
- `/auth/register` - 3 requests / 15min per IP
- `/auth/login` - 5 requests / 5min per IP
- `/auth/password/forgot` - 3 requests / 15min per IP

---

## ❓ FAQ

**Q: Что делать, если пользователь забыл пароль?**
A: Flow: POST /password/forgot → email с токеном → POST /password/reset с токеном и новым паролем

**Q: Как работает 2FA?**
A: После успешного login с 2FA пользователь должен ввести TOTP код. Login endpoint возвращает 400 с требованием 2FA кода.

**Q: Где хранятся refresh tokens?**
A: В Redis с TTL 7 дней. При logout токен добавляется в blacklist.

**Q: Можно ли иметь несколько OAuth провайдеров на одном аккаунте?**
A: Да, можно привязать несколько (один email + Google + Steam + Discord).

**Q: Что происходит при logout?**
A: Refresh token добавляется в blacklist (Redis), access token истекает через 15 минут.

**Q: Как проверяется JWT токен?**
A: API Gateway проверяет подпись, expiration, и что токен не в blacklist.

---

## 🔗 Связи

**Backend зависимости:**
- Session Management System - создание игровой сессии после login
- Database - PostgreSQL (accounts, roles, tokens)
- Redis - refresh tokens storage, blacklist, rate limiting
- Email Service - отправка verification и password reset emails

**Frontend зависимости:**
- Registration Page - форма регистрации
- Login Page - форма входа
- OAuth Flow - редиректы для OAuth провайдеров
- 2FA Page - ввод TOTP кода

---

**Источник:** `.BRAIN/05-technical/backend/authentication-authorization-system.md`

