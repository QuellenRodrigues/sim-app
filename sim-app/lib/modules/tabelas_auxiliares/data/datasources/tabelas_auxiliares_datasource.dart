import '../../domain/domain.dart';

abstract class TabelasAuxiliaresDatasource {
  Future<List<ItemTabelaModel>> listar(TabelaAuxiliar tabela);

  Future<ItemTabelaModel> salvar(TabelaAuxiliar tabela, ItemTabelaModel item);

  Future<void> excluir(TabelaAuxiliar tabela, int codigo);
}
