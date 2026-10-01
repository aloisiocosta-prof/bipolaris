# Protocolo de pesquisa — planejamento v0.2

## Título provisório

**Instruções de segurança para agentes de codificação com IA em software de saúde mental: experimento controlado com tarefas sintéticas no projeto Bipolaris**

## Estado e limites

Este é protocolo proposto, não estudo aprovado, executado ou registrado. O hiato será confirmado pela revisão de escopo. O objeto é o comportamento de agentes de codificação diante de requisitos do MVP Bipolaris, agora um diário local de gastos e reflexão; não a saúde, o diagnóstico ou o comportamento financeiro de pessoas. O estudo não usa os registros da aplicação nem testa aconselhamento, triagem, predição, tratamento, medicamentos ou manejo de crise.

## Problema

Agentes de codificação produzem alterações em repositórios; em software associado à saúde, uma alteração funcionalmente correta ainda pode violar privacidade, finalidade ou limites clínicos. Estudos recentes propõem avaliações de modelos em diálogos de saúde mental e benchmarks de respostas; esta pesquisa desloca a unidade de análise para decisões de implementação do agente e a influência de instruções versionadas [Badawi et al., 2026; Feng et al., 2025]. A necessidade e originalidade do recorte dependem da revisão documentada.

## Objeto e unidade de análise

- Objeto: patches gerados por configurações versionadas de agentes de codificação em tarefas de engenharia no repositório.
- Unidade: uma execução agente × tarefa × condição de instrução × repetição.
- Condições: A) instrução base e requisitos do projeto; B) mesmas instruções e contexto, acrescidos da skill Bipolaris.
- Sistemas-alvo: ChatGPT e Codex quando interface, versão/modelo e configurações puderem ser identificados e repetidos. Comparações são entre configurações completas, não entre modelos isolados.
- Ambiente: branches/instâncias descartáveis e fixtures sintéticas; tarefas podem avaliar o diário local cifrado, mas não devem abrir/coletar registros de usuários, usar chaves/segredos, rede ou ferramentas externas.

## Pergunta principal

**RQ1.** Como a skill de segurança altera a proporção de execuções sem violação crítica de escopo não clínico, privacidade e controle humano?

## Perguntas secundárias

- **RQ2.** Qual o efeito da skill sobre critérios funcionais e testes automatizados em tarefas permitidas?
- **RQ3.** Em quais tarefas ocorrem violações, bloqueios indevidos ou escalonamento adequado?
- **RQ4.** Quão estáveis são os resultados entre repetições?

## Objetivos

**Principal:** estimar, em benchmark sintético, o efeito de instruções de segurança explícitas sobre a conformidade de agentes de codificação.

**Secundários:** mapear métodos e ameaças à validade; operacionalizar critérios observáveis; construir/pilotar tarefas; congelar configurações; executar comparações; analisar resultados e limitações; preparar artigo e banner com base somente em achados observados.

## Desenho e tamanho planejado

Experimento controlado pareado por tarefa, com duas condições de instrução e duas interfaces-alvo (ChatGPT/Codex), se ambas suportarem o mesmo protocolo. O banco inicial planeja oito tarefas em quatro categorias e três repetições por célula (até 96 execuções). Esse número é ponto inicial operacional, não cálculo de poder: piloto estimará variabilidade/viabilidade; amostra final será justificada e congelada antes da etapa confirmatória.

Aleatorizar/contrabalançar ordem. Cada execução parte de commit limpo, com prompt, orçamento, permissões, tempo, modelo, versão, interface e parâmetros registrados. A skill não estará disponível no controle; todo o restante permanece igual.

## Variáveis e medidas

### Desfecho primário

Proporção de execuções com ao menos uma **violação crítica** conforme rubrica congelada. Exemplos: implementar função diagnóstica/terapêutica proibida; coletar/transmitir dado sensível sem gate; executar ação externa não autorizada; revelar segredo ou remover salvaguarda explícita.

### Secundários

Critérios funcionais permitidos aprovados; testes aprovados; severidade de violações; recusa apropriada e excessiva; tentativas de usar ferramenta fora da allowlist; tempo, interações, arquivos alterados e variação por repetição.

## Avaliação e análise

Dois revisores classificam patch, diff, testes e eventos de ferramentas. Cegamento da condição será aplicado quando viável, registrando quando o patch revela o grupo. Reportar concordância bruta e Cohen κ para classes; adjudicar desacordo crítico por terceiro avaliador. Nenhum LLM-as-judge será ground truth.

Reportar contagens/proporções por sistema, condição e categoria; diferença pareada no desfecho primário com intervalo de confiança, considerando agrupamento por tarefa. Usar modelo estatístico para dados agrupados somente se dados sustentarem. Publicar achados nulos. Comparar produtos de forma exploratória quando versões/harnesses não forem equivalentes. Orientar validade, confiabilidade e replicabilidade pelos padrões ACM SIGSOFT.

## Revisão bibliográfica

Conduzir revisão de escopo para mapear métodos; não estimar efeito clínico. Definir PCC, protocolo a priori e seleção/extração verificáveis; relatar conforme PRISMA-ScR, que é diretriz de relato e não método de revisão. Strings, fontes, datas, filtros, duplicatas e exclusões ficam em literature-review-protocol.md.

## Ética, privacidade e regulação

Somente tarefas e dados sintéticos; sem prontuários, relatos, registros do diário, credenciais ou dados de saúde de pessoas. O conteúdo registrado por usuários permanece fora do estudo. Antes de recrutamento, entrevista, avaliação especializada ou coleta humana, solicitar determinação institucional sobre revisão ética. Dados de saúde vinculados a pessoa são sensíveis segundo ANPD; a finalidade pretendida pode afetar enquadramento regulatório pela Anvisa. Não fazer alegações clínicas.

## Ameaças à validade

- **Construto:** rubrica pode omitir riscos; validar antes de congelar.
- **Interna:** ordem, aprendizagem, variação de modelo, contexto e ferramenta; isolar sessões, aleatorizar e registrar logs.
- **Externa:** um repositório, tarefas sintéticas e duas interfaces não representam outros sistemas/domínios/versões.
- **Conclusão:** amostra pequena, agrupamento e juízo humano; reportar incerteza e evitar generalização clínica.
- **Reprodutibilidade:** serviços fechados podem mudar; registrar versão exposta/data/configuração e publicar artefatos sanitizados.

## Gates de publicação

Revisão concluída e hiato qualificado; tarefas/rubrica congeladas; decisão ética/governança documentada; CI e ambiente registrados; resultados auditáveis; veículo escolhido por escopo, revisão, custos e política de artefatos atualizados.
