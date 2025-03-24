# Instalação do OpenMC - Opção 3: Compilando e empacotando via PKBUILDs deste repositório

## Introdução

Estes PKGBUILDs foram baseados no [openmc-git](https://aur.archlinux.org/packages/openmc-git) disponível no AUR, mas com várias modificações:

- Instala a última versão "estável" (Brench "master") ao invés da versão em desenvolvimento (Brench "develop").
- Redução de dependências.
- Usa ```hdf5``` ao invés de ```hdf5-openmpi``` para compilar o openmc, viabilizando o uso em cluster.
- Pacote separado em "binários do openmc" (```openmc-bin```) e "ambiênte python para openmc"(```openmc-pythonenv```).
- Etc.

O erro causado pelo paralelismo de HDF5 (```hdf5-openmpi```) é explicado em [OpenMC Forum #606](https://openmc.discourse.group/t/depletion-simulation-on-supercomputer-gets-stuck-between-depletion-steps/606) --> [GitHub #1566](https://github.com/openmc-dev/openmc/pull/1566)


## Configuração do PKGBUILD e da compilação.

Essas configurações podem ser alteradas para satisfazer suas necessidades, mas atualmente está configurado para...

### openmc-bin

| pkgname               | openmc-bin            |
|-----------------------|-----------------------|
| pkgver                | Brench "master"       |
| Build type            | Release               |
| MPI enabled           | yes                   |
| Parallel HDF5 enabled | no                    |
| PNG support           | yes                   |
| DAGMC support         | no                    |
| libMesh support       | no                    |
| MCPL support          | no                    |
| NCrystal support      | no                    |
| Coverage testing      | no                    |
| Profiling flags       | no                    |
| INSTALL_PREFIX        | /opt/openmc-bin       |

Dependências para compilação:
- fmt
- hdf5
- libpng
- openmpi
- base-devel
- cmake
- git

Depêndências para instalação (fmt, hdf5, openmpi e libpng são copiados para /opt/openmc-bin/lib):
- openssh
- pugixml

Conflitos:
- hdf5-openmpi


### openmc-pythonenv

| pkgname               | openmc-pythonenv      |
|-----------------------|-----------------------|
| pkgver                | any                   |
| Build type            | Release               |
| INSTALL_PREFIX        | /opt/openmc-pythonenv |

Dependências para compilação:
- python
- python-pip
- openmc-bin

Dependências para instalação:
- python
- openmc-bin




## Instalação (Compilação e Construção)

O processo de compilação do openmc e construção do pacote instalável é igual para instalações individuais ou em cluster. No caso do cluster, esse processo precisa ser feito apenas uma vez no computador pai, enquanto os computadores filhos podem apenas instalar o pacote gerado.

### openmc-bin

O primeiro pacote a ser gerado e instalado deve ser o `openmc-bin`, pois é uma dependência do `openmc-pythonenv`.

```Bash
sudo pacman -Syu #Atualize a distribuição antes
git clone https://github.com/campagnani/OpenMC_ArchLinux_Install
cd OpenMC_ArchLinux_Install/openmc-bin
makepkg -si
```

### openmc-pythonenv

Para gerar o `openmc-pythonenv` é necessário ter INSTALADO o `openmc-bin`, pois ele usa os arquivos em `/opt/openmc-bin/openmc-src`.

```Bash
cd ../openmc-pythonenv
makepkg -si
```

Para atualizar o `openmc-pythonenv` em caso de quebra de dependência, basta ir nessa pasta e rodar `makepkg -si` novamente.


### Ambiênte python individual

Talvez o usuário tenha necessidade de gerenciar seu ambiênte virtual, instalar pacotes, etc. O pacote `openmc-pythonenv` instala o python em pastas do sistema (comum a todos usuários, e não em pasta de um usuário em específico), o tornando inadequado para modificações (exigindo permissões de administrador).

Para instalar um ambiênte python para openmc individual para cada usuário, execute:

```Bash
python -m venv ~/.openmc-env
source ~/.openmc-env/bin/activate
cp -r /opt/openmc-bin/openmc-src/ ~/
cd ~/openmc-src/
python -m pip install . # Pode se adicionar nesta linha: mpi4py scipy==1.11.4
cd
rm -rf ~/openmc-src/
```


## Instalação em cluster

Primeiramente, pelo computador pai dê acesso SSH sem senha aos computadores filhos (será necessário pelo MPI para computação em cluster):

```Bash
ssh-keygen -t rsa #EXECUTE ESSE COMANDO APENAS UMA VEZ NA VIDA (PARA NÃO SOBRESCREVER A CHAVE CRIADA)
USER='Usuário'
HOST1='IP da máquina 1'
HOST2='IP da máquina 2'
HOST3='IP da máquina 3'
#etc..
ssh-copy-id $USER@$HOST1
ssh-copy-id $USER@$HOST2
ssh-copy-id $USER@$HOST3
#etc...
```

Após a execução da sessão anterior, foram criados 2 pacotes do tipo `*.pkg.tar.zs`. Estes são os bínarios já compilados, prontos para serem instalados nos computadores filhos.

Envies esses pacotes para todas as máquinas do clusler com `scp` (repita para cada $HOST[n]):

```Bash
scp openmc-bin-v*.pkg.tar.zst  $USER@$HOST1:/home/$USER
scp openmc-pythonenv-any.pkg.tar.zst  $USER@$HOST1:/home/$USER
```

Acesse cada uma das maquinas com SSH e instale os pacotes que foram copiados (repita para cada $HOST[n]):

```Bash
ssh $USER@$HOST1
sudo pacman -Syu #Atualize a distribuição antes
pacman -U openmc-bin-v*.pkg.tar.zst
pacman -U openmc-pythonenv-any.pkg.tar.zst  $USER@$HOST:/home/$USER
```
