from pathlib import Path
lines = Path('tasks/config/brain-mapping.yaml').read_text(encoding='utf-8').splitlines()
for i, line in enumerate(lines):
    if 'task_id:  API-TASK-193' in line:
        idx = i
        break
else:
    raise SystemExit('task not found')
replacement = [
    '  - source: .BRAIN/05-technical/backend/voice-lobby/voice-lobby-system.md',
    '    target: api/v1/social/voice/voice-lobbies.yaml',
    '    task_id: API-TASK-193',
    '    task_file: tasks/completed/2025-11-07-batch3/task-193-voice-lobby-system-api.md',
    '    status: completed',
    '    created: 2025-11-07 15:45',
    '    version: v1.0.0',
    '    updated: 2025-11-07 20:45',
    '    completed: 2025-11-07 20:45',
    '    related_sources:',
    '      - .BRAIN/05-technical/backend/voice-chat/voice-chat-system.md',
    '      - .BRAIN/05-technical/backend/party-system.md',
    '      - .BRAIN/05-technical/backend/guild-system-backend.md',
    '    related_targets:',
    '      - api/v1/social/voice/voice-chat.yaml',
    '      - api/v1/social/party-system.yaml'
]
lines[idx-2:idx+13] = replacement
Path('tasks/config/brain-mapping.yaml').write_text('\n'.join(lines) + '\n', encoding='utf-8')
