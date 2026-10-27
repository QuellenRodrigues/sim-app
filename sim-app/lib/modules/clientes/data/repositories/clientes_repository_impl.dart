import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class ClientesRepositoryImpl implements ClientesRepository {
  ClientesRepositoryImpl(this._datasource);

  final ClientesDatasource _datasource;

  @override
  Future<Either<BaseException, List<ClienteModel>>> listar({String busca = ''}) {
    return _executar(() => _datasource.listar(busca: busca), 'Não foi possível carregar os clientes.');
  }

  @override
  Future<Either<BaseException, ClienteModel>> salvar(ClienteModel cliente) {
    return _executar(() => _datasource.salvar(cliente), 'Não foi possível salvar o cliente.');
  }

  @override
  Future<Either<BaseException, Unit>> excluir(int codigo) {
    return _executar(() async {
      await _datasource.excluir(codigo);
      return unit;
    }, 'Não foi possível excluir o cliente.');
  }

  Future<Either<BaseException, T>> _executar<T>(Future<T> Function() acao, String mensagemPadrao) async {
    try {
      return Right(await acao());
    } on BaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      Log.e('ClientesRepositoryImpl: $mensagemPadrao', e);
      return Left(DomainException(message: mensagemPadrao));
    }
  }
}
