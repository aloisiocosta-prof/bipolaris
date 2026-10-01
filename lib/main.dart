import 'package:flutter/material.dart';

void main() {
  runApp(const BipolarisApp());
}

class BipolarisApp extends StatelessWidget {
  const BipolarisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bipolaris — protótipo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF365A8C)),
        useMaterial3: true,
      ),
      home: const PrototypeHomePage(),
    );
  }
}

class PrototypeHomePage extends StatelessWidget {
  const PrototypeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bipolaris')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Semantics(
                liveRegion: true,
                child: Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'PROTÓTIPO • todos os exemplos são fictícios • não use dados reais',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Um espaço experimental para organizar tópicos que a própria pessoa '
                'escolhe levar a uma conversa com alguém de confiança.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const Text(
                'Esta demonstração não oferece diagnóstico, tratamento, '
                'recomendação de medicação, monitoramento de risco ou atendimento '
                'de emergência. Nenhum agente de IA está conectado.',
              ),
              const SizedBox(height: 24),
              const _ExampleNote(
                heading: 'Exemplo fictício',
                body: '“Quero conversar sobre mudanças na minha rotina.”',
              ),
              const SizedBox(height: 12),
              const _ExampleNote(
                heading: 'Controle da pessoa',
                body: 'A pessoa decide o que escrever, revisar, exportar ou apagar.',
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => showAboutDialog(
                  context: context,
                  applicationName: 'Bipolaris — protótipo acadêmico',
                  applicationVersion: '0.1.0',
                  children: const [
                    Text(
                      'Demonstração com conteúdo fixo e fictício. '
                      'Não digite nem importe informações pessoais ou de saúde.',
                    ),
                  ],
                ),
                icon: const Icon(Icons.info_outline),
                label: const Text('Sobre os limites desta demonstração'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleNote extends StatelessWidget {
  const _ExampleNote({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notes_outlined),
        title: Text(heading),
        subtitle: Text(body),
      ),
    );
  }
}
