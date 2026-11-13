import 'package:core/core.dart';

import '../../domain/domain.dart';
import 'fornecedores_datasource.dart';

/// Fornecedores de exemplo, mantidos em memória enquanto o SIM não tem API.
///
/// Os fornecedores e os preços são fictícios; o catálogo de materiais é o do banco do SIM de 2014
/// e fica aqui até existir o cadastro de materiais. A lista é estática para sobreviver
/// à troca de telas, como um servidor faria.
class FornecedoresDatasourceMock implements FornecedoresDatasource {
  FornecedoresDatasourceMock({DateTime Function()? agora}) : _agora = agora ?? DateTime.now;

  final DateTime Function() _agora;

  static final List<FornecedorModel> _fornecedores = _iniciais();
  static final Map<int, Set<int>> _materiais = _materiaisIniciais();
  static final List<PrecoMaterialModel> _precos = _precosIniciais();

  /// Volta aos dados de exemplo (usado nos testes).
  static void reiniciar() {
    _fornecedores
      ..clear()
      ..addAll(_iniciais());
    _materiais
      ..clear()
      ..addAll(_materiaisIniciais());
    _precos
      ..clear()
      ..addAll(_precosIniciais());
  }

  static const _atraso = Duration(milliseconds: 250);

  @override
  Future<List<FornecedorModel>> listar({String busca = ''}) async {
    await Future<void>.delayed(_atraso);
    final termo = busca.trim().normalizado;
    final digitos = busca.somenteDigitos;

    final resultado = _fornecedores.where((f) {
      if (termo.isEmpty) return true;
      return f.razaoSocial.normalizado.contains(termo) ||
          f.nomeFantasia.normalizado.contains(termo) ||
          f.cidade.normalizado.contains(termo) ||
          f.contato.normalizado.contains(termo) ||
          (digitos.length >= 3 && f.cnpj.somenteDigitos.contains(digitos));
    }).toList()..sort((a, b) => a.razaoSocial.normalizado.compareTo(b.razaoSocial.normalizado));

    return resultado;
  }

  @override
  Future<FornecedorModel> salvar(FornecedorModel fornecedor) async {
    await Future<void>.delayed(_atraso);

    final cnpj = fornecedor.cnpj.somenteDigitos;
    if (cnpj.isNotEmpty) {
      final duplicado = _fornecedores.where(
        (f) => f.codigo != fornecedor.codigo && f.cnpj.somenteDigitos == cnpj,
      );
      if (duplicado.isNotEmpty) {
        throw DomainException(
          message: 'Já existe um fornecedor com este CNPJ: ${duplicado.first.razaoSocial}.',
        );
      }
    }

    if (fornecedor.codigo == null) {
      final proximo = _fornecedores.fold<int>(0, (maior, f) => f.codigo! > maior ? f.codigo! : maior) + 1;
      final novo = fornecedor.copyWith(codigo: proximo);
      _fornecedores.add(novo);
      return novo;
    }

    return _fornecedores[_indice(fornecedor.codigo!)] = fornecedor;
  }

  @override
  Future<FornecedorModel> alternarSuspensao(int codigo) async {
    await Future<void>.delayed(_atraso);
    final indice = _indice(codigo);
    final atual = _fornecedores[indice];
    return _fornecedores[indice] = atual.suspenso
        ? atual.copyWith(limparSuspensao: true)
        : atual.copyWith(suspensoEm: _agora());
  }

  @override
  Future<List<MaterialFornecidoModel>> listarMateriais(int codigo) async {
    await Future<void>.delayed(_atraso);
    final codigos = _materiais[codigo] ?? const {};
    return _ordenados(_catalogo.where((m) => codigos.contains(m.codigo)));
  }

  @override
  Future<List<MaterialFornecidoModel>> listarMateriaisDisponiveis(int codigo) async {
    await Future<void>.delayed(_atraso);
    final codigos = _materiais[codigo] ?? const {};
    return _ordenados(_catalogo.where((m) => !codigos.contains(m.codigo)));
  }

  @override
  Future<void> adicionarMateriais(int codigo, List<int> codigosMateriais) async {
    await Future<void>.delayed(_atraso);
    _indice(codigo);
    _materiais.putIfAbsent(codigo, () => {}).addAll(codigosMateriais);
  }

