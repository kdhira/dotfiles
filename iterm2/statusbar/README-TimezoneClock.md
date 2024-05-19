# Install

1. Create a new "Full environment" script
    1. Call it _TimezoneClock_
    1. Add `python-dateutils` to the required pip dependencies
    1. Save it in the `AutoLaunch` subdirectory so it runs automatically

1. Copy/symlink the [`TimezoneClock.py`](./TimezoneClock.py) to override the empty generated script

    ```sh
    rm "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/TimezoneClock/TimezoneClock/TimezoneClock.py"
    ln -s \
      "$KDHIRA_DOTFILES/iterm2/statusbar/TimezoneClock.py" \
      "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/TimezoneClock/TimezoneClock/TimezoneClock.py"
    ```
1. Modify the statusbar to include the TimezoneClock widget
