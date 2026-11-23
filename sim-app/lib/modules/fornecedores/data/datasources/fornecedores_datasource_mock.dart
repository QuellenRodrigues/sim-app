import 'package:core/core.dart';

import '../../../tabelas_auxiliares/tabelas_auxiliares.dart';
import '../../domain/domain.dart';
import 'fornecedores_datasource.dart';

/// Fornecedores de exemplo, mantidos em memória enquanto o SIM não tem API.
///
/// Os fornecedores e os preços são fictícios. O que cada um fornece são os grupos de compra das
/// Tabelas auxiliares, como no SIM de 2017 (tabelas Fornecedores_materiais e Materiais_grupo). A lista é estática para sobreviver
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
  Future<List<GrupoCompraModel>> listarMateriais(int codigo) async {
    await Future<void>.delayed(_atraso);
    final codigos = _materiais[codigo] ?? const {};
    return _ordenados(_catalogo.where((m) => codigos.contains(m.codigo)));
  }

  @override
  Future<List<GrupoCompraModel>> listarMateriaisDisponiveis(int codigo) async {
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
    _precos.removeWhere((p) => p.codigoFornecedor == codigo && p.grupo.codigo == codigoMaterial);
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
          p.grupo.codigo == preco.grupo.codigo &&
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
    List<FornecedorModel> queFornecem(int grupo, Set<int> comPreco) {
      return ativos.values
          .where((f) => (_materiais[f.codigo] ?? const {}).contains(grupo) && !comPreco.contains(f.codigo))
          .toList()
        ..sort((a, b) => a.razaoSocial.normalizado.compareTo(b.razaoSocial.normalizado));
    }

    final porItem = <String, List<PrecoMaterialModel>>{};
    for (final preco in _precos) {
      if (ativos.containsKey(preco.codigoFornecedor) && contemTudo(preco.nomeItem)) {
        final chave = '${preco.grupo.codigo}|${preco.especificacao.normalizado}';
        porItem.putIfAbsent(chave, () => []).add(preco);
      }
    }

    final grupos = <GrupoPrecosModel>[
      for (final precos in porItem.values)
        GrupoPrecosModel(
          grupo: precos.first.grupo,
          especificacao: precos.first.especificacao,
          ofertas: [
            for (final preco in precos..sort((a, b) => a.preco.compareTo(b.preco)))
              OfertaModel(fornecedor: ativos[preco.codigoFornecedor]!, preco: preco),
          ],
          semPreco: queFornecem(precos.first.grupo.codigo, {for (final p in precos) p.codigoFornecedor}),
        ),
    ];

    // Grupos encontrados pelo nome em que ninguém informou preço ainda.
    final comPreco = {for (final g in grupos) g.grupo.codigo};
    for (final grupo in _catalogo.where((g) => contemTudo(g.nome) && !comPreco.contains(g.codigo))) {
      final fornecedores = queFornecem(grupo.codigo, const {});
      if (fornecedores.isNotEmpty) grupos.add(GrupoPrecosModel(grupo: grupo, semPreco: fornecedores));
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

  List<GrupoCompraModel> _ordenados(Iterable<GrupoCompraModel> grupos) {
    return grupos.toList()..sort((a, b) => a.nome.normalizado.compareTo(b.nome.normalizado));
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
      razaoSocial: 'Ferramentas e Lubrificantes Resende Ltda.',
      nomeFantasia: 'Ferramentas Resende',
      cnpj: '43.671.168/0001-31',
      endereco: 'Av. Marechal Castelo Branco, 77',
      bairro: 'Campos Elíseos',
      cidade: 'Resende',
      estado: UnidadeFederativa.rj,
      cep: '27542-090',
      contato: 'Beatriz Falcão',
      telefone1: '(24) 3355-9100',
      email: 'vendas@ferramentasresende.com.br',
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

  /// Códigos dos grupos de compra de cada fornecedor.
  static Map<int, Set<int>> _materiaisIniciais() => {
    1: {6, 12, 20, 3, 23, 34},
    2: {8, 9, 10, 11, 22},
    3: {2, 3, 4, 12},
    4: {12, 15, 16, 17},
    5: {25},
    6: {13, 24},
    7: {29},
  };

  static const _parafusos = GrupoCompraModel(codigo: 12, nome: 'PARAFUSOS');
  static const _tuboSch = GrupoCompraModel(codigo: 9, nome: 'TUBO SCH');
  static const _barraRedonda = GrupoCompraModel(codigo: 6, nome: 'BARRA REDONDA CARBONO');

  static List<PrecoMaterialModel> _precosIniciais() => [
    PrecoMaterialModel(
      codigo: 1,
      codigoFornecedor: 4,
      grupo: _parafusos,
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
      grupo: _parafusos,
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
      grupo: _parafusos,
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
      grupo: _tuboSch,
      especificacao: 'SCH. 40 2 POL. A106',
      unidade: 'M',
      preco: 89.9,
      condicaoPagamento: '30/45/60',
      prazoDias: 2,
      data: DateTime(2026, 10, 5),
    ),
    PrecoMaterialModel(
      codigo: 5,
      codigoFornecedor: 1,
      grupo: _barraRedonda,
      especificacao: '1 POL. SAE 1045',
      unidade: 'KG',
      preco: 14.7,
      ipiPercentual: 3.25,
      condicaoPagamento: '28/35',
      prazoDias: 1,
      data: DateTime(2026, 10, 12),
    ),
  ];

  static List<GrupoCompraModel> get _catalogo => [
    for (final item in TabelasAuxiliaresDatasourceMock.ativos(TabelaAuxiliar.gruposCompra))
      GrupoCompraModel(codigo: item.codigo!, nome: item.descricao),
  ];
}
