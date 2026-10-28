import 'package:core/core.dart';

import '../../domain/domain.dart';
import 'clientes_datasource.dart';

/// Clientes de exemplo, mantidos em memória enquanto o SIM não tem API.
///
/// A lista é estática para sobreviver à troca de telas, como um servidor faria.
class ClientesDatasourceMock implements ClientesDatasource {
  static final List<ClienteModel> _clientes = [..._iniciais];

  /// Códigos excluídos. Como no SIM antigo (coluna EXCLUIDO), o cliente só é marcado,
  /// para não perder o histórico de orçamentos e encomendas.
  static final Set<int> _excluidos = {};

  /// Volta aos dados de exemplo (usado nos testes).
  static void reiniciar() {
    _clientes
      ..clear()
      ..addAll(_iniciais);
    _excluidos.clear();
  }

  static Iterable<ClienteModel> get _ativos => _clientes.where((c) => !_excluidos.contains(c.codigo));

  static const _atraso = Duration(milliseconds: 250);

  @override
  Future<List<ClienteModel>> listar({String busca = ''}) async {
    await Future<void>.delayed(_atraso);
    final termo = busca.trim().normalizado;
    final digitos = busca.somenteDigitos;

    final resultado = _ativos.where((c) {
      if (termo.isEmpty) return true;
      return c.razaoSocial.normalizado.contains(termo) ||
          c.nomeFantasia.normalizado.contains(termo) ||
          c.cidade.normalizado.contains(termo) ||
          (digitos.length >= 3 && c.cnpj.somenteDigitos.contains(digitos));
    }).toList()..sort((a, b) => a.razaoSocial.normalizado.compareTo(b.razaoSocial.normalizado));

    return resultado;
  }

  @override
  Future<ClienteModel> salvar(ClienteModel cliente) async {
    await Future<void>.delayed(_atraso);

    final cnpj = cliente.cnpj.somenteDigitos;
    if (cnpj.isNotEmpty) {
      final duplicado = _ativos.where((c) => c.codigo != cliente.codigo && c.cnpj.somenteDigitos == cnpj);
      if (duplicado.isNotEmpty) {
        throw DomainException(message: 'Já existe um cliente com este CNPJ: ${duplicado.first.razaoSocial}.');
      }
    }

    if (cliente.codigo == null) {
      final proximo = _clientes.fold<int>(0, (maior, c) => c.codigo! > maior ? c.codigo! : maior) + 1;
      final novo = cliente.copyWith(codigo: proximo);
      _clientes.add(novo);
      return novo;
    }

    final indice = _clientes.indexWhere((c) => c.codigo == cliente.codigo);
    if (indice < 0 || _excluidos.contains(cliente.codigo)) {
      throw DomainException(message: 'Cliente não encontrado.');
    }
    _clientes[indice] = cliente;
    return cliente;
  }

  @override
  Future<void> excluir(int codigo) async {
    await Future<void>.delayed(_atraso);
    _excluidos.add(codigo);
  }

