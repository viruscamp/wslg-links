# Maintainer: viruscamp@gmail.com
pkgname=wslg-links
pkgver=0.1
pkgrel=1
pkgdesc="Recreate WSLg sockets after /tmp and $XDG_RUNTIME_DIR mounted"
arch=('any')
license=('BSD')
install="${pkgname}.install"
source=(wslg-tmp-x11.service
        wslg-runtime-dir.service)
md5sums=('SKIP'
         'SKIP')

package() {
  install -D -m644 "${srcdir}/wslg-tmp-x11.service" "${pkgdir}/usr/lib/systemd/system/wslg-tmp-x11.service"
  install -D -m644 "${srcdir}/wslg-runtime-dir.service" "${pkgdir}/usr/lib/systemd/user/wslg-runtime-dir.service"
}
