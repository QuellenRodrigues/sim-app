import 'package:core/core.dart';

import '../../../tabelas_auxiliares/tabelas_auxiliares.dart';
import '../../domain/domain.dart';
import 'materiais_dados_2017.dart';
import 'materiais_datasource.dart';

/// Catálogo de materiais mantido em memória enquanto o SIM não tem API.
///
/// Os dados iniciais são os do banco do SIM de 2017 (tabelas técnicas de aço). Os grupos vêm de
/// Tabelas auxiliares › Tipos de material, como no banco antigo. As listas são estáticas para
/// sobreviver à troca de telas, como um servidor faria.
class MateriaisDatasourceMock implements MateriaisDatasource {
  static final List<MaterialModel> _materiais = _materiaisIniciais();
  static final Map<int, TabelaBitolasModel> _tabelas = _tabelasIniciais();

  /// Códigos excluídos. Como no SIM antigo, o material só é marcado, para não quebrar orçamentos.
  static final Set<int> _excluidos = {};

  /// Maior código de linha já usado, em todas as tabelas (no banco antigo era uma tabela só).
  static int _ultimaLinha = _maiorCodigoLinha();

  /// Volta aos dados iniciais (usado nos testes).
  static void reiniciar() {
    _materiais
      ..clear()
      ..addAll(_materiaisIniciais());
    _tabelas
      ..clear()
      ..addAll(_tabelasIniciais());
    _excluidos.clear();
    _ultimaLinha = _maiorCodigoLinha();
  }

  /// Materiais ativos, para outros cadastros de exemplo (como os materiais dos fornecedores).
  static List<MaterialModel> get ativos => _materiais.where((m) => !_excluidos.contains(m.codigo)).toList();

  static const _atraso = Duration(milliseconds: 200);

  @override
  Future<List<MaterialModel>> listar({String busca = ''}) async {
    await Future<void>.delayed(_atraso);
    final grupos = {for (final g in await _grupos()) g.codigo: g};

    return [
      for (final material in ativos)
        if (material.nome.combinaCom(busca))
          material.copyWith(
            grupo: grupos[material.grupo.codigo],
            quantidadeBitolas: _tabelas[material.codigo]?.linhas.length ?? 0,
          ),
    ]..sort((a, b) {
      final grupo = a.grupo.nome.normalizado.compareTo(b.grupo.nome.normalizado);
      return grupo != 0 ? grupo : a.descricao.normalizado.compareTo(b.descricao.normalizado);
    });
  }

  @override
  Future<List<GrupoMaterialModel>> listarGrupos() async {
    await Future<void>.delayed(_atraso);
    return _grupos();
  }

  @override
  Future<MaterialModel> salvar(MaterialModel material) async {
    await Future<void>.delayed(_atraso);
    final descricao = material.descricao.trim();

    final repetido = ativos.where(
      (m) =>
          m.codigo != material.codigo &&
          m.grupo.codigo == material.grupo.codigo &&
          m.descricao.normalizado == descricao.normalizado,
    );
    if (repetido.isNotEmpty) {
      throw DomainException(message: 'Já existe o material "${repetido.first.nome}".');
    }

    final salvo = material.copyWith(descricao: descricao);
    if (material.codigo == null) {
      final proximo = _materiais.fold<int>(0, (maior, m) => m.codigo! > maior ? m.codigo! : maior) + 1;
      final novo = salvo.copyWith(codigo: proximo, quantidadeBitolas: 0);
      _materiais.add(novo);
      return novo;
    }

    final indice = _indice(material.codigo!);
    return _materiais[indice] = salvo.copyWith(
      quantidadeBitolas: _tabelas[material.codigo]?.linhas.length ?? 0,
    );
  }

  @override
  Future<void> excluir(int codigo) async {
    await Future<void>.delayed(_atraso);
    _excluidos.add(codigo);
  }

  @override
  Future<TabelaBitolasModel> carregarTabela(int codigoMaterial) async {
    await Future<void>.delayed(_atraso);
    _indice(codigoMaterial);
    return _tabelas[codigoMaterial] ?? const TabelaBitolasModel();
  }

  @override
  Future<TabelaBitolasModel> salvarEstrutura(
    int codigoMaterial, {
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  }) async {
    await Future<void>.delayed(_atraso);
    final indice = _indice(codigoMaterial);
    final nomes = [for (final c in colunas) c.nome.trim()];
    if (nomes.any((n) => n.isEmpty)) throw DomainException(message: 'Dê um nome a todas as colunas.');
    if (nomes.length > TabelaBitolasModel.maximoColunas) {
      throw DomainException(message: 'A tabela pode ter até ${TabelaBitolasModel.maximoColunas} colunas.');
    }

    final atual = _tabelas[codigoMaterial] ?? const TabelaBitolasModel();
    final material = _materiais[indice];
    _materiais[indice] = material.copyWith(
      colunaBitola: ColunaEdicao.remapear(material.colunaBitola, colunas),
      limparColunaBitola: ColunaEdicao.remapear(material.colunaBitola, colunas) == null,
    );

    return _tabelas[codigoMaterial] = TabelaBitolasModel(
      nome: nome.trim(),
      unidade: unidade,
      colunas: nomes,
      linhas: [
        for (final linha in atual.linhas)
          LinhaBitolaModel(
            codigo: linha.codigo,
            valores: [for (final c in colunas) c.origem == null ? '' : linha.valor(c.origem!)],
          ),
      ],
    );
  }

