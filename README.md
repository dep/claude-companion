# claude-companion

You'll need to set these hooks up in `~/.claude/settings.json`:

```
"hooks": {
  "Notification": [
    {
      "matcher": "permission_prompt",
      "hooks": [
        {
          "type": "command",
          "command": "echo needsInput > ~/.claude/companion-state"
        }
      ]
    }
  ],
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "echo working > ~/.claude/companion-state"
        }
      ]
    }
  ],
  "PreToolUse": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "echo working > ~/.claude/companion-state"
        }
      ]
    }
  ],
  "Stop": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "echo success > ~/.claude/companion-state"
        }
      ]
    }
  ]
},
```
