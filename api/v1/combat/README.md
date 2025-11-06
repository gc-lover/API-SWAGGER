# Combat API
**Источник:** `.BRAIN/05-technical/ui-main-game.md` (v1.1.0)  
**Task ID:** API-TASK-032  
**Версия API:** v1.0.0

## Описание
API для текстовой боевой системы.

## Endpoints
- `POST /combat/initiate` - Начать бой
- `GET /combat/{combatId}` - Состояние боя
- `POST /combat/{combatId}/action` - Выполнить действие
- `GET /combat/{combatId}/available-actions` - Доступные действия
- `POST /combat/{combatId}/flee` - Сбежать
- `GET /combat/{combatId}/result` - Результат боя

