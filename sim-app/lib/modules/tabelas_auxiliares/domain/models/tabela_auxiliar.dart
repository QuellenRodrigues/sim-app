/// Listas simples do SIM antigo (código + descrição), editadas na mesma tela.
///
/// O comentário de cada valor diz de qual tabela do banco antigo ela vem.
enum TabelaAuxiliar {
  /// MAQUINA_GRUPO
  gruposMaquina(
    titulo: 'Grupos de máquina',
    descricao: 'Agrupam as operações no cadastro de máquinas e na programação da produção.',
    area: 'Fábrica',
  ),

  /// TIPO_MATERIAL
  tiposMaterial(
    titulo: 'Tipos de material',
    descricao: 'Classificam os materiais: barra, chapa, perfil, tubo, cantoneira…',
    area: 'Fábrica',
  ),

  /// NOME_QUALIDADE
  qualidadesMaterial(
    titulo: 'Qualidades de material',
    descricao: 'Aço carbono, aço inox, alumínio, bronze… usadas no controle de qualidade.',
    area: 'Fábrica',
  ),

  /// MATERIAL
  custosOrcamento(
    titulo: 'Custos adicionais',
    descricao: 'Itens cobrados à parte no orçamento: jato, tratamento térmico, frete, pintura…',
    area: 'Comercial',
  ),

  /// SERVICO
  tiposServico(
    titulo: 'Tipos de serviço',
    descricao: 'Natureza do trabalho da encomenda: serviço, usinagem ou caldeiraria.',
    area: 'Comercial',
  ),

  /// DESTINO
  destinos(
    titulo: 'Destinos',
    descricao: 'Destino do material comprado: uso próprio ou industrialização.',
    area: 'Comercial',
  ),

  /// ALMOXARIFADO_GRUPO_PRODUTO
  gruposProduto(
    titulo: 'Grupos de produto',
    descricao: 'Organizam os produtos do almoxarifado.',
    area: 'Almoxarifado',
  ),

  /// ALMOXARIFADO_TIPOS_SAIDA
  tiposSaida(
    titulo: 'Tipos de saída',
    descricao: 'Motivo da retirada de um produto do almoxarifado.',
    area: 'Almoxarifado',
  ),

  /// LIVRO_CAIXA_BANCO
  bancos(
    titulo: 'Bancos',
    descricao: 'Contas usadas nos lançamentos do livro caixa.',
    area: 'Financeiro',
  ),

  /// LIVRO_CAIXA_JUSTIFICATIVA
  justificativas(
    titulo: 'Justificativas',
    descricao: 'Classificam os lançamentos do livro caixa: despesas, tributos, transferências…',
    area: 'Financeiro',
  );

  const TabelaAuxiliar({required this.titulo, required this.descricao, required this.area});

  final String titulo;
  final String descricao;

  /// Parte do sistema que usa a tabela; agrupa as tabelas na tela.
  final String area;

  /// Tamanho máximo da descrição, igual ao do banco antigo.
  int get tamanhoMaximo => 50;
}
