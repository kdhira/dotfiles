# Add Tmux Configuration

## Opportunity
Tmux complements your terminal setup with:

- **Session persistence**: Survive SSH disconnects
- **Window/pane management**: Better than terminal tabs
- **Scriptable layouts**: Reproducible development environments
- **Remote pairing**: Share terminal sessions

Given your sophisticated iTerm2 and prompt setup, tmux would integrate well.

## Proposed Configuration

### Theme: Catppuccin (Matching Existing Theme)

```bash
# Install plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Configuration File

Create `tmux/.tmux.conf`:

```tmux
# =============================================================================
# TMUX Configuration - Kevin Hira
# =============================================================================

# Use 256 colors and true color
set -g default-terminal "screen-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Increase history
set -g history-limit 50000

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Mouse support
set -g mouse on

# Vi mode for copy
setw -g mode-keys vi

# Faster escape time (for vim)
set -sg escape-time 10

# Focus events (for vim autoread)
set -g focus-events on

# =============================================================================
# Key Bindings
# =============================================================================

# Remap prefix from C-b to C-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Split panes with | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes with Shift+arrow
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# =============================================================================
# Plugins (TPM)
# =============================================================================

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'catppuccin/tmux'

# Catppuccin config
set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_status_modules_right "session date_time"
set -g @catppuccin_date_time_text "%H:%M"

# Initialize TPM (keep at bottom)
run '~/.tmux/plugins/tpm/tpm'
```

### Session Scripts

Create `tmux/sessions/dev.sh`:

```bash
#!/usr/bin/env bash
# Development session layout

SESSION="dev"

tmux new-session -d -s $SESSION -n editor
tmux send-keys -t $SESSION:editor "vim ." Enter

tmux new-window -t $SESSION -n terminal
tmux split-window -h -t $SESSION:terminal
tmux send-keys -t $SESSION:terminal.1 "git status" Enter

tmux new-window -t $SESSION -n logs

tmux select-window -t $SESSION:editor
tmux attach -t $SESSION
```

## Implementation Steps

1. Create `tmux/.tmux.conf` with configuration
2. Add symlink instruction to README
3. Create session scripts for common workflows
4. Install TPM:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
5. Install plugins: Press `prefix + I` in tmux

## Files to Create

- `tmux/.tmux.conf`
- `tmux/sessions/dev.sh`
- `tmux/sessions/remote.sh`

## Files to Modify

- `README.md` (add tmux setup instructions)
- `install.sh` (add tmux symlink)

## Testing

1. Install tmux: `brew install tmux`
2. Symlink config: `ln -s $KDHIRA_DOTFILES/tmux/.tmux.conf ~/.tmux.conf`
3. Start tmux: `tmux`
4. Install plugins: `Ctrl-a + I`
5. Verify Catppuccin theme matches other tools
6. Test key bindings (split, navigate, resize)

## Shell Integration

Add to `.zshrc` for auto-attach:

```zsh
# Auto-attach to tmux session
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
    tmux attach -t default || tmux new -s default
fi
```
