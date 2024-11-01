# Maintainer: viruscamp@gmail.com
pkgname=wslg-links
pkgver=0.1
pkgrel=1
pkgdesc="Recreate WSLg sockets after /tmp and $XDG_RUNTIME_DIR mounted"
arch=('any')
license=('BSD-3-Clause')
install="${pkgname}.install"
source=(wslg-tmp-x11.service
        wslg-runtime-dir.service
        Makefile)
sha256sums=('001a1a0ccb8fef5ccc8a5664fc05dcf3d96b811ec07d20cd1aa47bf33bd9a299'
            '10a3aef8c9b12580fd2850af29953d6190ee25b21951f0c4fcaf045ca27aa6f7'
            '6080feee78bdce5fd876fd8bed73c9e2164c5d145a01c5b0644914cf5a2681f2')

package() {
  make PREFIX="${pkgdir}" install
}
