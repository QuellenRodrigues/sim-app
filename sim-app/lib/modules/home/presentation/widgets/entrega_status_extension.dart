import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

extension EntregaStatusX on EntregaStatus {
  SimStatusType get statusType => switch (this) {
    EntregaStatus.pronta => SimStatusType.sucesso,
    EntregaStatus.emProducao => SimStatusType.info,
    EntregaStatus.aguardandoMaterial => SimStatusType.alerta,
    EntregaStatus.atrasada => SimStatusType.erro,
    EntregaStatus.entregue => SimStatusType.neutro,
  };

  /// Cor sólida do status (barras de progresso, legenda).
  Color get cor => switch (this) {
    EntregaStatus.pronta => SimTokens.colorSuccess500,
    EntregaStatus.emProducao => SimTokens.colorInfo500,
    EntregaStatus.aguardandoMaterial => SimTokens.colorWarning500,
    EntregaStatus.atrasada => SimTokens.colorError500,
    EntregaStatus.entregue => SimTokens.colorNeutral300,
  };
}
