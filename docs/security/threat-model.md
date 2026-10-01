# Modelo de ameaças do diário Bipolaris

## Ativos

Gastos, estados emocionais autodescritos, motivações, reflexões, senha e exportações. Informações de saúde são dados pessoais sensíveis conforme LGPD, art. 5º, II.

## Ameaças e controles

| Ameaça | Controle atual | Risco residual |
|---|---|---|
| Leitura casual do armazenamento | Envelope cifrado AES-256-GCM; chave PBKDF2; senha não persistida | Senha fraca e implementação ainda sem auditoria independente |
| Senha esquecida | Aviso explícito e exportação manual | Sem recuperação, perda permanente |
| Exposição na exportação | Aviso de JSON sem cifra antes de copiar | Clipboard ou destino podem expor conteúdo |
| Dispositivo compartilhado/desbloqueado | Tela inicial exige senha; ação de bloquear | Malware, captura de tela e observação |
| Dados enviados ao servidor/CI | Sem backend; fixtures sintéticas; sem conteúdo nos logs | Origem web comprometida pode ler dados desbloqueados |
| Perda de dados | Aviso e exportação manual | Armazenamento do navegador é best effort; limpar site/desinstalar pode apagar dados |
| Resumo interpretado como diagnóstico | Texto descritivo e sem inferência automática | Usuário pode inferir demais; linguagem precisa continuar clara |

## Antes de uso institucional

Revisão criptográfica independente, atualização do threat model, inventário e avaliação do tratamento, plano de retenção/exclusão/incidentes, verificação de navegadores e Android e avaliação de acessibilidade. Pesquisa com participantes requer determinação ética e governança antes da coleta.

## Limites

Não declarar conformidade LGPD, eficácia, segurança clínica ou status de dispositivo médico. Não inserir registros de usuários em repositório, issues, CI, capturas de tela ou releases. Não adicionar rede, analytics, IA ou compartilhamento sem reavaliação explícita de arquitetura e governança.
