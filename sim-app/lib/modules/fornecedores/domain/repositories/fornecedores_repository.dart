import 'package:core/core.dart';

import '../models/models.dart';

abstract class FornecedoresRepository {
  /// Fornecedores cujo nome, CNPJ, cidade ou contato contém [busca] (todos, se vazia).
  Future<Either<BaseException, List<FornecedorModel>>> listar({String busca = ''});

  /// Inclui (sem código) ou altera (com código). Retorna o fornecedor salvo.
  Future<Either<BaseException, FornecedorModel>> salvar(FornecedorModel fornecedor);

  /// Suspende, ou reativa quem já está suspenso. Retorna o fornecedor atualizado.
  Future<Either<BaseException, FornecedorModel>> alternarSuspensao(int codigo);

  /// Materiais que o fornecedor fornece.
  Future<Either<BaseException, List<GrupoCompraModel>>> listarMateriais(int codigo);

  /// Materiais do catálogo que o fornecedor ainda não fornece.
  Future<Either<BaseException, List<GrupoCompraModel>>> listarMateriaisDisponiveis(int codigo);

  Future<Either<BaseException, Unit>> adicionarMateriais(int codigo, List<int> codigosMateriais);

  /// Remove o material e os preços que o fornecedor tinha para ele.
  Future<Either<BaseException, Unit>> removerMaterial(int codigo, int codigoMaterial);

  /// Preços informados pelo fornecedor.
  Future<Either<BaseException, List<PrecoMaterialModel>>> listarPrecos(int codigo);

  /// Inclui (sem código) ou altera (com código) um preço.
  Future<Either<BaseException, PrecoMaterialModel>> salvarPreco(PrecoMaterialModel preco);

  Future<Either<BaseException, Unit>> excluirPreco(int codigoPreco);

  /// Itens cujo nome contém todas as palavras de [busca], com os fornecedores e os preços.
  /// Fornecedores inativos ficam de fora, como nas compras do SIM antigo.
  Future<Either<BaseException, List<GrupoPrecosModel>>> consultarPrecos(String busca);
}
