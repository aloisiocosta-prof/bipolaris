# Bipolaris — projeto acadêmico de engenharia de software e agentes de IA

**Objetivo:** planejar, conduzir, documentar e apresentar pesquisa sobre requisitos de segurança em agentes de codificação com IA, usando tarefas sintéticas.

O protótipo Flutter Web/WasmGC e Android é um artefato acadêmico. Usa conteúdo fictício, não coleta dados, não se conecta a agentes e não realiza funções clínicas. A pesquisa não avalia eficácia terapêutica, diagnóstico ou resposta a crises. Ver [fontes e limites](docs/references.md).

## Artefatos de pesquisa

- [Protocolo de pesquisa](docs/research/protocol.md)
- [Protocolo de revisão de escopo](docs/research/literature-review-protocol.md)
- [Tarefas sintéticas](docs/research/benchmark-scenarios.md)
- [Rubrica de avaliação](docs/research/rubric.md)
- [Skill de implementação segura](.agents/skills/bipolaris-safe-implementation/SKILL.md)
- [Manuscrito ABNT/LaTeX](paper/main.tex)
- [Fonte LaTeX do banner WIP](presentation/poster.tex)
- [Plano de release e publicação](docs/publication/release-plan.md)

## Artigos, banner e aplicação compilada

A release SemVer anexará três arquivos: PDF do manuscrito de protocolo, PDF do banner marcado como trabalho em andamento e ZIP contendo exatamente a build Flutter Web/PWA destinada ao caminho GitHub Pages. Releases incluem metadados de compilação e checksums SHA-256. Enquanto não houver estudo executado, os PDFs não apresentam resultados empíricos.

- [Releases](https://github.com/aloisiocosta-prof/bipolaris/releases)
- [Site esperado no GitHub Pages](https://aloisiocosta-prof.github.io/bipolaris/)

Para iniciar uma versão depois de integrar à `main`, crie uma branch `release/vMAJOR.MINOR.PATCH` cujo número coincida com `version:` em `pubspec.yaml`. A automação só publicará depois de testes, builds e validação dos PDFs. O manifesto/PWA ZIP usa o caminho `/bipolaris/`; outro host requer rebuild com base path próprio.

## Executar localmente

Com Flutter 3.47.5:

```sh
flutter create . --platforms web,android --project-name bipolaris
flutter pub get
flutter run -d chrome
flutter test
./tool/build_web.sh
flutter build apk --debug
```

## CI/CD

GitHub Actions verifica formatação, análise, teste de widget, builds Web/Wasm e Android, compila os dois PDFs, implanta Pages a partir de `main` e cria releases versionadas com ZIP/PDFs após branch `release/vX.Y.Z`. A primeira publicação Pages exige origem “GitHub Actions” em Settings → Pages. Consulte o [plano de publicação](docs/publication/release-plan.md) e o histórico de [Actions](https://github.com/aloisiocosta-prof/bipolaris/actions).

## Estado científico

Há protocolo proposto e protótipo inicial; a revisão não está concluída, o experimento não foi executado e não existem resultados, submissão ou aceitação. Não inserir dados de pacientes, informações reais de saúde, credenciais ou material identificável neste repositório público.
