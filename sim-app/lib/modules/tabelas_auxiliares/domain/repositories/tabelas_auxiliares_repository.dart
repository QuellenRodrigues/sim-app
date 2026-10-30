import 'package:core/core.dart';

import '../models/models.dart';

abstract class TabelasAuxiliaresRepository {
  /// Itens da [tabela], em ordem alfabética.
  Future<Either<BaseException, List<ItemTabelaModel>>> listar(TabelaAuxiliar tabela);

  /// Inclui (sem código) ou altera (com código). Retorna o item salvo.
  Future<Either<BaseException, ItemTabelaModel>> salvar(TabelaAuxiliar tabela, ItemTabelaModel item);

  Future<Either<BaseException, Unit>> excluir(TabelaAuxiliar tabela, int codigo);
}
