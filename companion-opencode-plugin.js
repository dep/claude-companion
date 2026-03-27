// Mana plugin for opencode
// Install: copy or symlink to ~/.config/opencode/plugins/mana.js

export const ManaPlugin = async ({ $ }) => {
  const setState = (state) => $`echo ${state} > ~/.claude/companion-state`
  let doneTimer

  return {
    // Fired when the user sends a message — mark as working immediately
    "chat.message": async () => {
      clearTimeout(doneTimer)
      await setState("working")
    },
    // Belt-and-suspenders: also mark working when a tool fires
    "tool.execute.before": async () => {
      clearTimeout(doneTimer)
      await setState("working")
    },
    // Fired when opencode is waiting for permission approval
    "permission.ask": async () => {
      clearTimeout(doneTimer)
      await setState("needsInput")
    },
    // Debounce session.idle — it can fire between steps, not just at final completion
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        clearTimeout(doneTimer)
        doneTimer = setTimeout(() => setState("success"), 500)
      }
    },
  }
}
