# Obsidian OS

Sistema operacional personalizado baseado em Debian 13 (Trixie), arquitetura AMD64, com KDE Plasma e Wayland.

## Objetivo

Construir uma distribuição Live para computadores x86-64, com suporte a inicialização BIOS/UEFI, desktop KDE Plasma, ferramentas essenciais, firmware disponível nos repositórios Debian e possibilidade de persistência em mídia USB.

## Estado do projeto

Este repositório está em fase inicial. A presença dos arquivos de configuração não significa que uma ISO já tenha sido compilada ou testada em hardware real.

## Build

O processo de build será documentado e automatizado por GitHub Actions. Consulte os workflows em `.github/workflows/` quando estiverem disponíveis.

## Escopo inicial

- Debian 13 Trixie / AMD64
- KDE Plasma / Wayland
- Imagem Live híbrida para BIOS e UEFI
- Firmware e drivers disponíveis nos repositórios Debian
- Verificação de integridade SHA-256
- Evolução incremental dos recursos do Obsidian OS
