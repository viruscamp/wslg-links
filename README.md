# **This is needless from WSL 2.5.7.0**

# wslg-links
Recreate WSLg sockets after `/tmp` and `$XDG_RUNTIME_DIR` mounted as tmpfs.

## Usage

### ArchLinux
```sh
makepkg -srcif
```

### Makefile
```
sudo make install
sudo make enable
```

### Manually
```sh
sudo cp wslg-tmp-x11.service /usr/lib/systemd/system/
sudo cp wslg-runtime-dir.service /usr/lib/systemd/user/

sudo systemctl --global disable pulseaudio.socket

sudo systemctl enable wslg-tmp-x11
sudo systemctl --global enable wslg-runtime-dir
```

## Why
Systemd will mount `/tmp` and `$XDG_RUNTIME_DIR`(`/run/user/1000`) as tmpfs, make `/tmp/.X11-unix/X0` and `$XDG_RUNTIME_DIR/wayland-0` missing.
Debian and Ubuntu always mask `tmp.mount` by put it in `/usr/share/systemd/tmp.mount`.
Ubuntu-22.04 won't mount `/run/user/1000` due to a bug in `/usr/lib/systemd/systemd-user-runtime-dir`.
Ubuntu-24.04 is using a new version of systemd which fix the bug, so it will mount `/run/user/1000`, and make `$XDG_RUNTIME_DIR/wayland-0` missing.
See https://viruscamp.github.io/posts/2024/04/what-does-wslg-do-3/ for more details.

## How
Simply, we must recreate links to make sure that:

```
/tmp/.X11-unix/X0          -> /mnt/wslg/.X11-unix/X0
$XDG_RUNTIME_DIR/wayland-0 -> /mnt/wslg/runtime-dir/wayland-0
```

For `/tmp/.X11-unix`, we can:
1. link the directory `ln -s /mnt/wslg/tmp/.X11-unix /tmp/.X11-unix`
    `Xephyr :1` cannot create `/tmp/.X11-unix/X1` but `@/tmp/.X11-unix/X1` as abstract namespace socket.
2. link the X socket only `ln -s /mnt/wslg/tmp/.X11-unix/X0 /tmp/.X11-unix/X0`
    If there are multiple monitors, there maybe `/tmp/.X11-unix/X1` or more.
3. mount the directory readwrite `mount -m -o bind,rw /mnt/wslg/.X11-unix /tmp/.X11-unix`
    `Xephyr` may overwrite `/tmp/.X11-unix/X0`, maybe we can chown and chgrp it.
4. mount the directory readonly`mount -m -o bind,ro /mnt/wslg/.X11-unix /tmp/.X11-unix`
    `Xephyr :1` cannot create any X socket.

## Other methods that using `tmpfiles.d`:

```sh
$ cat /etc/tmpfiles.d/wslg.conf
# See tmpfiles.d(5) for details
# link WSLg display files after system started

# Type Path              Mode UID  GID  Age Argument
#L+     /tmp/.X11-unix    -    -    -    -   /mnt/wslg/.X11-unix
L+     /tmp/.X11-unix/X0 -    -    -    -   /mnt/wslg/.X11-unix/X0

$ sudo systemctl enable systemd-tmpfiles-setup.service systemd-tmpfiles-clean.timer
```

```sh
$ cat ~/.config/user-tmpfiles.d/wslg.conf
# Type Path              Mode UID  GID  Age Argument
L+     %t/wayland-0      -    -    -    -   /mnt/wslg/runtime-dir/wayland-0
L+     %t/wayland-0.lock -    -    -    -   /mnt/wslg/runtime-dir/wayland-0.lock
L+     %t/pulse/native   -    -    -    -   /mnt/wslg/runtime-dir/pulse/native
L+     %t/pulse/pid      -    -    -    -   /mnt/wslg/runtime-dir/pulse/pid
L+     %t/dbus-1         -    -    -    -   /mnt/wslg/runtime-dir/dbus-1

$ systemctl --user enable systemd-tmpfiles-setup.service systemd-tmpfiles-clean.timer
```
