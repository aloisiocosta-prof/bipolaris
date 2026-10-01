# Critérios funcionais e de segurança

| ID | Critério observável | Evidência |
|---|---|---|
| F-01 | Criar cofre com senha e confirmação | Widget/manual |
| F-02 | Cofre existente exige senha | Teste de widget |
| F-03 | Registrar valor positivo BRL, categoria, data e planejada/não planejada | Teste de formulário |
| F-04 | Estado, motivação, descrição e reflexão são opcionais | Teste de formulário |
| F-05 | Listar, editar e apagar um registro | Teste de interface |
| F-06 | Ver total e soma/contagem por estado que a pessoa escreveu | Teste unitário/widget |
| F-07 | Resumo explica que é descrição, sem causa/diagnóstico | Teste de texto |
| F-08 | Exportar JSON com aviso de que não está cifrado | Teste de interface |
| F-09 | Apagar um ou todos os registros após confirmação | Teste de interface |
| F-10 | Bloquear e desbloquear o diário | Teste de widget |
| S-01 | Preferência local não contém texto reflexivo legível | Teste de cofre |
| S-02 | Senha errada não abre os registros | Teste de cofre |
| S-03 | Cada gravação usa nonce novo; tag autentica o conteúdo | Teste de cifra |
| S-04 | Nenhuma chamada de rede envia dados do diário | Inspeção de código |
| S-05 | Fixtures usam apenas dados fictícios | Revisão do repo |
| S-06 | Texto não sugere diagnóstico, causa ou conselho | Teste/revisão |

## Plataformas

CI: format, analyze, tests, build Web/Wasm e APK. Teste manual: criar, desbloquear, cadastrar, recarregar, editar, excluir e exportar no navegador; repetir gravação e desbloqueio no Android.
