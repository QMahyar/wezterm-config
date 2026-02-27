# wezterm-config

My personal [WezTerm](https://wezfurlong.org/wezterm/) configuration for Windows.

## Features

- **Campbell-Vivid** colour scheme (mirrors Windows Terminal)
- Integrated title bar with per-process icons (PowerShell, Node, Neovim, WSL distros, …)
- Real italic & bold font faces — no synthesized/slanted fakes
- Symbol fallback via **Symbols Nerd Font Mono** (glyphs never go missing)
- In-terminal font picker (`Ctrl+Shift+Alt+F`) — fuzzy-search any installed font
- Ligatures disabled by default
- Windows Terminal-style keybindings
- Right-click = copy-if-selected, paste-if-not
- Ctrl+scroll to resize font, Ctrl+Shift+R to reload config

## Requirements

### WezTerm

Download and install from <https://wezfurlong.org/wezterm/installation.html>

### Fonts

Install at least these two from <https://www.nerdfonts.com/font-downloads>:

| Font | Purpose |
|---|---|
| **CaskaydiaMono Nerd Font Mono** | Default font |
| **Symbols Nerd Font Mono** | Symbol/icon fallback (required) |

Optional (switchable via font picker):

- **JetBrainsMono Nerd Font Mono**
- Any other Nerd Font Mono variant you like

### PowerShell 7 (recommended)

<https://github.com/PowerShell/PowerShell/releases>

## Setup

```powershell
# 1. Clone into WezTerm's config directory
git clone https://github.com/qmahyar/wezterm-config "$env:USERPROFILE\.config\wezterm"

# 2. Launch WezTerm — it will pick up the config automatically
```

> **Note:** WezTerm looks for its config at `%USERPROFILE%\.config\wezterm\wezterm.lua` on Windows.
> If you already have a config there, back it up first.

## Font picker

Press `Ctrl+Shift+Alt+F` to open a fuzzy font picker listing all fonts installed on your system.
Your choice is saved to `font-override.lua` (gitignored) so it persists across restarts but stays local to each machine.

## Key bindings (highlights)

| Key | Action |
|---|---|
| `Alt+D` | New tab |
| `Alt+W` | Close pane |
| `Alt+F` | Search |
| `Alt+1`–`9` | Switch to tab N |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Ctrl+Alt+↑↓←→` | Split pane |
| `Alt+↑↓←→` | Navigate panes |
| `Ctrl+Shift+Enter` | Zoom pane |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Font size up / down / reset |
| `Ctrl+Shift+K` | Clear scrollback |
| `Ctrl+Shift+Alt+F` | Font picker |
| `F11` | Toggle fullscreen |
