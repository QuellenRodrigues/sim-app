import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class TabelasAuxiliaresRepositoryImpl implements TabelasAuxiliaresRepository {
  TabelasAuxiliaresRepositoryImpl(this._datasource);

  final TabelasAuxiliaresDatasource _datasource;

  @override
  Future<Either<BaseException, List<ItemTabelaModel>>> listar(TabelaAuxiliar tabela) {
    return _executar(
      () => _datasource.listar(tabela),
      'Não foi possível carregar ${tabela.titulo.toLowerCase()}.',
    );
  }

  @override
  Future<Either<BaseException, ItemTabelaModel>> salvar(TabelaAuxiliar tabela, ItemTabelaModel item) {
    return _executar(() => _datasource.salvar(tabela, item), 'Não foi possível salvar o item.');
  }

  @override
  Future<Either<BaseException, Unit>> excluir(TabelaAuxiliar tabela, int codigo) {
    return _executar(() async {
      await _datasource.excluir(tabela, codigo);
      return unit;
    }, 'Não foi possível excluir o item.');
  }

  Future<Either<BaseException, T>> _executar<T>(Future<T> Function() acao, String mensagemPadrao) async {
    try {
      return Right(await acao());
    } on BaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      Log.e('TabelasAuxiliaresRepositoryImpl: $mensagemPadrao', e);
      return Left(DomainException(message: mensagemPadrao));
    }
  }
}
