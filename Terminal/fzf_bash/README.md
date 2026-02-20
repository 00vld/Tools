
---

### 1. Install FZF

```bash
sudo apt install fzf
```

---

### 2. Enable FZF in ZSH

Ensure these lines exist in your `~/.zshrc`:

```bash
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
```

Reload shell:

```bash
source ~/.zshrc
```

---

### 3. Update `connvpn` to use FZF selector

Edit:

```bash
nano ~/vpn/bin/connvpn
```

Add this near the top (after VPNDIR / LOGDIR variables):

```bash
if [ -z "$1" ]; then
    FILE=$(ls "$VPNDIR" | fzf --prompt="Select VPN > ")
else
    FILE="$1"
fi

[ -z "$FILE" ] && exit 0
```

This allows:

* Running `connvpn` with no arguments → opens interactive VPN picker
* Running `connvpn <file>` → works normally

---

### 4. Usage

Interactive selection:

```bash
connvpn
```

Direct usage still works:

```bash
connvpn htb.ovpn
```

---