pkgname=term-pdf
pkgver=0.0.4.5
pkgrel=1
pkgdesc="TermPDF Viewer terminal PDF viewer"
arch=('x86_64')
url="https://gnlz.cl/repo/"
license=('MIT')
depends=('gcc' 'python-pip' 'python-pymupdf' 'python-termcolor')
source=("/home/felipe/Development/TermPDFViewer-dev/term-pdf-0.0.4.5.tar.gz")
sha256sums=('bf37f984a9dbfcf7b7f30a8dca0d52ea84f2cd42e76da9c29cd42692206c8863')

prepare() {
    mkdir -p srcbuild
    tar xf "/home/felipe/Development/TermPDFViewer-dev/term-pdf-0.0.4.5.tar.gz" -C srcbuild
}

build() {
    gcc -o srcbuild/term-pdf-wrp srcbuild/term-pdf-wrp.c
}

package() {
    install -Dm755 srcbuild/term-pdf-wrp "$pkgdir/usr/local/bin/term-pdf"
    install -Dm755 srcbuild/termpdf.py "$pkgdir/usr/local/bin/termpdf.py"
}
