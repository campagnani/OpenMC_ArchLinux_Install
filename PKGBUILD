# Maintainer: Gavin Ridley <gavin dot keith dot ridley at gmail dot com>
# Maintainer: Luke Labrie-Cleary <luke dot cleary at copenhagenatomics dot com>
pkgname=openmc-ompi-nopy
pkgver=v0.14.0
pkgrel=1
pkgdesc="OpenMC build with OpenMPI and but without python env."
arch=('x86_64')
url="https://github.com/openmc-dev/openmc"
license=('MIT')

source=("${pkgname}::git+${url}.git")

md5sums=('SKIP')

depends=( 
	hdf5
	openssh
)
makedepends=(
    base-devel
	cmake
    git
)

provides=("${pkgname%-pkgver}")

build() {
    cd $srcdir/${pkgname}
	git checkout master
    mkdir build && cd build
    cmake .. -DOPENMC_USE_MPI=ON \
             -DHDF5_PREFER_PARALLEL=ON \
	     	 -DCMAKE_INSTALL_PREFIX=/opt/openmc	\
			 -DCMAKE_BUILD_TYPE=Release
	_ccores=$(nproc)
	# check if _ccores is a positive integer, if not, serial build
	if [[ "${_ccores}" =~ ^[1-9][0-9]*$ ]]; then
		make -j ${_ccores}
	else
		make
	fi


}

package() {
	cd $srcdir/${pkgname}/build 
	make DESTDIR="$pkgdir/" install
	cp -r $srcdir/${pkgname} $pkgdir/opt/openmc
	mv $pkgdir/opt/openmc/${pkgname} $pkgdir/opt/openmc/openmc-src 
	rm -rf $pkgdir/opt/openmc/openmc-source/build
	mkdir $pkgdir/bin
	cd $pkgdir/bin
	ln -s /opt/openmc/openmc
}
