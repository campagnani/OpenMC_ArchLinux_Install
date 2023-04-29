# Maintainer: Thalles Oliveira Campagnani <thallescampagnani at gmail dot com>

# Original Source: https://aur.archlinux.org/packages/openmc-git

pkgname=openmc
pkgver=0.13.3
pkgnamever=${pkgname}-${pkgver}
pkgrel=1
pkgdesc="The OpenMC project aims to provide a fully-featured Monte Carlo particle 
		 transport code based on modern methods."
arch=('x86_64')
url="https://github.com/openmc-dev/openmc"
license=('MIT')

source=("${pkgnamever}.tar.gz::https://github.com/openmc-dev/openmc/archive/refs/tags/v${pkgver}.tar.gz")

md5sums=('SKIP')

depends=(
	python-lxml
	python-scipy
	python-pandas
	python-matplotlib
	python-uncertainties
	embree
	libxrender 
	libxcursor 
	libxft 
	libxinerama 
	freecad 
	glu
	openssh
	dagmc-git
	nuclear-data
)
makedepends=(
    cmake
    git
    python
    python-numpy
    python-setuptools
)

provides=("${pkgnamever}")

conflicts=(
	openmc-git
)

build() {
    cd $srcdir/${pkgnamever}
    mkdir build && cd build
    cmake .. -DOPENMC_USE_DAGMC=ON \
             -DDAGMC_ROOT=/opt/DAGMC \
             -DOPENMC_USE_MPI=ON \
             -DHDF5_PREFER_PARALLEL=ON \
	     	 -DCMAKE_INSTALL_PREFIX=/opt/openmc
    make
}

package() {
	cd $srcdir/${pkgnamever}/build 
	make DESTDIR="$pkgdir/" install
	pip install ../
	mv $srcdir/${pkgnamever} $pkgdir/opt/openmc
	ln -s /opt/openmc/bin/openmc /usr/bin/
}