  @override
  Future<void> removerMaterial(int codigo, int codigoMaterial) async {
    await Future<void>.delayed(_atraso);
    _materiais[codigo]?.remove(codigoMaterial);
    _precos.removeWhere((p) => p.codigoFornecedor == codigo && p.material.codigo == codigoMaterial);
  }

  @override
  Future<List<PrecoMaterialModel>> listarPrecos(int codigo) async {
    await Future<void>.delayed(_atraso);
    return _precos.where((p) => p.codigoFornecedor == codigo).toList()
      ..sort((a, b) => a.nomeItem.normalizado.compareTo(b.nomeItem.normalizado));
  }

  @override
  Future<PrecoMaterialModel> salvarPreco(PrecoMaterialModel preco) async {
    await Future<void>.delayed(_atraso);
    final especificacao = preco.especificacao.trim();

    final repetido = _precos.any(
      (p) =>
          p.codigo != preco.codigo &&
          p.codigoFornecedor == preco.codigoFornecedor &&
          p.material.codigo == preco.material.codigo &&
          p.especificacao.normalizado == especificacao.normalizado,
    );
    if (repetido) throw DomainException(message: 'Este fornecedor já tem preço para este item.');

    final salvo = preco.copyWith(especificacao: especificacao, data: _agora());
    if (preco.codigo == null) {
      final proximo = _precos.fold<int>(0, (maior, p) => p.codigo! > maior ? p.codigo! : maior) + 1;
      final novo = salvo.copyWith(codigo: proximo);
      _precos.add(novo);
      return novo;
    }

    final indice = _precos.indexWhere((p) => p.codigo == preco.codigo);
    if (indice < 0) throw DomainException(message: 'Preço não encontrado.');
    return _precos[indice] = salvo;
  }

  @override
  Future<void> excluirPreco(int codigoPreco) async {
    await Future<void>.delayed(_atraso);
    _precos.removeWhere((p) => p.codigo == codigoPreco);
  }

  @override
  Future<List<GrupoPrecosModel>> consultarPrecos(String busca) async {
    await Future<void>.delayed(_atraso);
    final palavras = busca.normalizado.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (palavras.isEmpty) return const [];
    bool contemTudo(String texto) => palavras.every(texto.normalizado.contains);

    final ativos = {for (final f in _fornecedores.where((f) => !f.inativo)) f.codigo!: f};
    List<FornecedorModel> queFornecem(int material, Set<int> comPreco) {
      return ativos.values
          .where((f) => (_materiais[f.codigo] ?? const {}).contains(material) && !comPreco.contains(f.codigo))
          .toList()
        ..sort((a, b) => a.razaoSocial.normalizado.compareTo(b.razaoSocial.normalizado));
    }

    final porItem = <String, List<PrecoMaterialModel>>{};
    for (final preco in _precos) {
      if (ativos.containsKey(preco.codigoFornecedor) && contemTudo(preco.nomeItem)) {
        final chave = '${preco.material.codigo}|${preco.especificacao.normalizado}';
        porItem.putIfAbsent(chave, () => []).add(preco);
      }
    }

    final grupos = <GrupoPrecosModel>[
      for (final precos in porItem.values)
        GrupoPrecosModel(
          material: precos.first.material,
          especificacao: precos.first.especificacao,
          ofertas: [
            for (final preco in precos..sort((a, b) => a.preco.compareTo(b.preco)))
              OfertaModel(fornecedor: ativos[preco.codigoFornecedor]!, preco: preco),
          ],
          semPreco: queFornecem(precos.first.material.codigo, {for (final p in precos) p.codigoFornecedor}),
        ),
    ];

    // Materiais encontrados pelo nome em que ninguém informou preço ainda.
    final comGrupo = {for (final g in grupos) g.material.codigo};
    for (final material in _catalogo.where((m) => contemTudo(m.nome) && !comGrupo.contains(m.codigo))) {
      final fornecedores = queFornecem(material.codigo, const {});
      if (fornecedores.isNotEmpty) grupos.add(GrupoPrecosModel(material: material, semPreco: fornecedores));
    }

    return grupos..sort((a, b) {
      if (a.ofertas.isEmpty != b.ofertas.isEmpty) return a.ofertas.isEmpty ? 1 : -1;
      return a.nome.normalizado.compareTo(b.nome.normalizado);
    });
  }

