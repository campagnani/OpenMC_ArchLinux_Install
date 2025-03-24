# Instalação do OpenMC - Opção 2: Compilando e instalando a partir do AUR

## Método AUR oficial

O método oficial de instalar programas do AUR é clonando o reposítorio, construindo o pacote e instalando, entretanto você deve fazer o mesmo para TODAS as dependências:

```Bash
git clone https://aur.archlinux.org/openmc-git.git
cd openmc-git
makepkg -si
```

## Método AUR helpers

Existem programas denomidados "AUR helpers" como ```paru``` e ```yay``` que automatizam esse processo, caso você tenha algum deles instalados, basta executar:

```Bash
paru -S openmc-git
```

ou

```Bash
yay -S openmc-git
```

Ou comandos similares.