import 'package:core/core.dart';

enum EntregaStatus {
  emProducao('Em produção'),
  aguardandoMaterial('Aguardando material'),
  pronta('Pronta'),
  atrasada('Atrasada');

  const EntregaStatus(this.descricao);

  final String descricao;
}

/// Encomenda com data de entrega próxima.
class EntregaModel extends Equatable {
  const EntregaModel({
    required this.numero,
    required this.cliente,
    required this.item,
    required this.quantidade,
    required this.dataEntrega,
    required this.status,
  });

  final String numero;
  final String cliente;
  final String item;
  final int quantidade;
  final DateTime dataEntrega;
  final EntregaStatus status;

  @override
  List<Object?> get props => [numero, cliente, item, quantidade, dataEntrega, status];
}
