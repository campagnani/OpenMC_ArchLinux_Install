#!/bin/bash

echo """
###############################################################
###############################################################
######                                                   ######
######    Instalação assistida do OpenMC via conda       ######
######                                                   ######
######                                                   ######
######          Distribuição: ArchLinux Rolling          ######
######                                                   ######
######         Autor: Thalles Oliveira Campagnani        ######
######                                                   ######
###############################################################
###############################################################


"""
read -p "Pressione enter para iniciar... "


echo "{[( Instalação de dados nucleares )]}"
read -p "Instalar pacote nuclear-data? [y/N]: " data
if [[ $data == "y" || $data == "Y" ]]; then
    git clone https://aur.archlinux.org/nuclear-data.git
    cd nuclear-data
    makepkg -si
    cd ..

    echo '''
Para outros usuários pode ser necessário adicionar as linhas abaixo no ~/.bashrc:
    #OpenMC Cross Sections
    var=`echo /opt/nuclear-data/*hdf5 | head -n1`
    export OPENMC_CROSS_SECTIONS=$var/cross_sections.xml
'''
fi


echo "{[( Instalação do conda )]}"
read -p """
Instalar pacote miniconda3?
O pacote é necessário somente se você não tiver nenhum onda instalado
[y/N]: """ conda
if [[ $conda == "y" || $conda == "Y" ]]; then
    git clone https://aur.archlinux.org/miniconda3.git
    cd miniconda3
    makepkg -si
    cd ..

    echo '''
Para outros usuários pode ser necessário adicionar as linhas abaixo no ~/.bashrc:
    #MiniConda
    [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
    export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
'''
    # Recarregando BashRC
    source /opt/miniconda3/etc/profile.d/conda.sh
fi

# Adicionando repositório conda-forge ao conda.
conda config --add channels conda-forge

# Criando ambiente openmc-env
conda create -n openmc-env

# Ativiando ambiente openmc-env
conda activate openmc-env

# Instalando mamba no ambiente
conda install mamba


echo "{[( Instalação do OpenMC )]}"
read -p "Deseja escolher a versão do OpenMC? [y/N]: " versao
if [[ $versao == "y" || $versao == "Y" ]]; then
    clear
    echo 'Gerando lista de opções...'
    echo ''
    mamba search openmc
    echo ''
    echo ''
    read -p "Digite a versão (exemplo: 0.15.0) escolhida: " OPENMC_VERSION
    read -p "Digite a build (exemplo: nodagmc_nompi_py312h43f8915_1) escolhida: " OPENMC_BUILD
    VERSION_BUILD="[version=$OPENMC_VERSION,build=$OPENMC_BUILD]"
fi

mamba install openmc$VERSION_BUILD
