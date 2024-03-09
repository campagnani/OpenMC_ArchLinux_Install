# OpenMC - ArchLinux

Instruções de instalação do OpenMC para ArchLinux.

## Compilando e instalando a partir do AUR

Para compilar, empacotar e instalar em um único computador pessoal com ArchLinux:

```
paru -S openmc-git
```

ou

```
yay -S openmc-git
```


## Compilando e instalando versão para cluster

Essa versão é mais simples (menos dependências, não instala python, etc) mas ter suporte a paralelismo. Configuração do PKGBUILD:
| pkgname               | openmc-ompi-nopy    |
|-----------------------|---------------------|
| pkgver                | Brench "master"     |
| Build type            | Release             |
| MPI enabled           | yes                 |
| Parallel HDF5 enabled | yes                 |
| PNG support           | yes                 |
| DAGMC support         | no                  |
| libMesh support       | no                  |
| MCPL support          | no                  |
| NCrystal support      | no                  |
| Coverage testing      | no                  |
| Profiling flags       | no                  |
| INSTALL_PREFIX        | /opt/openmc         |

PKBUILD baseado em https://aur.archlinux.org/packages/openmc-git


```
git clone https://github.com/campagnani/OpenMC_ArchLinux_Install
cd OpenMC_ArchLinux_Install
makepkg -s
```

Isso criará um pacote, algo como `openmc-ompi-nopy-v0.14.0-1-x86_64.pkg.tar.zs`. Envie esse pacote para todos as máquinas do clusler com:

```
scp openmc-ompi-nopy-v*.pkg.tar.zst  USER@HOST:/home/openmc
```

Acesse a cada máquina com SSH e depois instale:

```
ssh USER@HOST
pacman -S openmc-ompi-nopy-v*.pkg.tar.zst
```

## Conda Install

Instalação via conda:

```
paru -S nuclear-data miniconda3

echo "" >> .bashrc
echo "#MiniConda" >> .bashrc
echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> .bashrc
echo "export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1" >> .bashrc
echo "" >> .bashrc
echo "#OpenMC Cross Sections" >> .bashrc
echo "var=`echo /opt/nuclear-data/*hdf5 | head -n1`" >> .bashrc
echo "export OPENMC_CROSS_SECTIONS=$var/cross_sections.xml" >> .bashrc

source /opt/miniconda3/etc/profile.d/conda.sh
conda config --add channels conda-forge
conda create -n openmc-env
conda activate openmc-env
conda install mamba
mamba search openmc
echo ""
echo ""
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "Para instalar versão específica, set conforme exemplo abaixo:"
echo "OPENMC_VERSION=0.14.0"
echo "OPENMC_BUILD=nompi_py312hecd8f91_1"
echo 'mamba install openmc[version=$OPENMC_VERSION,build=$OPENMC_BUILD]'
echo ""
echo "Caso contrário, apenas execute:"
echo "mamba install openmc"
```
