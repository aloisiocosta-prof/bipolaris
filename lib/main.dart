import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/expense_entry.dart';
import 'services/expense_vault.dart';
import 'theme/bipolaris_theme.dart';
import 'privacy_and_use_page.dart';

void main() => runApp(const BipolarisApp());

class BipolarisApp extends StatefulWidget {
  const BipolarisApp({super.key, this.vault});

  final ExpenseVault? vault;

  @override
  State<BipolarisApp> createState() => _BipolarisAppState();
}

class _BipolarisAppState extends State<BipolarisApp> {
  late final BipolarisRouterDelegate _routerDelegate = BipolarisRouterDelegate(
    vault: widget.vault,
  );

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Bipolaris — diário financeiro reflexivo',
    theme: BipolarisTheme.light(),
    routeInformationParser: const BipolarisRouteInformationParser(),
    routerDelegate: _routerDelegate,
    backButtonDispatcher: RootBackButtonDispatcher(),
  );
}

@immutable
class BipolarisRouteConfiguration {
  const BipolarisRouteConfiguration({this.showPrivacy = false});

  final bool showPrivacy;
}

class BipolarisRouteInformationParser
    extends RouteInformationParser<BipolarisRouteConfiguration> {
  const BipolarisRouteInformationParser();

  @override
  Future<BipolarisRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final location = uri.fragment.startsWith('/') ? uri.fragment : uri.path;
    final segments = location
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);
    return BipolarisRouteConfiguration(
      showPrivacy: segments.isNotEmpty && segments.last == 'privacy',
    );
  }

  @override
  RouteInformation restoreRouteInformation(
    BipolarisRouteConfiguration configuration,
  ) => RouteInformation(
    uri: Uri(path: configuration.showPrivacy ? '/privacy' : '/'),
  );
}

class BipolarisRouterDelegate
    extends RouterDelegate<BipolarisRouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<BipolarisRouteConfiguration> {
  BipolarisRouterDelegate({this.vault});

  final ExpenseVault? vault;
  static const _privacyPageKey = ValueKey<String>('privacy-page');
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _showPrivacy = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  BipolarisRouteConfiguration get currentConfiguration =>
      BipolarisRouteConfiguration(showPrivacy: _showPrivacy);

  @override
  Future<void> setNewRoutePath(
    BipolarisRouteConfiguration configuration,
  ) async {
    _showPrivacy = configuration.showPrivacy;
    notifyListeners();
  }

  void openPrivacy() {
    if (_showPrivacy) return;
    _showPrivacy = true;
    notifyListeners();
  }

  void _closePrivacy() {
    if (!_showPrivacy) return;
    _showPrivacy = false;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      MaterialPage<void>(
        key: const ValueKey<String>('vault-gate'),
        child: VaultGate(vault: vault, onOpenPrivacy: openPrivacy),
      ),
      if (_showPrivacy)
        const MaterialPage<void>(
          key: _privacyPageKey,
          child: PrivacyAndUsePage(),
        ),
    ],
    onDidRemovePage: (page) {
      if (page.key == _privacyPageKey) _closePrivacy();
    },
  );
}

class VaultGate extends StatefulWidget {
  const VaultGate({required this.onOpenPrivacy, super.key, this.vault});

  final ExpenseVault? vault;
  final VoidCallback onOpenPrivacy;

  @override
  State<VaultGate> createState() => _VaultGateState();
}

