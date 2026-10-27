import 'package:core/core.dart';

/// Cliente, com os mesmos campos do cadastro do SIM antigo (frmClientes).
class ClienteModel extends Equatable {
  const ClienteModel({
    required this.razaoSocial,
    this.codigo,
    this.nomeFantasia = '',
    this.cnpj = '',
    this.endereco = '',
    this.bairro = '',
    this.cidade = '',
    this.estado,
    this.cep = '',
    this.contato = '',
    this.telefone1 = '',
    this.telefone2 = '',
    this.telefone3 = '',
    this.email = '',
    this.fax = '',
    this.nextel = '',
    this.nextelId = '',
  });

  /// `null` enquanto o cliente não foi salvo.
  final int? codigo;
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String endereco;
  final String bairro;
  final String cidade;
  final UnidadeFederativa? estado;
  final String cep;
  final String contato;
  final String telefone1;
  final String telefone2;
  final String telefone3;
  final String email;
  final String fax;
  final String nextel;
  final String nextelId;

  /// Código com 4 dígitos, como no sistema antigo (ex.: "0007").
  String get codigoFormatado => codigo == null ? '' : codigo.toString().padLeft(4, '0');

  /// "Volta Redonda/RJ", "Volta Redonda" ou "".
  String get cidadeUf => [cidade, ?estado?.sigla].where((p) => p.isNotEmpty).join('/');

  ClienteModel copyWith({int? codigo}) {
    return ClienteModel(
      codigo: codigo ?? this.codigo,
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      cnpj: cnpj,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      cep: cep,
      contato: contato,
      telefone1: telefone1,
      telefone2: telefone2,
      telefone3: telefone3,
      email: email,
      fax: fax,
      nextel: nextel,
      nextelId: nextelId,
    );
  }

  @override
  List<Object?> get props => [
    codigo,
    razaoSocial,
    nomeFantasia,
    cnpj,
    endereco,
    bairro,
    cidade,
    estado,
    cep,
    contato,
    telefone1,
    telefone2,
    telefone3,
    email,
    fax,
    nextel,
    nextelId,
  ];
}
