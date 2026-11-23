import 'package:core/core.dart';

import '../models/models.dart';

abstract class MateriaisRepository {
  /// Materiais cujo grupo ou descrição contém todas as palavras de [busca] (todos, se vazia).
  Future<Either<BaseException, List<MaterialModel>>> listar({String busca = ''});

  /// Grupos ativos (cadastrados em Tabelas auxiliares › Tipos de material).
  Future<Either<BaseException, List<GrupoMaterialModel>>> listarGrupos();

  /// Inclui (sem código) ou altera (com código). Retorna o material salvo.
  Future<Either<BaseException, MaterialModel>> salvar(MaterialModel material);

  /// Como no SIM antigo, só marca o material como excluído.
  Future<Either<BaseException, Unit>> excluir(int codigo);

  Future<Either<BaseException, TabelaBitolasModel>> carregarTabela(int codigoMaterial);

  /// Altera nome, unidade e colunas. As linhas acompanham as colunas pela [ColunaEdicao.origem].
  Future<Either<BaseException, TabelaBitolasModel>> salvarEstrutura(
    int codigoMaterial, {
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  });

  /// Inclui (sem código, no fim da tabela) ou altera uma linha.
  Future<Either<BaseException, TabelaBitolasModel>> salvarLinha(int codigoMaterial, LinhaBitolaModel linha);

  Future<Either<BaseException, TabelaBitolasModel>> excluirLinha(int codigoMaterial, int codigoLinha);

  /// Sobe ([deslocamento] negativo) ou desce a linha na tabela.
  Future<Either<BaseException, TabelaBitolasModel>> moverLinha(
    int codigoMaterial,
    int codigoLinha,
    int deslocamento,
  );
}
