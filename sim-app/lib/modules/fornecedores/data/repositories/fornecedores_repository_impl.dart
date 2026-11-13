import 'package:core/core.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class FornecedoresRepositoryImpl implements FornecedoresRepository {
  FornecedoresRepositoryImpl(this._datasource);

  final FornecedoresDatasource _datasource;

  @override
  Future<Either<BaseException, List<FornecedorModel>>> listar({String busca = ''}) {
    return _executar(() => _datasource.listar(busca: busca), 'Não foi possível carregar os fornecedores.');
  }

  @override
  Future<Either<BaseException, FornecedorModel>> salvar(FornecedorModel fornecedor) {
    return _executar(() => _datasource.salvar(fornecedor), 'Não foi possível salvar o fornecedor.');
  }

  @override
  Future<Either<BaseException, FornecedorModel>> alternarSuspensao(int codigo) {
    return _executar(() => _datasource.alternarSuspensao(codigo), 'Não foi possível alterar a suspensão.');
  }

  @override
  Future<Either<BaseException, List<MaterialFornecidoModel>>> listarMateriais(int codigo) {
    return _executar(() => _datasource.listarMateriais(codigo), 'Não foi possível carregar os materiais.');
  }

  @override
  Future<Either<BaseException, List<MaterialFornecidoModel>>> listarMateriaisDisponiveis(int codigo) {
    return _executar(
      () => _datasource.listarMateriaisDisponiveis(codigo),
      'Não foi possível carregar o catálogo de materiais.',
    );
  }

  @override
  Future<Either<BaseException, Unit>> adicionarMateriais(int codigo, List<int> codigosMateriais) {
    return _executar(() async {
      await _datasource.adicionarMateriais(codigo, codigosMateriais);
      return unit;
    }, 'Não foi possível adicionar os materiais.');
  }

  @override
  Future<Either<BaseException, Unit>> removerMaterial(int codigo, int codigoMaterial) {
    return _executar(() async {
      await _datasource.removerMaterial(codigo, codigoMaterial);
      return unit;
    }, 'Não foi possível remover o material.');
  }

  @override
  Future<Either<BaseException, List<PrecoMaterialModel>>> listarPrecos(int codigo) {
    return _executar(() => _datasource.listarPrecos(codigo), 'Não foi possível carregar os preços.');
  }

  @override
  Future<Either<BaseException, PrecoMaterialModel>> salvarPreco(PrecoMaterialModel preco) {
    return _executar(() => _datasource.salvarPreco(preco), 'Não foi possível salvar o preço.');
  }

  @override
  Future<Either<BaseException, Unit>> excluirPreco(int codigoPreco) {
    return _executar(() async {
      await _datasource.excluirPreco(codigoPreco);
      return unit;
    }, 'Não foi possível excluir o preço.');
  }

  @override
  Future<Either<BaseException, List<GrupoPrecosModel>>> consultarPrecos(String busca) {
    return _executar(() => _datasource.consultarPrecos(busca), 'Não foi possível consultar os preços.');
  }

  Future<Either<BaseException, T>> _executar<T>(Future<T> Function() acao, String mensagemPadrao) async {
    try {
      return Right(await acao());
    } on BaseException catch (e) {
      return Left(e);
    } on Exception catch (e) {
      Log.e('FornecedoresRepositoryImpl: $mensagemPadrao', e);
      return Left(DomainException(message: mensagemPadrao));
    }
  }
}
