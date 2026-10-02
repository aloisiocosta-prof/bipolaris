# Bipolaris — diário financeiro reflexivo

Bipolaris é um MVP Flutter para a pessoa registrar gastos e, se desejar, descrever o próprio estado emocional, a motivação da compra e uma reflexão pessoal. O aplicativo apresenta totais e agrupamentos descritivos dos registros; não infere estados mentais, causalidade, diagnóstico ou tratamento.

## Funcionalidades

- Criar e desbloquear diário protegido por senha.
- Registrar valor em reais, categoria, data, situação planejada/não planejada e descrição opcional.
- Acrescentar estado autodescrito, motivação e reflexão em campos opcionais, com sugestões rápidas e texto livre.
- Consultar, editar e apagar registros.
- Filtrar por todo o histórico, mês atual ou últimos 30 dias e por categoria; lista, contagem, totais e agrupamentos usam os mesmos filtros.
- Ver total registrado e somas descritivas por estado autodeclarado.
- Copiar exportação JSON em texto legível, apagar todos os registros e bloquear o diário.

O racional de UX/UI, fluxos, escolhas visuais, critérios de aceitação e limites das referências está em [docs/design-system.md](docs/design-system.md).

## Privacidade e limites

O conteúdo é cifrado no cliente com AES-256-GCM e chave derivada da senha por PBKDF2-HMAC-SHA256, e salvo localmente no navegador ou dispositivo. A senha não é armazenada nem pode ser recuperada. O app não tem backend, conta, sincronização, telemetria, publicidade, conexão bancária ou integração de IA.

A exportação JSON é **texto sem cifra**; armazene-a em local privado. A persistência local é melhor esforço: limpar os dados do navegador ou desinstalar o app pode apagar registros. A cifra não protege um dispositivo desbloqueado, malware, extensão maliciosa ou página comprometida, e ainda não passou por auditoria criptográfica independente.

Este MVP não foi validado clinicamente, não declara conformidade LGPD e não é dispositivo médico. A LGPD define dados de saúde como sensíveis; qualquer uso institucional ou pesquisa com participantes exige avaliação de privacidade, segurança, base legal, informação aos titulares e determinação ética aplicável. Não versionar dados de usuários, mesmo cifrados, no repositório, CI, issues, capturas de tela ou releases.

O aviso legível “Privacidade e uso” fica acessível antes de criar o diário e pode ser reaberto no menu. Ele explica dados locais, cifra, exportação sem cifra, opções de exclusão e limites do MVP; descreve a versão atual e não declara conformidade jurídica com a LGPD. Veja também [docs/design-system.md](docs/design-system.md).

## Executar

Com Flutter 3.47.5 e Dart 3.9 ou superior:

```sh
flutter create . --platforms web,android --project-name bipolaris
flutter pub get
flutter run -d chrome
flutter test
./tool/build_web.sh
flutter build apk --debug
```

O build Web usa Flutter WebAssembly e publica a PWA em `/bipolaris/`; Android é compilado pela CI. GitHub Pages hospeda a interface estática e não recebe os registros.

## CI/CD

GitHub Actions executa formatação, análise, testes de modelo/cofre/interface, builds Web/PWA e APK e compilação dos documentos acadêmicos. Pages publica `build/web` após alterações do app na `main`. Releases usam SemVer, PDFs, ZIP do build e checksums.

## Estado acadêmico

O protocolo atual propõe estudar instruções de segurança para agentes de codificação usando tarefas sintéticas. O diário é o artefato em desenvolvimento; isso não constitui pesquisa com pacientes nem teste de eficácia clínica. Não há resultados clínicos ou validação com participantes.

## Referências

- Brasil. Lei nº 13.709/2018 (LGPD), texto compilado: https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm
- Astill Wright L, Moore M, Reeves S, Vallejos EP, Morriss R. Coproduction and safety of a bipolar mood-tracking app. *JMIR Formative Research*. 2025;9:e65140. doi:10.2196/65140.
- Michalak EE, et al. Self-monitoring with the PolarUs app: impacts and unmet needs. *Journal of Affective Disorders*. 2025;383:374–384. doi:10.1016/j.jad.2025.04.107.
- ANPD. Guia orientativo de segurança da informação para agentes de pequeno porte, atualizado em 2025: https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-sobre-seguranca-da-informacao-para-agentes-de-tratamento-de-pequeno-porte
- Flutter Wasm: https://docs.flutter.dev/platform-integration/web/wasm
- Flutter accessibility: https://docs.flutter.dev/ui/accessibility
- GitHub Pages: https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
- Dart cryptography: https://pub.dev/packages/cryptography
- Flutter shared_preferences: https://pub.dev/packages/shared_preferences
