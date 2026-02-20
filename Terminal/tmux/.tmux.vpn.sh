# ~/.tmux.vpn.sh
#!/bin/sh

IF="tun0"
WIDTH=9

if ip link show "$IF" >/dev/null 2>&1; then
    ip -4 addr show "$IF" | awk '/inet / {sub(/\/.*/, "", $2); printf "%-*s", '"$WIDTH"', $2; exit}'
else
    printf "%-*s" "$WIDTH" "no-vpn"
fi