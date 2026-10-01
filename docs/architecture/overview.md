# Arquitetura inicial

## Contexto
A primeira versão é Flutter/Dart, com um app único para Web/WasmGC e Android. O build de demonstração não contém persistência nem comunicação de rede; os exemplos estão codificados como texto fictício.

## Diagrama

```mermaid
flowchart LR
  Person["Pessoa usuária"]
  UI["Flutter UI"]
  Demo["Conteúdo fictício local"]
  Person --> UI
  UI --> Demo
```

Não existe backend, banco, telemetry, autenticação, modelo, agente, conexão com profissional ou ferramenta externa no protótipo.

## Arquitetura futura, sujeita a revisão
Se pesquisa posterior justificar IA, manter cliente Flutter separado de serviço intermediário, com autenticação, autorização, validação de finalidade e orquestração restrita. O modelo não deve acessar dados diretamente nem operar ferramentas: um adaptador explícito aplica allowlist, valida entrada e saída, registra metadados mínimos e requer aprovação da pessoa antes de exportar/compartilhar.

```mermaid
flowchart TD
  Client["Flutter: Web WasmGC / Android"]
  Consent["Consentimento e controles"]
  Gateway["Gateway de domínio restrito"]
  Agent["Agente sem autonomia clínica"]
  Review["Revisão explícita da pessoa"]
  Client --> Consent
  Consent --> Gateway
  Gateway --> Agent
  Agent --> Review
  Review --> Client
```

## Restrições de plataforma
- Web: testar build WasmGC nos navegadores realmente suportados; manter fallback JavaScript somente se necessário e documentar diferenças.
- Android: definir minSdk e permissões somente quando uma função real exigir; solicitar nenhuma permissão no demo.
- Não assumir paridade perfeita entre armazenamento, acessibilidade ou rede nas duas plataformas.
