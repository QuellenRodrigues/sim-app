import 'package:core/core.dart';

/// Fornecedor, com os campos do cadastro do SIM antigo (tabela Fornecedores, versão 2017).
class FornecedorModel extends Equatable {
  const FornecedorModel({
    required this.razaoSocial,
    this.codigo,
    this.nomeFantasia = '',
    this.cnpj = '',
    this.inscricaoEstadual = '',
    this.inscricaoMunicipal = '',
    this.endereco = '',
    this.bairro = '',
    this.cidade = '',
    this.estado,
    this.cep = '',
    this.contato = '',
    this.telefone1 = '',
    this.telefone2 = '',
    this.telefone3 = '',
    this.fax = '',
    this.email = '',
    this.email2 = '',
    this.email3 = '',
    this.inativo = false,
    this.suspensoEm,
  });

  /// `null` enquanto o fornecedor não foi salvo.
  final int? codigo;
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String inscricaoEstadual;
  final String inscricaoMunicipal;
  final String endereco;
  final String bairro;
  final String cidade;
  final UnidadeFederativa? estado;
  final String cep;
  final String contato;
  final String telefone1;
  final String telefone2;
  final String telefone3;
  final String fax;
  final String email;
  final String email2;
  final String email3;

  /// Inativo não aparece nas compras, mas continua no cadastro.
  final bool inativo;

  /// Data em que foi suspenso; `null` se não está suspenso.
  final DateTime? suspensoEm;

  bool get suspenso => suspensoEm != null;

  /// Código com 4 dígitos, como no sistema antigo (ex.: "0007").
  String get codigoFormatado => codigo == null ? '' : codigo.toString().padLeft(4, '0');

  /// "Volta Redonda/RJ", "Volta Redonda" ou "".
  String get cidadeUf => [cidade, ?estado?.sigla].where((p) => p.isNotEmpty).join('/');

  FornecedorModel copyWith({int? codigo, DateTime? suspensoEm, bool limparSuspensao = false}) {
    return FornecedorModel(
      codigo: codigo ?? this.codigo,
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      cnpj: cnpj,
      inscricaoEstadual: inscricaoEstadual,
      inscricaoMunicipal: inscricaoMunicipal,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      cep: cep,
      contato: contato,
      telefone1: telefone1,
      telefone2: telefone2,
      telefone3: telefone3,
      fax: fax,
      email: email,
      email2: email2,
      email3: email3,
      inativo: inativo,
      suspensoEm: limparSuspensao ? null : suspensoEm ?? this.suspensoEm,
    );
  }

  @override
  List<Object?> get props => [
    codigo,
    razaoSocial,
    nomeFantasia,
    cnpj,
    inscricaoEstadual,
    inscricaoMunicipal,
    endereco,
    bairro,
    cidade,
    estado,
    cep,
    contato,
    telefone1,
    telefone2,
    telefone3,
    fax,
    email,
    email2,
    email3,
    inativo,
    suspensoEm,
  ];
}
