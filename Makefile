PREFIX ?=

all: install enable

install:
	install -D -m644 wslg-tmp-x11.service $(PREFIX)/usr/lib/systemd/system/wslg-tmp-x11.service
	install -D -m644 wslg-runtime-dir.service $(PREFIX)/usr/lib/systemd/user/wslg-runtime-dir.service

enable:
	systemctl enable wslg-tmp-x11
	systemctl --global enable wslg-runtime-dir

uninstall:
	-rm -f $(PREFIX)/usr/lib/systemd/system/wslg-tmp-x11.service
	-rm -f $(PREFIX)/usr/lib/systemd/user/wslg-runtime-dir.service

disable:
	systemctl disable wslg-tmp-x11
	systemctl --global disable wslg-runtime-dir