  @override
  Future<TabelaBitolasModel> salvarLinha(int codigoMaterial, LinhaBitolaModel linha) async {
    await Future<void>.delayed(_atraso);
    _indice(codigoMaterial);
    final tabela = _tabelas[codigoMaterial] ?? const TabelaBitolasModel();
    if (!tabela.temColunas) throw DomainException(message: 'Defina as colunas da tabela primeiro.');

    final valores = [for (var i = 0; i < tabela.colunas.length; i++) linha.valor(i).trim()];
    if (valores.every((v) => v.isEmpty)) throw DomainException(message: 'Preencha ao menos uma coluna.');

    final linhas = [...tabela.linhas];
    if (linha.codigo == null) {
      linhas.add(LinhaBitolaModel(codigo: ++_ultimaLinha, valores: valores));
    } else {
      final posicao = linhas.indexWhere((l) => l.codigo == linha.codigo);
      if (posicao < 0) throw DomainException(message: 'Linha não encontrada.');
      linhas[posicao] = LinhaBitolaModel(codigo: linha.codigo, valores: valores);
    }
    return _guardar(codigoMaterial, tabela, linhas);
  }

  @override
  Future<TabelaBitolasModel> excluirLinha(int codigoMaterial, int codigoLinha) async {
    await Future<void>.delayed(_atraso);
    final tabela = _tabelas[codigoMaterial] ?? const TabelaBitolasModel();
    return _guardar(codigoMaterial, tabela, tabela.linhas.where((l) => l.codigo != codigoLinha).toList());
  }

  @override
  Future<TabelaBitolasModel> moverLinha(int codigoMaterial, int codigoLinha, int deslocamento) async {
    await Future<void>.delayed(_atraso);
    final tabela = _tabelas[codigoMaterial] ?? const TabelaBitolasModel();
    final linhas = [...tabela.linhas];
    final origem = linhas.indexWhere((l) => l.codigo == codigoLinha);
    if (origem < 0) throw DomainException(message: 'Linha não encontrada.');

    final destino = (origem + deslocamento).clamp(0, linhas.length - 1);
    linhas.insert(destino, linhas.removeAt(origem));
    return _guardar(codigoMaterial, tabela, linhas);
  }

  TabelaBitolasModel _guardar(int codigoMaterial, TabelaBitolasModel tabela, List<LinhaBitolaModel> linhas) {
    return _tabelas[codigoMaterial] = TabelaBitolasModel(
      nome: tabela.nome,
      unidade: tabela.unidade,
      colunas: tabela.colunas,
      linhas: linhas,
    );
  }

  int _indice(int codigo) {
    final indice = _materiais.indexWhere((m) => m.codigo == codigo);
    if (indice < 0 || _excluidos.contains(codigo)) throw DomainException(message: 'Material não encontrado.');
    return indice;
  }

  /// Grupos ativos, lidos das Tabelas auxiliares.
  static Future<List<GrupoMaterialModel>> _grupos() async {
    final itens = await TabelasAuxiliaresDatasourceMock().listar(TabelaAuxiliar.tiposMaterial);
    return [for (final item in itens) GrupoMaterialModel(codigo: item.codigo!, nome: item.descricao)];
  }

  static final _nomesGrupos = {for (final (codigo, nome) in gruposMateriais2017) codigo: nome};

  static List<MaterialModel> _materiaisIniciais() => [
    for (final m in materiais2017)
      MaterialModel(
        codigo: m.codigo,
        grupo: GrupoMaterialModel(codigo: m.grupo, nome: _nomesGrupos[m.grupo] ?? ''),
        descricao: m.descricao,
        medidas: {
          for (final medida in MedidaOrcamento.values)
            if (m.medidas.contains(medida.name)) medida,
        },
        colunaBitola: m.colunaBitola,
        valorZero: m.valorZero,
        descricaoEmBranco: m.descricaoEmBranco,
        exibirNoSubitem: m.exibirNoSubitem,
        quantidadeBitolas: m.tabela?.linhas.length ?? 0,
      ),
  ];

  static Map<int, TabelaBitolasModel> _tabelasIniciais() => {
    for (final m in materiais2017)
      if (m.tabela case final tabela?)
        m.codigo: TabelaBitolasModel(
          nome: tabela.nome,
          unidade: UnidadeTabela.de(tabela.unidade),
          colunas: tabela.colunas,
          linhas: [
            for (final (codigo, valores) in tabela.linhas) LinhaBitolaModel(codigo: codigo, valores: valores),
          ],
        ),
  };

  static int _maiorCodigoLinha() => _tabelasIniciais().values
      .expand((t) => t.linhas)
      .fold(0, (maior, l) => l.codigo! > maior ? l.codigo! : maior);
}
