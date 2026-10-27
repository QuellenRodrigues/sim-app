import '../../domain/domain.dart';
import 'home_datasource.dart';

/// Dados de exemplo enquanto o SIM não tem API.
///
/// As datas são relativas a hoje para a home sempre parecer atual.
class HomeDatasourceMock implements HomeDatasource {
  @override
  Future<HomePainelModel> carregarPainel() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final hoje = DateTime.now();
    DateTime dia(int deslocamento) => DateTime(hoje.year, hoje.month, hoje.day + deslocamento);

    EntregaModel entregue(String numero, String cliente, String item, int quantidade, int dias) =>
        EntregaModel(
          numero: numero,
          cliente: cliente,
          item: item,
          quantidade: quantidade,
          dataEntrega: dia(dias),
          status: EntregaStatus.entregue,
          etapa: 'Expedida',
          progresso: 1,
        );

    return HomePainelModel(
      resumo: const HomeResumoModel(
        orcamentosEmAberto: 14,
        valorOrcamentosEmAberto: 186450,
        orcamentosNovosNaSemana: 3,
        tendenciaOrcamentos: [8, 9, 7, 12, 11, 14, 13, 16, 17],
        encomendasEmProducao: 23,
        ordensProducaoAbertas: 31,
        tendenciaProducao: [18, 17, 20, 19, 22, 21, 23, 22, 23],
        encomendasAtrasadas: 2,
        diasAtrasoMaisAntiga: 2,
        tendenciaAtrasos: [0, 0, 1, 0, 0, 2, 1, 2, 2],
      ),
      entregas: [
        EntregaModel(
          numero: '2026/0412',
          cliente: 'Usinagem Rio Claro',
          item: 'Flange Ø200 aço 1045',
          quantidade: 36,
          dataEntrega: dia(-2),
          status: EntregaStatus.atrasada,
          etapa: 'Retífica',
          progresso: 0.85,
        ),
        entregue('2026/0419', 'Indústria Serra Azul', 'Tampa de mancal', 80, -2),
        entregue('2026/0416', 'Metalúrgica Vale Verde', 'Polia em V', 24, -1),
        entregue('2026/0420', 'Ferramentaria Alvorada', 'Porta-ferramenta', 12, -1),
        EntregaModel(
          numero: '2026/0418',
          cliente: 'Metalúrgica Vale Verde',
          item: 'Eixo de transmissão',
          quantidade: 120,
          dataEntrega: dia(0),
          status: EntregaStatus.pronta,
          etapa: 'Inspeção final',
          progresso: 1,
        ),
        entregue('2026/0422', 'Usinagem Rio Claro', 'Luva de acoplamento', 60, 0),
        EntregaModel(
          numero: '2026/0421',
          cliente: 'Ferramentaria Alvorada',
          item: 'Bucha de bronze SAE 65',
          quantidade: 2400,
          dataEntrega: dia(1),
          status: EntregaStatus.emProducao,
          etapa: 'Torneamento',
          progresso: 0.6,
        ),
        EntregaModel(
          numero: '2026/0423',
          cliente: 'Indústria Serra Azul',
          item: 'Suporte usinado',
          quantidade: 150,
          dataEntrega: dia(2),
          status: EntregaStatus.emProducao,
          etapa: 'Fresamento',
          progresso: 0.35,
        ),
        EntregaModel(
          numero: '2026/0425',
          cliente: 'Indústria Serra Azul',
          item: 'Engrenagem helicoidal m3',
          quantidade: 48,
          dataEntrega: dia(3),
          status: EntregaStatus.aguardandoMaterial,
          etapa: 'Aguardando aço SAE 4140',
          progresso: 0,
        ),
        EntregaModel(
          numero: '2026/0427',
          cliente: 'Metalúrgica Vale Verde',
          item: 'Pino guia retificado',
          quantidade: 600,
          dataEntrega: dia(5),
          status: EntregaStatus.emProducao,
          etapa: 'Corte',
          progresso: 0.1,
        ),
      ],
      maquinas: const [
        MaquinaModel(
          nome: 'Torno CNC 01',
          situacao: SituacaoMaquina.operando,
          ocupacao: 0.92,
          ordemProducao: '2026/0421',
        ),
        MaquinaModel(
          nome: 'Torno CNC 02',
          situacao: SituacaoMaquina.operando,
          ocupacao: 0.64,
          ordemProducao: '2026/0427',
        ),
        MaquinaModel(
          nome: 'Centro de usinagem',
          situacao: SituacaoMaquina.operando,
          ocupacao: 1.12,
          ordemProducao: '2026/0423',
        ),
        MaquinaModel(
          nome: 'Fresadora ferramenteira',
          situacao: SituacaoMaquina.setup,
          ocupacao: 0.41,
          ordemProducao: '2026/0427',
        ),
        MaquinaModel(
          nome: 'Retífica cilíndrica',
          situacao: SituacaoMaquina.operando,
          ocupacao: 0.78,
          ordemProducao: '2026/0412',
        ),
        MaquinaModel(nome: 'Serra de fita', situacao: SituacaoMaquina.parada, ocupacao: 0),
      ],
      alertas: const [
        AlertaModel(
          tipo: TipoAlerta.atraso,
          titulo: 'Encomenda 2026/0412 atrasada',
          descricao: 'Usinagem Rio Claro · 2 dias de atraso',
          acao: 'Renegociar data',
        ),
        AlertaModel(
          tipo: TipoAlerta.sobrecarga,
          titulo: 'Centro de usinagem em sobrecarga',
          descricao: '112% da capacidade programada hoje',
          acao: 'Reprogramar operações',
        ),
        AlertaModel(
          tipo: TipoAlerta.materialPendente,
          titulo: 'Material pendente na 2026/0425',
          descricao: 'Aço SAE 4140 Ø80 sem pedido de compra',
          acao: 'Criar pedido de compra',
        ),
      ],
    );
  }
}
