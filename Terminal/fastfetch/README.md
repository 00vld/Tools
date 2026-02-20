
---

## 1. Locate Fastfetch Config Directory

Fastfetch looks for configs inside:

```bash
~/.config/fastfetch/
```

Create it if it does not exist:

```bash
mkdir -p ~/.config/fastfetch
```

---

## 2. Add Your `config.json`

Place your config file here:

```bash
~/.config/fastfetch/config.json
```

Example:

```bash
cp config.json ~/.config/fastfetch/config.json
```

Fastfetch automatically loads this file by default if it exists.

---

## 3. Test the Configuration

Run:

```bash
fastfetch
```

If everything is correct, your custom layout should load automatically.

---

## 4. Generate a Default Config (Optional)

If you want a base config to edit:

```bash
fastfetch --gen-config
```

This creates:

```bash
~/.config/fastfetch/config.jsonc
```

You can rename it:

```bash
mv ~/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.json
```

---

## 5. Manually Specify a Config (Optional)

You can run Fastfetch with a specific config file:

```bash
fastfetch --config ~/.config/fastfetch/config.json
```

Useful for testing multiple layouts.

---

## 6. Force Fastfetch to Always Use Your Config (Optional)

If you want to guarantee your config is always used, add an alias.

Edit:

```bash
nano ~/.zshrc
```

Add:

```bash
alias fastfetch='fastfetch --config ~/.config/fastfetch/config.json'
```

Reload:

```bash
source ~/.zshrc
```

---

## 7. Auto Run Fastfetch on Terminal Start (Optional)

If you want Fastfetch to appear when opening a terminal:

Add at the bottom of `~/.zshrc`:

```bash
fastfetch
```

---