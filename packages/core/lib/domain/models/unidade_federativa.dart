/// Estados brasileiros (e o Distrito Federal).
enum UnidadeFederativa {
  ac('AC', 'Acre'),
  al('AL', 'Alagoas'),
  ap('AP', 'Amapá'),
  am('AM', 'Amazonas'),
  ba('BA', 'Bahia'),
  ce('CE', 'Ceará'),
  df('DF', 'Distrito Federal'),
  es('ES', 'Espírito Santo'),
  go('GO', 'Goiás'),
  ma('MA', 'Maranhão'),
  mt('MT', 'Mato Grosso'),
  ms('MS', 'Mato Grosso do Sul'),
  mg('MG', 'Minas Gerais'),
  pa('PA', 'Pará'),
  pb('PB', 'Paraíba'),
  pr('PR', 'Paraná'),
  pe('PE', 'Pernambuco'),
  pi('PI', 'Piauí'),
  rj('RJ', 'Rio de Janeiro'),
  rn('RN', 'Rio Grande do Norte'),
  rs('RS', 'Rio Grande do Sul'),
  ro('RO', 'Rondônia'),
  rr('RR', 'Roraima'),
  sc('SC', 'Santa Catarina'),
  sp('SP', 'São Paulo'),
  se('SE', 'Sergipe'),
  to('TO', 'Tocantins');

  const UnidadeFederativa(this.sigla, this.nome);

  final String sigla;
  final String nome;

  /// Busca pela sigla ("RJ") ou pelo nome ("Rio de Janeiro"), sem diferenciar maiúsculas.
  static UnidadeFederativa? de(String? valor) {
    if (valor == null) return null;
    final texto = valor.trim().toLowerCase();
    for (final uf in values) {
      if (uf.sigla.toLowerCase() == texto || uf.nome.toLowerCase() == texto) return uf;
    }
    return null;
  }
}
