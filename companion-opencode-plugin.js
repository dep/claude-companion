// Mana plugin for opencode
// Install: copy or symlink to ~/.config/opencode/plugins/mana.js

export const ManaPlugin = async ({ $ }) => {
  const setState = (state) => $`echo ${state} > ~/.claude/companion-state`

  return {
    // Fired when the user sends a message — mark as working immediately
    "chat.message": async () => {
      await setState("working")
    },
    // Belt-and-suspenders: also mark working when a tool fires
    "tool.execute.before": async () => {
      await setState("working")
    },
    // Fired when opencode is waiting for permission approval
    "permission.ask": async () => {
      await setState("needsInput")
    },
    // Fired when the session goes idle (agent is done)
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await setState("success")
      }
    },
  }
}
