took a lot from https://github.com/vtex/dotfiles/tree/master

`bash bootstrap.sh`

---

**UPDATED WORKFLOW**

- `./config/` - every item in this directory (files and folders) gets symlinked to ~/.config
- `./Brewfile` - homebrew bundle
- `./scripts` - scripts ran as part of the setup
    - `dependencies.sh` - installs required dependencies
    - `config.sh` - symlinks all items in the config directory to ~/
    - `macos.sh` - configures various macos related settings
    - `node.sh` - installs various node.js/npm related items
    - `zsh.sh` - installs/configures various zsh things

