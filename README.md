# dotfiles

This is the repository to store configuration for some of the software/programs I use that don't have their own natural configuration sync/version-control capabilities.

## Shell (ZSH)

The [`zshrc.d`](./zshrc.d) folder has scripts with intent to hold "themes" of configuration. Consume by adding to your `.zshrc` a declaration to source them:

```sh
source $PATH_TO_REPO/zshrc.d/<file>

# or if you've symlinked the zshrc.d folder to ~/.zshrc.d
source ~/.zshrc.d/<file>
```

## Git Configuration

The [`.gitconfig`](./.gitconfig) file has my configuration and aliases for git, install by symlinking to your HOME directory:

```sh
ln -s $PATH_TO_REPO/.gitconfig ~/.gitconfig
ln -s $PATH_TO_REPO/.gitexcludes ~/.gitexcludes
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
ln -s $PATH_TO_REPO/.vimrc ~/.vimrc
```

After this, on first boot of vim you might be automatically kicked after it downloads some files for `VimPlug`. If this happens, open `vim` again and run the commands

```sh
:PlugInstall

# :PlugUpdate is useful for updating VimPlug plugins
# :PlugUpgrade is useful for updating the VimPlug software itself
```
