pkgname=openmc-ompi-nopy
pkgver=v0.15.0
pkgrel=1
pkgdesc="OpenMC build with OpenMPI but without hdf5-openmpi, and without python env."
arch=('x86_64')
url="https://github.com/openmc-dev/openmc"
license=('MIT')

source=("${pkgname}::git+${url}.git")

pkgver() {
    cd "$pkgname"
    git checkout master > /dev/null  #Mude o repostório para a brench master (última versão estável) #Necessário descartar a saída padrão
    git describe --tags | sed 's/-.*//'
}

md5sums=('SKIP')

depends=( 
    hdf5
    openssh
    fmt
    openmpi
    pugixml
)

makedepends=(
    base-devel
    cmake
    git
    fmt
    openmpi
)

conflicts=(
    openmc-git
    hdf5-openmpi
)

provides=("${pkgname%-pkgver}")

build() {
    cd $srcdir/${pkgname}
    rm -rf build
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DOPENMC_USE_MPI=ON -DCMAKE_INSTALL_PREFIX=/opt/openmc

    _ccores=$(nproc)
    # check if _ccores is a positive integer, if not, serial build
    if [[ "${_ccores}" =~ ^[1-9][0-9]*$ ]]; then
        make -j ${_ccores}
    else
        make
    fi
}

package() {
    cd $srcdir/${pkgname}/build                       #Vá para o diretório build
    make DESTDIR="$pkgdir/" install                   #Execute o comando "make intall" mas com diretório destino como o pacote "$pkgdir/"
    rm -rf $srcdir/${pkgname}/build                   #Sendo a instalação bem sucedida remova os arquivos de compilação
    mkdir $pkgdir/opt/openmc/openmc-src               #Crie um diretório para hospedar o código fonte no diretório de instalação dentro do pacote
    cp -r $srcdir/${pkgname}/* $pkgdir/opt/openmc/openmc-src #Copie o código fonte
    rm -rf $srcdir                                    #Delete o código fonte
    mkdir -p $pkgdir/usr/bin                          #Crie o diretório /usr/bin no pacote
    ln -s /opt/openmc/bin/openmc $pkgdir/usr/bin      #Crie um link simbólico para o binário do openmc em /usr/bin
}
