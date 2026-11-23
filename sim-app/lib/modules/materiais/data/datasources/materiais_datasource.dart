import '../../domain/domain.dart';

abstract class MateriaisDatasource {
  Future<List<MaterialModel>> listar({String busca = ''});

  Future<List<GrupoMaterialModel>> listarGrupos();

  Future<MaterialModel> salvar(MaterialModel material);

  Future<void> excluir(int codigo);

  Future<TabelaBitolasModel> carregarTabela(int codigoMaterial);

  Future<TabelaBitolasModel> salvarEstrutura(
    int codigoMaterial, {
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  });

  Future<TabelaBitolasModel> salvarLinha(int codigoMaterial, LinhaBitolaModel linha);

  Future<TabelaBitolasModel> excluirLinha(int codigoMaterial, int codigoLinha);

  Future<TabelaBitolasModel> moverLinha(int codigoMaterial, int codigoLinha, int deslocamento);
}
