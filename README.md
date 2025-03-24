# OpenMC - ArchLinux

Instruções de instalação do OpenMC para ArchLinux.

Opções:
1. [Instalação (binários) de qualquer versão a partir do conda]() (recomendado para iniciantes).
2. [Instalação (compilação) da versão em desenvolvimento a partir da versão disponível no AUR]() (```openmc-git```).
3. [Instalação (compilação) da última versão "estável" a partir desse repositório]() (```openmc-bin``` & ```openmc-pythonenv```).


## Explicações e sugestões

1. A instalação a partir do conda (binários já compilados) é a melhor opções para usuários de ArchLinux devido a quantidade frequente de atualizações que criam a necessidade de recompilar o OpenMC por causa das depêndencias. 
Se você vai rodar em um ÚNICO computador, pode instalar tranquilamente usando esse método, é o mais recomendado.
Se for rodar em cluster (vários computadores em paralelo) irá dar erro devido ao ```hdf5-openmpi``` de acordo com [OpenMC Forum #606](https://openmc.discourse.group/t/depletion-simulation-on-supercomputer-gets-stuck-between-depletion-steps/606) --> [GitHub #1566](https://github.com/openmc-dev/openmc/pull/1566).
2. A versão disponível no AUR (```openmc-git```) irá instalar a versão em desenvolvimento disponível no github do OpenMC, além de várias dependências. Altamente não recomendado.
3. A versão disponível nesse repositório (```openmc-bin``` & ```openmc-pythonenv```) foi baseada na disponível no AUR (```openmc-git```), mas com severas modificações:
    - Instala a última versão "estável" ao invés da versão em desenvolvimento.
    - Necessita de menos dependências.
    - Usa ```hdf5``` ao invés de ```hdf5-openmpi``` para compilar o openmc, viabilizando o uso em cluster.
    - Pacote separado em "binários do openmc" (```openmc-bin```) e "ambiênte python para openmc"(```openmc-pythonenv```).
    - Etc.