class _VaultGateState extends State<VaultGate> {
  late final ExpenseVault _vault;
  final _passphrase = TextEditingController();
  final _confirmation = TextEditingController();
  bool? _hasVault;
  bool _busy = false;
  String? _error;
  ExpenseVaultSession? _session;
  List<ExpenseEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _vault = widget.vault ?? ExpenseVault();
    _checkVault();
  }

  @override
  void dispose() {
    _passphrase.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _checkVault() async {
    try {
      final exists = await _vault.exists();
      if (mounted) setState(() => _hasVault = exists);
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasVault = null;
          _error = 'Não foi possível acessar o armazenamento local.';
        });
      }
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final password = _passphrase.text;
    if (password.trim().length < 10) {
      setState(() => _error = 'Use uma senha com pelo menos 10 caracteres.');
      return;
    }
    if (_hasVault == false && password != _confirmation.text) {
      setState(() => _error = 'As senhas digitadas não coincidem.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final contents = _hasVault == true
          ? await _vault.unlock(password)
          : VaultContents(await _vault.create(password), const []);
      if (!mounted) return;
      setState(() {
        _session = contents.session;
        _entries = contents.entries;
        _busy = false;
        _passphrase.clear();
        _confirmation.clear();
      });
    } on VaultUnlockException {
      if (mounted) {
        setState(() {
          _error = 'Senha incorreta ou diário local inválido.';
          _busy = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Não foi possível abrir o diário. Tente novamente.';
          _busy = false;
        });
      }
    }
  }

  void _lock() {
    setState(() {
      _session = null;
      _entries = const [];
      _hasVault = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session != null) {
      return JournalPage(
        session: session,
        initialEntries: _entries,
        onLock: _lock,
        onOpenPrivacy: () => Router.navigate(context, widget.onOpenPrivacy),
      );
    }
    final creating = _hasVault == false;
    return Scaffold(
      appBar: AppBar(title: const Text('Bipolaris')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                creating ? 'Crie seu diário protegido' : 'Abra seu diário',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Seus registros são cifrados no dispositivo com uma senha que só '
                'você conhece. Eles não são enviados ao Bipolaris, ao GitHub ou '
                'a um profissional.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'A senha não pode ser recuperada. Exporte uma cópia de segurança '
                'antes de trocar de navegador ou dispositivo. A cifra protege os '
                'dados salvos, mas não protege um dispositivo desbloqueado ou '
                'uma página comprometida.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Router.navigate(context, widget.onOpenPrivacy),
                icon: const Icon(Icons.privacy_tip_outlined),
                label: const Text('Privacidade e uso'),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passphrase,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: creating ? 'Crie uma senha' : 'Senha do diário',
                  helperText: 'Use pelo menos 10 caracteres.',
                ),
                onSubmitted: (_) => _submit(),
              ),
              if (creating) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmation,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Repita a senha',
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                if (_hasVault == null)
                  TextButton.icon(
                    onPressed: _checkVault,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _busy || _hasVault == null ? null : _submit,
                icon: _busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock_open),
                label: Text(
                  creating ? 'Criar diário protegido' : 'Desbloquear',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bipolaris é um diário de autorreflexão, não um serviço clínico. '
                'Ele não faz diagnóstico, recomenda tratamento ou detecta crises.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalPage extends StatefulWidget {
  const JournalPage({
    required this.session,
    required this.initialEntries,
    required this.onLock,
    required this.onOpenPrivacy,
    super.key,
  });

  final ExpenseVaultSession session;
  final List<ExpenseEntry> initialEntries;
  final VoidCallback onLock;
  final VoidCallback onOpenPrivacy;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late List<ExpenseEntry> _entries;
  bool _saving = false;
  String _periodFilter = 'all';
  String _categoryFilter = '__all__';

  @override
  void initState() {
    super.initState();
    _entries = [...widget.initialEntries]
      ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
  }

  Future<void> _saveEntries(List<ExpenseEntry> next) async {
    setState(() => _saving = true);
    try {
      await widget.session.save(next);
      if (!mounted) return;
      setState(() {
        _entries = [...next]
          ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
        _saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Não foi possível salvar. Mantenha uma cópia de segurança.');
    }
  }

  Future<void> _editEntry([ExpenseEntry? existing]) async {
    final result = await showModalBottomSheet<ExpenseEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ExpenseForm(existing: existing),
    );
    if (result == null || !mounted) return;
    final next = [..._entries];
    final index = next.indexWhere((entry) => entry.id == result.id);
    if (index < 0) {
      next.add(result);
    } else {
      next[index] = result;
    }
    await _saveEntries(next);
  }

  Future<void> _deleteEntry(ExpenseEntry entry) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Apagar este registro?'),
            content: const Text('A ação não pode ser desfeita.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Apagar'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed && mounted) {
      await _saveEntries(
        _entries.where((candidate) => candidate.id != entry.id).toList(),
      );
    }
  }

  Future<void> _deleteAll() async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Apagar todos os registros?'),
            content: const Text(
              'Todos os gastos e reflexões deste diário serão apagados do '
              'armazenamento local.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Apagar tudo'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed && mounted) await _saveEntries([]);
  }

  Future<void> _export() async {
    final plainJson = const JsonEncoder.withIndent('  ').convert({
      'format': 'bipolaris-journal-v1',
      'exportedAt': DateTime.now().toIso8601String(),
      'entries': _entries.map((entry) => entry.toJson()).toList(),
    });
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exportar cópia JSON'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: SelectableText(
              'Este arquivo não está cifrado. Guarde-o em local privado.\n\n'
              '$plainJson',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: plainJson));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              _message('Cópia JSON copiada para a área de transferência.');
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar JSON'),
          ),
        ],
      ),
    );
  }

  void _message(String value) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last30DaysStart = today.subtract(const Duration(days: 29));
    final categories = _entries.map((entry) => entry.category).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final visibleEntries = _entries.where((entry) {
      final date = entry.purchasedAt;
      final matchesPeriod = switch (_periodFilter) {
        'month' => date.year == now.year && date.month == now.month,
        '30days' => !date.isBefore(last30DaysStart) && !date.isAfter(now),
        _ => true,
      };
      final matchesCategory =
          _categoryFilter == '__all__' || entry.category == _categoryFilter;
      return matchesPeriod && matchesCategory;
    }).toList();
    final periodLabel = switch (_periodFilter) {
      'month' => 'este mês',
      '30days' => 'últimos 30 dias',
      _ => 'todo o período',
    };
    final total = visibleEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.amountCents,
    );
    final groups = <String, List<ExpenseEntry>>{};
    for (final entry in visibleEntries) {
      final state = entry.selfReportedState?.trim();
      if (state != null && state.isNotEmpty) {
        groups.putIfAbsent(state, () => []).add(entry);
      }
    }
    final sortedGroups = groups.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bipolaris'),
        actions: [
          IconButton(
            tooltip: 'Exportar cópia JSON',
            onPressed: _entries.isEmpty ? null : _export,
            icon: const Icon(Icons.download_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opções do diário',
            onSelected: (value) {
              if (value == 'delete') _deleteAll();
              if (value == 'lock') widget.onLock();
              if (value == 'privacy') widget.onOpenPrivacy();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'privacy',
                child: ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacidade e uso'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Apagar todos os registros'),
                ),
              ),
              PopupMenuItem(
                value: 'lock',
                child: ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Bloquear diário'),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : () => _editEntry(),
        icon: const Icon(Icons.add),
        label: const Text('Registrar gasto'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Um diário para observar seus próprios registros',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Anote um gasto e, se quiser, descreva o que sentia e '
                        'o que motivou a compra. Você controla o que registra.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explorar registros',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Semantics(
                        label: 'Filtrar registros por período',
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'all', label: Text('Tudo')),
                            ButtonSegment(
                              value: 'month',
                              label: Text('Este mês'),
                            ),
                            ButtonSegment(
                              value: '30days',
                              label: Text('30 dias'),
                            ),
                          ],
                          selected: {_periodFilter},
                          onSelectionChanged: (selection) =>
                              setState(() => _periodFilter = selection.first),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _categoryFilter,
                            items: [
                              const DropdownMenuItem(
                                value: '__all__',
                                child: Text('Todas as categorias'),
                              ),
                              ...categories.map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _categoryFilter = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalCard = _SummaryCard(
                    title: 'Total • $periodLabel',
                    value: ExpenseEntry.formatMoney(total),
                  );
                  final countCard = _SummaryCard(
                    title: 'Registros exibidos',
                    value: visibleEntries.length.toString(),
                  );
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        totalCard,
                        const SizedBox(height: 12),
                        countCard,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: totalCard),
                      const SizedBox(width: 12),
                      Expanded(child: countCard),
                    ],
                  );
                },
              ),
              if (sortedGroups.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Soma dos gastos por estado que você descreveu',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Descrição dos seus registros; não indica causa, diagnóstico '
                  'ou relação clínica.',
                ),
                const SizedBox(height: 8),
                ...sortedGroups.map((group) {
                  final groupTotal = group.value.fold<int>(
                    0,
                    (sum, entry) => sum + entry.amountCents,
                  );
                  return Card(
                    child: ListTile(
                      title: Text(group.key),
                      subtitle: Text(
                        '${group.value.length} '
                        '${group.value.length == 1 ? 'registro' : 'registros'}',
                      ),
                      trailing: Text(ExpenseEntry.formatMoney(groupTotal)),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 20),
              Text(
                'Seus gastos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_saving)
                const LinearProgressIndicator()
              else if (visibleEntries.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _entries.isEmpty
                              ? 'Seu diário está vazio. Toque em “Registrar gasto” para anotar uma compra.'
                              : 'Nenhum registro corresponde a estes filtros.',
                        ),
                        if (_entries.isEmpty) ...[
                          const SizedBox(height: 4),
                          const Text('As perguntas de reflexão são opcionais.'),
                        ] else ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => setState(() {
                              _periodFilter = 'all';
                              _categoryFilter = '__all__';
                            }),
                            child: const Text('Limpar filtros'),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else
                ...visibleEntries.map(
                  (entry) => Card(
                    child: ListTile(
                      leading: Icon(
                        entry.planned
                            ? Icons.event_available_outlined
                            : Icons.event_busy_outlined,
                      ),
                      title: Text(
                        '${entry.category} • '
                        '${ExpenseEntry.formatMoney(entry.amountCents)}',
                      ),
                      subtitle: Text(_entrySummary(entry)),
                      isThreeLine: _entrySummary(entry).contains('\n'),
                      onTap: () => _editEntry(entry),
                      trailing: PopupMenuButton<String>(
                        tooltip: 'Ações do registro',
                        onSelected: (action) {
                          if (action == 'edit') _editEntry(entry);
                          if (action == 'delete') _deleteEntry(entry);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(value: 'delete', child: Text('Apagar')),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              const Text(
                'Privacidade: o diário é cifrado com sua senha e fica no '
                'armazenamento local deste navegador ou dispositivo. Não há '
                'sincronização. A cópia exportada é texto legível; proteja-a.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Bipolaris não oferece diagnóstico, tratamento, detecção de '
                'crises nem aconselhamento financeiro ou clínico.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _entrySummary(ExpenseEntry entry) {
    final pieces = <String>[
      '${_formatDate(entry.purchasedAt)} • '
          '${entry.planned ? 'planejada' : 'não planejada'}',
    ];
    if (entry.selfReportedState?.isNotEmpty ?? false) {
      pieces.add('Estado descrito: ${entry.selfReportedState}');
    }
    if (entry.motivation?.isNotEmpty ?? false) {
      pieces.add('Motivação: ${entry.motivation}');
    }
    if (entry.description?.isNotEmpty ?? false) {
      pieces.add(entry.description!);
    }
    return pieces.join('\n');
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    ),
  );
}

class _ExpenseForm extends StatefulWidget {
  const _ExpenseForm({this.existing});

  final ExpenseEntry? existing;

  @override
  State<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<_ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _category;
  late final TextEditingController _description;
  late final TextEditingController _state;
  late final TextEditingController _motivation;
  late final TextEditingController _reflection;
  late DateTime _purchasedAt;
  late bool _planned;
  String? _stateChoice;
  String? _motivationChoice;

  static const _stateOptions = [
    'Tranquilo(a)',
    'Animado(a)',
    'Preocupado(a)',
    'Frustrado(a)',
    'Triste',
    'Cansado(a)',
    'Outro / escrever',
  ];
  static const _motivationOptions = [
    'Necessidade',
    'Conveniência',
    'Lazer ou celebração',
    'Acolhimento pessoal',
    'Influência de outras pessoas',
    'Impulso',
    'Outro / escrever',
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _amount = TextEditingController(
      text: existing == null
          ? ''
          : (existing.amountCents / 100)
                .toStringAsFixed(2)
                .replaceAll('.', ','),
    );
    _category = TextEditingController(text: existing?.category ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    final existingState = existing?.selfReportedState;
    final existingMotivation = existing?.motivation;
    _stateChoice = existingState == null
        ? null
        : (_stateOptions.contains(existingState)
              ? existingState
              : 'Outro / escrever');
    _motivationChoice = existingMotivation == null
        ? null
        : (_motivationOptions.contains(existingMotivation)
              ? existingMotivation
              : 'Outro / escrever');
    _state = TextEditingController(
      text: existingState != null && !_stateOptions.contains(existingState)
          ? existingState
          : '',
    );
    _motivation = TextEditingController(
      text:
          existingMotivation != null &&
              !_motivationOptions.contains(existingMotivation)
          ? existingMotivation
          : '',
    );
    _reflection = TextEditingController(text: existing?.reflection ?? '');
    _purchasedAt = existing?.purchasedAt ?? DateTime.now();
    _planned = existing?.planned ?? true;
  }

  @override
  void dispose() {
    _amount.dispose();
    _category.dispose();
    _description.dispose();
    _state.dispose();
    _motivation.dispose();
    _reflection.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _purchasedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) setState(() => _purchasedAt = selected);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cents = ExpenseEntry.parseMoneyToCents(_amount.text)!;
    String? optional(TextEditingController controller) {
      final value = controller.text.trim();
      return value.isEmpty ? null : value;
    }

    Navigator.pop(
      context,
      ExpenseEntry(
        id: widget.existing?.id ?? ExpenseEntry.newId(),
        amountCents: cents,
        purchasedAt: _purchasedAt,
        category: _category.text.trim(),
        planned: _planned,
        description: optional(_description),
        selfReportedState: _choiceValue(_stateChoice, _state),
        motivation: _choiceValue(_motivationChoice, _motivation),
        reflection: optional(_reflection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existing == null ? 'Registrar gasto' : 'Editar gasto',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,R$ ]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  hintText: '0,00',
                ),
                validator: (value) =>
                    ExpenseEntry.parseMoneyToCents(value ?? '') == null
                    ? 'Informe um valor maior que zero.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  hintText: 'Ex.: alimentação, transporte, lazer',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe uma categoria.'
                    : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data da compra'),
                subtitle: Text(_formatDate(_purchasedAt)),
                trailing: IconButton(
                  tooltip: 'Escolher data',
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Compra planejada'),
                value: _planned,
                onChanged: (value) => setState(() => _planned = value),
              ),
              const Divider(),
              Text(
                'Reflexão opcional',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Descreva com suas palavras; o aplicativo não interpreta nem '
                'classifica sua resposta.',
              ),
              const SizedBox(height: 12),
              _ChoiceQuestion(
                title: 'Como você se sentia? (opcional)',
                helper:
                    'Escolha uma opção ou escreva a sua; estes rótulos são apenas sugestões.',
                options: _stateOptions,
                selected: _stateChoice,
                onSelected: (value) => setState(() => _stateChoice = value),
              ),
              if (_stateChoice == 'Outro / escrever') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _state,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descreva seu estado',
                    hintText: 'Com suas próprias palavras',
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _ChoiceQuestion(
                title: 'O que motivou a compra? (opcional)',
                helper: 'As opções não classificam a compra nem avaliam você.',
                options: _motivationOptions,
                selected: _motivationChoice,
                onSelected: (value) =>
                    setState(() => _motivationChoice = value),
              ),
              if (_motivationChoice == 'Outro / escrever') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _motivation,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descreva a motivação',
                    hintText: 'Com suas próprias palavras',
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'O que foi comprado? (opcional)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reflection,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'O que você gostaria de lembrar? (opcional)',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salvar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceQuestion extends StatelessWidget {
  const _ChoiceQuestion({
    required this.title,
    required this.helper,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final String helper;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 4),
      Text(helper),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: options
            .map(
              (option) => ChoiceChip(
                label: Text(option),
                selected: selected == option,
                onSelected: (checked) => onSelected(checked ? option : null),
              ),
            )
            .toList(),
      ),
    ],
  );
}

String? _choiceValue(String? choice, TextEditingController customValue) {
  if (choice == null) return null;
  if (choice != 'Outro / escrever') return choice;
  final value = customValue.text.trim();
  return value.isEmpty ? null : value;
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/'
    '${date.year}';
