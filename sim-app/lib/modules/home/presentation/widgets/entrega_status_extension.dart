import 'package:core/core.dart';

import '../../domain/domain.dart';

extension EntregaStatusX on EntregaStatus {
  SimStatusType get statusType => switch (this) {
    EntregaStatus.pronta => SimStatusType.sucesso,
    EntregaStatus.emProducao => SimStatusType.info,
    EntregaStatus.aguardandoMaterial => SimStatusType.alerta,
    EntregaStatus.atrasada => SimStatusType.erro,
  };
}
