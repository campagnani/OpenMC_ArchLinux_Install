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

Essa versão é mais simples para cluster (menos dependências, não instala python, etc) mas tem o suporte a paralelismo. Entretanto sem paralelismo de HDF5 por causa do seguinte erro: [OpenMC Forum #606](https://openmc.discourse.group/t/depletion-simulation-on-supercomputer-gets-stuck-between-depletion-steps/606) --> [GitHub #1566](https://github.com/openmc-dev/openmc/pull/1566)

Configuração do PKGBUILD:
| pkgname               | openmc-ompi-nopy    |
|-----------------------|---------------------|
| pkgver                | Brench "master"     |
| Build type            | Release             |
| MPI enabled           | yes                 |
| Parallel HDF5 enabled | no                  |
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

Isso criará um pacote, algo como `openmc-ompi-nopy-v0.15.0-1-x86_64.pkg.tar.zs`. Envie esse pacote para todos as máquinas do clusler com:

```
scp openmc-ompi-nopy-v*.pkg.tar.zst  USER@HOST:/home/openmc
```

Acesse a cada máquina com SSH e depois instale:

```
ssh USER@HOST
pacman -S openmc-ompi-nopy-v*.pkg.tar.zst
```

No computador pai, dê acesso SSH sem senha aos computadores filhos (será necessário pelo MPI para computação em cluster):
```
ssh-keygen -t rsa #EXECUTE ESSE COMANDO APENAS UMA VEZ NA VIDA (PARA NÃO SOBRESCREVER A CHAVE CRIADA)
ssh-copy-id USER@HOST1
ssh-copy-id USER@HOST2
ssh-copy-id USER@HOST3
...
```

Para construir a API do python no computador pai:

```
python -m venv openmc-env
source openmc-env/bin/activate
cp -r /opt/openmc/openmc-src/ ~/
cd openmc-src/
python -m pip install .
rm -rf ~/openmc-src/
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
