### Installation
You can clone the repo yourself and use `setup.sh`. The install script uses `stow` to manage symlnks.
```
cd dotfiles/home/ && stow -t "$HOME" *
```
### About
There are my dotfiles. You are free to borrow from them as you like, since that's more or less what I've done. Remember to change your username, email, and root directory name in gitconfig and wherever else.
Here's a few lists of stuff I like to have on my machines.

### Other Nice Things
Essentials:
  - Chrome - log in for the chrome extensions
  - [BetterTouchTools][btt-link]: a ~~free~~ Divvy alternative (no longer free, but still cool)
    - shortcuts saved in [btt/](./btt)
  - Dropbox
  - [RVM][rvm-link] or [rbenv][rbenv-link] with [ruby-build][ruby-build-link]
  - [Homebrew (includes xcode)][homebrew-link]
  - VirtualBox
  - Vagrant (startup Vagrantfile included here)
  - [neovim][neovim-link]
  - tmux

Chrome Extensions:
  - ~~Lastpass~~
    - Since Lastpass [got bought out][lastpass-bought-out-link], I now use 1Password
  - Disconnect
  - Privacy Badger
  - uBlock Origin
  - Evernote Web Clipper

Extra:
  - [Keybase][keybase-link]

[divvy-link]: http://mizage.com/divvy/
[rvm-link]: https://rvm.io/
[homebrew-link]: http://brew.sh/
[keybase-link]: https://keybase.io/
[btt-link]: http://www.boastr.net/
[rbenv-link]: https://github.com/sstephenson/rbenv#installation
[ruby-build-link]: https://github.com/sstephenson/ruby-build#installation
[lastpass-bought-out-link]: https://blog.lastpass.com/2015/10/lastpass-joins-logmein.html/
[neovim-link]: https://neovim.io 

