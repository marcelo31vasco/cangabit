import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const Color corPrimariaNordestao = Color(0xFFF33F2B);
const Color corSecundariaNordestao = Color(0xFF3A57A6);
const Color corFundoAplicacao = Color(0xFFF9F9F9);
const Color corSuperficie = Colors.white;
const Color corBordaSuave = Color(0xFFD8DDE8);
const Color corTextoPrincipal = Color(0xFF1E2430);
const Color corTextoSecundario = Color(0xFF667085);
const Color corRiscoCritico = Color(0xFFD92D20);
const Color corRiscoAlerta = Color(0xFFF79009);
const Color corRiscoSeguro = Color(0xFF12B76A);
const Color corRiscoVencido = Color(0xFF7A271A);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError capturado no bootstrap: ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  };

  try {
    debugPrint('main(): iniciando runApp(BipStockApp)');
    runApp(const BipStockApp());
  } catch (error, stackTrace) {
    debugPrint('main(): erro ao subir o app: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class BipStockApp extends StatefulWidget {
  const BipStockApp({super.key});

  @override
  State<BipStockApp> createState() => _BipStockAppState();
}

class _BipStockAppState extends State<BipStockApp> {
  final AppController _controller = AppController.seeded();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BIPSTOCK',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: corFundoAplicacao,
            colorScheme: const ColorScheme.light(
              primary: corPrimariaNordestao,
              secondary: corSecundariaNordestao,
              surface: corSuperficie,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: corTextoPrincipal,
            ),
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: corTextoPrincipal,
              displayColor: corTextoPrincipal,
            ),
            cardTheme: CardThemeData(
              color: corSuperficie,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: corBordaSuave),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: corSecundariaNordestao,
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: corSuperficie,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: corBordaSuave),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: corBordaSuave),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: corPrimariaNordestao),
              ),
              labelStyle: const TextStyle(color: corTextoSecundario),
            ),
          ),
          home: _controller.session == null
              ? LoginScreen(controller: _controller)
              : HomeShell(controller: _controller),
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'gestor@bipstock.com');
  final _passwordController = TextEditingController(text: '1234');
  final _companyController = TextEditingController();
  final _cnpjController = TextEditingController();
  bool _registeringCompany = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ok = widget.controller.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!ok && mounted) {
      showSnack(context, 'Credenciais inválidas.');
    }
  }

  void _registerCompany() {
    if (_companyController.text.trim().isEmpty || _cnpjController.text.trim().isEmpty) {
      showSnack(context, 'Informe nome da empresa e CNPJ.');
      return;
    }
    widget.controller.registerCompany(
      name: _companyController.text.trim(),
      cnpj: _cnpjController.text.trim(),
    );
    setState(() => _registeringCompany = false);
    showSnack(context, 'Empresa e filial principal cadastradas.');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 920;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isCompact
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BrandHero(),
                        const SizedBox(height: 24),
                        _LoginCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          login: _login,
                          registeringCompany: _registeringCompany,
                          onToggleRegister: () {
                            setState(() => _registeringCompany = !_registeringCompany);
                          },
                          companyController: _companyController,
                          cnpjController: _cnpjController,
                          registerCompany: _registerCompany,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Expanded(child: BrandHero()),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 420,
                          child: _LoginCard(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            login: _login,
                            registeringCompany: _registeringCompany,
                            onToggleRegister: () {
                              setState(() => _registeringCompany = !_registeringCompany);
                            },
                            companyController: _companyController,
                            cnpjController: _cnpjController,
                            registerCompany: _registerCompany,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class BrandHero extends StatelessWidget {
  const BrandHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'BIPSTOCK',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w900,
            color: corPrimariaNordestao,
            letterSpacing: 6,
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Controle de estoque, validade e reposicao em uma operacao simples.',
          style: TextStyle(fontSize: 18, height: 1.5, color: corTextoPrincipal),
        ),
        SizedBox(height: 18),
        Text(
          'CD central, lojas abastecidas, alertas de ruptura e vencimento, leitura de codigo de barras e painel responsivo.',
          style: TextStyle(fontSize: 15, height: 1.6, color: corTextoSecundario),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.login,
    required this.registeringCompany,
    required this.onToggleRegister,
    required this.companyController,
    required this.cnpjController,
    required this.registerCompany,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback login;
  final bool registeringCompany;
  final VoidCallback onToggleRegister;
  final TextEditingController companyController;
  final TextEditingController cnpjController;
  final VoidCallback registerCompany;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acesso seguro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use `gestor@bipstock.com / 1234` ou `operacao@bipstock.com / 1234`.',
              style: TextStyle(color: corTextoSecundario, height: 1.5),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    validator: validateRequired,
                    onFieldSubmitted: (_) => login(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: login,
              style: primaryButton(),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onToggleRegister,
              child: Text(
                registeringCompany ? 'Fechar cadastro da empresa' : 'Cadastrar empresa',
              ),
            ),
            if (registeringCompany) ...[
              const Divider(color: corBordaSuave, height: 28),
              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Nome do supermercado'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: registerCompany,
                style: outlinedButton(),
                child: const Text('Salvar empresa'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final session = widget.controller.session!;
    final pages = [
      DashboardPage(controller: widget.controller),
      ProductCatalogPage(controller: widget.controller),
      OperationsPage(controller: widget.controller),
      AlertsPage(controller: widget.controller),
      ReportsPage(controller: widget.controller),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;
        if (compact) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.controller.activeStore.name),
              actions: [
                _AlertBell(count: widget.controller.alerts.where((item) => !item.acknowledged).length),
                _SessionMenu(controller: widget.controller),
              ],
            ),
            body: pages[_index],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Produtos'),
                NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Operação'),
                NavigationDestination(icon: Icon(Icons.notifications), label: 'Alertas'),
                NavigationDestination(icon: Icon(Icons.summarize), label: 'Relatórios'),
              ],
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() => _index = value),
                  backgroundColor: const Color(0xFF091321),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 24, 12, 32),
                    child: Column(
                      children: [
                        const Text(
                          'BIPSTOCK',
                          style: TextStyle(
                            color: corPrimariaNordestao,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          session.user.role.label,
                          style: const TextStyle(color: corTextoSecundario, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_outlined),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_outlined),
                      label: Text('Produtos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.qr_code_scanner_outlined),
                      selectedIcon: Icon(Icons.qr_code_scanner_outlined),
                      label: Text('Operação'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.notifications_outlined),
                      selectedIcon: Icon(Icons.notifications_outlined),
                      label: Text('Alertas'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.summarize_outlined),
                      selectedIcon: Icon(Icons.summarize_outlined),
                      label: Text('Relatórios'),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: corBordaSuave)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.controller.activeStore.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Usuário: ${session.user.fullName} • ${session.user.role.label}',
                                    style: const TextStyle(color: corTextoSecundario),
                                  ),
                                ],
                              ),
                            ),
                            _AlertBell(
                              count: widget.controller.alerts.where((item) => !item.acknowledged).length,
                            ),
                            const SizedBox(width: 12),
                            _SessionMenu(controller: widget.controller),
                          ],
                        ),
                      ),
                      Expanded(child: pages[_index]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SessionMenu extends StatelessWidget {
  const _SessionMenu({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.store_mall_directory_outlined, color: corSecundariaNordestao),
        const SizedBox(width: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.activeStore.id,
            dropdownColor: corSuperficie,
            onChanged: (value) {
              if (value != null) {
                controller.selectStore(value);
              }
            },
            items: controller.storeOptions
                .map(
                  (store) => DropdownMenuItem(
                    value: store.id,
                    child: Text(store.name),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: controller.logout,
          style: outlinedButton(),
          icon: const Icon(Icons.logout),
          label: const Text('Sair'),
        ),
      ],
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final dashboard = controller.dashboard;
    final recommendations = controller.recommendations;
    final queue = controller.fefoQueue.take(6).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              KpiCard(label: 'Próximos ao vencimento', value: '${dashboard.nearExpiry}'),
              KpiCard(label: 'Produtos vencidos', value: '${dashboard.expired}'),
              KpiCard(label: 'Perdas evitadas', value: money(dashboard.lossesAvoided)),
              KpiCard(label: 'Economia estimada', value: money(dashboard.estimatedSavings)),
              KpiCard(label: 'Produtos cadastrados', value: '${dashboard.productsRegistered}'),
              KpiCard(label: 'Alertas ativos', value: '${dashboard.activeAlerts}'),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1080;
              if (compact) {
                return Column(
                  children: [
                    RecommendationPanel(controller: controller, recommendations: recommendations),
                    const SizedBox(height: 16),
                    FefoQueueCard(queue: queue),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RecommendationPanel(
                      controller: controller,
                      recommendations: recommendations,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: FefoQueueCard(queue: queue)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LogisticsOverviewCard(controller: controller),
        ],
      ),
    );
  }
}

class _AlertBell extends StatelessWidget {
  const _AlertBell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, right: 8),
          child: Icon(Icons.notifications_active_outlined, color: corSecundariaNordestao),
        ),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: corRiscoCritico,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class LogisticsOverviewCard extends StatelessWidget {
  const LogisticsOverviewCard({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final cd = controller.distributionCenter;
    final stores = controller.displayStores;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rede logistica',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            if (cd != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFEA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: corPrimariaNordestao),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warehouse_outlined, color: corPrimariaNordestao),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${cd.name} • centro principal de abastecimento',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: stores
                  .map(
                    (store) => SizedBox(
                      width: 220,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: corSuperficie,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: corBordaSuave),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.storefront_outlined, color: corSecundariaNordestao),
                            const SizedBox(height: 8),
                            Text(
                              store.name,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              store.regionLabel,
                              style: const TextStyle(color: corTextoSecundario),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final products = controller.filteredProducts;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Pesquisar por nome, EAN, categoria ou lote',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: controller.updateSearch,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final balance = controller.totalStockForProduct(product.id);
                final lots = controller.batchesForProduct(product.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            StatusChip(
                              label: balance <= product.minStock ? 'Ruptura' : 'Estável',
                              color: balance <= product.minStock ? corRiscoCritico : corRiscoSeguro,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'EAN ${product.ean13} • ${product.category} • ${product.sector}',
                          style: const TextStyle(color: corTextoSecundario),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            MiniStat(label: 'Saldo total', value: '$balance un'),
                            MiniStat(label: 'Estoque mínimo', value: '${product.minStock} un'),
                            MiniStat(label: 'Lotes', value: '${lots.length}'),
                            MiniStat(label: 'Preço médio', value: money(product.unitValue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OperationsPage extends StatefulWidget {
  const OperationsPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _eanController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _sectorController = TextEditingController();
  final _batchController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _minStockController = TextEditingController(text: '5');
  final _unitValueController = TextEditingController(text: '0,00');
  final _expiryController = TextEditingController(
    text: DateTime.now().add(const Duration(days: 7)).toIso8601String().split('T').first,
  );
  final _saleEanController = TextEditingController();
  final _saleQtyController = TextEditingController(text: '1');
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _batchController.text = generateBatchCode();
    _selectedCategory = widget.controller.categoryProfiles.first.name;
    _applyCategoryProfile(_selectedCategory!);
  }

  @override
  void dispose() {
    _eanController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _sectorController.dispose();
    _batchController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _unitValueController.dispose();
    _expiryController.dispose();
    _saleEanController.dispose();
    _saleQtyController.dispose();
    super.dispose();
  }

  Future<void> _scanEan() async {
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeCaptureScreen()),
    );
    if (value != null) {
      setState(() => _eanController.text = value);
      _syncCatalogProduct();
    }
  }

  void _syncCatalogProduct() {
    final product = widget.controller.findProductByEan(_eanController.text.trim());
    if (product == null) {
      return;
    }

    final categoryProfile = widget.controller.categoryProfileForName(product.category);
    setState(() {
      _descriptionController.text = product.description;
      _selectedCategory = product.category;
      _categoryController.text = product.category;
      _sectorController.text = product.sector;
      _minStockController.text = product.minStock.toString();
      _unitValueController.text = product.unitValue.toStringAsFixed(2).replaceAll('.', ',');
      if (categoryProfile != null) {
        _expiryController.text = suggestedExpiryFor(categoryProfile.shelfLifeDays);
      }
    });
  }

  void _applyCategoryProfile(String categoryName) {
    final profile = widget.controller.categoryProfileForName(categoryName);
    if (profile == null) {
      return;
    }

    setState(() {
      _selectedCategory = profile.name;
      _categoryController.text = profile.name;
      _sectorController.text = profile.sector;
      _expiryController.text = suggestedExpiryFor(profile.shelfLifeDays);
    });
  }

  void _registerBatch() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final expiry = DateTime.tryParse(_expiryController.text.trim());
    if (expiry == null) {
      showSnack(context, 'Informe a validade no formato AAAA-MM-DD.');
      return;
    }
    widget.controller.registerBatch(
      ean13: _eanController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      sector: _sectorController.text.trim(),
      batchCode: _batchController.text.trim(),
      quantity: int.parse(_quantityController.text.trim()),
      minStock: int.parse(_minStockController.text.trim()),
      unitValue: parseCurrency(_unitValueController.text),
      expiresAt: expiry,
    );
    _batchController.text = generateBatchCode();
    showSnack(context, 'Lote registrado e histórico atualizado.');
    setState(() {});
  }

  void _simulateSale() {
    final ok = widget.controller.consumeStock(
      _saleEanController.text.trim(),
      int.tryParse(_saleQtyController.text.trim()) ?? 0,
    );
    showSnack(
      context,
      ok ? 'Venda processada pela prioridade de validade.' : 'Não foi possível processar a venda.',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final recentBatches = widget.controller.recentBatches.take(5).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1080;
               final form = ResponsiveBatchFormCard(
                 categories: widget.controller.categoryProfiles,
                 formKey: _formKey,
                 eanController: _eanController,
                 descriptionController: _descriptionController,
                 categoryController: _categoryController,
                 sectorController: _sectorController,
                batchController: _batchController,
                quantityController: _quantityController,
                minStockController: _minStockController,
                unitValueController: _unitValueController,
                 expiryController: _expiryController,
                 scanEan: _scanEan,
                 registerBatch: _registerBatch,
                 selectedCategory: _selectedCategory,
                 onCategoryChanged: _applyCategoryProfile,
                 onEanEditingComplete: _syncCatalogProduct,
                );
              final actions = _OperationsActionsCard(
                controller: widget.controller,
                saleEanController: _saleEanController,
                saleQtyController: _saleQtyController,
                simulateSale: _simulateSale,
              );

              if (compact) {
                return Column(
                  children: [
                    form,
                    const SizedBox(height: 16),
                    actions,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: actions),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Últimos lotes registrados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...recentBatches.map(
                    (batch) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${batch.productDescription} • lote ${batch.batchCode}'),
                      subtitle: Text(
                        '${batch.quantityCurrent} un • validade ${shortDate(batch.expiresAt)} • ${batch.storeName}',
                      ),
                      trailing: StatusChip(
                        label: batch.zone.label,
                        color: zoneColor(batch.zone),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatchFormCard extends StatelessWidget {
  const _BatchFormCard({
    required this.categories,
    required this.formKey,
    required this.eanController,
    required this.descriptionController,
    required this.categoryController,
    required this.sectorController,
    required this.batchController,
    required this.quantityController,
    required this.minStockController,
    required this.unitValueController,
    required this.expiryController,
    required this.scanEan,
    required this.registerBatch,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onEanEditingComplete,
  });

  final List<CategoryProfile> categories;
  final GlobalKey<FormState> formKey;
  final TextEditingController eanController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController sectorController;
  final TextEditingController batchController;
  final TextEditingController quantityController;
  final TextEditingController minStockController;
  final TextEditingController unitValueController;
  final TextEditingController expiryController;
  final Future<void> Function() scanEan;
  final VoidCallback registerBatch;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onEanEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Entrada por lote',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'RF03, RF04, RF05, RF06 e RF07: leitura de EAN-13, registro de lote/validade, histórico e prioridade de saída por validade.',
                style: TextStyle(color: corTextoSecundario, height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: eanController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(labelText: 'EAN-13'),
                      validator: validateEan13,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: scanEan,
                    style: outlinedButton(),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Ler código'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: validateRequired,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      validator: validateRequired,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: sectorController,
                      decoration: const InputDecoration(labelText: 'Setor'),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: 'Lote'),
                      validator: validateRequired,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Validade (AAAA-MM-DD)',
                      ),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantidade'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: validatePositiveInt,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: minStockController,
                      decoration: const InputDecoration(labelText: 'Estoque mínimo'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: validatePositiveInt,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: unitValueController,
                      decoration: const InputDecoration(labelText: 'Valor unitário'),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: registerBatch,
                style: primaryButton(),
                child: const Text('Registrar lote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponsiveBatchFormCard extends StatelessWidget {
  const ResponsiveBatchFormCard({
    super.key,
    required this.categories,
    required this.formKey,
    required this.eanController,
    required this.descriptionController,
    required this.categoryController,
    required this.sectorController,
    required this.batchController,
    required this.quantityController,
    required this.minStockController,
    required this.unitValueController,
    required this.expiryController,
    required this.scanEan,
    required this.registerBatch,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onEanEditingComplete,
  });

  final List<CategoryProfile> categories;
  final GlobalKey<FormState> formKey;
  final TextEditingController eanController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController sectorController;
  final TextEditingController batchController;
  final TextEditingController quantityController;
  final TextEditingController minStockController;
  final TextEditingController unitValueController;
  final TextEditingController expiryController;
  final Future<void> Function() scanEan;
  final VoidCallback registerBatch;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onEanEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cadastro de produto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: eanController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(labelText: 'EAN-13'),
                      validator: validateEan13,
                      onEditingComplete: onEanEditingComplete,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: scanEan,
                    style: outlinedButton(),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Abrir camera'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Produto'),
                validator: validateRequired,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 320,
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: categories
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onCategoryChanged(value);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                      controller: sectorController,
                      decoration: const InputDecoration(labelText: 'Setor'),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: 'Lote'),
                      validator: validateRequired,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                      controller: expiryController,
                      decoration: const InputDecoration(labelText: 'Validade (AAAA-MM-DD)'),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantidade'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: validatePositiveInt,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: minStockController,
                      decoration: const InputDecoration(labelText: 'Estoque minimo'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: validatePositiveInt,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: unitValueController,
                      decoration: const InputDecoration(labelText: 'Valor unitario'),
                      validator: validateRequired,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'A categoria sugere setor e validade inicial.',
                style: TextStyle(color: corTextoSecundario),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: registerBatch,
                style: primaryButton(),
                child: const Text('Salvar lote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key, required this.controller});

  final AppController controller;

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final products = widget.controller.filteredProducts;
    final visibleProducts = _selectedProductId == null
        ? products
        : products.where((item) => item.id == _selectedProductId).toList();
    final selected = _selectedProductId == null
        ? null
        : products.where((item) => item.id == _selectedProductId).firstOrNull;
    final selectedLots = selected == null
        ? <StockBatch>[]
        : widget.controller.batchesForProduct(selected.id);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 460,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar por nome, EAN, categoria ou lote',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: widget.controller.updateSearch,
                ),
              ),
              SizedBox(
                width: 280,
                child: DropdownButtonFormField<String?>(
                  value: _selectedProductId,
                  decoration: const InputDecoration(labelText: 'Filtrar produto'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
                    ...products.map(
                      (product) => DropdownMenuItem<String?>(
                        value: product.id,
                        child: Text(product.description),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedProductId = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selected != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validades de ${selected.description}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    ...selectedLots.map(
                      (lot) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Lote ${lot.batchCode} • ${lot.storeName}'),
                        subtitle: Text(
                          'Validade ${shortDate(lot.expiresAt)} • ${lot.quantityCurrent} un',
                        ),
                        trailing: StatusChip(
                          label: lot.zone.label,
                          color: zoneColor(lot.zone),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (selected != null) const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: visibleProducts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = visibleProducts[index];
                final balance = widget.controller.totalStockForProduct(product.id);
                final lots = widget.controller.batchesForProduct(product.id);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            StatusChip(
                              label: balance <= product.minStock ? 'Ruptura' : 'Estavel',
                              color: balance <= product.minStock ? corRiscoCritico : corRiscoSeguro,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'EAN ${product.ean13} • ${product.category} • ${product.sector}',
                          style: const TextStyle(color: corTextoSecundario),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            MiniStat(label: 'Saldo', value: '$balance'),
                            MiniStat(label: 'Minimo', value: '${product.minStock}'),
                            MiniStat(label: 'Lotes', value: '${lots.length}'),
                            MiniStat(label: 'Preco', value: money(product.unitValue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationsActionsCard extends StatelessWidget {
  const _OperationsActionsCard({
    required this.controller,
    required this.saleEanController,
    required this.saleQtyController,
    required this.simulateSale,
  });

  final AppController controller;
  final TextEditingController saleEanController;
  final TextEditingController saleQtyController;
  final VoidCallback simulateSale;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Importação e integração MVP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                controller.importSampleSheet();
                showSnack(context, 'Importação simulada por planilha executada.');
              },
              style: outlinedButton(),
              icon: const Icon(Icons.table_view),
              label: const Text('Importar planilha'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                controller.importApiPayload();
                showSnack(context, 'Importação simulada por API executada.');
              },
              style: outlinedButton(),
              icon: const Icon(Icons.cloud_sync),
              label: const Text('Importar API'),
            ),
            const Divider(color: corBordaSuave, height: 28),
            const Text(
              'Simular saída por prioridade de validade',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: saleEanController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'EAN-13'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: saleQtyController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Quantidade vendida'),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: simulateSale,
              style: primaryButton(),
              child: const Text('Processar venda'),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final alerts = controller.alerts;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_outlined, color: corSecundariaNordestao),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${alerts.where((item) => !item.acknowledged).length} alerta(s) enviados para a central do app.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Alertas ativos: ${alerts.where((item) => !item.acknowledged).length}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
              OutlinedButton.icon(
                onPressed: controller.refreshOperationalRules,
                style: outlinedButton(),
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar motor'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: alerts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            StatusChip(
                              label: alert.zone.label,
                              color: zoneColor(alert.zone),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(alert.description, style: const TextStyle(height: 1.5)),
                        const SizedBox(height: 8),
                        Text(
                          '${alert.channel} • ${shortDateTime(alert.createdAt)}',
                          style: const TextStyle(color: corTextoSecundario),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            OutlinedButton(
                              onPressed: alert.acknowledged
                                  ? null
                                  : () {
                                      controller.handleAlert(
                                        alert.id,
                                        AlertResolution.promotion,
                                      );
                                      showSnack(
                                        context,
                                        'Promoção registrada e auditoria atualizada.',
                                      );
                                    },
                              style: outlinedButton(),
                              child: const Text('Aplicar promoção'),
                            ),
                            OutlinedButton(
                              onPressed: alert.acknowledged
                                  ? null
                                  : () {
                                      controller.handleAlert(
                                        alert.id,
                                        AlertResolution.restock,
                                      );
                                      showSnack(context, 'Reabastecimento registrado.');
                                    },
                              style: outlinedButton(),
                              child: const Text('Reabastecer'),
                            ),
                            OutlinedButton(
                              onPressed: alert.acknowledged
                                  ? null
                                  : () {
                                      controller.handleAlert(
                                        alert.id,
                                        AlertResolution.discard,
                                      );
                                      showSnack(context, 'Descarte/auditoria registrados.');
                                    },
                              style: outlinedButton(),
                              child: const Text('Descartar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final report = controller.report;
    final audits = controller.auditTrail.take(12).toList();
    final csv = controller.generateDailyReportCsv();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              KpiCard(label: 'Perdas no período', value: money(report.losses)),
              KpiCard(label: 'Economia gerada', value: money(report.savings)),
              KpiCard(label: 'Produtos salvos', value: '${report.savedProducts}'),
              KpiCard(label: 'ROI estimado', value: '${report.roi.toStringAsFixed(1)}%'),
              KpiCard(
                label: 'Redução das perdas',
                value: '${report.lossReduction.toStringAsFixed(1)}%',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: csv));
                if (context.mounted) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('CSV diario copiado'),
                      content: SizedBox(
                        width: 640,
                        child: SingleChildScrollView(
                          child: SelectableText(csv),
                        ),
                      ),
                    ),
                  );
                }
              },
              style: outlinedButton(),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Exportar relatorio diario CSV'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auditoria e rastreabilidade',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...audits.map(
                    (audit) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(audit.action),
                      subtitle: Text(
                        '${audit.details} • ${audit.userName} • ${shortDateTime(audit.createdAt)}',
                      ),
                      trailing: Text(
                        money(audit.financialImpact),
                        style: const TextStyle(
                          color: corPrimariaNordestao,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationPanel extends StatelessWidget {
  const RecommendationPanel({
    super.key,
    required this.controller,
    required this.recommendations,
  });

  final AppController controller;
  final List<RecommendationItem> recommendations;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recomendações automáticas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...recommendations.take(6).map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.title),
                subtitle: Text(item.description),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.action,
                      style: const TextStyle(color: corPrimariaNordestao, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      money(item.impact),
                      style: const TextStyle(color: corTextoSecundario, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FefoQueueCard extends StatelessWidget {
  const FefoQueueCard({super.key, required this.queue});

  final List<StockBatch> queue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saida por prioridade de validade',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...queue.map(
              (batch) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${batch.productDescription} • ${batch.batchCode}'),
                subtitle: Text(
                  'Validade ${shortDate(batch.expiresAt)} • ${batch.quantityCurrent} un',
                ),
                trailing: StatusChip(
                  label: batch.zone.label,
                  color: zoneColor(batch.zone),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.width = 150,
  });

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: corTextoSecundario, height: 1.35, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  const MiniStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: corBordaSuave),
        color: corSuperficie,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: corTextoSecundario, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class BarcodeCaptureScreen extends StatefulWidget {
  const BarcodeCaptureScreen({super.key});

  @override
  State<BarcodeCaptureScreen> createState() => _BarcodeCaptureScreenState();
}

class _BarcodeCaptureScreenState extends State<BarcodeCaptureScreen> {
  final _manualController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    autoStart: true,
  );
  bool _handled = false;
  bool _enableWebCamera = false;

  @override
  void dispose() {
    _scannerController.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final ean = extractEan13(value);
    if (ean == null) {
      showSnack(context, 'Código inválido. Informe 13 dígitos.');
      return;
    }
    Navigator.of(context).pop(ean);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && !_enableWebCamera) {
      return Scaffold(
        appBar: AppBar(title: const Text('Captura de código')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'No web, a captura usa entrada manual para evitar travamentos de câmera em navegadores.',
                style: TextStyle(color: corTextoSecundario, height: 1.5),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => setState(() => _enableWebCamera = true),
                style: outlinedButton(),
                icon: const Icon(Icons.videocam_outlined),
                label: const Text('Usar camera'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _manualController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'EAN-13'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _submit(_manualController.text),
                style: primaryButton(),
                child: const Text('Usar código'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Captura de código')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              if (_handled) {
                return;
              }
              final value = capture.barcodes.first.rawValue ?? '';
              final ean = extractEan13(value);
              if (ean != null) {
                _handled = true;
                Navigator.of(context).pop(ean);
              }
            },
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Aponte para um código EAN-13'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualController,
                      decoration: const InputDecoration(labelText: 'Ou digite manualmente'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => _submit(_manualController.text),
                      style: primaryButton(),
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppController extends ChangeNotifier {
  AppController.seeded() : _repository = InventoryRepository.seeded() {
    debugPrint(
      'AppController.seeded(): controlador criado com ${_repository.stores.length} loja(s), '
      '${_repository.users.length} usuário(s) e ${_repository.products.length} produto(s).',
    );
  }

  final InventoryRepository _repository;
  Session? session;
  String _search = '';

  List<StoreRecord> get storeOptions => _repository.stores;
  List<StoreRecord> get displayStores => _repository.stores.where((store) => store.kind == StoreKind.store).toList();
  StoreRecord? get distributionCenter => _repository.stores.where((store) => store.kind == StoreKind.distributionCenter).firstOrNull;
  List<CategoryProfile> get categoryProfiles => kCategoryProfiles;
  StoreRecord get activeStore => _repository.storeById(session!.storeId);
  DashboardSnapshot get dashboard => _repository.dashboardFor(session!.storeId);
  List<RecommendationItem> get recommendations =>
      _repository.recommendationsFor(session!.storeId);
  List<StockBatch> get fefoQueue => _repository.fefoQueue(session!.storeId);
  List<ProductRecord> get filteredProducts =>
      _repository.searchProducts(session!.storeId, _search);
  List<AlertRecord> get alerts => _repository.alertsFor(session!.storeId);
  List<StockBatch> get recentBatches => _repository.recentBatches(session!.storeId);
  ReportSnapshot get report => _repository.reportFor(session!.storeId);
  List<AuditRecord> get auditTrail => _repository.auditFor(session!.storeId);
  String generateDailyReportCsv() =>
      _repository.generateDailyReportCsv(session!.storeId);
  ProductRecord? findProductByEan(String ean13) =>
      _repository.findProductByEan(session!.storeId, ean13);
  CategoryProfile? categoryProfileForName(String name) =>
      kCategoryProfiles.where((item) => item.name == name).firstOrNull;

  bool login(String email, String password) {
    final auth = _repository.authenticate(email, password);
    if (auth == null) {
      return false;
    }
    session = auth;
    _repository.refreshRules(auth.storeId, auth.user.fullName);
    notifyListeners();
    return true;
  }

  void logout() {
    session = null;
    _search = '';
    notifyListeners();
  }

  void selectStore(String storeId) {
    if (session == null) {
      return;
    }
    session = Session(user: session!.user, storeId: storeId);
    _repository.refreshRules(storeId, session!.user.fullName);
    notifyListeners();
  }

  void updateSearch(String value) {
    _search = value.trim();
    notifyListeners();
  }

  int totalStockForProduct(String productId) =>
      _repository.totalStockForProduct(session!.storeId, productId);

  List<StockBatch> batchesForProduct(String productId) =>
      _repository.batchesForProduct(session!.storeId, productId);

  void registerBatch({
    required String ean13,
    required String description,
    required String category,
    required String sector,
    required String batchCode,
    required int quantity,
    required int minStock,
    required double unitValue,
    required DateTime expiresAt,
  }) {
    final current = session!;
    _repository.registerBatch(
      storeId: current.storeId,
      userName: current.user.fullName,
      ean13: ean13,
      description: description,
      category: category,
      sector: sector,
      batchCode: batchCode,
      quantity: quantity,
      minStock: minStock,
      unitValue: unitValue,
      expiresAt: expiresAt,
    );
    notifyListeners();
  }

  bool consumeStock(String ean13, int quantity) {
    final ok = _repository.consumeStockFefo(
      storeId: session!.storeId,
      ean13: ean13,
      quantity: quantity,
      userName: session!.user.fullName,
    );
    notifyListeners();
    return ok;
  }

  void importSampleSheet() {
    _repository.importSampleSheet(session!.storeId, session!.user.fullName);
    notifyListeners();
  }

  void importApiPayload() {
    _repository.importApiPayload(session!.storeId, session!.user.fullName);
    notifyListeners();
  }

  void handleAlert(String alertId, AlertResolution resolution) {
    _repository.resolveAlert(
      storeId: session!.storeId,
      alertId: alertId,
      resolution: resolution,
      userName: session!.user.fullName,
    );
    notifyListeners();
  }

  void refreshOperationalRules() {
    _repository.refreshRules(session!.storeId, session!.user.fullName);
    notifyListeners();
  }

  void registerCompany({required String name, required String cnpj}) {
    _repository.registerCompany(name: name, cnpj: cnpj);
    notifyListeners();
  }
}

class InventoryRepository {
  InventoryRepository.seeded() {
    debugPrint('InventoryRepository.seeded(): iniciando carga inicial.');
    _seed();
    debugPrint(
      'InventoryRepository.seeded(): carga finalizada com ${stores.length} loja(s), '
      '${users.length} usuário(s), ${products.length} produto(s) e ${batches.length} lote(s).',
    );
  }

  final List<StoreRecord> stores = [];
  final List<UserRecord> users = [];
  final List<ProductRecord> products = [];
  final List<StockBatch> batches = [];
  final List<AlertRecord> alerts = [];
  final List<AuditRecord> audits = [];
  int _sequence = 0;

  Session? authenticate(String email, String password) {
    final user = users.where((u) => u.email == email.trim().toLowerCase()).firstOrNull;
    if (user == null || user.password != password) {
      return null;
    }
    return Session(user: user, storeId: user.defaultStoreId);
  }

  StoreRecord storeById(String id) => stores.firstWhere((store) => store.id == id);
  ProductRecord? findProductByEan(String storeId, String ean13) {
    return products
        .where((item) => item.storeId == storeId && item.ean13 == ean13)
        .firstOrNull;
  }

  void registerCompany({required String name, required String cnpj}) {
    final store = StoreRecord(
      id: 'store-${++_sequence}',
      name: '$name - Matriz',
      code: 'MATRIZ-${_sequence.toString().padLeft(3, '0')}',
      cnpj: cnpj,
      kind: StoreKind.store,
      regionLabel: 'Nova unidade',
    );
    stores.add(store);
    audits.insert(
      0,
      AuditRecord(
        id: 'audit-${++_sequence}',
        storeId: store.id,
        userName: 'sistema',
        action: 'Cadastro da empresa',
        details: 'Empresa $name criada com filial principal ${store.name}.',
        financialImpact: 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  ProductRecord _upsertProduct({
    required String storeId,
    required String ean13,
    required String description,
    required String category,
    required String sector,
    required int minStock,
    required double unitValue,
  }) {
    final current = products
        .where((item) => item.storeId == storeId && item.ean13 == ean13)
        .firstOrNull;
    if (current != null) {
      final updated = current.copyWith(
        description: description,
        category: category,
        sector: sector,
        minStock: minStock,
        unitValue: unitValue,
      );
      final index = products.indexOf(current);
      products[index] = updated;
      return updated;
    }
    final created = ProductRecord(
      id: 'product-${++_sequence}',
      storeId: storeId,
      ean13: ean13,
      description: description,
      category: category,
      sector: sector,
      minStock: minStock,
      unitValue: unitValue,
    );
    products.add(created);
    return created;
  }

  void registerBatch({
    required String storeId,
    required String userName,
    required String ean13,
    required String description,
    required String category,
    required String sector,
    required String batchCode,
    required int quantity,
    required int minStock,
    required double unitValue,
    required DateTime expiresAt,
  }) {
    final product = _upsertProduct(
      storeId: storeId,
      ean13: ean13,
      description: description,
      category: category,
      sector: sector,
      minStock: minStock,
      unitValue: unitValue,
    );
    final batch = StockBatch(
      id: 'batch-${++_sequence}',
      storeId: storeId,
      storeName: storeById(storeId).name,
      productId: product.id,
      productDescription: product.description,
      ean13: product.ean13,
      category: product.category,
      sector: product.sector,
      batchCode: batchCode,
      quantityCurrent: quantity,
      unitValue: unitValue,
      expiresAt: expiresAt,
      createdAt: DateTime.now(),
    );
    batches.insert(0, batch);
    audits.insert(
      0,
      AuditRecord(
        id: 'audit-${++_sequence}',
        storeId: storeId,
        userName: userName,
        action: 'Entrada de lote',
        details: '${product.description} • lote $batchCode • $quantity un',
        financialImpact: quantity * unitValue,
        createdAt: DateTime.now(),
      ),
    );
    refreshRules(storeId, userName);
  }

  bool consumeStockFefo({
    required String storeId,
    required String ean13,
    required int quantity,
    required String userName,
  }) {
    if (quantity <= 0) {
      return false;
    }
    final queue = fefoQueue(storeId)
        .where((batch) => batch.ean13 == ean13 && batch.quantityCurrent > 0)
        .toList();
    if (queue.isEmpty) {
      return false;
    }
    final total = queue.fold<int>(0, (sum, batch) => sum + batch.quantityCurrent);
    if (total < quantity) {
      return false;
    }
    var remaining = quantity;
    for (final item in queue) {
      if (remaining == 0) {
        break;
      }
      final index = batches.indexWhere((batch) => batch.id == item.id);
      final consumed = min(remaining, item.quantityCurrent);
      batches[index] = item.copyWith(quantityCurrent: item.quantityCurrent - consumed);
      audits.insert(
        0,
        AuditRecord(
          id: 'audit-${++_sequence}',
          storeId: storeId,
          userName: userName,
          action: 'Saída por integração',
          details: '${item.productDescription} • lote ${item.batchCode} • -$consumed un',
          financialImpact: consumed * item.unitValue,
          createdAt: DateTime.now(),
        ),
      );
      remaining -= consumed;
    }
    refreshRules(storeId, userName);
    return true;
  }

  void importSampleSheet(String storeId, String userName) {
    registerBatch(
      storeId: storeId,
      userName: userName,
      ean13: '7891000000914',
      description: 'Queijo Coalho 320g',
      category: 'Laticínios',
      sector: 'Frios',
      batchCode: generateBatchCode(),
      quantity: 14,
      minStock: 6,
      unitValue: 14.90,
      expiresAt: DateTime.now().add(const Duration(days: 8)),
    );
  }

  void importApiPayload(String storeId, String userName) {
    registerBatch(
      storeId: storeId,
      userName: userName,
      ean13: '7891000000921',
      description: 'Mix de Folhas Higienizadas',
      category: 'Hortifruti',
      sector: 'FLV',
      batchCode: generateBatchCode(),
      quantity: 9,
      minStock: 4,
      unitValue: 8.70,
      expiresAt: DateTime.now().add(const Duration(days: 4)),
    );
  }

  void refreshRules(String storeId, String userName) {
    final storeProducts = products.where((item) => item.storeId == storeId).toList();
    final storeBatches = batches.where((item) => item.storeId == storeId).toList();

    for (final batch in storeBatches) {
      if (batch.quantityCurrent <= 0) {
        continue;
      }
      final zone = batch.zone;
      if (zone == RiskZone.safe) {
        continue;
      }
      final exists = alerts.any(
        (item) =>
            item.referenceId == batch.id &&
            item.zone == zone &&
            !item.acknowledged &&
            sameDate(item.createdAt, DateTime.now()),
      );
      if (!exists) {
        alerts.insert(
          0,
          AlertRecord(
            id: 'alert-${++_sequence}',
            storeId: storeId,
            referenceId: batch.id,
            title: zone == RiskZone.expired ? 'Produto vencido' : 'Produto próximo do vencimento',
            description:
                '${batch.productDescription} • lote ${batch.batchCode} • ${batch.quantityCurrent} un • validade ${shortDate(batch.expiresAt)}',
            zone: zone,
            channel: zone == RiskZone.critical ? 'Notificacao no app + WhatsApp' : 'Notificacao no app',
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    for (final product in storeProducts) {
      final total = totalStockForProduct(storeId, product.id);
      if (total > product.minStock) {
        continue;
      }
      final exists = alerts.any(
        (item) =>
            item.referenceId == product.id &&
            item.zone == RiskZone.stockout &&
            !item.acknowledged &&
            sameDate(item.createdAt, DateTime.now()),
      );
      if (!exists) {
        alerts.insert(
          0,
          AlertRecord(
            id: 'alert-${++_sequence}',
            storeId: storeId,
            referenceId: product.id,
            title: 'Risco de ruptura',
            description:
                '${product.description} com saldo $total un e estoque mínimo ${product.minStock} un.',
            zone: RiskZone.stockout,
            channel: 'Notificacao no app + E-mail',
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    audits.insert(
      0,
      AuditRecord(
        id: 'audit-${++_sequence}',
        storeId: storeId,
        userName: userName,
        action: 'Varredura operacional',
        details: 'Motor diario executado para validade, prioridade de saida e ruptura.',
        financialImpact: 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  void resolveAlert({
    required String storeId,
    required String alertId,
    required AlertResolution resolution,
    required String userName,
  }) {
    final index = alerts.indexWhere((alert) => alert.id == alertId);
    if (index == -1) {
      return;
    }
    final alert = alerts[index];
    alerts[index] = alert.copyWith(acknowledged: true);

    double impact = 0;
    String details = alert.description;
    if (alert.zone == RiskZone.expired && resolution == AlertResolution.discard) {
      final batch = batches.where((item) => item.id == alert.referenceId).firstOrNull;
      if (batch != null) {
        impact = batch.quantityCurrent * batch.unitValue;
      }
    }
    if (resolution == AlertResolution.promotion) {
      final batch = batches.where((item) => item.id == alert.referenceId).firstOrNull;
      if (batch != null) {
        impact = batch.quantityCurrent * batch.unitValue * 0.4;
      }
    }
    if (resolution == AlertResolution.restock) {
      final product = products.where((item) => item.id == alert.referenceId).firstOrNull;
      if (product != null) {
        details = '${product.description} reabastecido com pedido sugerido.';
      }
    }

    audits.insert(
      0,
      AuditRecord(
        id: 'audit-${++_sequence}',
        storeId: storeId,
        userName: userName,
        action: resolution.label,
        details: details,
        financialImpact: impact,
        createdAt: DateTime.now(),
      ),
    );
  }

  DashboardSnapshot dashboardFor(String storeId) {
    final storeProducts = products.where((item) => item.storeId == storeId).toList();
    final storeBatches = batches.where((item) => item.storeId == storeId).toList();
    final storeAlerts = alerts.where((item) => item.storeId == storeId && !item.acknowledged);
    final savings = audits
        .where((item) => item.storeId == storeId)
        .where((item) => item.action == AlertResolution.promotion.label)
        .fold<double>(0, (sum, item) => sum + item.financialImpact);
    final losses = storeBatches
        .where((item) => item.zone == RiskZone.expired)
        .fold<double>(0, (sum, item) => sum + item.quantityCurrent * item.unitValue);

    return DashboardSnapshot(
      nearExpiry: storeBatches
          .where((item) => item.zone == RiskZone.alert || item.zone == RiskZone.critical)
          .length,
      expired: storeBatches.where((item) => item.zone == RiskZone.expired).length,
      lossesAvoided: savings,
      estimatedSavings: max(savings, losses * 0.35),
      productsRegistered: storeProducts.length,
      activeAlerts: storeAlerts.length,
    );
  }

  List<RecommendationItem> recommendationsFor(String storeId) {
    final items = <RecommendationItem>[];
    for (final batch in fefoQueue(storeId)) {
      if (batch.zone == RiskZone.safe) {
        continue;
      }
      if (batch.zone == RiskZone.expired) {
        items.add(
          RecommendationItem(
            title: batch.productDescription,
            description: 'Lote ${batch.batchCode} vencido. Bloquear venda e consolidar perda.',
            action: 'Descartar',
            impact: batch.quantityCurrent * batch.unitValue,
          ),
        );
      } else if (batch.zone == RiskZone.critical) {
        items.add(
          RecommendationItem(
            title: batch.productDescription,
            description:
                'Vence em breve. Sugerir promoção automática e reposicionamento na gôndola.',
            action: 'Promover',
            impact: batch.quantityCurrent * batch.unitValue * 0.4,
          ),
        );
      } else {
        items.add(
          RecommendationItem(
            title: batch.productDescription,
            description: 'Entrou em alerta. Aplicar desconto moderado e revisar giro.',
            action: 'Ajustar preço',
            impact: batch.quantityCurrent * batch.unitValue * 0.2,
          ),
        );
      }
    }
    for (final product in products.where((item) => item.storeId == storeId)) {
      final total = totalStockForProduct(storeId, product.id);
      if (total <= product.minStock) {
        items.add(
          RecommendationItem(
            title: product.description,
            description: 'Saldo abaixo do mínimo. Recomendar novo pedido ao fornecedor.',
            action: 'Repor ${max(product.minStock * 2 - total, product.minStock)} un',
            impact: product.unitValue * max(product.minStock * 2 - total, product.minStock),
          ),
        );
      }
    }
    return items;
  }

  List<ProductRecord> searchProducts(String storeId, String query) {
    final normalized = query.trim().toLowerCase();
    final storeProducts = products.where((item) => item.storeId == storeId).toList();
    if (normalized.isEmpty) {
      return storeProducts;
    }
    return storeProducts.where((product) {
      final batchCodes = batches
          .where((batch) => batch.productId == product.id)
          .map((batch) => batch.batchCode.toLowerCase())
          .join(' ');
      return product.description.toLowerCase().contains(normalized) ||
          product.ean13.contains(normalized) ||
          product.category.toLowerCase().contains(normalized) ||
          batchCodes.contains(normalized);
    }).toList();
  }

  List<StockBatch> batchesForProduct(String storeId, String productId) {
    return batches
        .where((batch) => batch.storeId == storeId && batch.productId == productId)
        .toList()
      ..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
  }

  int totalStockForProduct(String storeId, String productId) {
    return batchesForProduct(storeId, productId)
        .fold<int>(0, (sum, batch) => sum + batch.quantityCurrent);
  }

  List<StockBatch> fefoQueue(String storeId) {
    return batches
        .where((batch) => batch.storeId == storeId && batch.quantityCurrent > 0)
        .toList()
      ..sort((a, b) {
        final expiry = a.expiresAt.compareTo(b.expiresAt);
        if (expiry != 0) {
          return expiry;
        }
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  List<AlertRecord> alertsFor(String storeId) {
    return alerts.where((item) => item.storeId == storeId).toList();
  }

  List<StockBatch> recentBatches(String storeId) {
    return batches.where((item) => item.storeId == storeId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  ReportSnapshot reportFor(String storeId) {
    final storeAudits = audits.where((item) => item.storeId == storeId).toList();
    final savings = storeAudits
        .where((item) => item.action == AlertResolution.promotion.label)
        .fold<double>(0, (sum, item) => sum + item.financialImpact);
    final losses = storeAudits
        .where((item) => item.action == AlertResolution.discard.label)
        .fold<double>(0, (sum, item) => sum + item.financialImpact);
    final savedProducts = storeAudits
        .where((item) => item.action == AlertResolution.promotion.label)
        .length;
    final roi = losses == 0 ? 100.0 : (savings / max(losses, 1)) * 100;
    final reduction =
        savings == 0 ? 0.0 : (savings / max(losses + savings, 1)) * 100;
    return ReportSnapshot(
      losses: losses,
      savings: savings,
      savedProducts: savedProducts,
      roi: roi.toDouble(),
      lossReduction: reduction.toDouble(),
    );
  }

  List<AuditRecord> auditFor(String storeId) {
    return audits.where((item) => item.storeId == storeId).toList();
  }

  String generateDailyReportCsv(String storeId) {
    final store = storeById(storeId);
    final storeBatches = batches.where((item) => item.storeId == storeId).toList();
    final rows = <String>[
      'loja,ean,produto,lote,quantidade,validade,status,valor_unitario'
    ];
    for (final batch in storeBatches) {
      rows.add(
        [
          csvEscape(store.name),
          csvEscape(batch.ean13),
          csvEscape(batch.productDescription),
          csvEscape(batch.batchCode),
          batch.quantityCurrent.toString(),
          shortDate(batch.expiresAt),
          batch.zone.label,
          batch.unitValue.toStringAsFixed(2),
        ].join(','),
      );
    }
    return rows.join('\n');
  }

  void _seed() {
    debugPrint('_seed(): preparando dados mockados iniciais do BipStock.');
    final cd = StoreRecord(
      id: 'store-cd',
      name: 'CD - Centro de Distribuicao',
      code: 'CD',
      cnpj: '12.345.678/0001-00',
      kind: StoreKind.distributionCenter,
      regionLabel: 'Hub principal',
    );
    final store1 = StoreRecord(
      id: 'store-1',
      name: 'Nordestao Tirol',
      code: 'TIROL',
      cnpj: '12.345.678/0001-01',
      kind: StoreKind.store,
      regionLabel: 'Zona Leste',
    );
    final store2 = StoreRecord(
      id: 'store-2',
      name: 'Nordestao Lagoa Nova',
      code: 'LAGOA-NOVA',
      cnpj: '12.345.678/0001-02',
      kind: StoreKind.store,
      regionLabel: 'Zona Sul',
    );
    final store3 = StoreRecord(
      id: 'store-3',
      name: 'Nordestao Ponta Negra',
      code: 'PONTA-NEGRA',
      cnpj: '12.345.678/0001-03',
      kind: StoreKind.store,
      regionLabel: 'Litoral Sul',
    );
    final store4 = StoreRecord(
      id: 'store-4',
      name: 'Nordestao Zona Norte',
      code: 'ZONA-NORTE',
      cnpj: '12.345.678/0001-04',
      kind: StoreKind.store,
      regionLabel: 'Zona Norte',
    );
    stores.addAll([cd, store1, store2, store3, store4]);

    users.addAll([
      UserRecord(
        id: 'user-1',
        fullName: 'Chagas Gestor',
        email: 'gestor@bipstock.com',
        password: '1234',
        role: UserRole.manager,
        defaultStoreId: cd.id,
      ),
      UserRecord(
        id: 'user-2',
        fullName: 'Fernando Operação',
        email: 'operacao@bipstock.com',
        password: '1234',
        role: UserRole.operator,
        defaultStoreId: store1.id,
      ),
    ]);

    registerBatch(
      storeId: store1.id,
      userName: 'seed',
      ean13: '7891000000013',
      description: 'Iogurte Natural 170g',
      category: 'Laticínios',
      sector: 'Frios',
      batchCode: 'IOG-101',
      quantity: 18,
      minStock: 8,
      unitValue: 4.89,
      expiresAt: DateTime.now().add(const Duration(days: 5)),
    );
    registerBatch(
      storeId: store1.id,
      userName: 'seed',
      ean13: '7891000000020',
      description: 'Pão de Forma Integral',
      category: 'Padaria',
      sector: 'Padaria',
      batchCode: 'PAD-220',
      quantity: 7,
      minStock: 10,
      unitValue: 9.50,
      expiresAt: DateTime.now().add(const Duration(days: 2)),
    );
    registerBatch(
      storeId: store1.id,
      userName: 'seed',
      ean13: '7891000000037',
      description: 'Maçã Gala Premium',
      category: 'Hortifruti',
      sector: 'FLV',
      batchCode: 'FLV-908',
      quantity: 35,
      minStock: 12,
      unitValue: 2.30,
      expiresAt: DateTime.now().add(const Duration(days: 16)),
    );
    registerBatch(
      storeId: store2.id,
      userName: 'seed',
      ean13: '7891000000044',
      description: 'Frango Resfriado Bandeja',
      category: 'Açougue',
      sector: 'Perecíveis',
      batchCode: 'ACO-331',
      quantity: 8,
      minStock: 10,
      unitValue: 18.90,
      expiresAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    final retailStores = [store1, store2, store3, store4];
    final csvRows = kSeedProductCsv.trim().split('\n').skip(1).toList();
    for (var i = 0; i < csvRows.length; i++) {
      final cols = csvRows[i].split(',');
      if (cols.length < 7) {
        continue;
      }
      final profile = categoryProfileFromCsv(cols[2].trim());
      final retailStore = retailStores[i % retailStores.length];
      registerBatch(
        storeId: retailStore.id,
        userName: 'seed',
        ean13: csvIdToEan13(cols[0].trim(), i),
        description: normalizeSeedText(cols[1].trim()),
        category: profile.name,
        sector: profile.sector,
        batchCode: 'CSV-${i.toString().padLeft(4, '0')}',
        quantity: int.tryParse(cols[4].trim()) ?? 0,
        minStock: max(5, ((int.tryParse(cols[4].trim()) ?? 0) * 0.2).round()),
        unitValue: double.tryParse(cols[3].trim()) ?? 0,
        expiresAt: parseCsvDate(cols[5].trim()),
      );
    }
    debugPrint('_seed(): dados iniciais carregados com sucesso.');
  }
}

class Session {
  const Session({required this.user, required this.storeId});

  final UserRecord user;
  final String storeId;
}

class StoreRecord {
  const StoreRecord({
    required this.id,
    required this.name,
    required this.code,
    required this.cnpj,
    required this.kind,
    required this.regionLabel,
  });

  final String id;
  final String name;
  final String code;
  final String cnpj;
  final StoreKind kind;
  final String regionLabel;
}

class UserRecord {
  const UserRecord({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.defaultStoreId,
  });

  final String id;
  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final String defaultStoreId;
}

enum UserRole { manager, operator }

enum StoreKind { distributionCenter, store }

extension on UserRole {
  String get label => this == UserRole.manager ? 'Gestor' : 'Operação';
}

class ProductRecord {
  const ProductRecord({
    required this.id,
    required this.storeId,
    required this.ean13,
    required this.description,
    required this.category,
    required this.sector,
    required this.minStock,
    required this.unitValue,
  });

  final String id;
  final String storeId;
  final String ean13;
  final String description;
  final String category;
  final String sector;
  final int minStock;
  final double unitValue;

  ProductRecord copyWith({
    String? description,
    String? category,
    String? sector,
    int? minStock,
    double? unitValue,
  }) {
    return ProductRecord(
      id: id,
      storeId: storeId,
      ean13: ean13,
      description: description ?? this.description,
      category: category ?? this.category,
      sector: sector ?? this.sector,
      minStock: minStock ?? this.minStock,
      unitValue: unitValue ?? this.unitValue,
    );
  }
}

enum RiskZone { safe, alert, critical, expired, stockout }

extension on RiskZone {
  String get label {
    switch (this) {
      case RiskZone.safe:
        return 'Seguro';
      case RiskZone.alert:
        return 'Alerta';
      case RiskZone.critical:
        return 'Crítico';
      case RiskZone.expired:
        return 'Vencido';
      case RiskZone.stockout:
        return 'Ruptura';
    }
  }
}

class StockBatch {
  const StockBatch({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.productId,
    required this.productDescription,
    required this.ean13,
    required this.category,
    required this.sector,
    required this.batchCode,
    required this.quantityCurrent,
    required this.unitValue,
    required this.expiresAt,
    required this.createdAt,
  });

  final String id;
  final String storeId;
  final String storeName;
  final String productId;
  final String productDescription;
  final String ean13;
  final String category;
  final String sector;
  final String batchCode;
  final int quantityCurrent;
  final double unitValue;
  final DateTime expiresAt;
  final DateTime createdAt;

  RiskZone get zone => zoneForDate(expiresAt);

  StockBatch copyWith({int? quantityCurrent}) {
    return StockBatch(
      id: id,
      storeId: storeId,
      storeName: storeName,
      productId: productId,
      productDescription: productDescription,
      ean13: ean13,
      category: category,
      sector: sector,
      batchCode: batchCode,
      quantityCurrent: quantityCurrent ?? this.quantityCurrent,
      unitValue: unitValue,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }
}

class AlertRecord {
  const AlertRecord({
    required this.id,
    required this.storeId,
    required this.referenceId,
    required this.title,
    required this.description,
    required this.zone,
    required this.channel,
    required this.createdAt,
    this.acknowledged = false,
  });

  final String id;
  final String storeId;
  final String referenceId;
  final String title;
  final String description;
  final RiskZone zone;
  final String channel;
  final DateTime createdAt;
  final bool acknowledged;

  AlertRecord copyWith({bool? acknowledged}) {
    return AlertRecord(
      id: id,
      storeId: storeId,
      referenceId: referenceId,
      title: title,
      description: description,
      zone: zone,
      channel: channel,
      createdAt: createdAt,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }
}

enum AlertResolution { promotion, restock, discard }

extension on AlertResolution {
  String get label {
    switch (this) {
      case AlertResolution.promotion:
        return 'Promoção aplicada';
      case AlertResolution.restock:
        return 'Reabastecimento';
      case AlertResolution.discard:
        return 'Descarte registrado';
    }
  }
}

class AuditRecord {
  const AuditRecord({
    required this.id,
    required this.storeId,
    required this.userName,
    required this.action,
    required this.details,
    required this.financialImpact,
    required this.createdAt,
  });

  final String id;
  final String storeId;
  final String userName;
  final String action;
  final String details;
  final double financialImpact;
  final DateTime createdAt;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.nearExpiry,
    required this.expired,
    required this.lossesAvoided,
    required this.estimatedSavings,
    required this.productsRegistered,
    required this.activeAlerts,
  });

  final int nearExpiry;
  final int expired;
  final double lossesAvoided;
  final double estimatedSavings;
  final int productsRegistered;
  final int activeAlerts;
}

class RecommendationItem {
  const RecommendationItem({
    required this.title,
    required this.description,
    required this.action,
    required this.impact,
  });

  final String title;
  final String description;
  final String action;
  final double impact;
}

class ReportSnapshot {
  const ReportSnapshot({
    required this.losses,
    required this.savings,
    required this.savedProducts,
    required this.roi,
    required this.lossReduction,
  });

  final double losses;
  final double savings;
  final int savedProducts;
  final double roi;
  final double lossReduction;
}

class CategoryProfile {
  const CategoryProfile({
    required this.name,
    required this.sector,
    required this.shelfLifeDays,
  });

  final String name;
  final String sector;
  final int shelfLifeDays;
}

const List<CategoryProfile> kCategoryProfiles = [
  CategoryProfile(name: 'Mercearia', sector: 'Gondola', shelfLifeDays: 180),
  CategoryProfile(name: 'Laticinios', sector: 'Frios', shelfLifeDays: 15),
  CategoryProfile(name: 'Bebidas', sector: 'Bebidas', shelfLifeDays: 120),
  CategoryProfile(name: 'Padaria', sector: 'Padaria', shelfLifeDays: 7),
  CategoryProfile(name: 'Acougue', sector: 'Pereciveis', shelfLifeDays: 5),
  CategoryProfile(name: 'Hortifruti', sector: 'FLV', shelfLifeDays: 10),
  CategoryProfile(name: 'Higiene e Beleza', sector: 'Higiene', shelfLifeDays: 240),
  CategoryProfile(name: 'Casa e Limpeza', sector: 'Limpeza', shelfLifeDays: 240),
  CategoryProfile(name: 'Eletronicos', sector: 'Acessorios', shelfLifeDays: 365),
  CategoryProfile(name: 'Esporte e Viagem', sector: 'Conveniencia', shelfLifeDays: 365),
  CategoryProfile(name: 'Moda e Acessorios', sector: 'Conveniencia', shelfLifeDays: 365),
];

const String kSeedProductCsv = '''
ID_Produto,Produto,Categoria,Preco_Unit,Estoque_Atual,Data_Vencimento,Status_Vencimento
101-91,Arroz Integral 5kg,Food and beverages,12.12,170,01/07/2026,Critico
102-38,Feijao Carioca 1kg,Food and beverages,13.8,82,23/12/2026,Seguro
103-79,Leite Integral 1L,Food and beverages,10.67,246,28/06/2026,Critico
104-13,Iogurte de Morango 1L,Food and beverages,11.07,149,10/08/2026,Seguro
105-87,Refrigerante de Cola 2L,Food and beverages,7.08,131,23/12/2026,Seguro
106-99,Suco de Laranja Integral 1L,Food and beverages,37.92,142,11/07/2026,Medio
107-85,Cafe Torrado e Moido 500g,Food and beverages,22.05,33,30/06/2026,Critico
108-99,Acucar Refinado 1kg,Food and beverages,30.65,172,30/06/2026,Critico
109-37,Oleo de Soja 900ml,Food and beverages,62.45,202,29/06/2026,Critico
110-21,Macarrao Espaguete 500g,Food and beverages,28.11,213,03/07/2026,Critico
111-87,Molho de Tomate Sache,Food and beverages,21.24,52,11/07/2026,Medio
112-78,Biscoito Recheado Chocolate,Food and beverages,12.93,223,29/06/2026,Critico
113-80,Pao de Forma Tradicional,Food and beverages,22.94,346,03/07/2026,Critico
114-83,Manteiga com Sal 200g,Food and beverages,16.94,65,28/06/2026,Critico
115-94,Queijo Prato Fatiado kg,Food and beverages,19.06,178,29/06/2026,Critico
116-39,Presunto Cozido Fatiado kg,Food and beverages,57.06,224,02/07/2026,Critico
117-64,Cerveja Puro Malte Lata 350ml,Food and beverages,30.37,235,10/08/2026,Seguro
118-20,Vinho Tinto Seco 750ml,Food and beverages,81.4,120,29/06/2026,Critico
119-94,Chocolate em Barra 90g,Food and beverages,97.37,181,03/07/2026,Critico
120-22,Salgadinho de Batata Classica,Food and beverages,92.6,263,11/07/2026,Medio
121-68,Peito de Frango File 1kg,Food and beverages,46.61,169,30/06/2026,Critico
122-83,Carne Moida de Acem 1kg,Food and beverages,60.87,14,30/06/2026,Critico
123-52,Costela Suina Resfriada kg,Food and beverages,24.49,115,29/06/2026,Critico
124-41,Ovos Brancos Grandes 12un,Food and beverages,92.98,39,01/07/2026,Critico
125-94,Sorvete de Creme 1.5L,Food and beverages,18.08,318,29/06/2026,Critico
126-78,Agua Mineral Sem Gas 1.5L,Food and beverages,42.82,236,03/07/2026,Critico
127-14,Maionese Tradicional 500g,Food and beverages,48.09,243,11/07/2026,Medio
128-44,Ketchup Picante 400g,Food and beverages,55.97,55,10/08/2026,Seguro
129-82,Cereal Matinal Matuto,Food and beverages,76.9,133,10/08/2026,Seguro
130-31,Sardinha em Lata,Food and beverages,97.03,139,11/07/2026,Medio
131-31,Sabonete em Barra Hidratante,Health and beauty,44.65,150,25/02/2027,Seguro
132-72,Shampoo Nutricao Profunda,Health and beauty,77.93,135,22/08/2026,Seguro
133-14,Condicionador Brilho Intenso,Health and beauty,71.95,142,26/07/2026,Seguro
134-80,Creme Dental Protecao Total,Health and beauty,89.25,72,25/08/2026,Seguro
135-15,Desodorante Antitranspirante Roll-on,Health and beauty,26.02,53,30/06/2026,Critico
136-12,Fio Dental Menta 50m,Health and beauty,13.5,134,25/08/2026,Seguro
137-67,Papel Higienico Folha Dupla x12,Health and beauty,99.3,239,30/06/2026,Critico
138-16,Protetor Solar FPS 30,Health and beauty,51.69,27,21/02/2027,Seguro
139-49,Hidratante Corporal 400ml,Health and beauty,54.73,151,21/02/2027,Seguro
140-54,Espuma de Barbear Refrescante,Health and beauty,27.0,135,26/07/2026,Seguro
141-89,Aparelho de Barbear Descartavel c/2,Health and beauty,30.24,115,25/08/2026,Seguro
142-23,Sabonete Liquido Refil,Health and beauty,89.14,244,30/06/2026,Critico
143-69,Alcool em Gel Antisseptico 70%,Health and beauty,37.55,146,26/07/2026,Seguro
144-84,Protetor Labial Hidratante,Health and beauty,95.44,191,22/08/2026,Seguro
145-21,Creme de Pentear Cachos,Health and beauty,27.5,74,30/06/2026,Critico
146-56,Algodao em Disco c/50,Health and beauty,74.97,44,25/08/2026,Seguro
147-38,Enxaguante Bucal Zero Alcool,Health and beauty,80.96,44,30/06/2026,Critico
148-73,Creme de Hidratacao Facial,Health and beauty,94.47,40,22/08/2026,Seguro
149-16,Detergente Liquido Neutro 500ml,Home and lifestyle,99.79,166,10/07/2026,Medio
150-13,Desinfetante Eucalipto 1L,Home and lifestyle,73.22,238,24/07/2026,Seguro
151-54,Amaciante de Roupas Concentrado 2L,Home and lifestyle,41.24,132,10/07/2026,Medio
152-32,Sabao em Po Ativo 1kg,Home and lifestyle,81.68,132,10/07/2026,Medio
153-61,Esponja de Aco Pacote c/4,Home and lifestyle,51.32,122,24/10/2026,Seguro
154-84,Saco de Lixo Reforcado 50L,Home and lifestyle,65.94,122,24/10/2026,Seguro
155-46,Agua Sanitaria Multiuso 1L,Home and lifestyle,14.36,151,10/07/2026,Medio
156-55,Pano de Prato Algodao c/3,Home and lifestyle,21.5,151,10/07/2026,Medio
157-19,Lampada LED 12W Branca,Home and lifestyle,26.26,95,24/10/2026,Seguro
158-96,Pilha Alcalina AAA c/4,Home and lifestyle,60.96,218,24/10/2026,Seguro
159-20,Organizador Plastico Transparente,Home and lifestyle,70.11,218,24/10/2026,Seguro
160-24,Vela Aromatica Lavanda,Home and lifestyle,42.08,218,24/10/2026,Seguro
161-46,Inseticida Aerosol Multi,Home and lifestyle,67.09,218,24/10/2026,Seguro
162-81,Limpador Multiuso Classico,Home and lifestyle,96.7,218,24/10/2026,Seguro
163-44,Vassoura de Nylon com Cabo,Home and lifestyle,35.38,218,24/10/2026,Seguro
164-32,Sabao em Barra Azul c/5,Home and lifestyle,95.49,218,24/10/2026,Seguro
165-38,Inseticida Eletrico Aparelho,Home and lifestyle,96.98,218,24/10/2026,Seguro
166-70,Flanela de Limpeza Microfibra,Home and lifestyle,23.65,218,24/10/2026,Seguro
167-27,Fone de Ouvido Intra-auricular,Electronic accessories,82.33,70,26/06/2027,Seguro
168-39,Carregador Portatil 10000mAh,Electronic accessories,26.61,42,26/06/2027,Seguro
169-15,Cabo HDMI High Speed 2m,Electronic accessories,99.69,99,26/06/2027,Seguro
170-22,Mouse Sem Fio Otimizado,Electronic accessories,74.89,53,08/11/2027,Seguro
171-87,Cartao de Memoria MicroSD 64GB,Electronic accessories,40.94,62,08/11/2027,Seguro
172-87,Pendrive USB 3.0 32GB,Electronic accessories,75.82,40,08/11/2027,Seguro
173-95,Adaptador de Tomada Padrao,Electronic accessories,46.77,60,26/06/2027,Seguro
174-89,Suporte de Celular Automotivo,Electronic accessories,32.32,10,26/06/2027,Seguro
175-68,Pelicula de Vidro Universal,Electronic accessories,54.07,95,26/06/2027,Seguro
176-79,Pilha Recarregavel AA c/2,Electronic accessories,18.22,46,26/06/2027,Seguro
177-31,Cabo USB-C de Carregamento Rapido,Electronic accessories,80.48,51,08/11/2027,Seguro
178-99,Adaptador Bluetooth USB,Electronic accessories,37.95,97,08/11/2027,Seguro
179-88,Garrafa Termica Inox 750ml,Sports and travel,76.82,62,26/06/2027,Seguro
180-87,Joelheira Elastica de Compressao,Sports and travel,52.26,12,26/06/2027,Seguro
181-89,Corda de Pular Ajustavel,Sports and travel,79.74,73,26/06/2027,Seguro
182-35,Faixa Elastica de Exercicios,Sports and travel,77.5,43,26/06/2027,Seguro
183-50,Kit de Meias Cano Alto x3,Sports and travel,54.27,46,26/06/2027,Seguro
184-75,Mochila de Costas Casual,Sports and travel,13.59,58,26/06/2027,Seguro
185-93,Bone Esportivo Dry-Fit,Sports and travel,41.06,83,26/06/2027,Seguro
186-29,Toalha de Microfibra Esportiva,Sports and travel,19.24,80,26/06/2027,Seguro
187-57,Oculos de Natacao Antiembacante,Sports and travel,39.43,94,26/06/2027,Seguro
188-41,Caneleira de Peso 2kg Par,Sports and travel,46.22,62,26/06/2027,Seguro
189-53,Tapete de Yoga em EVA,Sports and travel,13.98,98,26/06/2027,Seguro
190-25,Bolsa Termica Impermeavel,Sports and travel,39.75,96,26/06/2027,Seguro
191-23,Chinelo de Borracha Classico,Fashion accessories,97.79,49,26/06/2027,Seguro
192-36,Meia Invisivel Algodao x3,Fashion accessories,67.26,80,26/06/2027,Seguro
193-01,Cinto Casual Ajustavel,Fashion accessories,13.79,78,26/06/2027,Seguro
194-43,Carteira de Couro Slim,Fashion accessories,68.71,41,26/06/2027,Seguro
195-23,Relogio Digital de Pulso,Fashion accessories,56.53,55,26/06/2027,Seguro
196-84,Oculos de Sol Protecao UV,Fashion accessories,23.82,54,26/06/2027,Seguro
197-39,Bone Aba Reta Urbano,Fashion accessories,34.21,51,08/11/2027,Seguro
198-44,Presilha de Cabelo Kit c/4,Fashion accessories,21.87,69,08/11/2027,Seguro
199-73,Ecobag de Algodao Cru,Fashion accessories,20.97,78,08/11/2027,Seguro
200-23,Lenco de Pescoco Estampado,Fashion accessories,50.2,81,08/11/2027,Seguro
''';

ButtonStyle primaryButton() {
  return FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(54),
    backgroundColor: corPrimariaNordestao,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontWeight: FontWeight.w800),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  );
}

ButtonStyle outlinedButton() {
  return OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: const BorderSide(color: corBordaSuave),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    minimumSize: const Size(0, 48),
  );
}

CategoryProfile categoryProfileFromCsv(String sourceCategory) {
  switch (sourceCategory) {
    case 'Health and beauty':
      return kCategoryProfiles[6];
    case 'Home and lifestyle':
      return kCategoryProfiles[7];
    case 'Electronic accessories':
      return kCategoryProfiles[8];
    case 'Sports and travel':
      return kCategoryProfiles[9];
    case 'Fashion accessories':
      return kCategoryProfiles[10];
    case 'Food and beverages':
    default:
      return kCategoryProfiles[0];
  }
}

String csvIdToEan13(String source, int index) {
  final digits = source.replaceAll(RegExp(r'[^0-9]'), '');
  final padded = (digits + (1000000000000 + index).toString()).substring(0, 13);
  return padded;
}

String suggestedExpiryFor(int shelfLifeDays) {
  return DateTime.now()
      .add(Duration(days: shelfLifeDays))
      .toIso8601String()
      .split('T')
      .first;
}

DateTime parseCsvDate(String value) {
  final parts = value.split('/');
  if (parts.length != 3) {
    return DateTime.now().add(const Duration(days: 30));
  }
  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}

String normalizeSeedText(String value) {
  return value
      .replaceAll('Ã£', 'a')
      .replaceAll('Ã§', 'c')
      .replaceAll('Ã­', 'i')
      .replaceAll('Ã¡', 'a')
      .replaceAll('Ã©', 'e')
      .replaceAll('Ã³', 'o')
      .replaceAll('Ãº', 'u')
      .replaceAll('Ã¢', 'a')
      .replaceAll('Ãª', 'e')
      .replaceAll('Ãµ', 'o')
      .replaceAll('Ã‰', 'E')
      .replaceAll('Ã“', 'O')
      .replaceAll('Â', '');
}

String csvEscape(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

String? validateEmail(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    return 'Campo obrigatório';
  }
  if (!text.contains('@')) {
    return 'E-mail inválido';
  }
  return null;
}

String? validateEan13(String? value) {
  final text = value?.trim() ?? '';
  if (!RegExp(r'^\d{13}$').hasMatch(text)) {
    return 'Informe um EAN-13 válido';
  }
  return null;
}

String? validatePositiveInt(String? value) {
  final number = int.tryParse(value ?? '');
  if (number == null || number <= 0) {
    return 'Informe um número maior que zero';
  }
  return null;
}

String? extractEan13(String input) {
  final match = RegExp(r'\d{13}').firstMatch(input);
  return match?.group(0);
}

double parseCurrency(String input) {
  return double.tryParse(input.replaceAll('.', '').replaceAll(',', '.')) ?? 0;
}

String money(double value) => 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

String shortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String shortDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${shortDate(date)} $hour:$minute';
}

String generateBatchCode() {
  final now = DateTime.now();
  return 'LOT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecond.toString().padLeft(3, '0')}';
}

RiskZone zoneForDate(DateTime date) {
  final days = DateTime(date.year, date.month, date.day)
      .difference(DateTime.now().copyDate())
      .inDays;
  if (days < 0) {
    return RiskZone.expired;
  }
  if (days <= 7) {
    return RiskZone.critical;
  }
  if (days <= 15) {
    return RiskZone.alert;
  }
  return RiskZone.safe;
}

Color zoneColor(RiskZone zone) {
  switch (zone) {
    case RiskZone.safe:
      return corRiscoSeguro;
    case RiskZone.alert:
      return corRiscoAlerta;
    case RiskZone.critical:
      return corRiscoCritico;
    case RiskZone.expired:
      return corRiscoVencido;
    case RiskZone.stockout:
      return corSecundariaNordestao;
  }
}

bool sameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

extension on DateTime {
  DateTime copyDate() => DateTime(year, month, day);
}
