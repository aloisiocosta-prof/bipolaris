# Protocolo de revisão de escopo

## Questão e objetivo

Como estudos de computação e saúde mental avaliaram agentes generativos quanto a conformidade com instruções, salvaguardas, privacidade, autonomia, avaliação humana e reprodutibilidade?

Mapear conceitos, métodos, unidades de análise, cenários, métricas, evidência e limitações para fundamentar o experimento. Não avaliar eficácia clínica.

## Método e relato

Revisão de escopo orientada pela metodologia JBI e relatada com PRISMA-ScR. PRISMA-ScR é checklist de relato (20 itens essenciais e 2 opcionais), não método de condução. Considerar PRISMA-S para documentar execução das buscas.

## Fontes previstas

ACM Digital Library; IEEE Xplore; Scopus ou Web of Science (registrar disponibilidade); PubMed/MEDLINE; ACL Anthology; busca retrospectiva e prospectiva de citações. Google Scholar, se usado, será complementar com limite de resultados e data. WHO, NIST, ANPD e Anvisa serão analisados em matriz normativa separada e não contados como estudos empíricos.

## Período, idioma e tipos

2016 até data da busca em 2026; artigos revisados por pares e trabalhos completos de conferências em português ou inglês. Preprints em categoria separada, sem tratá-los como revisão por pares. Atualizar antes da submissão.

## Critérios

**Incluir:** estudos sobre modelos/agentes generativos em programação/software de saúde; avaliação de instruções, salvaguardas, privacidade, autonomia, segurança, colaboração humano-IA, benchmarks ou replicabilidade; estudos de apps para transtorno bipolar quando informarem requisitos/riscos do domínio.

**Excluir:** opinião sem método, propaganda, estudos sem relação com agente generativo ou engenharia/saúde mental, recomendações clínicas automatizadas sem avaliação do sistema, duplicatas e resumos sem dados suficientes.

## Strings iniciais para adaptação por base

```text
("coding agent" OR "AI coding assistant" OR "software engineering agent" OR "agentic coding")
AND (instruction OR policy OR compliance OR safety OR privacy OR guardrail OR evaluation)

("large language model" OR LLM OR "generative AI")
AND ("mental health" OR psychiatric OR bipolar)
AND (agent OR chatbot OR safety OR privacy OR evaluation OR benchmark)

(bipolar OR "bipolar disorder")
AND (app OR smartphone OR digital)
AND (evaluation OR privacy OR usability OR safety)
```

Traduzir cada string à sintaxe da base, testar e revisar. Preservar string exata, data/hora, filtros e resultados. Busca exploratória em 01/10/2026 não é busca sistemática nem seleção final.

## Seleção, extração e síntese

1. Exportar referências e deduplicar por DOI/título.
2. Pilotar título/resumo com dois revisores; resolver divergências e registrar regras.
3. Selecionar texto completo em duplicata ou verificar amostra por segundo revisor.
4. Registrar fluxograma e motivo de exclusão.
5. Extrair: ano, área, domínio/população, sistema/versão, interface/agente, dados, condição, cenário, método, medida, avaliador, artefatos, achados, riscos e limitações.
6. Síntese descritiva e mapa temático; não agregar efeitos incompatíveis.
7. Separar artigos revisados por pares, preprints, normas e documentação.
