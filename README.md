# dotfiles

This is the repository to store configuration for some of the software/programs I use that don't have their own natural configuration sync/version-control capabilities.

## Fist Things First

Ensure you have a `~/.zshrc` file defined, and add to it a variable export for the location of this repository:

```sh
# ~/.zshenv
KDHIRA_DOTFILES=/path/to/dotfiles
```

```sh
mv ~/.zshrc{,.old}
ln -s $KDHIRA_DOTFILES/.zshrc ~/.zshrc
```

This `KDHIRA_DOTFILES` variable will be used a fair few times elsewhere to reference other files in the repo

## Shell (ZSH)

The [`zshrc.d`](./zshrc.d) folder has scripts with intent to hold "themes" of configuration. Consume by adding to your `.zshrc` a declaration to source them:

```sh
source $KDHIRA_DOTFILES/zshrc.d/<file>

# or if you've symlinked the zshrc.d folder to ~/.zshrc.d
source ~/.zshrc.d/<file>
```

## Git Configuration

The [`.gitconfig`](./.gitconfig) file has my configuration and aliases for git, install by symlinking to your HOME directory:

```sh
ln -s $KDHIRA_DOTFILES/.gitconfig ~/.gitconfig
ln -s $KDHIRA_DOTFILES/.gitexcludes ~/.gitexcludes
```

This file has an include to `~/.gitconfig-user` which can hold the per-machine overrides. The `.gitconfig` has the `user.name` configuration set so, for me, only `user.email` should need to be set, but other things can be overridden/set here too (including `user.name`):

```sh
# Use "-f ~/.gitconfig-user" param to set config file to write to, eg:
git config -f ~/.gitconfig-user user.email "<email>"

# To override user.name from .gitconfig
git config -f ~/.gitconfig-user user.name "<name>"
```

## Vim Configuration

The [`.vimrc`](./.vimrc) file has my vim profile. Consume by symlinking into your HOME directory:

```sh
ln -s $KDHIRA_DOTFILES/.vimrc ~/.vimrc
```

After this, on first boot of vim you might be automatically kicked after it downloads some files for `VimPlug`. If this happens, open `vim` again and run the commands

```sh
:PlugInstall

# :PlugUpdate is useful for updating VimPlug plugins
# :PlugUpgrade is useful for updating the VimPlug software itself
```
