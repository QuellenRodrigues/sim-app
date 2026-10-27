import '../../domain/domain.dart';

abstract class ClientesDatasource {
  Future<List<ClienteModel>> listar({String busca = ''});

  Future<ClienteModel> salvar(ClienteModel cliente);

  Future<void> excluir(int codigo);
}
