import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._datasource);

  final HomeDatasource _datasource;

  @override
  Future<Either<BaseException, HomePainelModel>> carregarPainel() async {
    try {
      final result = await _datasource.carregarPainel();
      return Right(result);
    } on BaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      Log.e('HomeRepositoryImpl: falha ao carregar o painel', e);
      return Left(DomainException(message: 'Não foi possível carregar o painel. Tente novamente.'));
    }
  }
}
