import 'package:core/core.dart';

import '../models/models.dart';

abstract class ClientesRepository {
  /// Clientes cujo nome, CNPJ ou cidade contém [busca] (todos, se vazia).
  Future<Either<BaseException, List<ClienteModel>>> listar({String busca = ''});

  /// Inclui (sem código) ou altera (com código). Retorna o cliente salvo.
  Future<Either<BaseException, ClienteModel>> salvar(ClienteModel cliente);

  Future<Either<BaseException, Unit>> excluir(int codigo);
}
