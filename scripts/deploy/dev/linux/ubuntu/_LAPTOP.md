# Notebook (Laptop)

## Dev Environment

### CPU

### Memory

### SSD

### Display

* Disable screen blanking (power saving):

```bash
gsettings set org.gnome.desktop.session idle-delay 0
```

* Disable automatic screen lock:

```bash
gsettings set org.gnome.desktop.screensaver lock-enabled false
```

* Check the current setting:

```bash
gsettings get org.gnome.desktop.session idle-delay
```

* When running as a server or left on without a display

To keep the laptop out of suspend even with the lid closed, set `HandleLidSwitch=ignore` in
`/etc/systemd/logind.conf`.
