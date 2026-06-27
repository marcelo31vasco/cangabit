import 'dart:math';

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
  runApp(const AplicativoBipstock());
}

class AplicativoBipstock extends StatelessWidget {
  const AplicativoBipstock({super.key});

  ContaUsuario _usuarioInicial() {
    return ArmazenamentoAutenticacao.instancia.usuarioGestorPadrao;
  }

  @override
  Widget build(BuildContext context) {
    final usuarioInicial = _usuarioInicial();
    return MaterialApp(
      title: 'BIPSTOCK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: corFundoAplicacao,
        colorScheme: const ColorScheme.light(
          primary: corPrimariaNordestao,
          secondary: corSecundariaNordestao,
          surface: corSuperficie,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: corTextoPrincipal,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: corSecundariaNordestao,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: corSecundariaNordestao,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: corSuperficie,
          labelStyle: const TextStyle(color: corTextoSecundario),
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
            borderSide: const BorderSide(color: corPrimariaNordestao, width: 1.5),
          ),
        ),
      ),
      home: TelaPrincipal(contaUsuario: usuarioInicial),
    );
  }
}

class TelaDeAcessoRapido extends StatelessWidget {
  const TelaDeAcessoRapido({super.key});

  void _acessar(BuildContext context, ContaUsuario contaUsuario) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TelaDeLojas(contaUsuario: contaUsuario)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ArmazenamentoAutenticacao.instancia;
    final gestor = auth.fazerLogin('chagas@plugselo.com', '1234');
    final repositor = auth.fazerLogin('fernando@plugselo.com', '4321');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CabecalhoBipstock(
                titulo: 'Escolha seu acesso',
                subtitulo:
                    'Entramos direto na operacao. Selecione a persona para abrir o app sem tela inicial, login ou cadastro.',
              ),
              const SizedBox(height: 24),
              _CardDeAcessoPersona(
                titulo: 'Chagas',
                subtitulo: 'Gestor • senha 1234',
                descricao:
                    'Acesso gerencial completo para dashboard, recomendacoes, cadastro e visualizacoes gerais.',
                icone: Icons.bar_chart_rounded,
                onTap: gestor == null ? null : () => _acessar(context, gestor),
              ),
              const SizedBox(height: 14),
              _CardDeAcessoPersona(
                titulo: 'Fernando',
                subtitulo: 'Repositor • senha 4321',
                descricao:
                    'Acesso focado em operacao de loja, leitura de produtos e reposicao de estoque.',
                icone: Icons.inventory_2_outlined,
                onTap: repositor == null ? null : () => _acessar(context, repositor),
              ),
              const Spacer(),
              const RodapeCangaBit(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDeAcessoPersona extends StatelessWidget {
  const _CardDeAcessoPersona({
    required this.titulo,
    required this.subtitulo,
    required this.descricao,
    required this.icone,
    required this.onTap,
  });

  final String titulo;
  final String subtitulo;
  final String descricao;
  final IconData icone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: caixaPadrao(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icone, color: corPrimariaNordestao),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: corTextoPrincipal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: corPrimariaNordestao,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: corTextoSecundario,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded, color: corSecundariaNordestao),
          ],
        ),
      ),
    );
  }
}

class TelaDeCadastro extends StatefulWidget {
  const TelaDeCadastro({super.key});

  @override
  State<TelaDeCadastro> createState() => _TelaDeCadastroState();
}

class _TelaDeCadastroState extends State<TelaDeCadastro> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorTelefone = TextEditingController();
  final _controladorCpf = TextEditingController();
  final _controladorSenha = TextEditingController();
  TipoPerfilUsuario _perfilSelecionado = TipoPerfilUsuario.repositor;

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorEmail.dispose();
    _controladorTelefone.dispose();
    _controladorCpf.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  void _avancar() {
    if (!_chaveFormulario.currentState!.validate()) {
      return;
    }

    final resultado = ArmazenamentoAutenticacao.instancia.cadastrarConta(
      nomeCompleto: _controladorNome.text.trim(),
      email: _controladorEmail.text.trim(),
      telefone: _controladorTelefone.text.trim(),
      cpf: _controladorCpf.text.trim(),
      senha: _controladorSenha.text,
      perfil: _perfilSelecionado,
    );

    if (resultado.mensagemErro != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(resultado.mensagemErro!)));
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TelaDeLojas(contaUsuario: resultado.contaUsuario!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CabecalhoBipstock(
                  titulo: 'Cadastro',
                  subtitulo:
                      'Crie sua conta para operar captura, estoque e alertas de validade.',
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: caixaPadrao(),
                  child: Form(
                    key: _chaveFormulario,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controladorNome,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                          ),
                          validator: _validarCampoObrigatorio,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _controladorEmail,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'E-mail'),
                          validator: _validarEmail,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _controladorTelefone,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                          ),
                          validator: _validarCampoObrigatorio,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _controladorCpf,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'CPF'),
                          validator: _validarCampoObrigatorio,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _controladorSenha,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Defina sua senha',
                          ),
                          validator: _validarSenha,
                          onFieldSubmitted: (_) => _avancar(),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nivel de permissao',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SegmentedButton<TipoPerfilUsuario>(
                          segments: const [
                            ButtonSegment(
                              value: TipoPerfilUsuario.repositor,
                              label: Text('Repositor'),
                              icon: Icon(Icons.inventory_2_outlined),
                            ),
                            ButtonSegment(
                              value: TipoPerfilUsuario.gestor,
                              label: Text('Gestor'),
                              icon: Icon(Icons.bar_chart_rounded),
                            ),
                          ],
                          selected: {_perfilSelecionado},
                          onSelectionChanged: (novoValor) {
                            setState(() => _perfilSelecionado = novoValor.first);
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _avancar,
                          style: botaoPrimario(),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TelaDeLogin(),
                              ),
                            );
                          },
                          child: const Text('Ja tenho cadastro'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const RodapeCangaBit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validarCampoObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Campo obrigatorio';
    }
    if (!texto.contains('@')) {
      return 'Informe um e-mail valido';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatorio';
    }
    if (valor.length < 4) {
      return 'A senha deve ter pelo menos 4 caracteres';
    }
    return null;
  }
}

class TelaDeLogin extends StatefulWidget {
  const TelaDeLogin({super.key});

  @override
  State<TelaDeLogin> createState() => _TelaDeLoginState();
}

