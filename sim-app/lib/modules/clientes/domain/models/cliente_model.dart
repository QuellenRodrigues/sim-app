import 'package:core/core.dart';

import 'impostos_cliente.dart';

/// Cliente, com os mesmos campos do cadastro do SIM antigo (tabela CLIENTES, versão 2014–2017).
class ClienteModel extends Equatable {
  const ClienteModel({
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
    this.email = '',
    this.email2 = '',
    this.email3 = '',
    this.fax = '',
    this.nextel = '',
    this.nextelId = '',
    this.icms = TributacaoImposto.aParte,
    this.destinacaoIcms = DestinacaoIcms.usoConsumo,
    this.ipi = TributacaoImposto.aParte,
    this.iss = TributacaoImposto.incluso,
    this.aliquotaIss = 0,
  });

  /// `null` enquanto o cliente não foi salvo.
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
  final String email;
  final String email2;
  final String email3;
  final String fax;
  final String nextel;
  final String nextelId;

  /// Impostos usados como padrão nos orçamentos deste cliente.
  final TributacaoImposto icms;
  final DestinacaoIcms destinacaoIcms;
  final TributacaoImposto ipi;
  final TributacaoImposto iss;

  /// Alíquota do ISS como fração (0.05 = 5%).
  final double aliquotaIss;

  /// Código com 4 dígitos, como no sistema antigo (ex.: "0007").
  String get codigoFormatado => codigo == null ? '' : codigo.toString().padLeft(4, '0');

  /// "Volta Redonda/RJ", "Volta Redonda" ou "".
  String get cidadeUf => [cidade, ?estado?.sigla].where((p) => p.isNotEmpty).join('/');

  /// Alíquota de ICMS do estado do cliente; `null` sem estado ou sem alíquota cadastrada.
  double? get aliquotaIcms => AliquotaIcms.de(estado);

  ClienteModel copyWith({int? codigo}) {
    return ClienteModel(
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
      email: email,
      email2: email2,
      email3: email3,
      fax: fax,
      nextel: nextel,
      nextelId: nextelId,
      icms: icms,
      destinacaoIcms: destinacaoIcms,
      ipi: ipi,
      iss: iss,
      aliquotaIss: aliquotaIss,
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
    email,
    email2,
    email3,
    fax,
    nextel,
    nextelId,
    icms,
    destinacaoIcms,
    ipi,
    iss,
    aliquotaIss,
  ];
}
