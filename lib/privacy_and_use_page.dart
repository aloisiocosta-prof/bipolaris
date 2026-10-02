import 'package:flutter/material.dart';

/// Explains how this MVP handles diary data and how to use it.
class PrivacyAndUsePage extends StatelessWidget {
  const PrivacyAndUsePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacidade e uso')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações claras, quando você precisar',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Leia antes de criar o diário ou volte aqui pelo menu '
                      '“Opções do diário”. Em poucas palavras: seus registros '
                      'ficam cifrados neste dispositivo; você escolhe o que '
                      'escrever e pode apagar seus dados.',
                    ),
                  ],
                ),
              ),
            ),
            _InfoCard(
              icon: Icons.edit_note,
              title: 'Como usar o diário',
              paragraphs: const [
                'Registre um gasto e, se quiser, descreva como você se sentia '
                    'ou o que motivou a compra. Esses campos são opcionais; '
                    'você pode deixá-los vazios.',
                'Os totais apenas resumem o que você registrou. O Bipolaris '
                    'não interpreta seu estado, não faz diagnóstico, não '
                    'recomenda tratamento e não detecta crises.',
              ],
            ),
            _InfoCard(
              icon: Icons.storage_outlined,
              title: 'Que dados ficam salvos e onde?',
              paragraphs: const [
                'O diário pode conter valores, datas, categorias, se a compra '
                    'foi planejada, e textos que você escolher escrever — '
                    'incluindo informações pessoais ou de saúde.',
                'Nesta versão, o diário é cifrado no próprio navegador ou '
                    'dispositivo e salvo localmente. O aplicativo não usa '
                    'conta, servidor de diário, sincronização, publicidade '
                    'ou telemetria. Os registros não são enviados ao projeto '
                    'ou ao GitHub.',
              ],
            ),
            _InfoCard(
              icon: Icons.key_outlined,
              title: 'Senha, cifra e cópias',
              paragraphs: const [
                'A senha protege o diário local, mas não é guardada nem pode '
                    'ser recuperada. Se esquecê-la, não será possível abrir '
                    'os registros cifrados.',
                'A opção “Exportar cópia JSON” cria um arquivo legível, sem '
                    'cifra. Guarde-o em local privado e apague-o quando não '
                    'precisar mais. A cifra também não protege um dispositivo '
                    'desbloqueado, uma extensão maliciosa ou uma página '
                    'comprometida.',
              ],
            ),
            _InfoCard(
              icon: Icons.tune,
              title: 'Suas escolhas e como apagar',
              paragraphs: const [
                'Você pode deixar as reflexões em branco, editar um registro, '
                    'apagar um registro ou escolher “Apagar todos os '
                    'registros” no menu do diário.',
                'Para apagar também o cofre local e a senha configurada, use '
                    'as opções do navegador para limpar os dados deste site. '
                    'Isso é permanente para os dados que não tenham uma cópia '
                    'exportada. Desinstalar o app também pode remover dados '
                    'locais.',
              ],
            ),
            _InfoCard(
              icon: Icons.info_outline,
              title: 'Sobre este aviso e a LGPD',
              paragraphs: const [
                'A LGPD exige informações claras sobre o tratamento de dados '
                    'e reconhece informações de saúde como dados pessoais '
                    'sensíveis. Como textos livres podem revelar informações '
                    'pessoais ou de saúde, evite escrever algo que não queira '
                    'manter neste dispositivo.',
                'Este aviso descreve o funcionamento desta versão do MVP. '
                    'Ele não é uma avaliação jurídica, uma política completa '
                    'de privacidade nem uma declaração de conformidade com a '
                    'LGPD. O MVP não foi validado clinicamente e não é um '
                    'serviço de saúde.',
                'Se uma versão futura passar a enviar registros, criar contas '
                    'ou compartilhar dados, as informações sobre responsáveis, '
                    'finalidades, bases legais, direitos e canais de contato '
                    'precisarão ser revistas antes dessa mudança.',
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fontes oficiais',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lei nº 13.709/2018 (LGPD), especialmente arts. 5º, 6º, '
                      '9º e 18º. Consulte o texto oficial:',
                    ),
                    const SizedBox(height: 4),
                    const SelectableText(
                      'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/'
                      '2018/lei/L13709compilado.htm',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ANPD — orientações e materiais sobre proteção de dados:',
                    ),
                    const SizedBox(height: 4),
                    const SelectableText(
                      'https://www.gov.br/anpd/pt-br/documentos-e-publicacoes',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.paragraphs,
  });

  final IconData icon;
  final String title;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final paragraph in paragraphs) ...[
            Text(paragraph),
            if (paragraph != paragraphs.last) const SizedBox(height: 10),
          ],
        ],
      ),
    ),
  );
}