  int _indice(int codigo) {
    final indice = _fornecedores.indexWhere((f) => f.codigo == codigo);
    if (indice < 0) throw DomainException(message: 'Fornecedor não encontrado.');
    return indice;
  }

  List<MaterialFornecidoModel> _ordenados(Iterable<MaterialFornecidoModel> materiais) {
    return materiais.toList()..sort((a, b) => a.nome.compareTo(b.nome));
  }

  static List<FornecedorModel> _iniciais() => [
    FornecedorModel(
      codigo: 1,
      razaoSocial: 'Aços Serra da Mantiqueira Ltda.',
      nomeFantasia: 'Aços Mantiqueira',
      cnpj: '10.275.958/0001-49',
      endereco: 'Rua do Aço, 120',
      bairro: 'Distrito Industrial',
      cidade: 'Volta Redonda',
      estado: UnidadeFederativa.rj,
      cep: '27260-100',
      contato: 'Renata Tavares',
      telefone1: '(24) 3347-1200',
      email: 'vendas@acosmantiqueira.ind.br',
    ),
    FornecedorModel(
      codigo: 2,
      razaoSocial: 'Distribuidora de Tubos Vale do Aço S.A.',
      nomeFantasia: 'Tubos Vale',
      cnpj: '15.748.916/0001-00',
      endereco: 'Av. das Siderúrgicas, 2.300',
      bairro: 'Horto',
      cidade: 'Ipatinga',
      estado: UnidadeFederativa.mg,
      cep: '35160-210',
      contato: 'Claudio Neves',
      telefone1: '(31) 3824-5500',
      email: 'comercial@tubosvale.com.br',
      email2: 'nf@tubosvale.com.br',
    ),
    FornecedorModel(
      codigo: 3,
      razaoSocial: 'Perfis e Chapas Campo Belo Ltda.',
      nomeFantasia: 'Perfis Campo Belo',
      cnpj: '92.242.892/0001-55',
      endereco: 'Rua Sete de Abril, 45',
      bairro: 'Bonsucesso',
      cidade: 'Rio de Janeiro',
      estado: UnidadeFederativa.rj,
      cep: '21041-030',
      contato: 'Sônia Barreto',
      telefone1: '(21) 3868-4400',
      email: 'orcamento@perfiscampobelo.com.br',
    ),
    FornecedorModel(
      codigo: 4,
      razaoSocial: 'Rolamentos e Transmissões Paulista Ltda.',
      nomeFantasia: 'RT Paulista',
      cnpj: '64.682.456/0001-61',
      endereco: 'Rua Voluntários da Pátria, 980',
      bairro: 'Santana',
      cidade: 'São Paulo',
      estado: UnidadeFederativa.sp,
      cep: '02011-000',
      contato: 'Hélio Ramos',
      telefone1: '(11) 2971-3300',
      email: 'vendas@rtpaulista.com.br',
    ),
    FornecedorModel(
      codigo: 5,
      razaoSocial: 'Tratamento Térmico Sul Fluminense Ltda.',
      nomeFantasia: 'TT Sul Fluminense',
      cnpj: '34.410.628/0001-87',
      endereco: 'Estrada Velha, 310',
      bairro: 'Santa Rita',
      cidade: 'Barra Mansa',
      estado: UnidadeFederativa.rj,
      cep: '27330-400',
      contato: 'Marcelo Vidal',
      telefone1: '(24) 3323-7700',
      suspensoEm: DateTime(2026, 9, 21),
    ),
    FornecedorModel(
      codigo: 6,
      razaoSocial: 'Laboratório de Ensaios Resende Ltda.',
      nomeFantasia: 'Lab Ensaios Resende',
      cnpj: '43.671.168/0001-31',
      endereco: 'Av. Marechal Castelo Branco, 77',
      bairro: 'Campos Elíseos',
      cidade: 'Resende',
      estado: UnidadeFederativa.rj,
      cep: '27542-090',
      contato: 'Beatriz Falcão',
      telefone1: '(24) 3355-9100',
      email: 'laboratorio@ensaiosresende.com.br',
    ),
    FornecedorModel(
      codigo: 7,
      razaoSocial: 'Transportes Rodovia Dutra Ltda.',
      nomeFantasia: 'Transdutra',
      cnpj: '38.069.987/0001-73',
      endereco: 'Rodovia Presidente Dutra, km 298',
      bairro: 'Parque Embaixador',
      cidade: 'Resende',
      estado: UnidadeFederativa.rj,
      cep: '27537-970',
      contato: 'Gilberto Sá',
      telefone1: '(24) 3381-2200',
      email: 'coleta@transdutra.com.br',
      inativo: true,
    ),
  ];

