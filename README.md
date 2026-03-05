# claude-companion

You'll need to set these hooks up in `~/.claude/settings.json`:

```
{
  ...
  "hooks" : {
    "UserPromptSubmit" : [
      {
        "type" : "command",
        "command" : "echo working > ~/.claude/companion-state"
      }
    ],
    "PreToolUse" : [
      {
        "type" : "command",
        "command" : "echo working > ~/.claude/companion-state"
      }
    ],
    "PermissionRequest" : [
      {
        "type" : "command",
        "command" : "echo needsInput > ~/.claude/companion-state"
      }
    ],
    "Stop" : [
      {
        "type" : "command",
        "command" : "echo success > ~/.claude/companion-state"
      }
    ]
  }
}
```
