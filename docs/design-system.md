# Design system e interação do diário

## Objetivo

A interface ajuda uma pessoa a registrar uma despesa, se quiser descrever seu próprio estado e motivação, e depois localizar e rever os registros. Os termos e agrupamentos representam somente o que a pessoa informou. O app não classifica emoções, infere intenção, estabelece causalidade, faz diagnóstico ou recomenda ações.

O app Clue é uma referência de fluxo visual, não um modelo de domínio: adaptamos ideias gerais de escolha rápida, registro simples e revisão temporal. Não reutilizamos sua marca, ilustrações, identidade visual, conteúdo nem recursos de ciclo menstrual. Comentários da loja são sinais qualitativos isolados, não uma amostra representativa ou requisito de produto.

## Decisões do sistema

| Elemento | Decisão no Bipolaris | Regra de uso |
|---|---|---|
| Cor primária | Ameixa #655078 | Ações principais e foco; não codifica estados emocionais |
| Cor secundária | Verde azulado #236B63 | Ênfase discreta, nunca sem rótulo |
| Superfície | Fundo lavanda muito claro e cartões brancos | Separar grupos de informação sem painéis densos |
| Texto | Carvão #263238 | Contraste e leitura acima de decoração |
| Forma | Cartões arredondados e bordas suaves | Agrupar resumo, filtros e registros |
| Ação principal | “Registrar gasto” em botão fixo | Manter acesso ao fluxo principal |
| Resposta emocional | Chips opcionais mais “Outro / escrever” | Permitir sugestão rápida, resposta própria ou nenhuma resposta |
| Revisão | Filtros “Tudo”, “Este mês”, “30 dias” e categoria | Deixar explícito o intervalo usado no total e na lista |
| Linguagem | “Estado que você descreveu” | Não apresentar agrupamento como medida clínica |

## Fluxo de registro

1. A pessoa insere valor, categoria e data.
2. Pode marcar se a compra foi planejada.
3. Pode escolher uma sugestão para o estado e para a motivação, escrever sua própria resposta, ou deixar ambos vazios.
4. Pode acrescentar descrição e reflexão pessoal.
5. Salvar mantém o conteúdo no diário local protegido pela senha.

As opções são pontos de partida, não uma escala validada. Os chips não têm hierarquia de gravidade e “Impulso” não é inferido pelo sistema. Alterar os rótulos ou remover opções não altera interpretação automatizada, pois não existe tal interpretação.

## Revisão e filtros

Período e categoria afetam conjuntamente a lista, o total e o agrupamento por estado autodescrito. “30 dias” cobre hoje e os 29 dias anteriores, excluindo datas futuras. “Este mês” usa mês e ano locais atuais. “Tudo” inclui todo o histórico. Os agrupamentos não descrevem associação ou causa entre emoção e gasto; apenas somam valores associados ao mesmo texto informado.

## Acessibilidade e responsividade

- Usar alvos de toque de pelo menos 48 × 48 dp nos controles interativos e checar contraste do texto; validar também navegação por teclado/leitor de tela e escala ampliada.
- Manter os chips em quebra automática e o formulário rolável para telas estreitas e teclado aberto.
- Empilhar cartões de resumo quando a largura disponível for menor que 600 dp; em larguras maiores, exibi-los lado a lado. Esse limite é uma decisão do projeto e possui teste de widget.
- Usar rótulos de campo, texto auxiliar e tooltips; cor sozinha não comunica estado.
- Conferir semântica Web em widgets personalizados e fazer teste manual nos leitores de tela suportados antes de alegar conformidade.

Esses valores seguem recomendações de implementação do Flutter e são critérios de desenvolvimento, não uma declaração de conformidade WCAG ou certificação. Ver “Flutter accessibility” nas referências.

## Critérios de aceitação

- [ ] Registrar e editar uma despesa preserva os textos autodeclarados.
- [ ] Pular estado/motivação é válido; opções rápidas e texto livre funcionam.
- [ ] Alterar período ou categoria atualiza lista, total, contagem e agrupamentos de forma coerente.
- [ ] Excluir e persistir continuam funcionando com o cofre cifrado.
- [ ] Interface continua rolável em janela estreita e com teclado virtual aberto.
- [ ] Nenhum rótulo sugere diagnóstico, causalidade ou aconselhamento.
- [ ] Verificar contraste, alvos de toque, semântica e escala com ferramentas do Flutter e revisão manual.

## Base de evidências e limites

A revisão exploratória de Vial, Boudhraâ e Dumont descreve a necessidade de relatar melhor o envolvimento de usuários no desenho de intervenções digitais de saúde mental; ela informa a escolha de documentar fluxos e critérios, mas não avalia Bipolaris. O estudo de desenvolvimento centrado em usuários de um rastreador de humor e ciclo menstrual reporta necessidades específicas do grupo estudado; suas conclusões não são generalizadas aqui para pessoas com transtorno bipolar ou para gastos financeiros. A listagem e comentários de loja do Clue serviram apenas como referência exploratória de interface. Não foram coletados dados de participantes para este trabalho.

## Referências

- Material Design 3. Foundations. https://m3.material.io/foundations/
- Flutter. Use themes to share colors and font styles. https://docs.flutter.dev/cookbook/design/themes

- Vial S, Boudhraâ S, Dumont M. Human-Centered Design Approaches in Digital Mental Health Interventions: Exploratory Mapping Review. *JMIR Mental Health*. 2022;9(6):e35591. https://doi.org/10.2196/35591
- Developing a Mood and Menstrual Tracking App for People With Premenstrual Dysphoric Disorder: User-Centered Design Study. *JMIR Formative Research*. 2024;8:e59333. https://formative.jmir.org/2024/1/e59333/
- Google Play. Clue Period & Cycle Tracker, listagem e capturas exploradas para referência visual. https://play.google.com/store/apps/details?id=com.popularapp.periodcalendar
- Flutter. Accessibility: UI design and styling. https://docs.flutter.dev/ui/accessibility/ui-design-and-styling
- Flutter. Web accessibility. https://docs.flutter.dev/ui/accessibility/web-accessibility
