# Instalação do OpenMC - Opção 1: Via Conda

Você pode simplesmente executar o script automático desse repositório, MAS recomendo fazer manualmente para aprender.

### Script assistido:

```Bash
curl -L https://raw.githubusercontent.com/campagnani/OpenMC_ArchLinux_Install/refs/heads/main/openmc-conda.sh | bash -
```

### Manual:

[Instale as seções de choque conforme instrulções]() (pode ser feito depois).

Instale algum conda, como por exemplo o ```miniconda3```(vantagem de ser leve):

```Bash
paru -S miniconda3
```

Se tiver instalado o ```miniconda3```, adicione o carregamento do perfil do conda no ```.bashrc``` do usuário (deve ser feito para cada usuário que quiser usar o ```miniconda3```):
```Bash
echo '''
#MiniConda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
''' >> ~/.bashrc
```

Recarregue o ```.bashrc```:
```Bash
source /opt/miniconda3/etc/profile.d/conda.sh
```

Adicione o repositório conda-forge ao conda:
```Bash
conda config --add channels conda-forge
```

Crie um ambiente "openmc-env" (ou o nome que você quiser):
```Bash
conda create -n openmc-env
```

Ative o ambiente criado:
```Bash
conda activate openmc-env
```

Instale o mamba no ambiente:
```Bash
conda install mamba
```

Agora você precisa escolher a versão do OpenMC que quer instalar. Se quiser instalar qualquer uma, apenas rode:
```Bash
mamba install openmc
```

Para escolher, primeiro liste as opções disponíveis de instalação do openmc com:
```Bash
mamba search openmc
```

Então substituia os valores das varíaveis abaixo para a versão escolhida e execute:
```Bash
OPENMC_VERSION=0.15.0
OPENMC_BUILD=nodagmc_nompi_py312h43f8915_1
mamba install openmc[version=$OPENMC_VERSION,build=$OPENMC_BUILD]
```

Neste exemplo foi escolhida a versão "0.15.0" compilada sem "DAGMC", sem "MPI" e com "Python 3.12".