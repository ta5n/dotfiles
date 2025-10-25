# Dotfiles Kurulum Kılavuzu

Bu kılavuz, ta5n/dotfiles repository'sini kullanarak yeni bir sisteme dotfiles kurulumunu anlatır.

## Yedek Oluşturma (Mevcut Sistemde)

Eğer mevcut dotfiles'larınız varsa önce yedekleyin:

```bash
# Yedek dizini oluştur
BACKUP_DIR=~/dotfiles-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

# Mevcut dotfiles'ları yedekle
cp ~/.zshrc "$BACKUP_DIR/" 2>/dev/null
cp ~/.bashrc "$BACKUP_DIR/" 2>/dev/null
cp ~/.p10k.zsh "$BACKUP_DIR/" 2>/dev/null
cp ~/.vimrc "$BACKUP_DIR/" 2>/dev/null
cp ~/.gitconfig "$BACKUP_DIR/" 2>/dev/null
cp -r ~/.config/nvim "$BACKUP_DIR/" 2>/dev/null

echo "Backup created at: $BACKUP_DIR"
ls -la "$BACKUP_DIR"
```

---

## Yeni Sistemde Kurulum

### Seçenek 1: Tek Komutla Kurulum (Önerilen)

En hızlı yöntem - chezmoi'yi kurar ve dotfiles'ları uygular:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ta5n
```

**Ne yapar?**
- chezmoi'yi indirir ve kurar
- GitHub'dan ta5n/dotfiles repository'sini çeker
- Tüm dotfiles'ları otomatik uygular
- Kurulum scriptlerini çalıştırır (oh-my-zsh, powerlevel10k, eklentiler)

---

### Seçenek 2: Adım Adım Kurulum

Daha kontrollü bir kurulum isterseniz:

#### 1. Chezmoi Kurulumu

```bash
# Linux/WSL
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin

# PATH'e ekle
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

#### 2. Dotfiles Repository'yi Çek

```bash
chezmoi init https://github.com/ta5n/dotfiles.git
```

#### 3. Değişiklikleri Önizle

Hangi dosyaların oluşturulacağını/değiştirileceğini görmek için:

```bash
chezmoi diff
```

#### 4. Dotfiles'ları Uygula

```bash
chezmoi apply -v
```

`-v` parametresi yapılan işlemleri detaylı gösterir.

---

## Kurulum Sonrası

### 1. Shell'i Yeniden Yükle

```bash
# ZSH kullanıyorsanız
source ~/.zshrc

# Veya shell'i yeniden başlat
exec zsh

# Bash kullanıyorsanız
source ~/.bashrc
```

### 2. Default Shell'i ZSH Yap

```bash
chsh -s $(which zsh)
```

Log out/log in yapmanız gerekebilir.

### 3. Powerlevel10k Yapılandırması (Opsiyonel)

Promtu özelleştirmek isterseniz:

```bash
p10k configure
```

### 4. Nerd Font Kurulumu

İconların düzgün görünmesi için Nerd Font gereklidir:

**Linux/WSL:**
```bash
# Manuel kurulum
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
```

**macOS:**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

**Windows Terminal (WSL için):**
1. Settings → Profiles → Ubuntu/WSL profili
2. Appearance → Font face → "MesloLGS NF"

---

## Güncellemeler

### Dotfiles'ları Güncelle

Repository'den son değişiklikleri çek ve uygula:

```bash
chezmoi update
```

Veya alias kullanarak:

```bash
update-dotfiles
```

### Chezmoi Kaynak Dizinine Git

Dotfiles'ları düzenlemek için:

```bash
chezmoi cd
```

Çıkmak için:

```bash
exit
```

### Tek Bir Dosyayı Düzenle

```bash
# Editörde aç
chezmoi edit ~/.zshrc

# Değişiklikleri uygula
chezmoi apply
```

### Yeni Dosya Ekle

```bash
# Mevcut dosyayı chezmoi'ye ekle
chezmoi add ~/.gitconfig

# Düzenle
chezmoi edit ~/.gitconfig

# Uygula
chezmoi apply
```

---

## Chezmoi Komutları

| Komut | Açıklama |
|-------|----------|
| `chezmoi init <repo>` | Repository'den dotfiles'ları çek |
| `chezmoi apply` | Dotfiles'ları uygula |
| `chezmoi update` | Repository'den güncelle ve uygula |
| `chezmoi diff` | Değişiklikleri önizle |
| `chezmoi add <file>` | Dosyayı chezmoi'ye ekle |
| `chezmoi edit <file>` | Dosyayı düzenle |
| `chezmoi cd` | Kaynak dizine git |
| `chezmoi status` | Durum kontrolü |
| `chezmoi apply --dry-run` | Sadece test et, değişiklik yapma |

---

## Platform-Spesifik Notlar

### WSL (Windows Subsystem for Linux)

- DISPLAY değişkeni otomatik ayarlanır
- Windows dosyalarına erişim: `/mnt/c/Users/...`
- Alias: `winpath` - Windows kullanıcı dizinine git

### Git Bash for Windows

- Bash yapılandırması kullanılır
- ZSH kuruluysa `exec zsh` ile geçiş yapabilirsiniz

### macOS

- Homebrew ile paket yönetimi
- macOS-specific pluginler otomatik eklenir

---

## Sorun Giderme

### oh-my-zsh kurulu değil

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Powerlevel10k kurulu değil

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### zsh-syntax-highlighting kurulu değil

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### zsh-autosuggestions kurulu değil

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### lsd kurulu değil

```bash
# Ubuntu/Debian
sudo apt install lsd

# macOS
brew install lsd

# Arch
sudo pacman -S lsd
```

### grc kurulu değil

```bash
# Ubuntu/Debian
sudo apt install grc

# macOS
brew install grc

# Arch
sudo pacman -S grc
```

### Vim/Neovim eklentileri yüklenmiyor

**Vim:**
```bash
vim +PlugInstall +qall
```

**Neovim:**
Neovim'i ilk açtığınızda otomatik yüklenecek, veya:
```
:Lazy sync
```

---

## Özelleştirme

### Local Overrides

Chezmoi tarafından yönetilmeyen, kişisel ayarlarınız için:

**ZSH:**
```bash
# ~/.zshrc.local dosyası oluşturun
touch ~/.zshrc.local
```

**Bash:**
```bash
# ~/.bashrc.local dosyası oluşturun
touch ~/.bashrc.local
```

Bu dosyalar otomatik yüklenecek ama git'e commit edilmeyecek.

### Chezmoi Template Değişkenleri

İlk kurulumda sorulacak sorular için `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    name = "Your Name"
    email = "your.email@example.com"
```

---

## Yardım ve Kaynaklar

- **Repository:** https://github.com/ta5n/dotfiles
- **Chezmoi Docs:** https://www.chezmoi.io/
- **oh-my-zsh:** https://ohmyz.sh/
- **Powerlevel10k:** https://github.com/romkatv/powerlevel10k
- **Issue bildirme:** https://github.com/ta5n/dotfiles/issues

---

## Hızlı Başvuru

```bash
# Yeni sistemde tek komut kurulum
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ta5n

# Güncellemeleri çek ve uygula
chezmoi update

# Dosya düzenle
chezmoi edit ~/.zshrc
chezmoi apply

# Değişiklikleri kontrol et
chezmoi diff

# Kaynak dizine git
chezmoi cd
```
