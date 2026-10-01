# Bipolaris — projeto acadêmico de engenharia de software e agentes de IA

**Objetivo:** planejar, conduzir, documentar e apresentar pesquisa sobre o cumprimento de requisitos de segurança por agentes de codificação com IA ao alterar software experimental relacionado à saúde mental.

O protótipo Flutter Web/WasmGC e Android é um artefato de pesquisa. Usa somente texto fictício; não coleta dados, não se conecta a agentes e não realiza funções clínicas. A pesquisa não avaliará eficácia terapêutica, diagnóstico ou resposta a crises. Dados de saúde são sensíveis; qualquer futura coleta requer finalidade e governança apropriadas. Ver [fontes e limites](docs/references.md).

## Pergunta principal proposta

Como instruções de segurança específicas do repositório alteram a conformidade de agentes de codificação com requisitos de escopo não clínico, privacidade e supervisão humana ao implementar tarefas sintéticas no Bipolaris?

O possível hiato permanece provisório até a revisão de escopo.

## Artefatos

- [Protocolo de pesquisa](docs/research/protocol.md)
- [Protocolo de revisão de escopo](docs/research/literature-review-protocol.md)
- [Tarefas sintéticas](docs/research/benchmark-scenarios.md)
- [Rubrica de avaliação](docs/research/rubric.md)
- [Skill de segurança](.agents/skills/bipolaris-safe-implementation/SKILL.md)
- [Esqueleto ABNT em LaTeX](paper/main.tex)
- [Plano do banner](presentation/poster-outline.md)
- [Visão e limites do artefato](docs/product/vision.md), [arquitetura](docs/architecture/overview.md), [modelo de ameaças](docs/security/threat-model.md)

## Estado científico

Há protocolo proposto e protótipo inicial, mas a revisão bibliográfica não foi concluída, o experimento não foi executado e não existem resultados, submissão ou aceitação. Não utilizar dados reais de saúde ou material de pacientes.

## Executar

Com Flutter 3.47.5:

```sh
flutter create . --platforms web,android --project-name bipolaris
flutter pub get
flutter run -d chrome
flutter test
flutter build web --wasm
flutter build apk --debug
```

A compilação WasmGC requer navegadores compatíveis; conferir a documentação Flutter atual antes de afirmar suporte: https://docs.flutter.dev/platform-integration/web/wasm.

## CI

O GitHub Actions verifica formatação, análise estática, teste de widget e builds Web/Wasm e Android. O workflow gera scaffolds de plataforma no runner; esse comportamento e o ambiente devem ser registrados na replicação.