  static Map<int, Set<int>> _materiaisIniciais() => {
    1: {2, 3, 7, 14, 15, 19},
    2: {6, 12, 13, 22, 74},
    3: {4, 9, 14, 26, 59, 75},
    4: {14, 70, 71},
    5: {66},
    6: {83, 84, 16},
    7: {68},
  };

  static const _parafuso = MaterialFornecidoModel(codigo: 14, tipo: 'MAT. COMERCIAL', descricao: 'PARAFUSO');
  static const _tuboSch40 = MaterialFornecidoModel(codigo: 12, tipo: 'TUBO', descricao: 'SCH. 40');
  static const _barraRedonda = MaterialFornecidoModel(codigo: 2, tipo: 'BARRA', descricao: 'REDONDA');

  static List<PrecoMaterialModel> _precosIniciais() => [
    PrecoMaterialModel(
      codigo: 1,
      codigoFornecedor: 4,
      material: _parafuso,
      especificacao: 'M10 x 50 ZINCADO',
      unidade: 'UN',
      preco: 1.85,
      ipiPercentual: 5,
      condicaoPagamento: '30/45',
      prazoDias: 3,
      data: DateTime(2026, 10, 19),
    ),
    PrecoMaterialModel(
      codigo: 2,
      codigoFornecedor: 3,
      material: _parafuso,
      especificacao: 'M10 x 50 ZINCADO',
      unidade: 'UN',
      preco: 1.62,
      frete: FreteCotacao.cif,
      condicaoPagamento: '28',
      prazoDias: 5,
      data: DateTime(2026, 9, 2),
    ),
    PrecoMaterialModel(
      codigo: 3,
      codigoFornecedor: 4,
      material: _parafuso,
      especificacao: 'M12 x 80 INOX',
      unidade: 'UN',
      preco: 6.4,
      ipiPercentual: 5,
      condicaoPagamento: '30/45',
      prazoDias: 4,
      data: DateTime(2026, 10, 19),
    ),
    PrecoMaterialModel(
      codigo: 4,
      codigoFornecedor: 2,
      material: _tuboSch40,
      especificacao: '2 POL. A106',
      unidade: 'M',
      preco: 89.9,
      condicaoPagamento: '30/45/60',
      prazoDias: 2,
      data: DateTime(2026, 10, 5),
    ),
    PrecoMaterialModel(
      codigo: 5,
      codigoFornecedor: 1,
      material: _barraRedonda,
      especificacao: '1 POL. SAE 1045',
      unidade: 'KG',
      preco: 14.7,
      ipiPercentual: 3.25,
      condicaoPagamento: '28/35',
      prazoDias: 1,
      data: DateTime(2026, 10, 12),
    ),
  ];

