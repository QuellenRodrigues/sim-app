import 'package:core/core.dart';

/// Como um imposto entra no preço do orçamento do cliente
/// (colunas ICMS_1, IPI e ISS_1 do SIM antigo).
enum TributacaoImposto {
  aParte('A', 'À parte'),
  incluso('I', 'Incluso'),
  naoIncidente('N', 'Não incidente');

  const TributacaoImposto(this.codigo, this.descricao);

  /// Letra gravada no banco do SIM antigo.
  final String codigo;
  final String descricao;
}

/// Destinação do material para o ICMS (coluna ICMS_2 do SIM antigo).
enum DestinacaoIcms {
  usoConsumo('U', 'Uso e consumo'),
  industrializacao('I', 'Industrialização');

  const DestinacaoIcms(this.codigo, this.descricao);

  /// Letra gravada no banco do SIM antigo.
  final String codigo;
  final String descricao;
}

/// Alíquota de ICMS por estado, da tabela ICMS_ESTADO do SIM antigo.
///
/// No sistema antigo ela não era digitada no cliente: vinha do estado.
/// Fica aqui até existir uma API de configurações.
abstract final class AliquotaIcms {
  static const _porEstado = {
    UnidadeFederativa.ba: 0.07,
    UnidadeFederativa.es: 0.07,
    UnidadeFederativa.se: 0.07,
    UnidadeFederativa.rj: 0.19,
    UnidadeFederativa.to: null,
  };

  static const _padrao = 0.12;

  /// `null` quando o estado não tem alíquota cadastrada.
  static double? de(UnidadeFederativa? estado) {
    if (estado == null) return null;
    return _porEstado.containsKey(estado) ? _porEstado[estado] : _padrao;
  }
}
