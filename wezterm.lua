-- WezTerm Configuration
-- Mirrors Windows Terminal look & feel
-- Replicated from portable config (E:\WezTerm\wezterm.lua) for normal installation

local wezterm = require 'wezterm'
local act     = wezterm.action
local config  = wezterm.config_builder()

-- ─────────────────────────────────────────────────────────────────────────────
-- FONT
-- ─────────────────────────────────────────────────────────────────────────────
local ligature_off = { 'calt=0', 'clig=0', 'liga=0' }

-- Symbol-only fallback used when the primary font lacks a glyph.
local SYMBOL_FALLBACK = { family = 'Symbols Nerd Font Mono', weight = 'Regular' }

-- Build font + font_rules for a given family, using real italic/bold faces
-- instead of synthesized ones, with Symbols Nerd Font Mono as a fallback.
local function make_font_config(family)
  local normal = wezterm.font_with_fallback {
    { family = family, weight = 'Regular', italic = false, harfbuzz_features = ligature_off },
    SYMBOL_FALLBACK,
  }
  local bold = wezterm.font_with_fallback {
    { family = family, weight = 'Bold', italic = false, harfbuzz_features = ligature_off },
    SYMBOL_FALLBACK,
  }
  local italic = wezterm.font_with_fallback {
    { family = family, weight = 'Regular', italic = true, harfbuzz_features = ligature_off },
    SYMBOL_FALLBACK,
  }
  local bold_italic = wezterm.font_with_fallback {
    { family = family, weight = 'Bold', italic = true, harfbuzz_features = ligature_off },
    SYMBOL_FALLBACK,
  }
  local rules = {
    { intensity = 'Normal', italic = true,  font = italic      },
    { intensity = 'Bold',   italic = false, font = bold        },
    { intensity = 'Bold',   italic = true,  font = bold_italic },
    { intensity = 'Half',   italic = false, font = normal      },
    { intensity = 'Half',   italic = true,  font = italic      },
  }
  return normal, rules
end

local default_font_family = 'CaskaydiaMono Nerd Font Mono'
local default_font, default_font_rules = make_font_config(default_font_family)
config.font       = default_font
config.font_rules = default_font_rules
config.font_size   = 10.0
config.line_height = 1.2

