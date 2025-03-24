## Dependências: Seções de Choque e Cadeias de Decaimento

O OpenMC necessita de arquivos de seções de choque no formato HDF5 para executar as simulações, e você é obrigado a fornecer a localização dos mesmos. As mesmas podem ser geradas/convertidas para HDF5 usando o NJOY através da API python do openmc.

O pacote nuclear-data (disponível no AUR) faz o favor de baixar as bibliotecas oficiais em formado ACE e converter para HDF5 automaticamente por você (permitindo escolher 1 ou mais bibliotecas), além de permitir escolher as cadeias de decaimento.

AVISO: Cada biblioteca de seção de choque contém vários GB de tamanho, então verifique se você tem espaço em disco disponível, principalmente se for instalar mais de uma biblioteca.

AVISO2: O pacote ```nuclear-data``` instala as seções de choque na pasta ```\opt```, portanto verique se você tem espaço na partição que contém essa pasta (99,9% dos casos: partição raiz).


### Instalando nuclear-data (método AUR oficial)

O método oficial de instalar programas do AUR é clonando o reposítorio, construindo o pacote e instalando (ou você pode usar AUR helpers, conforme descrito mais abaixo):

```Bash
git clone https://aur.archlinux.org/nuclear-data.git
cd nuclear-data
makepkg -si
```

Depois remova o pacote gerado para liberar espaço em disco:
```Bash
cd ..
rm -r nuclear-data
```


### Instalando nuclear-data (método AUR helpers)

Você pode usar AUR helpers como PARU ou YAY caso tenha instalados, apesar de que no caso do pacote ```nuclear-data``` não fará nenhuma diferença pratica pois ele não possuí dependências e não sofre atualizações.

```Bash
paru -S nuclear-data
```

ou 

```Bash
yay -S nuclear-data
```



### Gerando prórias seções de choque com NJOY

Existem algumas vantagens de gerar as prórias seções de choque, como:
- Converter diretamente dos arquivos ENDF.
- Poder escolher as temperaturas.
- Adicionar informações de deposição de calor.
- Etc.

Para isso é necessário ter instalado a API python do openmc (além do NJOY), então siga os próximos passos de instalação do openmc, depois gere suas próprias seções de choque.


### Alternando seções de choque

O openmc lê a variável de ambiênte ```OPENMC_CROSS_SECTIONS``` esperando um camínho para uma bliblioteca de seção de choque, portanto alterar essa varíavel é um jeito de alternar entre as bibliotecas de seções de choque a serem usadas. Outro jeito é definindo o caminho na API python:

```Python
materials = openmc.Materials (....)
materials.cross_sections = "...../cross_sections.xml"
```

O pacote ```nuclear-data``` cria automáticamente essa variável no arquivo ```.bashrc``` do usuário. Com o comando abaixo é possível adicionar em outros usuários:

```Bash
echo '''
#OpenMC Cross Sections
var=`echo /opt/nuclear-data/*hdf5 | head -n1`
export OPENMC_CROSS_SECTIONS=$var/cross_sections.xml
''' >> ~/.bashrc
```

É recomendável deixar a variável ```OPENMC_CROSS_SECTIONS``` apontândo para uma seção de choque oficial do nuclear-data, e quando desejar alterar defina o caminho para a biblioteca adequada à projeto espcífico, assim você garante que CADA PROJETO ira simular com a seção de choque adequada ao mesmo, e não fica na dúvida de qual valor estava defido na `OPENMC_CROSS_SECTIONS` no momento da simulação.