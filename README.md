# Quick start

    git clone git@github.com:joech4n/zsh-dotfiles.git ~/.dotfiles
    ~/.dotfiles/script/bootstrap
    cd ~/.dotfiles && stow -t ~ stow

## install

Run Quick Start section above.

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`bin/dot` is a simple script that updates various dependencies. Tweak this script,
and occasionally run `dot` from time to time to keep your environment fresh and
up-to-date.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
- **topic/{,post}-install{,$(uname)}.sh**: Run by script/install for topical installers.
- **zsh/zpreztorc**: The zsh config is mostly built around [prezto](https://github.com/sorin-ionescu/prezto). Any substantial zsh configuration should probably eventually end up as a prezto module in zsh/zprezto-contrib.
- **Brewfile**: Catalogs my apps/utilities for [brew bundle](https://github.com/Homebrew/homebrew-bundle).

## thanks

- <https://github.com/holman/dotfiles>
- <https://github.com/sorin-ionescu/prezto>