-- ─────────────────────────────────────────────────────────────────────────────
-- COLOR SCHEME  (Campbell-Vivid)
-- ─────────────────────────────────────────────────────────────────────────────
config.colors = {
  foreground    = '#E8E8E8',
  background    = '#0C0C0C',
  cursor_bg     = '#FFFFFF',
  cursor_border = '#FFFFFF',
  cursor_fg     = '#0C0C0C',
  selection_bg  = '#264F78',
  selection_fg  = '#FFFFFF',

  ansi = {
    '#1A1A1A', -- black
    '#D9242E', -- red
    '#1BC411', -- green
    '#D4A800', -- yellow
    '#1058E8', -- blue
    '#9B1FAD', -- magenta
    '#2FA8EE', -- cyan
    '#E0E0E0', -- white
  },
  brights = {
    '#8A8A8A', -- bright black
    '#FF5561', -- bright red
    '#23F00F', -- bright green
    '#FFEE58', -- bright yellow
    '#4D8FFF', -- bright blue
    '#E040D0', -- bright magenta
    '#79EAEA', -- bright cyan
    '#FFFFFF', -- bright white
  },

  scrollbar_thumb = '#9B1FAD',

  tab_bar = {
    -- Tab bar strip: clearly brighter than terminal bg (#0C0C0C)
    background        = '#252525',
    inactive_tab_edge = '#3a3a3a',
    -- Active tab: brightest, pops above bar
    active_tab = {
      bg_color  = '#3a3a3a',
      fg_color  = '#FFFFFF',
      intensity = 'Bold',
      underline = 'None',
      italic    = false,
    },
    -- Inactive tab: sits between bar and active
    inactive_tab = {
      bg_color = '#1e1e1e',
      fg_color = '#888888',
      underline = 'None',
      italic    = false,
    },
    -- Hovered inactive: step up toward active
    inactive_tab_hover = {
      bg_color = '#2e2e2e',
      fg_color = '#DDDDDD',
      italic    = false,
    },
    new_tab = {
      bg_color = '#252525',
      fg_color = '#555555',
    },
    new_tab_hover = {
      bg_color = '#2e2e2e',
      fg_color = '#FFFFFF',
    },
  },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- WINDOW FRAME
-- ─────────────────────────────────────────────────────────────────────────────
config.window_frame = {
  font      = wezterm.font { family = 'CaskaydiaMono Nerd Font Mono', weight = 'Regular' },
  font_size = 10.0,
  active_titlebar_bg              = '#252525',
  inactive_titlebar_bg            = '#1a1a1a',
  active_titlebar_fg              = '#CCCCCC',
  inactive_titlebar_fg            = '#666666',
  active_titlebar_border_bottom   = '#3a3a3a',
  inactive_titlebar_border_bottom = '#252525',
  button_fg                       = '#CCCCCC',
  button_bg                       = '#252525',
  button_hover_fg                 = '#FFFFFF',
  button_hover_bg                 = '#3a3a3a',
}

-- ─────────────────────────────────────────────────────────────────────────────
-- WINDOW / TAB CHROME
-- ─────────────────────────────────────────────────────────────────────────────
config.window_decorations           = 'INTEGRATED_BUTTONS | RESIZE'
config.use_fancy_tab_bar            = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom            = false
config.show_tab_index_in_tab_bar    = false
config.tab_max_width                = 32

-- ─────────────────────────────────────────────────────────────────────────────
-- TAB TITLES
-- ─────────────────────────────────────────────────────────────────────────────
local PROCESS_ICONS = {
  ['pwsh']        = { icon = wezterm.nerdfonts.md_powershell,    label = 'PowerShell'         },
  ['powershell']  = { icon = wezterm.nerdfonts.md_powershell,    label = 'Windows PowerShell' },
  ['cmd']         = { icon = wezterm.nerdfonts.md_console_line,  label = 'Command Prompt'     },
  ['wsl']         = { icon = wezterm.nerdfonts.dev_linux,        label = 'WSL'                },
  ['wslhost']     = { icon = wezterm.nerdfonts.dev_linux,        label = 'WSL'                },
  ['nvim']        = { icon = wezterm.nerdfonts.dev_vim,          label = 'Neovim'             },
  ['vim']         = { icon = wezterm.nerdfonts.dev_vim,          label = 'Vim'                },
  ['python']      = { icon = wezterm.nerdfonts.dev_python,       label = 'Python'             },
  ['python3']     = { icon = wezterm.nerdfonts.dev_python,       label = 'Python'             },
  ['node']        = { icon = wezterm.nerdfonts.dev_nodejs_small, label = 'Node.js'            },
  ['git']         = { icon = wezterm.nerdfonts.dev_git,          label = 'Git'                },
  ['ssh']         = { icon = wezterm.nerdfonts.md_ssh,           label = 'SSH'                },
}

local WSL_DISTRO_ICONS = {
  ubuntu   = { icon = wezterm.nerdfonts.dev_ubuntu, label = 'Ubuntu'     },
  debian   = { icon = wezterm.nerdfonts.dev_debian, label = 'Debian'     },
  arch     = { icon = wezterm.nerdfonts.dev_linux,  label = 'Arch Linux' },
  kali     = { icon = wezterm.nerdfonts.dev_linux,  label = 'Kali Linux' },
  fedora   = { icon = wezterm.nerdfonts.dev_linux,  label = 'Fedora'     },
  opensuse = { icon = wezterm.nerdfonts.dev_linux,  label = 'openSUSE'   },
  alpine   = { icon = wezterm.nerdfonts.dev_linux,  label = 'Alpine'     },
  docker   = { icon = wezterm.nerdfonts.dev_docker, label = 'Docker'     },
}

local function wsl_distro_info(domain)
  if not domain then return nil end
  local distro = domain:match('^WSL:(.+)$')
  if not distro then return nil end
  local key = distro:lower()
  for pattern, info in pairs(WSL_DISTRO_ICONS) do
    if key:find(pattern, 1, true) then
      return info, distro
    end
  end
  return { icon = wezterm.nerdfonts.dev_linux, label = distro }, distro
end

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local pane      = tab.active_pane
  local domain    = pane.domain_name or ''
  local proc_path = pane.foreground_process_name or ''
  local base      = (proc_path:match('([^/\\]+)$') or proc_path):lower():gsub('%.exe$', '')

  local icon, title

  local wsl_info, distro_name = wsl_distro_info(domain)
  if wsl_info then
    icon  = wsl_info.icon
    title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or wsl_info.label
  elseif base == 'wsl' or base == 'wslhost' then
    icon  = wezterm.nerdfonts.dev_linux
    title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or 'WSL'
  elseif base == 'bash' and domain == 'local' then
    icon  = wezterm.nerdfonts.dev_git_branch
    title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or 'Git Bash'
  elseif PROCESS_ICONS[base] then
    local info = PROCESS_ICONS[base]
    icon  = info.icon
    title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or info.label
  else
    icon  = ''
    title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title
            or pane.title
            or base
  end

  title = wezterm.truncate_right(title, max_width - 4)
  local icon_str = icon ~= '' and (icon .. ' ') or ''
  local index    = tostring(tab.tab_index + 1) .. ': '
  local intensity = (tab.is_active or hover) and 'Normal' or 'Half'

  return {
    { Attribute = { Intensity = intensity } },
    { Text = ' ' .. index .. icon_str .. title .. ' ' },
  }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- SCROLLBAR
-- ─────────────────────────────────────────────────────────────────────────────
config.enable_scroll_bar = true
config.window_padding = {
  left   = 8,
  right  = 4,
  top    = 4,
  bottom = 0,
}

-- ─────────────────────────────────────────────────────────────────────────────
-- SCROLLBACK
-- ─────────────────────────────────────────────────────────────────────────────
config.scrollback_lines = 10000

-- ─────────────────────────────────────────────────────────────────────────────
-- RENDERING
-- ─────────────────────────────────────────────────────────────────────────────
config.front_end = 'WebGpu'

-- ─────────────────────────────────────────────────────────────────────────────
-- INITIAL WINDOW SIZE  (120 x 30)
-- ─────────────────────────────────────────────────────────────────────────────
config.initial_cols = 120
config.initial_rows = 30

-- ─────────────────────────────────────────────────────────────────────────────
-- GENERAL BEHAVIOUR
-- ─────────────────────────────────────────────────────────────────────────────
config.default_cwd = wezterm.home_dir

config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.selection_word_boundary = ' \t\n/\\"\':-.,:;<>~!@#$%^&*|+=[]{}~?·'

config.pane_focus_follows_mouse = false

config.window_close_confirmation = 'AlwaysPrompt'
config.skip_close_confirmation_for_processes_named = {
  'pwsh.exe',
  'powershell.exe',
  'cmd.exe',
  'bash',
  'sh',
  'zsh',
  'fish',
  'nu',
  'tmux',
  'screen',
  'wezterm-mux-server',
  'wezterm-mux-server.exe',
}

config.adjust_window_size_when_changing_font_size = false
config.audible_bell    = 'Disabled'
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate    = 500

-- ─────────────────────────────────────────────────────────────────────────────
-- DEFAULT SHELL  (PowerShell 7, fallback to PowerShell 5)
-- ─────────────────────────────────────────────────────────────────────────────
local function find_pwsh()
  local ok, stdout, _ = wezterm.run_child_process { 'where.exe', 'pwsh.exe' }
  if ok and stdout and #stdout > 0 then
    local path = stdout:match('([^\r\n]+)')
    if path and #path > 0 then return path end
  end

  local pf  = os.getenv('ProgramFiles')  or 'C:\\Program Files'
  local pfw = os.getenv('PROGRAMW6432')  or pf
  local candidates = {
    pf  .. '\\PowerShell\\7\\pwsh.exe',
    pfw .. '\\PowerShell\\7\\pwsh.exe',
    pf  .. '\\PowerShell\\7-preview\\pwsh.exe',
    pf  .. '\\PowerShell\\pwsh.exe',
    (os.getenv('USERPROFILE')  or '') .. '\\scoop\\apps\\pwsh\\current\\pwsh.exe',
    (os.getenv('LOCALAPPDATA') or '') .. '\\Microsoft\\PowerShell\\7\\pwsh.exe',
  }
  for _, path in ipairs(candidates) do
    local f = io.open(path)
    if f then f:close(); return path end
  end
  return nil
end

local pwsh_exe = find_pwsh()
local is_pwsh7 = pwsh_exe ~= nil

if is_pwsh7 then
  config.default_prog = { pwsh_exe, '-NoLogo', '-ExecutionPolicy', 'Bypass' }
else
  config.default_prog = { 'powershell.exe', '-NoLogo', '-ExecutionPolicy', 'Bypass' }
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LAUNCH MENU
-- ─────────────────────────────────────────────────────────────────────────────
local launch_menu = {}

if is_pwsh7 then
  table.insert(launch_menu, {
    label = 'PowerShell 7',
    args  = { pwsh_exe, '-NoLogo', '-ExecutionPolicy', 'Bypass' },
    cwd   = wezterm.home_dir,
  })
end

table.insert(launch_menu, {
  label = 'Windows PowerShell 5',
  args  = { 'powershell.exe', '-NoLogo', '-ExecutionPolicy', 'Bypass' },
  cwd   = wezterm.home_dir,
})

table.insert(launch_menu, { label = 'Command Prompt', args = { 'cmd.exe' }, cwd = wezterm.home_dir })

local git_bash_paths = {
  (os.getenv('ProgramFiles')      or '') .. '\\Git\\bin\\bash.exe',
  (os.getenv('ProgramFiles(x86)') or '') .. '\\Git\\bin\\bash.exe',
  (os.getenv('LOCALAPPDATA')      or '') .. '\\Programs\\Git\\bin\\bash.exe',
}
for _, path in ipairs(git_bash_paths) do
  local f = io.open(path)
  if f then
    f:close()
    table.insert(launch_menu, { label = 'Git Bash', args = { path, '--login', '-i' }, cwd = wezterm.home_dir })
    break
  end
end

local wsl_ok, wsl_out = wezterm.run_child_process { 'wsl.exe', '--list', '--quiet' }
if wsl_ok and wsl_out then
  for distro in wsl_out:gmatch('[^\r\n]+') do
    distro = distro:gsub('%z', ''):gsub('^%s+', ''):gsub('%s+$', '')
    if #distro > 0 then
      table.insert(launch_menu, {
        label = distro,
        args  = { 'wsl.exe', '-d', distro },
        cwd   = wezterm.home_dir,
      })
    end
  end
end

config.launch_menu = launch_menu

-- ─────────────────────────────────────────────────────────────────────────────
-- FONT PICKER  (Ctrl+Shift+Alt+F)
-- ─────────────────────────────────────────────────────────────────────────────
local DEFAULT_FONT  = 'CaskaydiaMono Nerd Font Mono'
local DEFAULT_LABEL = '★ CaskaydiaMono Nerd Font Mono (default)'

local font_override_path = wezterm.config_dir .. '\\font-override.lua'
local ok_fo, saved_font = pcall(dofile, font_override_path)
if ok_fo and saved_font and saved_font ~= DEFAULT_FONT then
  local f, rules = make_font_config(saved_font)
  config.font       = f
  config.font_rules = rules
end

local function get_system_fonts()
  local ok, stdout = wezterm.run_child_process {
    wezterm.executable_dir .. '\\wezterm.exe',
    'ls-fonts', '--list-system',
  }
  local families = {}
  local seen     = { [DEFAULT_FONT:lower()] = true }
  if ok and stdout then
    for family in stdout:gmatch('wezterm%.font%("([^"]+)"') do
      local key = family:lower()
      if not seen[key] then
        seen[key] = true
        table.insert(families, family)
      end
    end
  end
  table.sort(families, function(a, b)
    return a:lower() < b:lower()
  end)
  return families
end

wezterm.on('pick-font', function(window, pane)
  local families = get_system_fonts()
  local choices = {
    { id = DEFAULT_FONT, label = DEFAULT_LABEL },
  }
  for _, family in ipairs(families) do
    table.insert(choices, { id = family, label = family })
  end

  window:perform_action(
    act.InputSelector {
      title       = 'Choose Font',
      description = 'Select a font - Enter to apply, Esc to cancel, / to filter',
      fuzzy       = true,
      choices     = choices,
      action      = wezterm.action_callback(function(win, _, id, _label)
        if not id then return end

        local f = io.open(font_override_path, 'w')
        if f then
          f:write('-- Auto-generated by font picker. Delete to reset to default.\n')
          if id == DEFAULT_FONT then
            f:write('return nil\n')
          else
            f:write('return ' .. string.format('%q', id) .. '\n')
          end
          f:close()
        end

        local overrides = win:get_config_overrides() or {}
        if id == DEFAULT_FONT then
          overrides.font       = nil
          overrides.font_rules = nil
        else
          local f, rules       = make_font_config(id)
          overrides.font       = f
          overrides.font_rules = rules
        end
        win:set_config_overrides(overrides)
        win:perform_action(act.ReloadConfiguration, pane)
      end),
    },
    pane
  )
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- BACKGROUND IMAGE  (Ctrl+Shift+Alt+B)
-- ─────────────────────────────────────────────────────────────────────────────
-- State is persisted to bg-override.lua (gitignored).
-- Format: { enabled=bool, mode='file'|'folder', path=string, index=number }

local bg_override_path = wezterm.config_dir .. '\\bg-override.lua'

local function bg_load()
  local ok, data = pcall(dofile, bg_override_path)
  if ok and type(data) == 'table' then return data end
  return { enabled = false, mode = 'file', path = '', index = 1, interval_minutes = 0 }
end

local function bg_save(data)
  local f = io.open(bg_override_path, 'w')
  if not f then return end
  f:write('-- Auto-generated by background picker. Delete to reset.\n')
  f:write('return {\n')
  f:write(string.format('  enabled          = %s,\n', tostring(data.enabled)))
  f:write(string.format('  mode             = %q,\n', data.mode or 'file'))
  f:write(string.format('  path             = %q,\n', data.path or ''))
  f:write(string.format('  index            = %d,\n', data.index or 1))
  f:write(string.format('  interval_minutes = %d,\n', data.interval_minutes or 0))
  f:write('}\n')
  f:close()
end

-- Build the background layer table for a given image path.
local function bg_make_layer(path)
  return {
    -- Layer 1: solid dark base — blocks Windows desktop from showing through
    {
      source = { Color = '#0C0C0C' },
      width  = '100%',
      height = '100%',
      opacity = 1.0,
    },
    -- Layer 2: the wallpaper
    {
      source           = { File = path },
      width            = '100%',
      height           = '100%',
      repeat_x         = 'NoRepeat',
      repeat_y         = 'NoRepeat',
      vertical_align   = 'Middle',
      horizontal_align = 'Center',
      opacity          = 0.45,
      hsb              = { brightness = 0.7, saturation = 0.9, hue = 1.0 },
    },
    -- Layer 3: dark overlay to dim the image and improve text readability
    {
      source  = { Color = '#0C0C0C' },
      width   = '100%',
      height  = '100%',
      opacity = 0.55,  -- higher = darker overlay
    },
  }
end

-- Collect image files from a folder.
local function bg_folder_images(folder)
  local files = {}
  for _, ext in ipairs({ 'png','jpg','jpeg','bmp','gif','tiff','tga' }) do
    for _, f in ipairs(wezterm.glob(folder .. '\\*.' .. ext)) do
      table.insert(files, f)
    end
    for _, f in ipairs(wezterm.glob(folder .. '\\*.' .. ext:upper())) do
      table.insert(files, f)
    end
  end
  -- deduplicate
  local seen, out = {}, {}
  for _, f in ipairs(files) do
    local k = f:lower()
    if not seen[k] then seen[k] = true; table.insert(out, f) end
  end
  table.sort(out)
  return out
end

-- Apply or clear background on a window based on persisted state.
local function bg_apply(window, data)
  local overrides = window:get_config_overrides() or {}
  if not data.enabled or data.path == '' then
    overrides.background = nil
    window:set_config_overrides(overrides)
    return
  end
  local image_path = data.path
  if data.mode == 'folder' then
    local images = bg_folder_images(data.path)
    if #images == 0 then
      overrides.background = nil
      window:set_config_overrides(overrides)
      return
    end
    -- clamp index
    local idx = ((data.index - 1) % #images) + 1
    data.index = idx
    image_path = images[idx]
  end
  overrides.background = bg_make_layer(image_path)
  window:set_config_overrides(overrides)
end

-- Auto-advance timer: schedules itself recursively while interval > 0 and folder mode.
local function bg_schedule_timer()
  local data = bg_load()
  local mins = data.interval_minutes or 0
  if mins <= 0 or not data.enabled or data.mode ~= 'folder' or data.path == '' then
    return -- nothing to schedule
  end
  wezterm.time.call_after(mins * 60, function()
    local d = bg_load()
    -- only advance if still enabled, folder mode, same folder, same interval
    if d.enabled and d.mode == 'folder' and d.path ~= '' and (d.interval_minutes or 0) > 0 then
      d.index = (d.index or 1) + 1
      bg_save(d)
      -- apply to all windows
      for _, win in ipairs(wezterm.gui.windows()) do
        bg_apply(win, bg_load())
      end
      bg_schedule_timer() -- reschedule
    end
  end)
end

-- Apply saved background on every config reload (including startup).
wezterm.on('window-config-reloaded', function(window, pane)
  local data = bg_load()
  bg_apply(window, data)
  bg_schedule_timer()
end)

-- ── Background menu event ────────────────────────────────────────────────────
wezterm.on('pick-background', function(window, pane)
  local data = bg_load()
  local status = data.enabled and '✔ ON' or '✘ OFF'
  local mode_label = data.mode == 'folder'
    and ('Folder: ' .. (data.path ~= '' and data.path or '(none)'))
    or  ('File: '   .. (data.path ~= '' and data.path or '(none)'))

  window:perform_action(
    act.InputSelector {
      title       = 'Background Image',
      description = 'Select an option — Enter to confirm, Esc to cancel',
      fuzzy       = false,
      choices     = {
        { id = 'toggle',   label = '1  Toggle background — currently ' .. status                                              },
        { id = 'file',     label = '2  Choose a single image file'                                                            },
        { id = 'folder',   label = '3  Choose a folder  (' .. mode_label .. ')'                                               },
        { id = 'next',     label = '4  Next image  (folder mode only)  — Ctrl+Shift+?'                                        },
        { id = 'prev',     label = '5  Previous image  (folder mode only)  — Ctrl+Shift+<'                                    },
        { id = 'interval', label = '6  Auto-change interval  (folder mode) — currently ' .. (data.interval_minutes or 0) .. ' min  (0 = off)' },
      },
      action = wezterm.action_callback(function(win, pn, id, _label)
        if not id then return end

        if id == 'toggle' then
          data.enabled = not data.enabled
          bg_save(data)
          bg_apply(win, data)

        elseif id == 'file' then
          -- Use PowerShell OpenFileDialog to pick an image
          local ok, out = wezterm.run_child_process {
            'powershell.exe', '-NoProfile', '-Command',
            [[Add-Type -AssemblyName System.Windows.Forms;]] ..
            [[$d = New-Object System.Windows.Forms.OpenFileDialog;]] ..
            [[$d.Title = 'Choose background image';]] ..
            [[$d.Filter = 'Images|*.png;*.jpg;*.jpeg;*.bmp;*.gif;*.tiff;*.tga';]] ..
            [[$d.Multiselect = $false;]] ..
            [[if ($d.ShowDialog() -eq 'OK') { $d.FileName }]],
          }
          if ok and out and #out:gsub('%s','') > 0 then
            local path = out:match('([^\r\n]+)')
            if path and #path > 0 then
              data.mode    = 'file'
              data.path    = path
              data.enabled = true
              bg_save(data)
              bg_apply(win, data)
            end
          end

        elseif id == 'folder' then
          -- Use PowerShell FolderBrowserDialog to pick a folder
          local ok, out = wezterm.run_child_process {
            'powershell.exe', '-NoProfile', '-Command',
            [[Add-Type -AssemblyName System.Windows.Forms;]] ..
            [[$d = New-Object System.Windows.Forms.FolderBrowserDialog;]] ..
            [[$d.Description = 'Choose folder with background images';]] ..
            [[if ($d.ShowDialog() -eq 'OK') { $d.SelectedPath }]],
          }
          if ok and out and #out:gsub('%s','') > 0 then
            local path = out:match('([^\r\n]+)')
            if path and #path > 0 then
              data.mode    = 'folder'
              data.path    = path
              data.index   = 1
              data.enabled = true
              bg_save(data)
              bg_apply(win, data)
            end
          end

        elseif id == 'next' then
          if data.mode == 'folder' and data.path ~= '' then
            data.index = (data.index or 1) + 1
            data.enabled = true
            bg_save(data)
            bg_apply(win, data)
          end

        elseif id == 'prev' then
          if data.mode == 'folder' and data.path ~= '' then
            data.index = math.max(1, (data.index or 1) - 1)
            data.enabled = true
            bg_save(data)
            bg_apply(win, data)
          end

        elseif id == 'interval' then
          -- Show a list of preset intervals to pick from
          win:perform_action(
            act.InputSelector {
              title       = 'Auto-change Interval',
              description = 'How often to switch background (folder mode). 0 = disabled.',
              fuzzy       = false,
              choices     = {
                { id = '0',   label = '0   — Disabled (manual only)' },
                { id = '1',   label = '1   minute'                   },
                { id = '2',   label = '2   minutes'                  },
                { id = '5',   label = '5   minutes'                  },
                { id = '10',  label = '10  minutes'                  },
                { id = '15',  label = '15  minutes'                  },
                { id = '30',  label = '30  minutes'                  },
                { id = '60',  label = '60  minutes (1 hour)'         },
              },
              action = wezterm.action_callback(function(iwin, ipane, iid, _)
                if not iid then return end
                local mins = tonumber(iid) or 0
                local d = bg_load()
                d.interval_minutes = mins
                bg_save(d)
                bg_schedule_timer()
              end),
            },
            pn
          )
        end
      end),
    },
    pane
  )
end)

-- ── Quick background action events ──────────────────────────────────────────
wezterm.on('bg-next', function(window, pane)
  local data = bg_load()
  if data.mode == 'folder' and data.path ~= '' then
    data.index   = (data.index or 1) + 1
    data.enabled = true
    bg_save(data)
    bg_apply(window, data)
  end
end)

wezterm.on('bg-prev', function(window, pane)
  local data = bg_load()
  if data.mode == 'folder' and data.path ~= '' then
    data.index   = math.max(1, (data.index or 1) - 1)
    data.enabled = true
    bg_save(data)
    bg_apply(window, data)
  end
end)

wezterm.on('bg-toggle', function(window, pane)
  local data   = bg_load()
  data.enabled = not data.enabled
  bg_save(data)
  bg_apply(window, data)
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- KEY BINDINGS  (mirrors Windows Terminal)
-- ─────────────────────────────────────────────────────────────────────────────
-- NOTE: We do NOT use disable_default_key_bindings = true because it breaks
-- image paste from clipboard (WezTerm handles image data in its default bindings).
-- Instead we override only what we need, and the defaults remain active.

config.keys = {

  -- Clipboard
  -- NOTE: CTRL+V and CTRL+SHIFT+V are intentionally NOT remapped here.
  -- Remapping them with PasteFrom 'Clipboard' breaks image paste from clipboard.
  -- WezTerm's default paste handler supports image data; PasteFrom does not.
  { key = 'c', mods = 'CTRL', action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and #sel > 0 then
        window:perform_action(act.CopyTo 'Clipboard', pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end)
  },
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },

  -- Tabs
  { key = 'd', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'ALT', action = act.CloseCurrentPane { confirm = false } },
  { key = 'f', mods = 'ALT', action = act.Search { CaseSensitiveString = '' } },
  { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette },

  { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = act.ActivateTab(-1) },

  { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1)  },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'w',   mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },

  -- Pane splitting
  { key = 'DownArrow',  mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Down',  size = { Percent = 50 } } },
  { key = 'UpArrow',    mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Up',    size = { Percent = 50 } } },
  { key = 'LeftArrow',  mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Left',  size = { Percent = 50 } } },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Right', size = { Percent = 50 } } },

  -- Pane navigation
  { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Left'  },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection 'Up'    },
  { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Down'  },

  -- Pane zoom
  { key = 'Enter', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },

  -- Font size
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize    },

  -- Scrollback
  { key = 'PageUp',   mods = 'SHIFT',      action = act.ScrollByPage(-1)                    },
  { key = 'PageDown', mods = 'SHIFT',      action = act.ScrollByPage(1)                     },
  { key = 'k',        mods = 'CTRL|SHIFT', action = act.ClearScrollback 'ScrollbackOnly'    },

  -- Window
  { key = 'n',   mods = 'CTRL|SHIFT', action = act.SpawnWindow      },
  { key = 'F11', mods = '',           action = act.ToggleFullScreen  },

  -- Launcher / Config
  { key = 'l', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewTab {
      args = { 'explorer.exe', wezterm.config_dir },
    }
  },
  { key = 't', mods = 'CTRL|SHIFT', action = act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' } },
  { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },

  -- Utilities
  { key = 'x',     mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  { key = 'u',     mods = 'CTRL|SHIFT', action = act.CharSelect       },
  { key = 'Space', mods = 'CTRL|SHIFT', action = act.QuickSelect      },

  -- Font picker
  { key = 'f', mods = 'CTRL|SHIFT|ALT', action = act.EmitEvent 'pick-font' },

  -- Background picker menu
  { key = 'b', mods = 'CTRL|SHIFT|ALT', action = act.EmitEvent 'pick-background' },

  -- Background quick shortcuts
  -- Shift+/ = ?, Shift+, = <, Shift+. = >  — bind the shifted characters directly
  { key = '?', mods = 'CTRL|SHIFT', action = act.EmitEvent 'bg-next'   },
  { key = '<', mods = 'CTRL|SHIFT', action = act.EmitEvent 'bg-prev'   },
  { key = '>', mods = 'CTRL|SHIFT', action = act.EmitEvent 'bg-toggle' },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- MOUSE BINDINGS
-- ─────────────────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  -- Ctrl+scroll up → increase font size
  {
    event  = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods   = 'CTRL',
    action = act.IncreaseFontSize,
  },
  -- Ctrl+scroll down → decrease font size
  {
    event  = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods   = 'CTRL',
    action = act.DecreaseFontSize,
  },
  -- Single left-click: complete selection (no auto-copy)
  {
    event  = { Up = { streak = 1, button = 'Left' } },
    mods   = 'NONE',
    action = act.CompleteSelection 'PrimarySelection',
  },
  -- Ctrl+left-click: open hyperlink
  {
    event  = { Up = { streak = 1, button = 'Left' } },
    mods   = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Right-click: copy+clear if selected, otherwise paste
  {
    event  = { Down = { streak = 1, button = 'Right' } },
    mods   = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and #sel > 0 then
        window:perform_action(act.CopyTo 'Clipboard', pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.PasteFrom 'Clipboard', pane)
      end
    end),
  },
  -- Middle-click: disabled
  {
    event  = { Down = { streak = 1, button = 'Middle' } },
    mods   = 'NONE',
    action = act.Nop,
  },
  {
    event  = { Up = { streak = 1, button = 'Middle' } },
    mods   = 'NONE',
    action = act.Nop,
  },
  -- Triple-click: select whole line
  {
    event  = { Up = { streak = 3, button = 'Left' } },
    mods   = 'NONE',
    action = act.SelectTextAtMouseCursor 'Line',
  },
}

return config
