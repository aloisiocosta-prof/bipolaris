# Bipolaris — protótipo acadêmico

Protótipo Flutter para Web (WasmGC) e Android, redesenhado como ponto de partida de pesquisa sobre interfaces controladas pela pessoa e agentes de IA de escopo restrito.

> **Demonstração somente:** contém texto fictício; não digite nem importe informações pessoais ou de saúde. Não oferece diagnóstico, tratamento, recomendação de medicamentos, avaliação de risco ou atendimento de emergência. Nenhum modelo/agente está conectado.

## Estado do projeto

- v0.1: tela estática demonstrativa, sem persistência, rede, telemetria ou entrada de dados.
- CI verifica formatação, análise, teste Flutter e builds Web/Wasm e Android.
- Documentos de escopo, arquitetura, política futura de agentes, ameaças e plano de avaliação estão em [docs](docs/).

## Executar

Com Flutter stable instalado:

```sh
flutter create . --platforms web,android --project-name bipolaris
flutter pub get
flutter run -d chrome
flutter test
flutter build web --wasm
flutter build apk --debug
```

A saída Wasm requer navegador compatível com WasmGC; verifique a matriz oficial do Flutter antes de definir suporte de produção: https://docs.flutter.dev/platform-integration/web/wasm.

## Próximas etapas de pesquisa

1. Revisar finalidade pretendida, requisitos e riscos com profissionais e pessoas com experiência vivida.
2. Fazer avaliação de privacidade, segurança e acessibilidade com dados fictícios.
3. Submeter protocolo à governança ética aplicável antes de pesquisa com participantes.
4. Avaliar enquadramento regulatório antes de divulgar qualquer finalidade médica ou clínica.
5. Só então decidir se cabe persistência local, backend ou integração de IA.

Consulte [a visão do produto](docs/product/vision.md), [política para agentes](docs/ai/agent-policy.md), [modelo de ameaças](docs/security/threat-model.md), [plano de avaliação](docs/research/evaluation-plan.md) e [fontes](docs/references.md).