class _TelaDeLoginState extends State<TelaDeLogin> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_chaveFormulario.currentState!.validate()) {
      return;
    }

    final contaUsuario = ArmazenamentoAutenticacao.instancia.fazerLogin(
      _controladorEmail.text.trim(),
      _controladorSenha.text,
    );

    if (contaUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha invalidos.')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => _resolverDestino(contaUsuario)),
    );
  }

  Widget _resolverDestino(ContaUsuario contaUsuario) {
    if (contaUsuario.lojaSelecionada == null) {
      return TelaDeLojas(contaUsuario: contaUsuario);
    }
    return TelaPrincipal(contaUsuario: contaUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CabecalhoBipstock(
                titulo: 'Login',
                subtitulo:
                    'Acesse sua conta com e-mail e senha para acompanhar lotes, alertas e operacao FEFO.',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: caixaPadrao(),
                child: Form(
                  key: _chaveFormulario,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controladorEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Campo obrigatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _controladorSenha,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Campo obrigatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _entrar(),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _entrar,
                        style: botaoPrimario(),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TelaRecuperacaoDeSenha(),
                            ),
                          );
                        },
                        child: const Text('Esqueceu senha?'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const RodapeCangaBit(),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaRecuperacaoDeSenha extends StatefulWidget {
  const TelaRecuperacaoDeSenha({super.key});

  @override
  State<TelaRecuperacaoDeSenha> createState() => _TelaRecuperacaoDeSenhaState();
}

class _TelaRecuperacaoDeSenhaState extends State<TelaRecuperacaoDeSenha> {
  final _controladorEmail = TextEditingController();
  final _controladorCodigo = TextEditingController();
  final _controladorNovaSenha = TextEditingController();

  bool _codigoEnviado = false;
  String? _emailDestino;

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorCodigo.dispose();
    _controladorNovaSenha.dispose();
    super.dispose();
  }

  void _enviarCodigo() {
    final email = _controladorEmail.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um e-mail valido.')),
      );
      return;
    }

    final codigo = ArmazenamentoAutenticacao.instancia.gerarCodigoRecuperacao(
      email,
    );
    if (codigo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum cadastro encontrado para este e-mail.'),
        ),
      );
      return;
    }

    setState(() {
      _codigoEnviado = true;
      _emailDestino = email;
    });

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: corSuperficie,
          title: const Text('Codigo gerado no MVP'),
          content: Text(
            'No MVP local nao existe envio real de e-mail.\n\nCodigo para $email:\n$codigo',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _trocarSenha() {
    final email = _emailDestino ?? _controladorEmail.text.trim();
    final codigo = _controladorCodigo.text.trim();
    final novaSenha = _controladorNovaSenha.text;

    if (codigo.isEmpty || novaSenha.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o codigo e uma nova senha valida.'),
        ),
      );
      return;
    }

    final sucesso = ArmazenamentoAutenticacao.instancia.redefinirSenha(
      email: email,
      codigo: codigo,
      novaSenha: novaSenha,
    );

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Codigo invalido ou expirado.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha alterada com sucesso.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CabecalhoBipstock(
                titulo: 'Recuperar senha',
                subtitulo:
                    'Solicite um codigo pelo e-mail e defina uma nova senha.',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: caixaPadrao(),
                child: Column(
                  children: [
                    TextField(
                      controller: _controladorEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail cadastrado',
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.tonal(
                      onPressed: _enviarCodigo,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: const Color(0xFFFDE6E2),
                        foregroundColor: corPrimariaNordestao,
                      ),
                      child: const Text('Enviar codigo'),
                    ),
                    if (_codigoEnviado) ...[
                      const SizedBox(height: 18),
                      TextField(
                        controller: _controladorCodigo,
                        decoration: const InputDecoration(
                          labelText: 'Codigo recebido',
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _controladorNovaSenha,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Nova senha'),
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: _trocarSenha,
                        style: botaoPrimario(),
                        child: const Text(
                          'Trocar senha',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const RodapeCangaBit(),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaDeLojas extends StatefulWidget {
  const TelaDeLojas({super.key, required this.contaUsuario});

  final ContaUsuario contaUsuario;

  @override
  State<TelaDeLojas> createState() => _TelaDeLojasState();
}

class _TelaDeLojasState extends State<TelaDeLojas> {
  static const List<String> lojas = [
    'Nordestao Salgado Filho',
    'Nordestao Tirol',
    'Nordestao Cidade Jardim',
    'Nordestao Igapo',
    'Nordestao Nova Parnamirim',
  ];

  String? lojaSelecionada;

  @override
  void initState() {
    super.initState();
    lojaSelecionada = widget.contaUsuario.lojaSelecionada;
  }

  void _acessarOperacao() {
    if (lojaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma loja para continuar.')),
      );
      return;
    }

    widget.contaUsuario.lojaSelecionada = lojaSelecionada;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TelaPrincipal(contaUsuario: widget.contaUsuario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CabecalhoBipstock(
                titulo: 'Qual filial voce vai operar?',
                subtitulo:
                    'Selecione a unidade vinculada aos produtos, lotes e alertas.',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: lojas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, indice) {
                    final loja = lojas[indice];
                    final selecionada = loja == lojaSelecionada;
                    return InkWell(
                      onTap: () {
                        setState(() => lojaSelecionada = loja);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: selecionada
                              ? const Color(0xFFFFEFEA)
                              : corSuperficie,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selecionada
                                ? corPrimariaNordestao
                                : corBordaSuave,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selecionada
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                              color: selecionada
                                  ? corPrimariaNordestao
                                  : corTextoSecundario,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                loja,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _acessarOperacao,
                style: botaoPrimario(),
                child: const Text(
                  'Acessar Operacao',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 18),
              const RodapeCangaBit(),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, required this.contaUsuario});

  final ContaUsuario contaUsuario;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final CentralDeEstoque _central = CentralDeEstoque.instancia;
  final FiltroDashboard _filtro = FiltroDashboard();
  bool _rotinaExecutadaAoAbrir = false;

  @override
  void initState() {
    super.initState();
    _filtro.filial = widget.contaUsuario.lojaSelecionada;
    WidgetsBinding.instance.addPostFrameCallback((_) => _executarRotinaInicial());
  }

  void _executarRotinaInicial() {
    if (_rotinaExecutadaAoAbrir) {
      return;
    }
    _rotinaExecutadaAoAbrir = true;
    final resultado = _central.executarVarreduraDiaria(
      filial: widget.contaUsuario.lojaSelecionada,
      usuario: widget.contaUsuario.nomeCompleto,
    );
    if (resultado.novosAlertas > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Rotina diaria executada: ${resultado.novosAlertas} novo(s) alerta(s) gerado(s).',
          ),
        ),
      );
      setState(() {});
    }
  }

  Future<void> _abrirScanner() async {
    final resultado = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const TelaDeCamera()),
    );

    if (resultado == null || !mounted) {
      return;
    }

    await _abrirCadastroDeLote(codigoBarrasInicial: resultado);
  }

  Future<void> _abrirCadastroDeLote({String? codigoBarrasInicial}) async {
    final alterou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TelaCadastroDeLote(
          filialPadrao: widget.contaUsuario.lojaSelecionada ?? '',
          produtoInicial: codigoBarrasInicial == null
              ? null
              : _central.localizarOuCriarProduto(codigoBarrasInicial),
          codigoBarrasInicial: codigoBarrasInicial,
        ),
      ),
    );

    if (alterou == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _abrirAjusteManual() async {
    final alterou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TelaAjusteManual(
          filtro: _filtro,
          usuario: widget.contaUsuario,
        ),
      ),
    );

    if (alterou == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _abrirIntegracaoDeVendas() async {
    final alterou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TelaIntegracaoDeVendas(
          filialPadrao: widget.contaUsuario.lojaSelecionada ?? '',
        ),
      ),
    );
    if (alterou == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _mostrarRelatorio() async {
    final relatorio = _central.gerarRelatorioTexto(_filtro);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: corSuperficie,
          title: const Text('Relatorio exportavel'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: SelectableText(
                relatorio,
                style: const TextStyle(height: 1.45, color: corTextoPrincipal),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: relatorio));
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Relatorio copiado.')),
                );
              },
              child: const Text('Copiar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _executarRotinaAgora() {
    final resultado = _central.executarVarreduraDiaria(
      filial: _filtro.filial,
      usuario: widget.contaUsuario.nomeCompleto,
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Rotina concluida. ${resultado.novosAlertas} alerta(s), ${resultado.notificacoesEnviadas} notificacao(oes).',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _central.calcularDashboard(_filtro);
    final fefo = _central.obterFilaFefo(_filtro);
    final alertas = _central.obterAlertasRecentes(_filtro);
    final acoes = _central.obterSugestoesDeAcao(_filtro);
    final podeGerir = widget.contaUsuario.perfil == TipoPerfilUsuario.gestor;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final acao = await showModalBottomSheet<_AcaoRapida>(
            context: context,
            backgroundColor: corSuperficie,
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    runSpacing: 12,
                    children: [
                      _ItemAcaoRapida(
                        titulo: 'Escanear EAN-13',
                        icone: Icons.qr_code_scanner_rounded,
                        onTap: () => Navigator.of(
                          context,
                        ).pop(_AcaoRapida.escanear),
                      ),
                      _ItemAcaoRapida(
                        titulo: 'Cadastrar lote manualmente',
                        icone: Icons.playlist_add_circle_outlined,
                        onTap: () => Navigator.of(
                          context,
                        ).pop(_AcaoRapida.cadastrarLote),
                      ),
                      _ItemAcaoRapida(
                        titulo: 'Simular saida via ERP/PDV',
                        icone: Icons.sync_alt_rounded,
                        onTap: () => Navigator.of(
                          context,
                        ).pop(_AcaoRapida.integracao),
                      ),
                      if (podeGerir)
                        _ItemAcaoRapida(
                          titulo: 'Ajuste manual de inventario',
                          icone: Icons.tune_rounded,
                          onTap: () => Navigator.of(
                            context,
                          ).pop(_AcaoRapida.ajusteManual),
                        ),
                      if (podeGerir)
                        _ItemAcaoRapida(
                          titulo: 'Exportar relatorio',
                          icone: Icons.file_download_outlined,
                          onTap: () =>
                              Navigator.of(context).pop(_AcaoRapida.relatorio),
                        ),
                    ],
                  ),
                ),
              );
            },
          );

          switch (acao) {
            case _AcaoRapida.escanear:
              await _abrirScanner();
              break;
            case _AcaoRapida.cadastrarLote:
              await _abrirCadastroDeLote();
              break;
            case _AcaoRapida.integracao:
              await _abrirIntegracaoDeVendas();
              break;
            case _AcaoRapida.ajusteManual:
              await _abrirAjusteManual();
              break;
            case _AcaoRapida.relatorio:
              await _mostrarRelatorio();
              break;
            case null:
              break;
          }
        },
        backgroundColor: corPrimariaNordestao,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Operacoes'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CabecalhoBipstock(
                      titulo: 'Ola, ${widget.contaUsuario.primeiroNome}!',
                      subtitulo:
                          '${widget.contaUsuario.lojaSelecionada ?? 'Sem loja'} â€¢ ${widget.contaUsuario.nomeDoPerfil}',
                    ),
                    const SizedBox(height: 20),
                    _CartaoResumoOperacao(
                      dashboard: dashboard,
                      ultimaRotina: _central.ultimaExecucaoFormatada,
                    ),
                    const SizedBox(height: 16),
                    _PainelDeFiltros(
                      filtro: _filtro,
                      opcoesCategoria: _central.categoriasDisponiveis,
                      opcoesSetor: _central.setoresDisponiveis,
                      opcoesFilial: _central.filiaisDisponiveis,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _CardIndicador(
                          titulo: 'Perdas evitadas',
                          valor: formatarMoeda(dashboard.valorDePerdasEvitadas),
                          detalhe:
                              '${dashboard.acoesPreventivasExecutadas} acao(oes) executada(s)',
                          destaque: corRiscoSeguro,
                        ),
                        _CardIndicador(
                          titulo: 'Produtos em risco',
                          valor: '${dashboard.lotesEmRisco}',
                          detalhe:
                              '${dashboard.itensCriticos} critico(s) â€¢ ${dashboard.itensEmAlerta} alerta(s)',
                          destaque: corRiscoAlerta,
                        ),
                        _CardIndicador(
                          titulo: 'Valor dos lotes criticos',
                          valor: formatarMoeda(dashboard.valorLotesCriticos),
                          detalhe: 'Baseado no saldo atual filtrado',
                          destaque: corRiscoCritico,
                        ),
                        _CardIndicador(
                          titulo: 'Saldo total em estoque',
                          valor: '${dashboard.quantidadeTotalEmEstoque}',
                          detalhe: '${dashboard.totalDeLotes} lote(s) no filtro',
                          destaque: corSecundariaNordestao,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Fila FEFO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: corTextoPrincipal,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _executarRotinaAgora,
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Rodar rotina'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (fefo.isEmpty)
                      const _PainelVazio(
                        titulo: 'Nenhum lote encontrado',
                        subtitulo: 'Ajuste os filtros ou cadastre novos lotes.',
                      )
                    else
                      ...fefo.take(6).map(
                        (lote) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CardLoteFefo(
                            lote: lote,
                            onAplicarAcao: widget.contaUsuario.perfil ==
                                    TipoPerfilUsuario.gestor
                                ? () {
                                    _central.executarAcaoPreventiva(
                                      loteId: lote.id,
                                      usuario: widget.contaUsuario.nomeCompleto,
                                    );
                                    setState(() {});
                                  }
                                : null,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    const Text(
                      'Alertas recentes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: corTextoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (alertas.isEmpty)
                      const _PainelVazio(
                        titulo: 'Nenhum alerta recente',
                        subtitulo: 'A rotina diaria ainda nao detectou novos riscos.',
                      )
                    else
                      ...alertas.take(5).map(
                        (alerta) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CardAlerta(alerta: alerta),
                        ),
                      ),
                    const SizedBox(height: 18),
                    const Text(
                      'Acoes sugeridas pelo motor de regras',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: corTextoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (acoes.isEmpty)
                      const _PainelVazio(
                        titulo: 'Sem sugestoes no momento',
                        subtitulo: 'Os lotes filtrados estao em situacao controlada.',
                      )
                    else
                      ...acoes.take(5).map(
                        (acao) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CardAcaoPreventiva(
                            acao: acao,
                            podeExecutar: podeGerir,
                            onExecutar: podeGerir
                                ? () {
                                    _central.executarAcaoPreventiva(
                                      loteId: acao.lote.id,
                                      usuario: widget.contaUsuario.nomeCompleto,
                                    );
                                    setState(() {});
                                  }
                                : null,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    const RodapeCangaBit(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, indice) {
                  final lotes = fefo.take(8).toList();
                  if (indice >= lotes.length) {
                    return const SizedBox.shrink();
                  }
                  return _MiniCardLote(lote: lotes[indice]);
                }, childCount: min(fefo.length, 8)),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaCadastroDeLote extends StatefulWidget {
  const TelaCadastroDeLote({
    super.key,
    required this.filialPadrao,
    this.produtoInicial,
    this.codigoBarrasInicial,
  });

  final String filialPadrao;
  final ProdutoCatalogo? produtoInicial;
  final String? codigoBarrasInicial;

  @override
  State<TelaCadastroDeLote> createState() => _TelaCadastroDeLoteState();
}

class _TelaCadastroDeLoteState extends State<TelaCadastroDeLote> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoBarrasController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _categoriaController;
  late final TextEditingController _setorController;
  final _loteController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '12');
  final _valorController = TextEditingController(text: '0,00');
  DateTime _validadeSelecionada = DateTime.now().add(const Duration(days: 7));
  final CentralDeEstoque _central = CentralDeEstoque.instancia;

  @override
  void initState() {
    super.initState();
    final produto = widget.produtoInicial;
    _codigoBarrasController = TextEditingController(
      text: widget.codigoBarrasInicial ?? produto?.ean13 ?? '',
    );
    _descricaoController = TextEditingController(text: produto?.descricao ?? '');
    _categoriaController = TextEditingController(text: produto?.categoria ?? '');
    _setorController = TextEditingController(text: produto?.setor ?? '');
    _valorController.text = produto == null
        ? '0,00'
        : produto.valorUnitario.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  void dispose() {
    _codigoBarrasController.dispose();
    _descricaoController.dispose();
    _categoriaController.dispose();
    _setorController.dispose();
    _loteController.dispose();
    _quantidadeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _aplicarAtalhoDeValidade(int dias) {
    setState(() {
      _validadeSelecionada = DateTime.now().add(Duration(days: dias));
    });
  }

  Future<void> _escolherData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _validadeSelecionada,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data != null) {
      setState(() => _validadeSelecionada = data);
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantidade = int.tryParse(_quantidadeController.text.trim()) ?? 0;
    final valor = parseMoeda(_valorController.text);

    if (quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma quantidade valida.')),
      );
      return;
    }

    _central.cadastrarLote(
      ean13: _codigoBarrasController.text.trim(),
      descricao: _descricaoController.text.trim(),
      categoria: _categoriaController.text.trim(),
      setor: _setorController.text.trim(),
      codigoLote: _loteController.text.trim().isEmpty
          ? gerarCodigoLote()
          : _loteController.text.trim(),
      quantidade: quantidade,
      valorUnitario: valor,
      validade: _validadeSelecionada,
      filial: widget.filialPadrao,
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de lote')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: caixaPadrao(),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _codigoBarrasController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'EAN-13 do produto',
                        ),
                        validator: validarObrigatorio,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descricao do produto',
                        ),
                        validator: validarObrigatorio,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _categoriaController,
                        decoration: const InputDecoration(labelText: 'Categoria'),
                        validator: validarObrigatorio,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _setorController,
                        decoration: const InputDecoration(labelText: 'Setor'),
                        validator: validarObrigatorio,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _loteController,
                        decoration: const InputDecoration(
                          labelText: 'Codigo do lote',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _quantidadeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Quantidade',
                              ),
                              validator: validarObrigatorio,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _valorController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Valor unitario',
                              ),
                              validator: validarObrigatorio,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      InkWell(
                        onTap: _escolherData,
                        borderRadius: BorderRadius.circular(18),
                        child: Ink(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FB),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: corBordaSuave),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.event_available_rounded),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Validade: ${formatarData(_validadeSelecionada)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _AtalhoValidade(
                            label: '+7 dias',
                            onTap: () => _aplicarAtalhoDeValidade(7),
                          ),
                          _AtalhoValidade(
                            label: '+15 dias',
                            onTap: () => _aplicarAtalhoDeValidade(15),
                          ),
                          _AtalhoValidade(
                            label: '+30 dias',
                            onTap: () => _aplicarAtalhoDeValidade(30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _salvar,
                  style: botaoPrimario(),
                  child: const Text('Salvar lote'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaAjusteManual extends StatefulWidget {
  const TelaAjusteManual({
    super.key,
    required this.filtro,
    required this.usuario,
  });

  final FiltroDashboard filtro;
  final ContaUsuario usuario;

  @override
  State<TelaAjusteManual> createState() => _TelaAjusteManualState();
}

class _TelaAjusteManualState extends State<TelaAjusteManual> {
  final _motivoController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '-1');
  final CentralDeEstoque _central = CentralDeEstoque.instancia;
  String? _loteIdSelecionado;

  @override
  void dispose() {
    _motivoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _salvar() {
    final loteId = _loteIdSelecionado;
    final delta = int.tryParse(_quantidadeController.text.trim()) ?? 0;
    final motivo = _motivoController.text.trim();

    if (loteId == null || delta == 0 || motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha lote, ajuste e motivo.')),
      );
      return;
    }

    final sucesso = _central.ajustarInventario(
      loteId: loteId,
      deltaQuantidade: delta,
      motivo: motivo,
      usuario: widget.usuario.nomeCompleto,
    );

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajuste nao pode zerar abaixo de 0.')),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final lotes = _central.obterFilaFefo(widget.filtro);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajuste manual')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: caixaPadrao(),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _loteIdSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Selecione o lote',
                      ),
                      items: lotes
                          .map(
                            (lote) => DropdownMenuItem(
                              value: lote.id,
                              child: Text(
                                '${lote.produto.descricao} â€¢ ${lote.codigoLote} â€¢ saldo ${lote.quantidadeAtual}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) {
                        setState(() => _loteIdSelecionado = valor);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ajuste de quantidade (+/-)',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _motivoController,
                      decoration: const InputDecoration(
                        labelText: 'Motivo do ajuste',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _salvar,
                style: botaoPrimario(),
                child: const Text('Aplicar ajuste'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaIntegracaoDeVendas extends StatefulWidget {
  const TelaIntegracaoDeVendas({super.key, required this.filialPadrao});

  final String filialPadrao;

  @override
  State<TelaIntegracaoDeVendas> createState() => _TelaIntegracaoDeVendasState();
}

class _TelaIntegracaoDeVendasState extends State<TelaIntegracaoDeVendas> {
  final _eanController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');
  final _canalController = TextEditingController(text: 'PDV Loja');
  final CentralDeEstoque _central = CentralDeEstoque.instancia;

  @override
  void dispose() {
    _eanController.dispose();
    _quantidadeController.dispose();
    _canalController.dispose();
    super.dispose();
  }

  void _registrar() {
    final quantidade = int.tryParse(_quantidadeController.text.trim()) ?? 0;
    if (_eanController.text.trim().isEmpty || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe EAN e quantidade validos.')),
      );
      return;
    }

    final sucesso = _central.registrarSaidaViaIntegracao(
      ean13: _eanController.text.trim(),
      quantidade: quantidade,
      filial: widget.filialPadrao,
      origem: _canalController.text.trim(),
    );

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nao foi possivel consumir o estoque FEFO para este EAN.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integracao de vendas')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: caixaPadrao(),
                child: Column(
                  children: [
                    TextField(
                      controller: _eanController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'EAN-13'),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade vendida',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _canalController,
                      decoration: const InputDecoration(
                        labelText: 'Origem ERP/PDV',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _registrar,
                style: botaoPrimario(),
                child: const Text('Registrar saida'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaDeCamera extends StatefulWidget {
  const TelaDeCamera({super.key});

  @override
  State<TelaDeCamera> createState() => _TelaDeCameraState();
}

class _TelaDeCameraState extends State<TelaDeCamera> {
  final MobileScannerController controladorDaCamera = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool leituraEmProcessamento = false;

  @override
  void dispose() {
    controladorDaCamera.dispose();
    super.dispose();
  }

  Future<void> _aoDetectar(BarcodeCapture captura) async {
    if (leituraEmProcessamento || captura.barcodes.isEmpty) {
      return;
    }

    final codigoLido = captura.barcodes.first.rawValue;
    if (codigoLido == null || codigoLido.isEmpty) {
      return;
    }

    final ean13 = extrairEan13(codigoLido);
    if (ean13 == null) {
      return;
    }

    setState(() {
      leituraEmProcessamento = true;
    });
    HapticFeedback.heavyImpact();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(ean13);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corSecundariaNordestao,
      appBar: AppBar(title: const Text('Leitura de EAN-13')),
      body: Stack(
        children: [
          MobileScanner(controller: controladorDaCamera, onDetect: _aoDetectar),
          Align(
            child: Container(
              width: 260,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: corPrimariaNordestao, width: 3),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xE6FFFFFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x55F33F2B)),
              ),
                child: Text(
                  leituraEmProcessamento
                    ? 'Leitura confirmada. Abrindo cadastro do lote...'
                    : 'Aponte a camera para o codigo EAN-13 do produto.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: corTextoPrincipal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CabecalhoBipstock extends StatelessWidget {
  const CabecalhoBipstock({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [corPrimariaNordestao, corSecundariaNordestao],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_offer_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BIPSTOCK',
                    style: TextStyle(
                      color: corSecundariaNordestao,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),
                  Text(
                    'supermercado',
                    style: TextStyle(
                      color: corPrimariaNordestao,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: corTextoPrincipal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitulo,
          style: const TextStyle(
            color: corTextoSecundario,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class RodapeCangaBit extends StatelessWidget {
  const RodapeCangaBit({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'App desenvolvido pela Canga Bit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: corTextoSecundario,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'BIPSTOCK',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: corTextoSecundario,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoResumoOperacao extends StatelessWidget {
  const _CartaoResumoOperacao({
    required this.dashboard,
    required this.ultimaRotina,
  });

  final DashboardValidade dashboard;
  final String ultimaRotina;

  @override
  Widget build(BuildContext context) {
    final total = dashboard.totalDeLotes == 0 ? 1 : dashboard.totalDeLotes;
    final progressoSeguro = dashboard.lotesSeguros / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: caixaPadrao(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Controle FEFO e validade',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${dashboard.lotesSeguros}/${dashboard.totalDeLotes} seguros',
                style: const TextStyle(
                  color: corPrimariaNordestao,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progressoSeguro.clamp(0, 1),
              backgroundColor: const Color(0xFFE6EAF2),
              valueColor: const AlwaysStoppedAnimation(corRiscoSeguro),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'A fila de saida prioriza o lote com vencimento mais proximo. Ultima rotina: $ultimaRotina.',
            style: const TextStyle(color: corTextoSecundario, height: 1.4),
          ),
          if (dashboard.quantidadeVencida > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFEA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${dashboard.quantidadeVencida} unidade(s) vencida(s) exigem acao imediata.',
                style: const TextStyle(
                  color: corPrimariaNordestao,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PainelDeFiltros extends StatelessWidget {
  const _PainelDeFiltros({
    required this.filtro,
    required this.opcoesCategoria,
    required this.opcoesSetor,
    required this.opcoesFilial,
    required this.onChanged,
  });

  final FiltroDashboard filtro;
  final List<String> opcoesCategoria;
  final List<String> opcoesSetor;
  final List<String> opcoesFilial;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: caixaPadrao(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros dinamicos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _DropdownFiltro<String?>(
                label: 'Categoria',
                valor: filtro.categoria,
                itens: [null, ...opcoesCategoria],
                texto: (item) => item ?? 'Todas',
                onChanged: (valor) {
                  filtro.categoria = valor;
                  onChanged();
                },
              ),
              _DropdownFiltro<String?>(
                label: 'Setor',
                valor: filtro.setor,
                itens: [null, ...opcoesSetor],
                texto: (item) => item ?? 'Todos',
                onChanged: (valor) {
                  filtro.setor = valor;
                  onChanged();
                },
              ),
              _DropdownFiltro<String?>(
                label: 'Filial',
                valor: filtro.filial,
                itens: [null, ...opcoesFilial],
                texto: (item) => item ?? 'Todas',
                onChanged: (valor) {
                  filtro.filial = valor;
                  onChanged();
                },
              ),
              _DropdownFiltro<ZonaValidade?>(
                label: 'Zona de risco',
                valor: filtro.zona,
                itens: [null, ...ZonaValidade.values],
                texto: (item) => item?.rotulo ?? 'Todas',
                onChanged: (valor) {
                  filtro.zona = valor;
                  onChanged();
                },
              ),
              _DropdownFiltro<PeriodoFiltro>(
                label: 'Periodo',
                valor: filtro.periodo,
                itens: PeriodoFiltro.values,
                texto: (item) => item.rotulo,
                onChanged: (valor) {
                  if (valor == null) {
                    return;
                  }
                  filtro.periodo = valor;
                  onChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownFiltro<T> extends StatelessWidget {
  const _DropdownFiltro({
    required this.label,
    required this.valor,
    required this.itens,
    required this.texto,
    required this.onChanged,
  });

  final String label;
  final T valor;
  final List<T> itens;
  final String Function(T) texto;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: DropdownButtonFormField<T>(
        value: valor,
        decoration: InputDecoration(labelText: label),
        items: itens
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(texto(item)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _CardIndicador extends StatelessWidget {
  const _CardIndicador({
    required this.titulo,
    required this.valor,
    required this.detalhe,
    required this.destaque,
  });

  final String titulo;
  final String valor;
  final String detalhe;
  final Color destaque;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: corBordaSuave),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: corTextoSecundario,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: destaque,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detalhe,
            style: const TextStyle(color: corTextoSecundario, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _CardLoteFefo extends StatelessWidget {
  const _CardLoteFefo({required this.lote, this.onAplicarAcao});

  final LoteEstoque lote;
  final VoidCallback? onAplicarAcao;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: caixaPadrao(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  lote.produto.descricao,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: corTextoPrincipal,
                  ),
                ),
              ),
              _ChipZona(zona: lote.zonaValidade),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${lote.produto.categoria} â€¢ ${lote.produto.setor} â€¢ ${lote.filial}',
            style: const TextStyle(color: corTextoSecundario),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _InfoCurta(titulo: 'EAN', valor: lote.produto.ean13),
              _InfoCurta(titulo: 'Lote', valor: lote.codigoLote),
              _InfoCurta(titulo: 'Saldo', valor: '${lote.quantidadeAtual}'),
              _InfoCurta(
                titulo: 'Validade',
                valor:
                    '${formatarData(lote.validade)} â€¢ ${lote.diasParaVencerRotulo}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Regra FEFO: este lote tem prioridade de saida para vendas e separacoes.',
            style: const TextStyle(color: corTextoSecundario, height: 1.35),
          ),
          if (onAplicarAcao != null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAplicarAcao,
                icon: const Icon(Icons.local_offer_outlined),
                label: const Text('Aplicar acao preventiva'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardAlerta extends StatelessWidget {
  const _CardAlerta({required this.alerta});

  final AlertaValidade alerta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: corBordaSuave),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: corDaZona(alerta.zona).withOpacity(0.12),
            child: Icon(
              alerta.zona == ZonaValidade.critico
                  ? Icons.warning_amber_rounded
                  : alerta.zona == ZonaValidade.vencido
                  ? Icons.error_outline_rounded
                  : alerta.zona == ZonaValidade.ruptura
                  ? Icons.inventory_2_outlined
                  : Icons.notifications_active_outlined,
              color: corDaZona(alerta.zona),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alerta.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: corTextoPrincipal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alerta.descricao,
                  style: const TextStyle(color: corTextoSecundario, height: 1.35),
                ),
                const SizedBox(height: 8),
                Text(
                  '${alerta.canalNotificacao} â€¢ ${formatarDataHora(alerta.criadoEm)}',
                  style: const TextStyle(
                    color: corTextoSecundario,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAcaoPreventiva extends StatelessWidget {
  const _CardAcaoPreventiva({
    required this.acao,
    required this.podeExecutar,
    this.onExecutar,
  });

  final SugestaoAcaoPreventiva acao;
  final bool podeExecutar;
  final VoidCallback? onExecutar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: caixaPadrao(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  acao.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                formatarMoeda(acao.valorImpactado),
                style: const TextStyle(
                  color: corPrimariaNordestao,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            acao.descricao,
            style: const TextStyle(color: corTextoSecundario, height: 1.35),
          ),
          const SizedBox(height: 10),
          Text(
            '${acao.lote.produto.descricao} â€¢ lote ${acao.lote.codigoLote} â€¢ ${acao.lote.diasParaVencerRotulo}',
            style: const TextStyle(
              color: corTextoSecundario,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (podeExecutar) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: onExecutar,
                icon: const Icon(Icons.task_alt_rounded),
                label: const Text('Executar'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniCardLote extends StatelessWidget {
  const _MiniCardLote({required this.lote});

  final LoteEstoque lote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corSuperficie,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: corBordaSuave),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipZona(zona: lote.zonaValidade),
          const Spacer(),
          Text(
            lote.produto.descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: corTextoPrincipal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Lote ${lote.codigoLote}',
            style: const TextStyle(color: corTextoSecundario),
          ),
          const SizedBox(height: 6),
          Text(
            '${lote.quantidadeAtual} un â€¢ ${lote.diasParaVencerRotulo}',
            style: const TextStyle(
              color: corPrimariaNordestao,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PainelVazio extends StatelessWidget {
  const _PainelVazio({required this.titulo, required this.subtitulo});

  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: caixaPadrao(),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 32,
            color: corTextoSecundario,
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: corTextoPrincipal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: const TextStyle(color: corTextoSecundario),
          ),
        ],
      ),
    );
  }
}

class _AtalhoValidade extends StatelessWidget {
  const _AtalhoValidade({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: corPrimariaNordestao,
        side: const BorderSide(color: corPrimariaNordestao),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}

class _ChipZona extends StatelessWidget {
  const _ChipZona({required this.zona});

  final ZonaValidade zona;

  @override
  Widget build(BuildContext context) {
    final cor = corDaZona(zona);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        zona.rotulo,
        style: TextStyle(color: cor, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InfoCurta extends StatelessWidget {
  const _InfoCurta({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$titulo: $valor',
        style: const TextStyle(
          color: corTextoPrincipal,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ItemAcaoRapida extends StatelessWidget {
  const _ItemAcaoRapida({
    required this.titulo,
    required this.icone,
    required this.onTap,
  });

  final String titulo;
  final IconData icone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: corBordaSuave),
        ),
        child: Row(
          children: [
            Icon(icone, color: corPrimariaNordestao),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

enum _AcaoRapida { escanear, cadastrarLote, integracao, ajusteManual, relatorio }

enum TipoPerfilUsuario { gestor, repositor }

enum ZonaValidade { vencido, ruptura, critico, alerta, seguro }

enum PeriodoFiltro {
  hoje('Hoje'),
  seteDias('7 dias'),
  quinzeDias('15 dias'),
  trintaDias('30 dias'),
  todos('Todo o historico');

  const PeriodoFiltro(this.rotulo);
  final String rotulo;
}

class ResultadoCadastro {
  const ResultadoCadastro({this.contaUsuario, this.mensagemErro});

  final ContaUsuario? contaUsuario;
  final String? mensagemErro;
}

class ContaUsuario {
  ContaUsuario({
    required this.nomeCompleto,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
    required this.perfil,
    this.lojaSelecionada,
  });

  final String nomeCompleto;
  final String email;
  final String telefone;
  final String cpf;
  String senha;
  final TipoPerfilUsuario perfil;
  String? lojaSelecionada;

  String get primeiroNome {
    final partes = nomeCompleto.trim().split(RegExp(r'\s+'));
    return partes.isEmpty ? nomeCompleto : partes.first;
  }

  String get nomeDoPerfil =>
      perfil == TipoPerfilUsuario.gestor ? 'Gestor' : 'Repositor';
}

class ProdutoCatalogo {
  const ProdutoCatalogo({
    required this.ean13,
    required this.descricao,
    required this.categoria,
    required this.setor,
    required this.valorUnitario,
    this.estoqueMinimo = 5,
  });

  final String ean13;
  final String descricao;
  final String categoria;
  final String setor;
  final double valorUnitario;
  final int estoqueMinimo;
}

class LoteEstoque {
  const LoteEstoque({
    required this.id,
    required this.produto,
    required this.codigoLote,
    required this.quantidadeAtual,
    required this.valorUnitario,
    required this.validade,
    required this.filial,
    required this.criadoEm,
  });

  final String id;
  final ProdutoCatalogo produto;
  final String codigoLote;
  final int quantidadeAtual;
  final double valorUnitario;
  final DateTime validade;
  final String filial;
  final DateTime criadoEm;

  ZonaValidade get zonaValidade => zonaParaData(validade);

  int get diasParaVencer => somenteData(validade)
      .difference(somenteData(DateTime.now()))
      .inDays;

  String get diasParaVencerRotulo {
    if (diasParaVencer < 0) {
      return 'vencido ha ${diasParaVencer.abs()} dia(s)';
    }
    if (diasParaVencer == 0) {
      return 'vence hoje';
    }
    return 'vence em $diasParaVencer dia(s)';
  }

  double get valorTotal => quantidadeAtual * valorUnitario;

  LoteEstoque copyWith({
    int? quantidadeAtual,
    DateTime? validade,
  }) {
    return LoteEstoque(
      id: id,
      produto: produto,
      codigoLote: codigoLote,
      quantidadeAtual: quantidadeAtual ?? this.quantidadeAtual,
      valorUnitario: valorUnitario,
      validade: validade ?? this.validade,
      filial: filial,
      criadoEm: criadoEm,
    );
  }
}

class AlertaValidade {
  const AlertaValidade({
    required this.id,
    required this.loteId,
    required this.titulo,
    required this.descricao,
    required this.zona,
    required this.canalNotificacao,
    required this.criadoEm,
  });

  final String id;
  final String loteId;
  final String titulo;
  final String descricao;
  final ZonaValidade zona;
  final String canalNotificacao;
  final DateTime criadoEm;
}

class EventoEstoque {
  const EventoEstoque({
    required this.id,
    required this.loteId,
    required this.tipo,
    required this.quantidade,
    required this.motivo,
    required this.usuario,
    required this.criadoEm,
    this.valorImpactado = 0,
  });

  final String id;
  final String loteId;
  final String tipo;
  final int quantidade;
  final String motivo;
  final String usuario;
  final DateTime criadoEm;
  final double valorImpactado;
}

class SugestaoAcaoPreventiva {
  const SugestaoAcaoPreventiva({
    required this.lote,
    required this.titulo,
    required this.descricao,
    required this.valorImpactado,
  });

  final LoteEstoque lote;
  final String titulo;
  final String descricao;
  final double valorImpactado;
}

class DashboardValidade {
  const DashboardValidade({
    required this.totalDeLotes,
    required this.lotesSeguros,
    required this.lotesEmRisco,
    required this.itensCriticos,
    required this.itensEmAlerta,
    required this.valorLotesCriticos,
    required this.valorDePerdasEvitadas,
    required this.quantidadeTotalEmEstoque,
    required this.quantidadeVencida,
    required this.totalAlertas,
    required this.acoesPreventivasExecutadas,
  });

  final int totalDeLotes;
  final int lotesSeguros;
  final int lotesEmRisco;
  final int itensCriticos;
  final int itensEmAlerta;
  final double valorLotesCriticos;
  final double valorDePerdasEvitadas;
  final int quantidadeTotalEmEstoque;
  final int quantidadeVencida;
  final int totalAlertas;
  final int acoesPreventivasExecutadas;
}

class ResultadoRotinaDiaria {
  const ResultadoRotinaDiaria({
    required this.novosAlertas,
    required this.notificacoesEnviadas,
  });

  final int novosAlertas;
  final int notificacoesEnviadas;
}

class FiltroDashboard {
  String? categoria;
  String? setor;
  String? filial;
  ZonaValidade? zona;
  PeriodoFiltro periodo = PeriodoFiltro.trintaDias;
}

class ArmazenamentoAutenticacao {
  ArmazenamentoAutenticacao._() {
    cadastrarConta(
      nomeCompleto: 'Chagas',
      email: 'chagas@plugselo.com',
      telefone: '(84) 99999-1111',
      cpf: '00000000000',
      senha: '1234',
      perfil: TipoPerfilUsuario.gestor,
      lojaSelecionada: 'Nordestao Tirol',
    );
    cadastrarConta(
      nomeCompleto: 'Fernando',
      email: 'fernando@plugselo.com',
      telefone: '(84) 99999-2222',
      cpf: '11111111111',
      senha: '4321',
      perfil: TipoPerfilUsuario.repositor,
    );
  }

  static final ArmazenamentoAutenticacao instancia =
      ArmazenamentoAutenticacao._();

  final Map<String, ContaUsuario> contasPorEmail = {};
  final Map<String, String> codigosDeRecuperacaoPorEmail = {};

  ResultadoCadastro cadastrarConta({
    required String nomeCompleto,
    required String email,
    required String telefone,
    required String cpf,
    required String senha,
    required TipoPerfilUsuario perfil,
    String? lojaSelecionada,
  }) {
    final emailNormalizado = email.trim().toLowerCase();
    if (contasPorEmail.containsKey(emailNormalizado)) {
      return const ResultadoCadastro(
        mensagemErro: 'Ja existe cadastro com este e-mail.',
      );
    }

    final contaUsuario = ContaUsuario(
      nomeCompleto: nomeCompleto,
      email: emailNormalizado,
      telefone: telefone,
      cpf: cpf,
      senha: senha,
      perfil: perfil,
      lojaSelecionada: lojaSelecionada,
    );
    contasPorEmail[emailNormalizado] = contaUsuario;
    return ResultadoCadastro(contaUsuario: contaUsuario);
  }

  ContaUsuario? fazerLogin(String email, String senha) {
    final contaUsuario = contasPorEmail[email.trim().toLowerCase()];
    if (contaUsuario == null || contaUsuario.senha != senha) {
      return null;
    }
    return contaUsuario;
  }

  ContaUsuario get usuarioGestorPadrao =>
      contasPorEmail['chagas@plugselo.com']!;

  ContaUsuario get usuarioRepositorPadrao =>
      contasPorEmail['fernando@plugselo.com']!;

  String? gerarCodigoRecuperacao(String email) {
    final emailNormalizado = email.trim().toLowerCase();
    if (!contasPorEmail.containsKey(emailNormalizado)) {
      return null;
    }

    final codigoGerado = (Random().nextInt(900000) + 100000).toString();
    codigosDeRecuperacaoPorEmail[emailNormalizado] = codigoGerado;
    return codigoGerado;
  }

  bool redefinirSenha({
    required String email,
    required String codigo,
    required String novaSenha,
  }) {
    final emailNormalizado = email.trim().toLowerCase();
    final contaUsuario = contasPorEmail[emailNormalizado];
    final codigoEsperado = codigosDeRecuperacaoPorEmail[emailNormalizado];

    if (contaUsuario == null ||
        codigoEsperado == null ||
        codigoEsperado != codigo) {
      return false;
    }

    contaUsuario.senha = novaSenha;
    codigosDeRecuperacaoPorEmail.remove(emailNormalizado);
    return true;
  }
}

class CentralDeEstoque {
  CentralDeEstoque._() {
    _carregarDadosExemplo();
  }

  static final CentralDeEstoque instancia = CentralDeEstoque._();

  final List<ProdutoCatalogo> _produtos = [];
  final List<LoteEstoque> _lotes = [];
  final List<AlertaValidade> _alertas = [];
  final List<EventoEstoque> _eventos = [];
  DateTime? _ultimaExecucaoRotina;
  int _sequencia = 0;

  List<String> get categoriasDisponiveis =>
      _produtos.map((item) => item.categoria).toSet().toList()..sort();

  List<String> get setoresDisponiveis =>
      _produtos.map((item) => item.setor).toSet().toList()..sort();

  List<String> get filiaisDisponiveis =>
      _lotes.map((item) => item.filial).toSet().toList()..sort();

  String get ultimaExecucaoFormatada {
    final data = _ultimaExecucaoRotina;
    if (data == null) {
      return 'nao executada';
    }
    return formatarDataHora(data);
  }

  ProdutoCatalogo localizarOuCriarProduto(String ean13) {
    final existente = primeiroOndeOuNulo(
      _produtos,
      (item) => item.ean13 == ean13,
    );
    if (existente != null) {
      return existente;
    }

    final produto = ProdutoCatalogo(
      ean13: ean13,
      descricao: 'Produto EAN $ean13',
      categoria: 'Mercearia',
      setor: 'Gondola',
      valorUnitario: 0,
      estoqueMinimo: 5,
    );
    _produtos.add(produto);
    return produto;
  }

  void cadastrarLote({
    required String ean13,
    required String descricao,
    required String categoria,
    required String setor,
    required String codigoLote,
    required int quantidade,
    required double valorUnitario,
    required DateTime validade,
    required String filial,
  }) {
    var produto = primeiroOndeOuNulo(
      _produtos,
      (item) => item.ean13 == ean13,
    );
    produto ??= ProdutoCatalogo(
      ean13: ean13,
      descricao: descricao,
      categoria: categoria,
      setor: setor,
      valorUnitario: valorUnitario,
      estoqueMinimo: 5,
    );

    if (!_produtos.contains(produto)) {
      _produtos.add(produto);
    } else {
      final indice = _produtos.indexOf(produto);
      _produtos[indice] = ProdutoCatalogo(
        ean13: ean13,
        descricao: descricao,
        categoria: categoria,
        setor: setor,
        valorUnitario: valorUnitario,
        estoqueMinimo: produto.estoqueMinimo,
      );
      produto = _produtos[indice];
    }

    final lote = LoteEstoque(
      id: 'lote-${++_sequencia}',
      produto: produto,
      codigoLote: codigoLote,
      quantidadeAtual: quantidade,
      valorUnitario: valorUnitario,
      validade: validade,
      filial: filial,
      criadoEm: DateTime.now(),
    );
    _lotes.add(lote);
    _eventos.add(
      EventoEstoque(
        id: 'evt-${++_sequencia}',
        loteId: lote.id,
        tipo: 'entrada',
        quantidade: quantidade,
        motivo: 'Cadastro de lote',
        usuario: 'operacao',
        criadoEm: DateTime.now(),
        valorImpactado: lote.valorTotal,
      ),
    );
  }

  bool ajustarInventario({
    required String loteId,
    required int deltaQuantidade,
    required String motivo,
    required String usuario,
  }) {
    final indice = _lotes.indexWhere((item) => item.id == loteId);
    if (indice == -1) {
      return false;
    }
    final lote = _lotes[indice];
    final novaQuantidade = lote.quantidadeAtual + deltaQuantidade;
    if (novaQuantidade < 0) {
      return false;
    }

    _lotes[indice] = lote.copyWith(quantidadeAtual: novaQuantidade);
    _eventos.add(
      EventoEstoque(
        id: 'evt-${++_sequencia}',
        loteId: lote.id,
        tipo: 'ajuste_manual',
        quantidade: deltaQuantidade,
        motivo: motivo,
        usuario: usuario,
        criadoEm: DateTime.now(),
        valorImpactado: deltaQuantidade * lote.valorUnitario,
      ),
    );
    return true;
  }

  bool registrarSaidaViaIntegracao({
    required String ean13,
    required int quantidade,
    required String filial,
    required String origem,
  }) {
    final candidatos = _lotes
        .where(
          (item) =>
              item.produto.ean13 == ean13 &&
              item.filial == filial &&
              item.quantidadeAtual > 0,
        )
        .toList()
      ..sort((a, b) => a.validade.compareTo(b.validade));

    if (candidatos.isEmpty) {
      return false;
    }

    var restante = quantidade;
    for (final lote in candidatos) {
      if (restante == 0) {
        break;
      }
      final indice = _lotes.indexWhere((item) => item.id == lote.id);
      final consumo = min(restante, lote.quantidadeAtual);
      _lotes[indice] = lote.copyWith(
        quantidadeAtual: lote.quantidadeAtual - consumo,
      );
      _eventos.add(
        EventoEstoque(
          id: 'evt-${++_sequencia}',
          loteId: lote.id,
          tipo: 'saida_integracao',
          quantidade: -consumo,
          motivo: origem,
          usuario: 'webhook:$origem',
          criadoEm: DateTime.now(),
          valorImpactado: consumo * lote.valorUnitario,
        ),
      );
      restante -= consumo;
    }
    return restante == 0;
  }

  ResultadoRotinaDiaria executarVarreduraDiaria({
    required String? filial,
    required String usuario,
  }) {
    final lotes = _aplicarFiltrosBase(
      FiltroDashboard()
        ..filial = filial
        ..periodo = PeriodoFiltro.todos,
    );
    var novosAlertas = 0;
    var notificacoes = 0;

    // 1. Verificacao de validade (Prioridade 1)
    for (final lote in lotes) {
      if (lote.quantidadeAtual <= 0 || lote.zonaValidade == ZonaValidade.seguro) {
        continue;
      }

      final jaExiste = _alertas.any(
        (alerta) =>
            alerta.loteId == lote.id &&
            alerta.zona == lote.zonaValidade &&
            somenteData(alerta.criadoEm) == somenteData(DateTime.now()),
      );
      if (jaExiste) {
        continue;
      }

      _gerarAlerta(
        loteId: lote.id,
        zona: lote.zonaValidade,
        titulo: lote.zonaValidade == ZonaValidade.vencido
            ? 'Lote vencido'
            : 'Lote em risco',
        descricao:
            '${lote.produto.descricao} entrou na zona ${lote.zonaValidade.rotulo.toLowerCase()} com ${lote.quantidadeAtual} un.',
      );
      _eventos.add(
        EventoEstoque(
          id: 'evt-${++_sequencia}',
          loteId: lote.id,
          tipo: 'rotina_diaria',
          quantidade: 0,
          motivo: 'Varredura diaria',
          usuario: usuario,
          criadoEm: DateTime.now(),
        ),
      );
      novosAlertas++;
      notificacoes++;
    }

    // 2. Verificacao de falta de produto / ruptura (Prioridade 3)
    final produtosNaFilial = _produtos
        .where((produto) => lotes.any((lote) => lote.produto.ean13 == produto.ean13))
        .toSet();

    for (final produto in produtosNaFilial) {
      final quantidadeTotalProduto = lotes
          .where((lote) => lote.produto.ean13 == produto.ean13)
          .fold<int>(0, (soma, lote) => soma + lote.quantidadeAtual);

      if (quantidadeTotalProduto <= produto.estoqueMinimo) {
        final jaNotificado = _alertas.any(
          (alerta) =>
              alerta.loteId == produto.ean13 &&
              alerta.zona == ZonaValidade.ruptura &&
              somenteData(alerta.criadoEm) == somenteData(DateTime.now()),
        );

        if (!jaNotificado) {
          _gerarAlerta(
            loteId: produto.ean13,
            zona: ZonaValidade.ruptura,
            titulo: 'Risco de Ruptura (Falta)',
            descricao:
                '${produto.descricao} esta com saldo critico de $quantidadeTotalProduto un (Minimo: ${produto.estoqueMinimo}). Reabasteca a gondola.',
          );
          novosAlertas++;
          notificacoes++;
        }
      }
    }

    _ultimaExecucaoRotina = DateTime.now();
    return ResultadoRotinaDiaria(
      novosAlertas: novosAlertas,
      notificacoesEnviadas: notificacoes,
    );
  }

  void _gerarAlerta({
    required String loteId,
    required ZonaValidade zona,
    required String titulo,
    required String descricao,
  }) {
    _alertas.insert(
      0,
      AlertaValidade(
        id: 'alt-${++_sequencia}',
        loteId: loteId,
        titulo: titulo,
        descricao: descricao,
        zona: zona,
        canalNotificacao:
            (zona == ZonaValidade.critico ||
                zona == ZonaValidade.vencido ||
                zona == ZonaValidade.ruptura)
            ? 'Push + WhatsApp'
            : 'Push',
        criadoEm: DateTime.now(),
      ),
    );
  }

  void executarAcaoPreventiva({
    required String loteId,
    required String usuario,
  }) {
    final lote = primeiroOndeOuNulo(_lotes, (item) => item.id == loteId);
    if (lote == null) {
      return;
    }

    final valor = lote.valorTotal * (lote.zonaValidade == ZonaValidade.critico ? 0.6 : 0.35);
    _eventos.insert(
      0,
      EventoEstoque(
        id: 'evt-${++_sequencia}',
        loteId: lote.id,
        tipo: 'acao_preventiva',
        quantidade: 0,
        motivo: lote.zonaValidade == ZonaValidade.critico
            ? 'Campanha de desconto automatica'
            : 'Repaginacao sugerida pelo motor',
        usuario: usuario,
        criadoEm: DateTime.now(),
        valorImpactado: valor,
      ),
    );
  }

  DashboardValidade calcularDashboard(FiltroDashboard filtro) {
    final lotes = _aplicarFiltrosBase(filtro);
    final eventos = _aplicarFiltroEventos(filtro);

    final lotesSeguros =
        lotes.where((item) => item.zonaValidade == ZonaValidade.seguro).length;
    final lotesCriticos =
        lotes.where((item) => item.zonaValidade == ZonaValidade.critico).toList();
    final lotesAlerta =
        lotes.where((item) => item.zonaValidade == ZonaValidade.alerta).toList();
    final lotesVencidos =
        lotes.where((item) => item.zonaValidade == ZonaValidade.vencido).toList();

    return DashboardValidade(
      totalDeLotes: lotes.length,
      lotesSeguros: lotesSeguros,
      lotesEmRisco: lotesCriticos.length + lotesAlerta.length + lotesVencidos.length,
      itensCriticos: lotesCriticos.length + lotesVencidos.length,
      itensEmAlerta: lotesAlerta.length,
      valorLotesCriticos: lotesCriticos.fold<double>(
            0,
            (total, lote) => total + lote.valorTotal,
          ) +
          lotesVencidos.fold<double>(0, (total, lote) => total + lote.valorTotal),
      valorDePerdasEvitadas: eventos
          .where((item) => item.tipo == 'acao_preventiva')
          .fold<double>(0, (total, evento) => total + evento.valorImpactado),
      quantidadeTotalEmEstoque:
          lotes.fold<int>(0, (total, lote) => total + lote.quantidadeAtual),
      quantidadeVencida:
          lotesVencidos.fold<int>(0, (total, lote) => total + lote.quantidadeAtual),
      totalAlertas: obterAlertasRecentes(filtro).length,
      acoesPreventivasExecutadas:
          eventos.where((item) => item.tipo == 'acao_preventiva').length,
    );
  }

  List<LoteEstoque> obterFilaFefo(FiltroDashboard filtro) {
    final lotes = _aplicarFiltrosBase(filtro)
        .where((item) => item.quantidadeAtual > 0)
        .toList()
      ..sort((a, b) {
        final comparacaoValidade = a.validade.compareTo(b.validade);
        if (comparacaoValidade != 0) {
          return comparacaoValidade;
        }
        return a.criadoEm.compareTo(b.criadoEm);
      });
    return lotes;
  }

  List<AlertaValidade> obterAlertasRecentes(FiltroDashboard filtro) {
    final lotesFiltrados = _aplicarFiltrosBase(filtro);
    final idsDosLotes = lotesFiltrados.map((item) => item.id).toSet();
    final eansDosProdutos = lotesFiltrados.map((item) => item.produto.ean13).toSet();
    return _alertas
        .where(
          (item) =>
              idsDosLotes.contains(item.loteId) ||
              eansDosProdutos.contains(item.loteId),
        )
        .where((item) => _dataDentroDoPeriodo(item.criadoEm, filtro.periodo))
        .toList();
  }

  List<SugestaoAcaoPreventiva> obterSugestoesDeAcao(FiltroDashboard filtro) {
    return obterFilaFefo(filtro)
        .where(
          (lote) =>
              lote.zonaValidade == ZonaValidade.critico ||
              lote.zonaValidade == ZonaValidade.alerta ||
              lote.zonaValidade == ZonaValidade.vencido,
        )
        .map((lote) {
          final percentual =
              lote.zonaValidade == ZonaValidade.critico ? 0.25 : 0.15;
          return SugestaoAcaoPreventiva(
            lote: lote,
            titulo: lote.zonaValidade == ZonaValidade.vencido
                ? 'Bloquear venda e tratar perda consolidada'
                : lote.zonaValidade == ZonaValidade.critico
                ? 'Aplicar desconto agressivo'
                : 'Rebaixar preco e repaginar ponto de venda',
            descricao: lote.zonaValidade == ZonaValidade.vencido
                ? 'Produto ja vencido. O sistema recomenda baixa imediata e ajuste manual se a perda ja estiver consolidada.'
                : 'Sugestao automatica para reduzir risco financeiro antes do vencimento.',
            valorImpactado: lote.valorTotal * percentual,
          );
        })
        .toList();
  }

  String gerarRelatorioTexto(FiltroDashboard filtro) {
    final dashboard = calcularDashboard(filtro);
    final alertas = obterAlertasRecentes(filtro);
    final acoes = _aplicarFiltroEventos(filtro)
        .where((item) => item.tipo == 'acao_preventiva')
        .toList();

    final buffer = StringBuffer()
      ..writeln('RELATORIO BIPSTOCK')
      ..writeln('Emitido em: ${formatarDataHora(DateTime.now())}')
      ..writeln('Filial: ${filtro.filial ?? 'Todas'}')
      ..writeln('Categoria: ${filtro.categoria ?? 'Todas'}')
      ..writeln('Setor: ${filtro.setor ?? 'Todos'}')
      ..writeln('Zona: ${filtro.zona?.rotulo ?? 'Todas'}')
      ..writeln('Periodo: ${filtro.periodo.rotulo}')
      ..writeln('')
      ..writeln('INDICADORES')
      ..writeln('- Lotes totais: ${dashboard.totalDeLotes}')
      ..writeln('- Lotes em risco: ${dashboard.lotesEmRisco}')
      ..writeln('- Valor dos lotes criticos: ${formatarMoeda(dashboard.valorLotesCriticos)}')
      ..writeln('- Perdas evitadas: ${formatarMoeda(dashboard.valorDePerdasEvitadas)}')
      ..writeln('')
      ..writeln('ALERTAS')
      ..writeln(
        alertas.isEmpty
            ? '- Nenhum alerta no periodo.'
            : alertas
                .take(10)
                .map(
                  (item) =>
                      '- ${item.titulo}: ${item.descricao} (${formatarDataHora(item.criadoEm)})',
                )
                .join('\n'),
      )
      ..writeln('')
      ..writeln('ACOES TOMADAS')
      ..writeln(
        acoes.isEmpty
            ? '- Nenhuma acao preventiva executada no periodo.'
            : acoes
                .take(10)
                .map(
                  (item) =>
                      '- ${item.motivo} â€¢ ${formatarMoeda(item.valorImpactado)} â€¢ ${formatarDataHora(item.criadoEm)}',
                )
                .join('\n'),
      );
    return buffer.toString();
  }

  List<LoteEstoque> _aplicarFiltrosBase(FiltroDashboard filtro) {
    return _lotes.where((lote) {
      if (filtro.categoria != null && lote.produto.categoria != filtro.categoria) {
        return false;
      }
      if (filtro.setor != null && lote.produto.setor != filtro.setor) {
        return false;
      }
      if (filtro.filial != null && lote.filial != filtro.filial) {
        return false;
      }
      if (filtro.zona != null && lote.zonaValidade != filtro.zona) {
        return false;
      }
      return _dataDentroDoPeriodo(lote.criadoEm, filtro.periodo);
    }).toList();
  }

  List<EventoEstoque> _aplicarFiltroEventos(FiltroDashboard filtro) {
    final ids = _aplicarFiltrosBase(
      FiltroDashboard()
        ..categoria = filtro.categoria
        ..setor = filtro.setor
        ..filial = filtro.filial
        ..zona = filtro.zona
        ..periodo = PeriodoFiltro.todos,
    ).map((item) => item.id).toSet();

    return _eventos
        .where((item) => ids.contains(item.loteId))
        .where((item) => _dataDentroDoPeriodo(item.criadoEm, filtro.periodo))
        .toList();
  }

  bool _dataDentroDoPeriodo(DateTime data, PeriodoFiltro periodo) {
    final hoje = somenteData(DateTime.now());
    final alvo = somenteData(data);
    switch (periodo) {
      case PeriodoFiltro.hoje:
        return alvo == hoje;
      case PeriodoFiltro.seteDias:
        return !alvo.isBefore(hoje.subtract(const Duration(days: 7)));
      case PeriodoFiltro.quinzeDias:
        return !alvo.isBefore(hoje.subtract(const Duration(days: 15)));
      case PeriodoFiltro.trintaDias:
        return !alvo.isBefore(hoje.subtract(const Duration(days: 30)));
      case PeriodoFiltro.todos:
        return true;
    }
  }

  void _carregarDadosExemplo() {
    final produtos = [
      const ProdutoCatalogo(
        ean13: '7891000000013',
        descricao: 'Iogurte Natural 170g',
        categoria: 'Laticinios',
        setor: 'Frios',
        valorUnitario: 4.89,
        estoqueMinimo: 8,
      ),
      const ProdutoCatalogo(
        ean13: '7891000000020',
        descricao: 'Pao de Forma Integral',
        categoria: 'Padaria',
        setor: 'Padaria',
        valorUnitario: 9.50,
        estoqueMinimo: 10,
      ),
      const ProdutoCatalogo(
        ean13: '7891000000037',
        descricao: 'Maca Gala Premium',
        categoria: 'Hortifruti',
        setor: 'FLV',
        valorUnitario: 2.30,
        estoqueMinimo: 12,
      ),
      const ProdutoCatalogo(
        ean13: '7891000000044',
        descricao: 'Frango Resfriado Bandeja',
        categoria: 'Acougue',
        setor: 'Pereciveis',
        valorUnitario: 18.90,
        estoqueMinimo: 10,
      ),
    ];
    _produtos.addAll(produtos);

    final agora = DateTime.now();
    _lotes.addAll([
      LoteEstoque(
        id: 'lote-1',
        produto: produtos[0],
        codigoLote: 'IOG-101',
        quantidadeAtual: 18,
        valorUnitario: 4.89,
        validade: agora.add(const Duration(days: 5)),
        filial: 'Nordestao Tirol',
        criadoEm: agora.subtract(const Duration(days: 2)),
      ),
      LoteEstoque(
        id: 'lote-2',
        produto: produtos[0],
        codigoLote: 'IOG-098',
        quantidadeAtual: 10,
        valorUnitario: 4.89,
        validade: agora.add(const Duration(days: 12)),
        filial: 'Nordestao Tirol',
        criadoEm: agora.subtract(const Duration(days: 5)),
      ),
      LoteEstoque(
        id: 'lote-3',
        produto: produtos[1],
        codigoLote: 'PAD-220',
        quantidadeAtual: 22,
        valorUnitario: 9.50,
        validade: agora.add(const Duration(days: 2)),
        filial: 'Nordestao Salgado Filho',
        criadoEm: agora.subtract(const Duration(days: 1)),
      ),
      LoteEstoque(
        id: 'lote-4',
        produto: produtos[2],
        codigoLote: 'FLV-908',
        quantidadeAtual: 35,
        valorUnitario: 2.30,
        validade: agora.add(const Duration(days: 18)),
        filial: 'Nordestao Cidade Jardim',
        criadoEm: agora.subtract(const Duration(days: 3)),
      ),
      LoteEstoque(
        id: 'lote-5',
        produto: produtos[3],
        codigoLote: 'ACO-331',
        quantidadeAtual: 8,
        valorUnitario: 18.90,
        validade: agora.subtract(const Duration(days: 1)),
        filial: 'Nordestao Tirol',
        criadoEm: agora.subtract(const Duration(days: 4)),
      ),
    ]);
    _sequencia = 100;
  }
}

BoxDecoration caixaPadrao() {
  return BoxDecoration(
    color: corSuperficie,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: corBordaSuave),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0F3A57A6),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );
}

ButtonStyle botaoPrimario() {
  return FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(56),
    backgroundColor: corPrimariaNordestao,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  );
}

String? validarObrigatorio(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Campo obrigatorio';
  }
  return null;
}

Color corDaZona(ZonaValidade zona) {
  switch (zona) {
    case ZonaValidade.vencido:
      return corRiscoVencido;
    case ZonaValidade.ruptura:
      return Colors.black87;
    case ZonaValidade.critico:
      return corRiscoCritico;
    case ZonaValidade.alerta:
      return corRiscoAlerta;
    case ZonaValidade.seguro:
      return corRiscoSeguro;
  }
}

ZonaValidade zonaParaData(DateTime validade) {
  final dias = somenteData(validade)
      .difference(somenteData(DateTime.now()))
      .inDays;
  if (dias < 0) {
    return ZonaValidade.vencido;
  }
  if (dias <= 7) {
    return ZonaValidade.critico;
  }
  if (dias <= 15) {
    return ZonaValidade.alerta;
  }
  return ZonaValidade.seguro;
}

String? extrairEan13(String valorLido) {
  final match = RegExp(r'\d{13}').firstMatch(valorLido);
  return match?.group(0);
}

String gerarCodigoLote() {
  final agora = DateTime.now();
  return 'L${agora.year}${agora.month.toString().padLeft(2, '0')}${agora.day.toString().padLeft(2, '0')}${agora.millisecond.toString().padLeft(3, '0')}';
}

double parseMoeda(String valor) {
  final normalizado = valor.replaceAll('.', '').replaceAll(',', '.').trim();
  return double.tryParse(normalizado) ?? 0;
}

String formatarMoeda(double valor) {
  final texto = valor.toStringAsFixed(2).replaceAll('.', ',');
  return 'R\$ $texto';
}

String formatarData(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  final ano = data.year.toString();
  return '$dia/$mes/$ano';
}

String formatarDataHora(DateTime data) {
  final hora = data.hour.toString().padLeft(2, '0');
  final minuto = data.minute.toString().padLeft(2, '0');
  return '${formatarData(data)} $hora:$minuto';
}

DateTime somenteData(DateTime data) {
  return DateTime(data.year, data.month, data.day);
}

extension on ZonaValidade {
  String get rotulo {
    switch (this) {
      case ZonaValidade.vencido:
        return 'Vencido';
      case ZonaValidade.ruptura:
        return 'Em Falta';
      case ZonaValidade.critico:
        return 'Critico';
      case ZonaValidade.alerta:
        return 'Alerta';
      case ZonaValidade.seguro:
        return 'Seguro';
    }
  }
}

T? primeiroOndeOuNulo<T>(Iterable<T> itens, bool Function(T item) teste) {
  for (final item in itens) {
    if (teste(item)) {
      return item;
    }
  }
  return null;
}

