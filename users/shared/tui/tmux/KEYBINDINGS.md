# Tmux Keybindings Reference

**Prefix key:** `C-S-b` (Ctrl+Shift+b)

## Sessions

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `prefix + s` | manual | Open sesh session picker (fzf) |
| `prefix + L` | manual | Switch to last session (via sesh) |
| `prefix + d` | native | Detach from session |
| `prefix + $` | native | Rename session |
| `prefix + (` | native | Previous session |
| `prefix + )` | native | Next session |
| `prefix + w` | native | Session and window preview |

### Inside sesh picker

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `Ctrl-a` | manual | Show all sources |
| `Ctrl-t` | manual | Show tmux sessions only |
| `Ctrl-g` | manual | Show config sessions only |
| `Ctrl-x` | manual | Show zoxide directories only |
| `Ctrl-f` | manual | Find directories |
| `Ctrl-d` | manual | Kill selected session |

## Windows

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `M-1` to `M-9` | manual | Select window 1-9 (Alt+number) |
| `C-,` | manual | Previous window |
| `C-.` | manual | Next window |
| `C-S-<` | manual | Swap window with previous |
| `C-S->` | manual | Swap window with next |
| `C-S-t` | manual | New window (in current path) |
| `C-S-q` | manual | Kill window (confirms if multiple panes) |
| `prefix + c` | native | Create window |
| `prefix + &` | native | Kill window |
| `prefix + ,` | native | Rename window |
| `prefix + l` | native | Toggle last window |
| `prefix + 0-9` | native | Select window by number |

## Panes - Navigation

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-Left` | manual | Select pane left |
| `C-Down` | manual | Select pane down |
| `C-Up` | manual | Select pane up |
| `C-Right` | manual | Select pane right |
| `C-n` | manual | Next pane (vim-aware) |
| `C-p` | manual | Previous pane (vim-aware) |
| `C-f4` | manual | Display pane numbers → press to jump |
| `prefix + p` | manual | fzf popup to select pane |
| `prefix + q` | native | Show pane numbers briefly |
| `prefix + o` | native | Cycle through panes |
| `prefix + ;` | native | Toggle last active pane |

## Panes - Create/Kill

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-S-Enter` | manual | Split vertical (in current path) |
| `C-M-Enter` | manual | Break pane to new window |
| `C-S-w` | manual | Kill pane |
| `C-M-g` | manual | Split with proxychains shell |
| `prefix + "` | native | Split horizontal |
| `prefix + %` | native | Split vertical |
| `prefix + x` | native | Kill pane (with confirm) |
| `prefix + !` | native | Convert pane to window |

## Panes - Resize/Swap

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-S-Left` | manual | Resize pane left by 4 |
| `C-S-Down` | manual | Resize pane down by 4 |
| `C-S-Up` | manual | Resize pane up by 4 |
| `C-S-Right` | manual | Resize pane right by 4 |
| `C-S-n` | manual | Swap with next pane |
| `C-S-p` | manual | Swap with previous pane |
| `C-Enter` | manual | Swap to top-left position |
| `C-S-f4` | manual | Display pane numbers → press to swap |
| `prefix + {` | native | Swap with previous pane |
| `prefix + }` | native | Swap with next pane |
| `prefix + z` | native | Toggle pane zoom |

## Layouts

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-S-f` | manual | Toggle pane zoom (fullscreen) |
| `C-S-l` | manual | Enter LAYOUT mode |
| `LAYOUT + f` | manual | Zoom pane |
| `LAYOUT + v` | manual | Main-vertical layout |
| `LAYOUT + h` | manual | Main-horizontal layout |
| `LAYOUT + t` | manual | Tiled layout |
| `prefix + Space` | native | Cycle through layouts |

## Scrolling / Copy Mode

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-S-PPage` | manual | Page up (vim-aware) |
| `C-S-NPage` | manual | Page down (vim-aware) |
| `C-S-Home` | manual | Scroll to top (vim-aware) |
| `C-S-End` | manual | Scroll to bottom (vim-aware) |
| `prefix + [` | native | Enter copy mode |
| `prefix + ]` | native | Paste buffer |
| `q` | native | Exit copy mode |

### In copy mode (vi keys)

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `v` | manual | Begin selection |
| `C-v` | manual | Toggle rectangle selection |
| `y` | manual/yank | Copy selection to clipboard |
| `Y` | yank | Copy selection and paste to command line |
| `h/j/k/l` | native | Navigate |
| `w/b` | native | Word forward/back |
| `0/$` | native | Start/end of line |
| `g/G` | native | Top/bottom of buffer |
| `/` | native | Search forward |
| `?` | native | Search backward |
| `n/N` | native | Next/previous search match |

## Clipboard (tmux-yank)

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `prefix + y` | yank | Copy current command line to clipboard |
| `prefix + Y` | yank | Copy current working directory to clipboard |

## Session Persistence (tmux-resurrect)

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `prefix + C-s` | resurrect | Save session state |
| `prefix + C-r` | resurrect | Restore session state |

## Misc

| Shortkey | Source | Explanation |
|----------|--------|-------------|
| `C-S-f5` | manual | Reload tmux config |
| `C-S-k` | manual | Clear screen and scrollback |
| `prefix + y` | manual | Enable pane synchronization |
| `prefix + Y` | manual | Disable pane synchronization |
| `Home` | manual | Send Home key (vim fix) |
| `End` | manual | Send End key (vim fix) |
| `prefix + :` | native | Command prompt |
| `prefix + ?` | native | List all keybindings |
| `prefix + t` | native | Show clock |
| `prefix + r` | sensible | Reload config |
| `prefix + a` | sensible | Send prefix to nested tmux |

## Legend

| Source | Description |
|--------|-------------|
| manual | Defined in `config.conf` |
| native | Built-in tmux default |
| yank | tmux-yank plugin |
| resurrect | tmux-resurrect plugin |
| sensible | tmux-sensible plugin |
| sesh | sesh session manager |
