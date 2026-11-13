import '../../domain/domain.dart';

abstract class FornecedoresDatasource {
  Future<List<FornecedorModel>> listar({String busca = ''});

  Future<FornecedorModel> salvar(FornecedorModel fornecedor);

  Future<FornecedorModel> alternarSuspensao(int codigo);

  Future<List<MaterialFornecidoModel>> listarMateriais(int codigo);

  Future<List<MaterialFornecidoModel>> listarMateriaisDisponiveis(int codigo);

  Future<void> adicionarMateriais(int codigo, List<int> codigosMateriais);

  Future<void> removerMaterial(int codigo, int codigoMaterial);

  Future<List<PrecoMaterialModel>> listarPrecos(int codigo);

  Future<PrecoMaterialModel> salvarPreco(PrecoMaterialModel preco);

  Future<void> excluirPreco(int codigoPreco);

  Future<List<GrupoPrecosModel>> consultarPrecos(String busca);
}
