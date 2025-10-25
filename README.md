# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Shell Configuration**
  - ZSH with [oh-my-zsh](https://ohmyz.sh/)
  - [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme (lean style)
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - Bash configuration for Git Bash compatibility

- **Editor Configuration**
  - Vim with vim-plug and best practices
  - Neovim with lazy.nvim and modern Lua configuration
  - LSP support, autocompletion, syntax highlighting
  - Git integration, file explorer, fuzzy finder

- **Platform Support**
  - Linux (Debian/Ubuntu, Fedora/RHEL, Arch)
  - macOS
  - WSL (Windows Subsystem for Linux)
  - Git Bash for Windows

## Installation

### Prerequisites

- `curl` or `wget`
- `git`

### Quick Start

1. Install chezmoi and apply dotfiles:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ta5n
```

Or with a specific dotfiles repository:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/ta5n/dotfiles.git
```

2. The installation script will automatically:
   - Install oh-my-zsh
   - Install Powerlevel10k theme
   - Install zsh plugins (syntax-highlighting, autosuggestions)
   - Install necessary dependencies
   - Apply dotfiles to your home directory

3. Log out and log back in for shell changes to take effect.

## Manual Installation

1. Install chezmoi:

```bash
# Linux/macOS
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin

# Add to PATH if needed
export PATH="$HOME/.local/bin:$PATH"
```

2. Initialize with your dotfiles repository:

```bash
chezmoi init https://github.com/ta5n/dotfiles.git
```

3. Preview changes:

```bash
chezmoi diff
```

4. Apply dotfiles:

```bash
chezmoi apply -v
```

## Usage

### Update Dotfiles

Pull latest changes from repository and apply:

```bash
chezmoi update
```

Or:

```bash
update-dotfiles  # Alias defined in .zshrc and .bashrc
```

### Edit Dotfiles

Edit a dotfile in your editor:

```bash
chezmoi edit ~/.zshrc
```

Apply changes:

```bash
chezmoi apply
```

### Add New Dotfiles

Add a file to chezmoi:

```bash
chezmoi add ~/.gitconfig
```

### Manage Repository

Navigate to chezmoi source directory:

```bash
chezmoi cd
```

Then use git commands:

```bash
git add .
git commit -m "Update dotfiles"
git push
```

Exit source directory:

```bash
exit
```

## Platform-Specific Notes

### WSL

- The configuration automatically detects WSL and applies WSL-specific settings
- DISPLAY variable is set for X11 support
- Includes `winpath` alias to navigate to Windows user directory

### Git Bash for Windows

- Falls back to Bash configuration
- Includes Windows-specific terminal settings
- Use ZSH if available by running: `exec zsh`

### macOS

- Automatically uses Homebrew for package management
- Includes macOS-specific plugins for oh-my-zsh

## Customization

### Local Overrides

Create local configuration files that won't be tracked:

- `~/.zshrc.local` - Local ZSH configuration
- `~/.bashrc.local` - Local Bash configuration

### Powerlevel10k

To reconfigure Powerlevel10k theme:

```bash
p10k configure
```

### Vim Plugins

Install/update vim plugins:

```bash
vim +PlugInstall +qall
```

### Neovim Plugins

Plugins are automatically installed on first launch. To manage:

```
:Lazy
```

## Troubleshooting

### Fonts not displaying correctly

Install a Nerd Font for proper icon display:

- Download from [Nerd Fonts](https://www.nerdfonts.com/)
- Recommended: MesloLGS NF (automatically installed on macOS via Homebrew)
- Configure your terminal to use the installed font

### ZSH not default shell

Change default shell manually:

```bash
chsh -s $(which zsh)
```

### Permission issues with chezmoi

Ensure executable scripts have correct permissions:

```bash
chmod +x ~/.local/share/chezmoi/.chezmoiscripts/*.sh
```

## File Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore              # Platform-specific ignore rules
├── .chezmoiscripts/
│   └── run_once_before_*.sh    # Installation scripts
├── dot_bashrc.tmpl             # Bash configuration
├── dot_zshrc.tmpl              # ZSH configuration
├── dot_p10k.zsh                # Powerlevel10k configuration
├── dot_vimrc                   # Vim configuration
├── dot_config/
│   └── nvim/
│       └── init.lua            # Neovim configuration
└── README.md                   # This file
```

## Resources

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [oh-my-zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Neovim Documentation](https://neovim.io/doc/)

## License

MIT License - Feel free to use and modify as needed.
