import 'package:core/core.dart';

import '../models/models.dart';

abstract class HomeRepository {
  Future<Either<BaseException, HomePainelModel>> carregarPainel();
}
