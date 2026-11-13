# Obsidian OS

Distribuição Live em desenvolvimento baseada em Debian 13 (Trixie), AMD64, KDE Plasma e Wayland.

## Build automatizado

O workflow **Build Obsidian OS ISO** é acionado a cada push na branch `main` e também pode ser iniciado manualmente em **Actions → Build Obsidian OS ISO → Run workflow**.

O artefato esperado é `obsidian-os-0.1.0-amd64.iso`, acompanhado de SHA-256. Considere a ISO produzida somente quando o workflow terminar com sucesso e o artefato estiver disponível.

## Conteúdo inicial

- Debian 13 Trixie / amd64
- KDE Plasma, SDDM, Dolphin e Konsole
- Live boot híbrido para BIOS legado e UEFI
- Debian Installer em modo Live e atalho de instalação no desktop
- Firmware disponível nos repositórios Debian
- Ferramentas de diagnóstico e suporte a sistemas de arquivos comuns
- Identidade visual Obsidian e tema Plymouth para o carregamento do sistema

## Limitações da primeira versão

Esta é uma imagem Live inicial para validação. Ainda não inclui instalador gráfico próprio, persistência USB pré-configurada, perfis de energia, ZRAM adaptativa, Waydroid, camada de jogos ou Obsidian Studio. Drivers NVIDIA proprietários não são instalados automaticamente. A compatibilidade precisa ser validada em máquinas físicas e virtuais.

## Build local

O workflow chama os scripts com Bash explicitamente para não depender do bit de execução preservado pelo GitHub Contents API.

## Build local

Em Debian Trixie amd64, com privilégios root, conexão à internet e espaço livre amplo (recomendado 30 GB):

```bash
./build-iso.sh
```
