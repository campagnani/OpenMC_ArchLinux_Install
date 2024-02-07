# OpenMC_ArchLinux_Install

## Compiling

Na mesma pasta que o PKBUILD executar:
```
makepkg -si
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
