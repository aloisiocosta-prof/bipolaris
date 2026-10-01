# Tratamento local de dados — Bipolaris

## Dados e finalidade

Cada registro pode conter valor em centavos, data, categoria, compra planejada, descrição, estado autodeclarado, motivação e reflexão. O propósito é permitir à pessoa guardar, rever, editar, apagar e exportar os próprios registros localmente.

## Fluxo

1. A senha deriva uma chave local usando PBKDF2-HMAC-SHA256 e salt aleatório.
2. O conteúdo JSON é cifrado por AES-256-GCM, com nonce renovado a cada gravação.
3. Apenas o envelope cifrado é gravado no armazenamento local.
4. A senha permanece na memória enquanto o cofre está aberto.
5. Exportar copia JSON em claro somente após ação explícita e aviso.
6. Bloquear remove a sessão da interface; apagar remove registros; apagar o cofre remove o envelope.

## Retenção, cópia e limitações

Não há sincronização ou backup automático. JSON exportado é texto legível. Senha perdida não pode ser recuperada. Limpar dados do navegador ou desinstalar pode apagar os registros. A cifra em repouso não protege navegador, sistema operacional, clipboard, origem ou dispositivo comprometidos. shared_preferences descreve persistência best effort.

## Pesquisa

O protocolo de agentes usa apenas tarefas sintéticas. Pesquisadores não acessam nem coletam os registros locais de usuários. Não utilizar entradas reais em testes, documentação, logs, issues, CI ou releases. Atividade de pesquisa com pessoas requer governança e determinação ética/privacidade antes da coleta.
