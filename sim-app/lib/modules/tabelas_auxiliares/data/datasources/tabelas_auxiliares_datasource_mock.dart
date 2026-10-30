import 'package:core/core.dart';

import '../../domain/domain.dart';
import 'tabelas_auxiliares_datasource.dart';

/// Tabelas auxiliares mantidas em memória enquanto o SIM não tem API.
///
/// Os valores iniciais são os do banco do SIM de 2014 (sem os registros de teste).
/// A lista é estática para sobreviver à troca de telas, como um servidor faria.
class TabelasAuxiliaresDatasourceMock implements TabelasAuxiliaresDatasource {
  static final Map<TabelaAuxiliar, List<ItemTabelaModel>> _itens = _copiaDosIniciais();

  /// Códigos excluídos por tabela. Como no SIM antigo, o item só é marcado como excluído,
  /// para não quebrar orçamentos e lançamentos que já o usam.
  static final Map<TabelaAuxiliar, Set<int>> _excluidos = {};

  /// Volta aos dados iniciais (usado nos testes).
  static void reiniciar() {
    _itens
      ..clear()
      ..addAll(_copiaDosIniciais());
    _excluidos.clear();
  }

  static Map<TabelaAuxiliar, List<ItemTabelaModel>> _copiaDosIniciais() => {
    for (final MapEntry(key: tabela, value: itens) in _iniciais.entries) tabela: [...itens],
  };

  static const _atraso = Duration(milliseconds: 200);

  List<ItemTabelaModel> _daTabela(TabelaAuxiliar tabela) => _itens.putIfAbsent(tabela, () => []);

  Iterable<ItemTabelaModel> _ativos(TabelaAuxiliar tabela) {
    final excluidos = _excluidos[tabela] ?? const {};
    return _daTabela(tabela).where((item) => !excluidos.contains(item.codigo));
  }

  @override
  Future<List<ItemTabelaModel>> listar(TabelaAuxiliar tabela) async {
    await Future<void>.delayed(_atraso);
    return _ativos(tabela).toList()
      ..sort((a, b) => a.descricao.normalizado.compareTo(b.descricao.normalizado));
  }

  @override
  Future<ItemTabelaModel> salvar(TabelaAuxiliar tabela, ItemTabelaModel item) async {
    await Future<void>.delayed(_atraso);

    final descricao = item.descricao.trim();
    final repetido = _ativos(tabela).where(
      (outro) => outro.codigo != item.codigo && outro.descricao.trim().normalizado == descricao.normalizado,
    );
    if (repetido.isNotEmpty) {
      throw DomainException(message: '"${repetido.first.descricao}" já está em ${tabela.titulo}.');
    }

    final itens = _daTabela(tabela);
    if (item.codigo == null) {
      final proximo = itens.fold<int>(0, (maior, i) => i.codigo! > maior ? i.codigo! : maior) + 1;
      final novo = ItemTabelaModel(codigo: proximo, descricao: descricao);
      itens.add(novo);
      return novo;
    }

    final indice = itens.indexWhere((i) => i.codigo == item.codigo);
    if (indice < 0 || (_excluidos[tabela]?.contains(item.codigo) ?? false)) {
      throw DomainException(message: 'Item não encontrado.');
    }
    return itens[indice] = item.copyWith(descricao: descricao);
  }

  @override
  Future<void> excluir(TabelaAuxiliar tabela, int codigo) async {
    await Future<void>.delayed(_atraso);
    _excluidos.putIfAbsent(tabela, () => {}).add(codigo);
  }

