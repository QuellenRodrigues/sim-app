import '../../domain/domain.dart';

abstract class HomeDatasource {
  Future<HomePainelModel> carregarPainel();
}
