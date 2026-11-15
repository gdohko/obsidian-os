# Obsidian OS

Distribuição Live em desenvolvimento baseada em Debian 13 (Trixie), AMD64 e KDE Plasma 6 sobre Wayland.

## Build automatizado

O workflow **Build Obsidian OS ISO** é acionado a cada push na branch `main` e também pode ser iniciado manualmente em **Actions → Build Obsidian OS ISO → Run workflow**.

O artefato esperado é `obsidian-os-0.1.0-amd64.iso`, acompanhado de SHA-256. Considere a ISO produzida somente quando o workflow terminar com sucesso e o artefato estiver disponível.

## Conteúdo inicial

- Debian 13 Trixie / AMD64, kernel Debian e sessão Live com SDDM
- KDE Plasma 6 Wayland como sessão padrão; XFCE disponível como sessão alternativa
- Layout inicial Obsidian: barra superior Plasma com lançador, tarefas, bandeja do sistema e relógio; dock Plank inferior
- Identidade Desert/Obsidian: papel de parede de dunas, esquema escuro Breeze e logotipo do projeto
- Dolphin como gerenciador de arquivos, Konsole, Ark, Kate, Firefox ESR e utilitários multimídia
- Tema Plymouth Obsidian durante o carregamento
- Live boot híbrido com GRUB para BIOS legado e UEFI
- Firmware disponível nos repositórios Debian e ferramentas de diagnóstico e suporte a sistemas de arquivos comuns

O layout Plasma é aplicado no primeiro login por um script idempotente. O dock Plank usa XWayland; o compositor Picom fica restrito à sessão XFCE.

## Limitações da primeira versão

Para evitar a falha do live-build no Debian Trixie ao buscar o índice Contents no caminho antigo, a primeira ISO não incorpora o Debian Installer. Esta versão é uma imagem Live inicial para validação, ainda sem instalador gráfico próprio, instalador Debian integrado, persistência USB pré-configurada, perfis de energia, ZRAM adaptativa, Waydroid, camada de jogos ou Obsidian Studio. Drivers NVIDIA proprietários não são instalados automaticamente. A compatibilidade precisa ser validada em máquinas físicas e virtuais.

## Build local

O workflow usa GRUB para BIOS e UEFI e chama os scripts com Bash explicitamente para não depender do bit de execução preservado pelo GitHub Contents API.

Em Debian Trixie AMD64, com privilégios root, conexão à internet e espaço livre amplo (recomendado 30 GB):

```bash
./build-iso.sh
```
