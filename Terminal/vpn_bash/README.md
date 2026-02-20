
---
## Folder Structure

```bash
~/vpn/
├── bin/         # scripts/commands
├── profiles/    # .ovpn / .conf files
└── logs/        # VPN logs
```

Create it:

```bash
mkdir -p ~/vpn/{bin,profiles,logs}
```

---

## Shell Setup (ZSH)

Add VPN tools to PATH.

Edit:

```bash
nano ~/.zshrc
```

Append:

```bash
##### VPN TOOLKIT #####
export PATH="$HOME/vpn/bin:$PATH"

alias hosts='cat /etc/hosts'
```

Reload:

```bash
source ~/.zshrc
```

---

## Main Command — `connvpn`

Location:

```
~/vpn/bin/connvpn
```

### Script

```bash
#!/bin/bash

# --- AUTO ROOT ---
if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

VPNDIR="/home/kali/vpn/profiles"
LOGDIR="/home/kali/vpn/logs"

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage: connvpn <vpnfile>"
    exit 1
fi

FULL="$VPNDIR/$FILE"

[ -f "$FULL" ] || { echo "[-] VPN file not found"; exit 1; }

echo "[+] Starting VPN..."

pkill openvpn 2>/dev/null

mkdir -p "$LOGDIR"
chmod 755 "$LOGDIR"

# ---------- OPENVPN ----------
if [[ "$FILE" == *.ovpn ]]; then

    nohup openvpn \
        --config "$FULL" \
        > "$LOGDIR/openvpn.log" 2>&1 &

    # wait for tunnel
    for i in {1..15}; do
        if ip a | grep -q tun; then
            break
        fi
        sleep 1
    done

    if pgrep openvpn >/dev/null; then
        echo "[✓] VPN running in background"
        echo "    logs: tail -f ~/vpn/logs/openvpn.log"
    else
        echo "[-] Failed to start"
    fi

    exit
fi

# ---------- WIREGUARD ----------
if grep -q "\[Interface\]" "$FULL"; then
    wg-quick up "$FULL" > "$LOGDIR/wireguard.log" 2>&1
    echo "[✓] WireGuard started"
    exit
fi

echo "[-] Unknown VPN type"
```

Make executable:

```bash
chmod +x ~/vpn/bin/connvpn
```

---

## Stop VPN — `stopvpn`

Location:

```
~/vpn/bin/stopvpn
```

```bash
#!/bin/bash

sudo pkill openvpn 2>/dev/null

for i in $(ip link | awk -F: '/wg/{print $2}' | tr -d ' '); do
  sudo wg-quick down $i 2>/dev/null
done

echo "[✓] VPN stopped"
```

```bash
chmod +x ~/vpn/bin/stopvpn
```

---

## VPN Status — `vpnstatus`

Location:

```
~/vpn/bin/vpnstatus
```

```bash
#!/bin/bash

if pgrep openvpn >/dev/null; then
    echo "VPN: OpenVPN ✔"
elif ip link | grep -q wg; then
    echo "VPN: WireGuard ✔"
else
    echo "VPN: OFF"
fi
```

```bash
chmod +x ~/vpn/bin/vpnstatus
```

---

## List Profiles — `vpns`

Location:

```
~/vpn/bin/vpns
```

```bash
#!/bin/bash
ls ~/vpn/profiles
```

```bash
chmod +x ~/vpn/bin/vpns
```

---

## Move Downloaded VPN Files

Location:

```
~/vpn/bin/vpnfilemv
```

```bash
#!/bin/bash

mv ~/Downloads/*.ovpn ~/vpn/profiles/ 2>/dev/null
mv ~/Downloads/*.conf ~/vpn/profiles/ 2>/dev/null

echo "[✓] VPN files moved"
```

```bash
chmod +x ~/vpn/bin/vpnfilemv
```

---

## ZSH Autocomplete (VPN Files Only)

Create completion folder:

```bash
mkdir -p ~/.zsh/completions
```

Create completion file:

```bash
nano ~/.zsh/completions/_connvpn
```

Content:

```bash
#compdef connvpn

_arguments "1:VPN file:_files -W $HOME/vpn/profiles"
```

Add this **before** `compinit` in `.zshrc`:

```bash
fpath=(~/.zsh/completions $fpath)
```

Reload:

```bash
source ~/.zshrc
```

Now:

```bash
connvpn <TAB>
```

shows VPN profiles instead of system folders.

---

## tmux VPN Status (Optional)

Example `~/.tmux-vpn.sh`:

```bash
#!/bin/bash

if pgrep openvpn >/dev/null || ip link | grep -q wg; then
    echo "vpn-on"
else
    echo "no-vpn"
fi
```

Make executable:

```bash
chmod +x ~/.tmux-vpn.sh
```

---

## Usage

### Move downloaded VPN configs

```bash
vpnfilemv
```

### List available profiles

```bash
vpns
```

### Connect (background)

```bash
connvpn htb.ovpn
```

Output:

```
[+] Starting VPN...
[✓] VPN running in background
```

### Check status

```bash
vpnstatus
```

### Stop VPN

```bash
stopvpn
```

### Watch logs (only if needed)

```bash
tail -f ~/vpn/logs/openvpn.log
```

---