  static const _iniciais = [
    ClienteModel(
      codigo: 1,
      razaoSocial: 'Metalúrgica Vale Verde Ltda.',
      nomeFantasia: 'Vale Verde',
      cnpj: '11.222.333/0001-81',
      inscricaoEstadual: '78.123.456',
      endereco: 'Rua das Indústrias, 450',
      bairro: 'Distrito Industrial',
      cidade: 'Volta Redonda',
      estado: UnidadeFederativa.rj,
      cep: '27250-000',
      contato: 'Marcos Antunes',
      telefone1: '(24) 3342-1100',
      telefone2: '(24) 99812-4410',
      email: 'compras@valeverde.ind.br',
    ),
    ClienteModel(
      codigo: 2,
      razaoSocial: 'Usinagem Rio Claro S.A.',
      nomeFantasia: 'Rio Claro Usinagem',
      cnpj: '44.555.666/0001-81',
      endereco: 'Av. Brasil, 1.220',
      bairro: 'Vila Mury',
      cidade: 'Volta Redonda',
      estado: UnidadeFederativa.rj,
      cep: '27281-300',
      contato: 'Patrícia Lemos',
      telefone1: '(24) 3348-2020',
      email: 'pcp@rioclaro.com.br',
      email2: 'fiscal@rioclaro.com.br',
      fax: '(24) 3348-2021',
      icms: TributacaoImposto.incluso,
      destinacaoIcms: DestinacaoIcms.industrializacao,
    ),
    ClienteModel(
      codigo: 3,
      razaoSocial: 'Ferramentaria Alvorada Ltda.',
      nomeFantasia: 'Alvorada',
      cnpj: '77.888.999/0001-81',
      endereco: 'Rua Dois, 88',
      bairro: 'Boa Sorte',
      cidade: 'Barra Mansa',
      estado: UnidadeFederativa.rj,
      cep: '27345-020',
      contato: 'José Carlos',
      telefone1: '(24) 3322-7788',
      email: 'ferramentaria@alvorada.com.br',
    ),
    ClienteModel(
      codigo: 4,
      razaoSocial: 'Indústria Serra Azul Ltda.',
      nomeFantasia: 'Serra Azul',
      cnpj: '12.345.678/0001-95',
      endereco: 'Rodovia BR-393, km 12',
      bairro: 'Área Industrial',
      cidade: 'Resende',
      estado: UnidadeFederativa.rj,
      cep: '27537-000',
      contato: 'Fernanda Rocha',
      telefone1: '(24) 3381-5500',
      telefone2: '(24) 3381-5501',
      email: 'suprimentos@serraazul.ind.br',
    ),
    ClienteModel(
      codigo: 5,
      razaoSocial: 'Caldeiraria Paraíba do Sul Ltda.',
      nomeFantasia: 'Caldeiraria PS',
      cnpj: '24.681.357/0001-40',
      endereco: 'Rua Coronel Rocha, 301',
      bairro: 'Centro',
      cidade: 'Barra do Piraí',
      estado: UnidadeFederativa.rj,
      cep: '27123-110',
      contato: 'Antônio Lima',
      telefone1: '(24) 2442-3030',
    ),
    ClienteModel(
      codigo: 6,
      razaoSocial: 'Mecânica Industrial Itatiaia Eireli',
      nomeFantasia: 'MI Itatiaia',
      cnpj: '13.579.246/0001-01',
      endereco: 'Estrada do Contorno, 900',
      bairro: 'Jardim Itatiaia',
      cidade: 'Itatiaia',
      estado: UnidadeFederativa.rj,
      cep: '27580-000',
      contato: 'Rogério Dias',
      telefone1: '(24) 3352-4400',
      email: 'manutencao@miitatiaia.com.br',
    ),
    ClienteModel(
      codigo: 7,
      razaoSocial: 'Siderúrgica Vale do Paraíba S.A.',
      nomeFantasia: 'SVP',
      cnpj: '98.765.432/0001-98',
      endereco: 'Av. dos Trabalhadores, 5.000',
      bairro: 'Retiro',
      cidade: 'Volta Redonda',
      estado: UnidadeFederativa.rj,
      cep: '27277-000',
      contato: 'Luciana Prado',
      telefone1: '(24) 3344-9000',
      telefone2: '(24) 3344-9010',
      telefone3: '(24) 3344-9020',
      email: 'manutencao.mecanica@svp.com.br',
    ),
    ClienteModel(
      codigo: 8,
      razaoSocial: 'Automação Taubaté Ltda.',
      nomeFantasia: 'AutoTaubaté',
      cnpj: '19.283.746/0001-88',
      endereco: 'Rua Visconde do Rio Branco, 77',
      bairro: 'Centro',
      cidade: 'Taubaté',
      estado: UnidadeFederativa.sp,
      cep: '12020-040',
      contato: 'Eduardo Faria',
      telefone1: '(12) 3632-1414',
      email: 'eduardo@autotaubate.com.br',
      inscricaoMunicipal: '45.210-7',
      iss: TributacaoImposto.aParte,
      aliquotaIss: 0.05,
    ),
  ];
}