  static const _iniciais = <TabelaAuxiliar, List<ItemTabelaModel>>{
    TabelaAuxiliar.gruposMaquina: [
      ItemTabelaModel(codigo: 1, descricao: 'TORNO'),
      ItemTabelaModel(codigo: 2, descricao: 'FRESADORA'),
      ItemTabelaModel(codigo: 3, descricao: 'FURADEIRA'),
      ItemTabelaModel(codigo: 4, descricao: 'ACABAMENTO'),
      ItemTabelaModel(codigo: 5, descricao: 'PLAINA'),
      ItemTabelaModel(codigo: 6, descricao: 'CALDEIRARIA'),
      ItemTabelaModel(codigo: 7, descricao: 'MANDRILHADORA'),
      ItemTabelaModel(codigo: 8, descricao: 'TRAÇAR'),
      ItemTabelaModel(codigo: 9, descricao: 'ROSQUEAR'),
      ItemTabelaModel(codigo: 10, descricao: 'SOLDAR'),
      ItemTabelaModel(codigo: 11, descricao: 'TN'),
      ItemTabelaModel(codigo: 12, descricao: 'CNC'),
      ItemTabelaModel(codigo: 13, descricao: 'INSPECIONAR'),
      ItemTabelaModel(codigo: 14, descricao: 'CALANDRA'),
      ItemTabelaModel(codigo: 15, descricao: 'SOLDA'),
      ItemTabelaModel(codigo: 16, descricao: 'DOBRADEIRA'),
      ItemTabelaModel(codigo: 17, descricao: 'PREPARAÇÃO'),
      ItemTabelaModel(codigo: 18, descricao: 'EXPEDIÇÃO'),
      ItemTabelaModel(codigo: 19, descricao: 'CORTE A FRIO'),
      ItemTabelaModel(codigo: 20, descricao: 'MONTAGEM'),
      ItemTabelaModel(codigo: 21, descricao: 'PINTURA'),
      ItemTabelaModel(codigo: 22, descricao: 'AJUSTAGEM'),
      ItemTabelaModel(codigo: 23, descricao: 'FRESA'),
      ItemTabelaModel(codigo: 24, descricao: 'CORTE A QUENTE'),
      ItemTabelaModel(codigo: 25, descricao: 'SEM MÃO DE OBRA'),
    ],
    TabelaAuxiliar.tiposMaterial: [
      ItemTabelaModel(codigo: 1, descricao: 'CANTONEIRA'),
      ItemTabelaModel(codigo: 2, descricao: 'PERFIL'),
      ItemTabelaModel(codigo: 3, descricao: 'TUBO'),
      ItemTabelaModel(codigo: 4, descricao: 'BARRA'),
      ItemTabelaModel(codigo: 8, descricao: 'CHAPA'),
      ItemTabelaModel(codigo: 9, descricao: 'MAT. COMERCIAL'),
      ItemTabelaModel(codigo: 10, descricao: 'GROSSA'),
      ItemTabelaModel(codigo: 12, descricao: 'PERFIL IPE'),
      ItemTabelaModel(codigo: 13, descricao: 'T. TERMICO'),
      ItemTabelaModel(codigo: 15, descricao: 'S. TERCEIRO'),
      ItemTabelaModel(codigo: 16, descricao: 'SOLDA'),
      ItemTabelaModel(codigo: 17, descricao: 'FORNECIDO PELO CLIENTE'),
      ItemTabelaModel(codigo: 18, descricao: 'BORRACHA'),
      ItemTabelaModel(codigo: 19, descricao: 'REVESTIMENTO'),
      ItemTabelaModel(codigo: 20, descricao: 'ROLAMENTO'),
      ItemTabelaModel(codigo: 22, descricao: 'MAN. ELETRICA'),
      ItemTabelaModel(codigo: 23, descricao: 'BARRA INOX'),
      ItemTabelaModel(codigo: 24, descricao: 'PROVISORIAMENTE SEM MATERIAL'),
      ItemTabelaModel(codigo: 25, descricao: 'ELETRODO'),
      ItemTabelaModel(codigo: 26, descricao: 'PINTURA'),
    ],
    TabelaAuxiliar.qualidadesMaterial: [
      ItemTabelaModel(codigo: 1, descricao: 'AÇO INOX'),
      ItemTabelaModel(codigo: 2, descricao: 'ALUMÍNIO'),
      ItemTabelaModel(codigo: 3, descricao: 'AÇO CARBONO'),
      ItemTabelaModel(codigo: 4, descricao: 'BRONZE'),
      ItemTabelaModel(codigo: 5, descricao: 'LATÃO'),
      ItemTabelaModel(codigo: 6, descricao: 'S/N'),
    ],
    TabelaAuxiliar.custosOrcamento: [
      ItemTabelaModel(codigo: 1, descricao: 'JATO'),
      ItemTabelaModel(codigo: 2, descricao: 'TRAT. TÉRMICO'),
      ItemTabelaModel(codigo: 3, descricao: 'MAT. COMERCIAL'),
      ItemTabelaModel(codigo: 4, descricao: 'FORN. CLIENTE'),
      ItemTabelaModel(codigo: 5, descricao: 'ELETRODO'),
      ItemTabelaModel(codigo: 6, descricao: 'TESTE Ñ DESTR.'),
      ItemTabelaModel(codigo: 7, descricao: 'SERV. TERCEIROS'),
      ItemTabelaModel(codigo: 8, descricao: 'PINTURA'),
      ItemTabelaModel(codigo: 9, descricao: 'BALANCEAMENTO'),
      ItemTabelaModel(codigo: 10, descricao: 'FRETE'),
      ItemTabelaModel(codigo: 11, descricao: 'ALUGUEL'),
      ItemTabelaModel(codigo: 12, descricao: 'MONTAGEM'),
      ItemTabelaModel(codigo: 13, descricao: 'EMBALAGEM'),
      ItemTabelaModel(codigo: 14, descricao: 'PROPOSTA TECNICA'),
      ItemTabelaModel(codigo: 15, descricao: 'OUTROS'),
      ItemTabelaModel(codigo: 16, descricao: 'NAO COTAMOS'),
      ItemTabelaModel(codigo: 17, descricao: 'MADEIRAS'),
      ItemTabelaModel(codigo: 18, descricao: 'LUBRIFICANTES'),
      ItemTabelaModel(codigo: 19, descricao: 'FERRAMENTAS'),
      ItemTabelaModel(codigo: 20, descricao: 'CHAPA PERFURADA'),
      ItemTabelaModel(codigo: 21, descricao: 'CHAPAS ESPECIAIS'),
      ItemTabelaModel(codigo: 22, descricao: 'QUALIF. DE SOLDADOR'),
      ItemTabelaModel(codigo: 23, descricao: 'HORA EXTRA (%)'),
    ],
    TabelaAuxiliar.tiposServico: [
      ItemTabelaModel(codigo: 1, descricao: 'SERVICO'),
      ItemTabelaModel(codigo: 2, descricao: 'USINAGEM'),
      ItemTabelaModel(codigo: 3, descricao: 'CALDEIRARIA'),
    ],
    TabelaAuxiliar.destinos: [
      ItemTabelaModel(codigo: 1, descricao: 'USO PRÓPRIO'),
      ItemTabelaModel(codigo: 2, descricao: 'INDUSTRIALIZAÇÃO'),
    ],
    TabelaAuxiliar.gruposProduto: [
      ItemTabelaModel(codigo: 1, descricao: 'MARTELO DE BORRACHA'),
      ItemTabelaModel(codigo: 2, descricao: 'CHAVE DE FENDA'),
      ItemTabelaModel(codigo: 3, descricao: 'CHAVE TORC'),
      ItemTabelaModel(codigo: 4, descricao: 'CHAVE PHILIPS'),
      ItemTabelaModel(codigo: 5, descricao: 'ALICATE DE CORTE'),
      ItemTabelaModel(codigo: 6, descricao: 'ALICATE DE BICO'),
      ItemTabelaModel(codigo: 7, descricao: 'MARTELO DE AÇO'),
      ItemTabelaModel(codigo: 8, descricao: 'MARTELO DE BOLA'),
      ItemTabelaModel(codigo: 9, descricao: 'MARTELO DE ORELHA'),
      ItemTabelaModel(codigo: 10, descricao: 'EQUIPAMENTO DE MEDIÇÃO'),
      ItemTabelaModel(codigo: 11, descricao: 'FERRAMENTA MANUAL'),
      ItemTabelaModel(codigo: 12, descricao: 'FERRAMENTA ELÉTRICA'),
      ItemTabelaModel(codigo: 14, descricao: 'ELETRODO CARBONO'),
      ItemTabelaModel(codigo: 15, descricao: 'MATÉRIA PRIMA'),
      ItemTabelaModel(codigo: 16, descricao: 'TINTA'),
      ItemTabelaModel(codigo: 17, descricao: 'LIXA'),
      ItemTabelaModel(codigo: 18, descricao: 'REBITE'),
      ItemTabelaModel(codigo: 19, descricao: 'LAMPADA'),
      ItemTabelaModel(codigo: 20, descricao: 'DIVERSOS'),
      ItemTabelaModel(codigo: 21, descricao: 'MAT. ESCRITORIO'),
      ItemTabelaModel(codigo: 22, descricao: 'REBOLO'),
    ],
    TabelaAuxiliar.tiposSaida: [
      ItemTabelaModel(codigo: 2, descricao: 'MATÉRIA PRIMA'),
      ItemTabelaModel(codigo: 3, descricao: 'ESCRITÓRIO'),
      ItemTabelaModel(codigo: 4, descricao: 'MANUTENÇÃO PREDIAL'),
      ItemTabelaModel(codigo: 5, descricao: 'MANUTENÇÃO DE EQUIPAMENTO/MÁQUINA'),
      ItemTabelaModel(codigo: 6, descricao: 'MANUTENÇÃO DE VEÍCULOS'),
      ItemTabelaModel(codigo: 7, descricao: 'PATRIMÔNIO'),
      ItemTabelaModel(codigo: 8, descricao: 'PRODUÇÃO'),
      ItemTabelaModel(codigo: 9, descricao: 'EMPRÉSTIMO'),
    ],
    TabelaAuxiliar.bancos: [
      ItemTabelaModel(codigo: 1, descricao: 'BANCO DO BRASIL'),
      ItemTabelaModel(codigo: 2, descricao: 'CAIXA ECONÔMICA FEDERAL'),
      ItemTabelaModel(codigo: 3, descricao: 'ITAÚ'),
      ItemTabelaModel(codigo: 4, descricao: 'SANTANDER'),
      ItemTabelaModel(codigo: 5, descricao: 'ABN AMRO BANK'),
      ItemTabelaModel(codigo: 6, descricao: 'ECONÔMICO'),
    ],
    TabelaAuxiliar.justificativas: [
      ItemTabelaModel(codigo: 1, descricao: 'BCO. MOV'),
      ItemTabelaModel(codigo: 2, descricao: 'BCO. DESP'),
      ItemTabelaModel(codigo: 3, descricao: 'COMUNICAÇÃO'),
      ItemTabelaModel(codigo: 4, descricao: 'DESPESAS GERAIS'),
      ItemTabelaModel(codigo: 5, descricao: 'DESPESAS JURÍDICAS'),
      ItemTabelaModel(codigo: 6, descricao: 'DESPESAS SERVIÇOS'),
      ItemTabelaModel(codigo: 7, descricao: 'DESPESAS TÉCNICAS'),
      ItemTabelaModel(codigo: 8, descricao: 'ESTORNO'),
      ItemTabelaModel(codigo: 9, descricao: 'PARCELAS DE TRIBUTOS'),
      ItemTabelaModel(codigo: 10, descricao: 'REMUNERAÇÃO'),
      ItemTabelaModel(codigo: 11, descricao: 'TRANSFERÊNCIA BANCÁRIA'),
      ItemTabelaModel(codigo: 12, descricao: 'TRIBUTOS PARCELADOS'),
      ItemTabelaModel(codigo: 13, descricao: 'RESERVA'),
      ItemTabelaModel(codigo: 14, descricao: 'RECEBIMENTO'),
    ],
  };
}
