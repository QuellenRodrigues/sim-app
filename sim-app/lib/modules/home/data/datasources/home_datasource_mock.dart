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

    return HomePainelModel(
      resumo: const HomeResumoModel(
        orcamentosEmAberto: 14,
        valorOrcamentosEmAberto: 186450,
        encomendasEmProducao: 23,
        entregasNaSemana: 9,
        encomendasAtrasadas: 2,
      ),
      proximasEntregas: [
        EntregaModel(
          numero: '2026/0412',
          cliente: 'Usinagem Rio Claro',
          item: 'Flange Ø200 aço 1045',
          quantidade: 36,
          dataEntrega: dia(-2),
          status: EntregaStatus.atrasada,
        ),
        EntregaModel(
          numero: '2026/0418',
          cliente: 'Metalúrgica Vale Verde',
          item: 'Eixo de transmissão',
          quantidade: 120,
          dataEntrega: dia(0),
          status: EntregaStatus.pronta,
        ),
        EntregaModel(
          numero: '2026/0421',
          cliente: 'Ferramentaria Alvorada',
          item: 'Bucha de bronze SAE 65',
          quantidade: 2400,
          dataEntrega: dia(1),
          status: EntregaStatus.emProducao,
        ),
        EntregaModel(
          numero: '2026/0425',
          cliente: 'Indústria Serra Azul',
          item: 'Engrenagem helicoidal m3',
          quantidade: 48,
          dataEntrega: dia(3),
          status: EntregaStatus.aguardandoMaterial,
        ),
        EntregaModel(
          numero: '2026/0427',
          cliente: 'Metalúrgica Vale Verde',
          item: 'Pino guia retificado',
          quantidade: 600,
          dataEntrega: dia(5),
          status: EntregaStatus.emProducao,
        ),
      ],
      cargaMaquinas: const [
        CargaMaquinaModel(maquina: 'Torno CNC 01', ocupacao: 0.92),
        CargaMaquinaModel(maquina: 'Torno CNC 02', ocupacao: 0.64),
        CargaMaquinaModel(maquina: 'Centro de usinagem', ocupacao: 1.12),
        CargaMaquinaModel(maquina: 'Fresadora ferramenteira', ocupacao: 0.41),
        CargaMaquinaModel(maquina: 'Retífica cilíndrica', ocupacao: 0.78),
      ],
    );
  }
}
