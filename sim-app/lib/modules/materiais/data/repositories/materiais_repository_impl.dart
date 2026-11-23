import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class MateriaisRepositoryImpl implements MateriaisRepository {
  MateriaisRepositoryImpl(this._datasource);

  final MateriaisDatasource _datasource;

  @override
  Future<Either<BaseException, List<MaterialModel>>> listar({String busca = ''}) {
    return _executar(() => _datasource.listar(busca: busca), 'Não foi possível carregar os materiais.');
  }

  @override
  Future<Either<BaseException, List<GrupoMaterialModel>>> listarGrupos() {
    return _executar(_datasource.listarGrupos, 'Não foi possível carregar os grupos de material.');
  }

  @override
  Future<Either<BaseException, MaterialModel>> salvar(MaterialModel material) {
    return _executar(() => _datasource.salvar(material), 'Não foi possível salvar o material.');
  }

  @override
  Future<Either<BaseException, Unit>> excluir(int codigo) {
    return _executar(() async {
      await _datasource.excluir(codigo);
      return unit;
    }, 'Não foi possível excluir o material.');
  }

  @override
  Future<Either<BaseException, TabelaBitolasModel>> carregarTabela(int codigoMaterial) {
    return _executar(() => _datasource.carregarTabela(codigoMaterial), 'Não foi possível carregar a tabela.');
  }

  @override
  Future<Either<BaseException, TabelaBitolasModel>> salvarEstrutura(
    int codigoMaterial, {
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  }) {
    return _executar(
      () => _datasource.salvarEstrutura(codigoMaterial, nome: nome, unidade: unidade, colunas: colunas),
      'Não foi possível salvar as colunas.',
    );
  }

  @override
  Future<Either<BaseException, TabelaBitolasModel>> salvarLinha(int codigoMaterial, LinhaBitolaModel linha) {
    return _executar(
      () => _datasource.salvarLinha(codigoMaterial, linha),
      'Não foi possível salvar a linha.',
    );
  }

  @override
  Future<Either<BaseException, TabelaBitolasModel>> excluirLinha(int codigoMaterial, int codigoLinha) {
    return _executar(
      () => _datasource.excluirLinha(codigoMaterial, codigoLinha),
      'Não foi possível excluir a linha.',
    );
  }

  @override
  Future<Either<BaseException, TabelaBitolasModel>> moverLinha(
    int codigoMaterial,
    int codigoLinha,
    int deslocamento,
  ) {
    return _executar(
      () => _datasource.moverLinha(codigoMaterial, codigoLinha, deslocamento),
      'Não foi possível mover a linha.',
    );
  }

  Future<Either<BaseException, T>> _executar<T>(Future<T> Function() acao, String mensagemPadrao) async {
    try {
      return Right(await acao());
    } on BaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      Log.e('MateriaisRepositoryImpl: $mensagemPadrao', e);
      return Left(DomainException(message: mensagemPadrao));
    }
  }
}
