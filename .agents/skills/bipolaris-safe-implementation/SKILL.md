---
name: bipolaris-safe-implementation
description: Implementar e verificar o diário local de gastos/reflexão Bipolaris, seus artefatos e salvaguardas.
---

# Implementação segura do Bipolaris

## Contexto autorizado

Bipolaris é um MVP Flutter Web/Wasm e Android que permite registrar gastos e acrescentar autorrelatos opcionais. Resumos descrevem os próprios registros; não há função clínica ou inferência automatizada. O diário usa cofre local cifrado por senha, sem backend ou sincronização. A implementação local está autorizada; isso não autoriza coleta de pesquisa ou integração externa.

## Antes de alterações

1. Ler visão de produto, arquitetura, critérios de aceite, tratamento de dados e threat model.
2. Classificar a mudança como permitida, sensível, clínica, externa ou ambígua.
3. Usar dados sintéticos em fixtures, testes, screenshots de CI, issues e releases.
4. Verificar Web/Wasm e Android separadamente; não presumir paridade.
5. Testar funcionalidade e invariantes de privacidade/cifra.
6. Registrar comandos, ambiente, resultados e limitações.

## Permitido

- CRUD local de gastos e autorrelatos opcionais.
- Totais agrupados descritivamente pelos termos escritos pela pessoa.
- Cifra local, bloqueio, exclusão e exportação explícita com aviso de JSON sem cifra.
- Melhorias de acessibilidade, documentação e testes nas duas plataformas.

## Proibido sem nova autorização e governança

- Diagnóstico, previsão de episódio, risco, triagem, terapia, conselho médico/financeiro ou alegações clínicas.
- Enviar, sincronizar, compartilhar, treinar modelos ou enviar dados a APIs, bancos, analytics ou terceiros.
- Inserir registros de usuários, identificadores, credenciais ou exportações em repo, issues, CI, logs ou releases.
- Ações externas automáticas ou acesso a ferramentas não autorizadas.
- Alegar conformidade LGPD, auditoria criptográfica, aprovação ética ou validação sem evidência.

## Salvaguardas e relato

Não registrar conteúdo pessoal em logs; erros de desbloqueio são genéricos. Mudanças em finalidade, rede, armazenamento, criptografia ou compartilhamento exigem revisão humana e atualização dos documentos. Pesquisa com pessoas requer governança aplicável antes de qualquer coleta.

Reportar arquivos alterados, comportamento, testes/builds realmente executados, limitações de plataforma e riscos não avaliados.
