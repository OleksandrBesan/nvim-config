# Neovim Configuration Refactoring Plan

- [x] **Refactor `lua/utils.lua`**: Move utility functions into separate modules under `lua/utils/`.
- [x] **Group Plugins**: Organize plugins into subdirectories by category in `lua/plugins/`.
- [x] **Refactor `init.lua`**: Relocate functions to more appropriate files.
- [x] **Review Environment Setup**: In `lua/env.lua`, check if `LUA_PATH` and other hardcoded paths are necessary and make them more portable if possible.
- [x] **Remove Unused Scripts**: Identify and delete any unused Lua scripts.
- [ ] **Centralize or Co-locate Keymaps**: Decide on a consistent strategy for placing keymap definitions.

---
*Let's tackle these one by one.*
