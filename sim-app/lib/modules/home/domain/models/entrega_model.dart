import 'package:core/core.dart';

enum EntregaStatus {
  emProducao('Em produção'),
  aguardandoMaterial('Aguardando material'),
  pronta('Pronta'),
  atrasada('Atrasada'),
  entregue('Entregue');

  const EntregaStatus(this.descricao);

  final String descricao;
}

/// Encomenda com data de entrega na semana (ou já atrasada).
class EntregaModel extends Equatable {
  const EntregaModel({
    required this.numero,
    required this.cliente,
    required this.item,
    required this.quantidade,
    required this.dataEntrega,
    required this.status,
    required this.etapa,
    required this.progresso,
  });

  final String numero;
  final String cliente;
  final String item;
  final int quantidade;
  final DateTime dataEntrega;
  final EntregaStatus status;

  /// Etapa atual da produção (ex.: "Torneamento").
  final String etapa;

  /// Fração concluída da produção, de 0 a 1.
  final double progresso;

  bool get concluida => status == EntregaStatus.entregue;

  @override
  List<Object?> get props => [numero, cliente, item, quantidade, dataEntrega, status, etapa, progresso];
}
