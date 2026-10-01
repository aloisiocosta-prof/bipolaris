# Plano de documentação, publicação e apresentação — Bipolaris

**Versão do plano:** 0.1  
**Estado em 2026-10-01:** pipeline submetido à CI; artigo-protocolo e banner permanecem trabalhos em andamento, sem resultados empíricos.

## Decisão editorial

A versão inicial é um **protocolo/proposta de pesquisa e artefato de software**, não um artigo de resultados. O banner deve identificar “protocolo em elaboração” e manter a área de resultados sem valores até a análise real. O hiato de pesquisa permanece provisório até concluir e documentar a revisão de escopo [Ralph et al., 2020; Tricco et al., 2018].

## Objetivo do pipeline

Para cada versão SemVer aprovada, compilar e anexar à Release do GitHub:

1. `bipolaris-article-vX.Y.Z.pdf`: manuscrito de protocolo em LaTeX/abnTeX2.
2. `bipolaris-poster-banner-vX.Y.Z.pdf`: banner científico horizontal provisório, marcado WIP.
3. `bipolaris-web-pages-vX.Y.Z.zip`: conteúdo integral de `build/web`, compilado Flutter WebAssembly GC com manifest PWA, service worker e base path do GitHub Pages.
4. `BUILD-INFO.txt` e `SHA256SUMS.txt`: proveniência e checksums da compilação.

Git tags identificam o commit da release, e os arquivos ficam anexados à versão para download, em vez de depender somente da retenção temporária de artefatos Actions [GitHub Docs, 2026a; GitHub Docs, 2026b].

## Fluxo e gates

| Gate | Atividade | Evidência | Critério para avançar |
|---|---|---|---|
| 0. Integridade científica | Confirmar protocolo, pergunta, medidas, limites clínicos e estado WIP | Protocolo, fontes e rubrica versionados | Nenhum dado, métrica ou resultado inventado |
| 1. Build acadêmico | Compilar artigo e banner com TeX Live/abnTeX2 | PDFs de prova | Build sem erro; banner de uma página; referências resolvidas |
| 2. Flutter Web/PWA | Format/analyze/test, build WasmGC, base path, manifest, ícones e SW | `build/web` validado e ZIP | URLs sob `/bipolaris/`; manifesto e cache verificados |
| 3. CI do PR | Executar jobs Flutter e acadêmico | Logs e artefatos Actions | Todos os jobs verdes antes de integrar |
| 4. GitHub Pages | Implantar `build/web` da `main` com Pages Actions | URL pública e deployment | HTTPS, caminho do projeto, WasmGC, instalação e navegação verificados |
| 5. Release SemVer | Criar branch `release/vX.Y.Z`; validar versão; compilar; publicar | Tag, Release, PDFs, ZIP, build info, hashes | Commit, versão, arquivos e SHA-256 conferidos |
| 6. Publicação científica | Revisar, pilotar, congelar protocolo, obter decisão ética e executar estudo | Análise reproduzível e manuscrito atualizado | Conclusões limitadas aos dados, com requisitos éticos resolvidos |

## Estratégia de versão

- Usar `MAJOR.MINOR.PATCH` em tags `vMAJOR.MINOR.PATCH`.
- `0.y.z` identifica protótipos de pesquisa sem alegação de produto clínico; PATCH para correções, MINOR para artefatos ou protocolo compatíveis, MAJOR após estabilidade formal do contrato de publicação.
- A tag precisa coincidir com `version:` em `pubspec.yaml`; a action interrompe em caso de divergência.
- Criar branch explícita `release/vX.Y.Z` a partir do commit integrado após CI verde. A automação compila primeiro, cria release em rascunho com todos os arquivos e a publica após validações.
- Não reescrever tag publicada; corrigir por nova versão. SHA-256 ajuda a detectar alterações acidentais.

## LaTeX e revisão editorial

O artigo usa abnTeX2 e as referências BibTeX versionadas. ABNT controla apresentação/citações, mas não demonstra validade científica. Toda afirmação deve ser rastreável; nenhuma hipótese pode aparecer como resultado. O banner usa 120 × 90 cm apenas como prova provisória; adequar ao edital antes de imprimir ou submeter. Afiliação, coautores, financiamento, evento e dimensões finais dependem de confirmação dos autores.

A CI compila os arquivos, confirma os PDFs e conta páginas. Revisão humana pré-release deve abrir os PDFs renderizados e verificar cortes, escala real, contraste, referências, autoria, edital, direitos e acessibilidade. CI não substitui revisão por pares, parecer ético, revisão linguística ou inspeção visual.

## Flutter Web, WasmGC, PWA e Pages

Pages e o ZIP vêm do mesmo comando `./tool/build_web.sh`, com `--wasm --base-href /bipolaris/`. O script ajusta escopo/URLs do manifesto, registra service worker e armazena em cache respostas same-origin visitadas. O Flutter não gera service worker por padrão; portanto, offline e instalação exigem configuração/testes próprios [Flutter Docs, 2026].

Testar navegador compatível com WasmGC, instalação, primeira carga, recarga offline depois que recursos foram visitados, atualização de versão e navegação. O cache offline se limita ao app/recursos já acessados; não há backend nem sincronização. O ZIP está preparado para o caminho `/bipolaris/`; outro host/base exige rebuild.

O Pages é público e depende da configuração inicial com origem “GitHub Actions” nas Settings do repositório; depois, o workflow implanta o artefato [GitHub Docs, 2026c]. URL esperada: `https://aloisiocosta-prof.github.io/bipolaris/`.

## Skills e conexões

- **GitHub:** branch/PR, Actions, artefatos temporários, Releases e deployment Pages.
- **Web + docs oficiais:** verificar comportamento do Flutter Wasm/PWA, Pages, retenção de artifacts e toolchain LaTeX.
- **computing-research-lifecycle:** gates até análise, documentação e publicação.
- **computing-academic-documentation:** coerência entre pergunta, método, evidência e gênero textual.
- **computing-publication-strategy:** escolher revista/conferência após maturidade do manuscrito e verificar taxas, escopo e políticas atuais.
- **computing-academic-poster:** preservar o estágio WIP e adequar às regras do evento.
- **SciSpace/Consensus/Scite:** usar na revisão futura se houver conexão; verificar resultados no artigo/DOI e registrar busca/data.

## Próximas decisões dos autores

1. Confirmar autores e afiliação institucional.
2. Escolher evento e fornecer chamada/template/dimensões do banner.
3. Confirmar publicação pública do site e dos PDFs.
4. Configurar Settings → Pages → Build and deployment → Source: GitHub Actions caso a implantação não consiga habilitar o Pages.
5. Depois do merge e do CI verde, criar `release/v0.1.0` e revisar arquivos/hashes antes de divulgar.