  static const _catalogo = [
    MaterialFornecidoModel(codigo: 7, tipo: 'BARRA', descricao: 'CHATA'),
    MaterialFornecidoModel(codigo: 3, tipo: 'BARRA', descricao: 'QUADRADA'),
    MaterialFornecidoModel(codigo: 2, tipo: 'BARRA', descricao: 'REDONDA'),
    MaterialFornecidoModel(codigo: 33, tipo: 'BARRA', descricao: 'SEXTAVADA'),
    MaterialFornecidoModel(codigo: 23, tipo: 'CANTONEIRA', descricao: 'ABAS IGUAIS'),
    MaterialFornecidoModel(codigo: 15, tipo: 'CHAPA', descricao: 'FINA FRIO'),
    MaterialFornecidoModel(codigo: 59, tipo: 'CHAPA', descricao: 'FINA QUENTE'),
    MaterialFornecidoModel(codigo: 19, tipo: 'CHAPA', descricao: 'GROSSA'),
    MaterialFornecidoModel(codigo: 81, tipo: 'CHAPA', descricao: 'OXICORTADA'),
    MaterialFornecidoModel(codigo: 75, tipo: 'CHAPA', descricao: 'XADREZ'),
    MaterialFornecidoModel(codigo: 82, tipo: 'MAT. COMERCIAL'),
    MaterialFornecidoModel(codigo: 71, tipo: 'MAT. COMERCIAL', descricao: 'ACOPLAMENTO'),
    MaterialFornecidoModel(codigo: 14, tipo: 'MAT. COMERCIAL', descricao: 'PARAFUSO'),
    MaterialFornecidoModel(codigo: 70, tipo: 'MAT. COMERCIAL', descricao: 'ROLAMENTO'),
    MaterialFornecidoModel(codigo: 77, tipo: 'PERFIL', descricao: 'H'),
    MaterialFornecidoModel(codigo: 69, tipo: 'PERFIL', descricao: 'H (W)'),
    MaterialFornecidoModel(codigo: 4, tipo: 'PERFIL', descricao: 'I P/ AMERICANO'),
    MaterialFornecidoModel(codigo: 26, tipo: 'PERFIL', descricao: 'IPE'),
    MaterialFornecidoModel(codigo: 27, tipo: 'PERFIL', descricao: 'IPN'),
    MaterialFornecidoModel(codigo: 78, tipo: 'PERFIL', descricao: 'T'),
    MaterialFornecidoModel(codigo: 9, tipo: 'PERFIL', descricao: 'U P/ AMERICANO'),
    MaterialFornecidoModel(codigo: 62, tipo: 'PERFIL', descricao: 'W'),
    MaterialFornecidoModel(codigo: 85, tipo: 'S. TERCEIRO'),
    MaterialFornecidoModel(codigo: 65, tipo: 'S. TERCEIRO', descricao: 'BALANCEAM.'),
    MaterialFornecidoModel(codigo: 68, tipo: 'S. TERCEIRO', descricao: 'FRETE'),
    MaterialFornecidoModel(codigo: 80, tipo: 'S. TERCEIRO', descricao: 'MAN. ELETRICA'),
    MaterialFornecidoModel(codigo: 67, tipo: 'S. TERCEIRO', descricao: 'REVESTIMENTO'),
    MaterialFornecidoModel(codigo: 66, tipo: 'S. TERCEIRO', descricao: 'TRAT, TERMICO'),
    MaterialFornecidoModel(codigo: 83, tipo: 'E.N.D.', descricao: 'LIQ. PENETRANTE'),
    MaterialFornecidoModel(codigo: 84, tipo: 'E.N.D.', descricao: 'ULTRA SOM'),
    MaterialFornecidoModel(codigo: 16, tipo: 'E.N.D.', descricao: 'VISUAL DE SOLDA'),
    MaterialFornecidoModel(codigo: 64, tipo: 'TUBO', descricao: 'ELETRODUTO'),
    MaterialFornecidoModel(codigo: 8, tipo: 'TUBO', descricao: 'INDUSTR. RED.'),
    MaterialFornecidoModel(codigo: 73, tipo: 'TUBO', descricao: 'MEC. TREFILADO'),
    MaterialFornecidoModel(codigo: 79, tipo: 'TUBO', descricao: 'MECANICO ST 52'),
    MaterialFornecidoModel(codigo: 22, tipo: 'TUBO', descricao: 'QUADR.'),
    MaterialFornecidoModel(codigo: 74, tipo: 'TUBO', descricao: 'RETANGULAR'),
    MaterialFornecidoModel(codigo: 76, tipo: 'TUBO', descricao: 'SCH. 10'),
    MaterialFornecidoModel(codigo: 60, tipo: 'TUBO', descricao: 'SCH. 100'),
    MaterialFornecidoModel(codigo: 20, tipo: 'TUBO', descricao: 'SCH. 120'),
    MaterialFornecidoModel(codigo: 61, tipo: 'TUBO', descricao: 'SCH. 140'),
    MaterialFornecidoModel(codigo: 21, tipo: 'TUBO', descricao: 'SCH. 160'),
    MaterialFornecidoModel(codigo: 6, tipo: 'TUBO', descricao: 'SCH. 20'),
    MaterialFornecidoModel(codigo: 12, tipo: 'TUBO', descricao: 'SCH. 40'),
    MaterialFornecidoModel(codigo: 13, tipo: 'TUBO', descricao: 'SCH. 80'),
    MaterialFornecidoModel(codigo: 28, tipo: 'TUBO', descricao: 'VMEC 134 AP'),
    MaterialFornecidoModel(codigo: 24, tipo: 'TUBO', descricao: 'XXS'),
  ];
}
