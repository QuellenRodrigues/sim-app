import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/domain.dart';
import 'materiais_state.dart';

class MateriaisViewModel extends ViewModel<MateriaisState> {
  MateriaisViewModel(this._repository) : super(MateriaisState.initial());

  final MateriaisRepository _repository;
  Timer? _debounce;

  final descricaoController = TextEditingController();

  @override
  void initViewModel() {
    super.initViewModel();
    carregarGrupos();
    carregar();
  }

  Future<void> carregar() async {
    emit(state.copyWith(isLoading: true, limparErroLista: true));
    final result = await _repository.listar(busca: state.busca);
    final newState = result.fold(
      (erro) => state.copyWith(erroLista: erro.message),
      (materiais) => state.copyWith(materiais: materiais),
    );
    emit(newState.copyWith(isLoading: false));
  }

  Future<void> carregarGrupos() async {
    final result = await _repository.listarGrupos();
    result.fold(
      (erro) => emit(state.copyWith(aviso: MateriaisAviso(erro.message, sucesso: false))),
      (grupos) => emit(state.copyWith(grupos: grupos)),
    );
  }

  /// Filtra a lista enquanto a pessoa digita.
  void buscar(String texto, {Duration espera = const Duration(milliseconds: 300)}) {
    _debounce?.cancel();
    _debounce = Timer(espera, () {
      emit(state.copyWith(busca: texto));
      carregar();
    });
  }

  void selecionar(MaterialModel material) {
    descricaoController.text = material.descricao;
    emit(
      state.copyWith(
        modo: MateriaisModo.edicao,
        selecionado: material,
        grupo: material.grupo,
        medidas: material.medidas,
        colunaBitola: material.colunaBitola,
        limparColunaBitola: material.colunaBitola == null,
        valorZero: material.valorZero,
        descricaoEmBranco: material.descricaoEmBranco,
        exibirNoSubitem: material.exibirNoSubitem,
        tabela: const TabelaBitolasModel(),
        buscaTabela: '',
      ),
    );
    carregarTabela();
  }

  /// Limpa o formulário para cadastrar um material.
  void novo() => _limpar(MateriaisModo.novo);

  /// Fecha o formulário sem salvar.
  void fechar() => _limpar(MateriaisModo.nenhum);

  void alterarAba(MaterialAba aba) => emit(state.copyWith(aba: aba));

  void alterarGrupo(GrupoMaterialModel? grupo) =>
      emit(state.copyWith(grupo: grupo, limparGrupo: grupo == null));

  void alterarMedida(MedidaOrcamento medida, {required bool pedir}) {
    emit(state.copyWith(medidas: pedir ? {...state.medidas, medida} : ({...state.medidas}..remove(medida))));
  }

  void alterarColunaBitola(int? coluna) {
    emit(state.copyWith(colunaBitola: coluna, limparColunaBitola: coluna == null));
  }

  void alterarValorZero(bool valor) => emit(state.copyWith(valorZero: valor));

  void alterarDescricaoEmBranco(bool valor) => emit(state.copyWith(descricaoEmBranco: valor));

  void alterarExibirNoSubitem(bool valor) => emit(state.copyWith(exibirNoSubitem: valor));

  Future<void> salvar() async {
    final grupo = state.grupo;
    if (state.salvando || grupo == null) return;
    emit(state.copyWith(salvando: true));

    final edicao = state.modo == MateriaisModo.edicao;
    final result = await _repository.salvar(
      MaterialModel(
        codigo: edicao ? state.selecionado?.codigo : null,
        grupo: grupo,
        descricao: descricaoController.text.trim(),
        medidas: state.medidas,
        colunaBitola: state.colunaBitola,
        valorZero: state.valorZero,
        descricaoEmBranco: state.descricaoEmBranco,
        exibirNoSubitem: state.exibirNoSubitem,
      ),
    );

    result.fold(
      (erro) => emit(state.copyWith(salvando: false, aviso: MateriaisAviso(erro.message, sucesso: false))),
      (salvo) {
        emit(
          state.copyWith(
            salvando: false,
            aviso: MateriaisAviso('Material salvo com sucesso!', sucesso: true),
          ),
        );
        if (edicao) {
          // Mantém a aba e a tabela já carregadas.
          emit(state.copyWith(selecionado: salvo));
        } else {
          selecionar(salvo);
        }
      },
    );
    await carregar();
  }

  Future<void> excluir() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) {
      fechar();
      return;
    }

    final result = await _repository.excluir(codigo);
    result.fold(
      (erro) => emit(state.copyWith(aviso: MateriaisAviso(erro.message, sucesso: false))),
      (_) {
        fechar();
        emit(state.copyWith(aviso: MateriaisAviso('Material excluído com sucesso!', sucesso: true)));
      },
    );
    await carregar();
  }

  Future<void> carregarTabela() async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return;

    emit(state.copyWith(carregandoTabela: true, limparErroTabela: true));
    final result = await _repository.carregarTabela(codigo);

    // A pessoa pode ter aberto outro material enquanto carregava.
    if (state.selecionado?.codigo != codigo) return;
    final newState = result.fold(
      (erro) => state.copyWith(erroTabela: erro.message),
      (tabela) => state.copyWith(tabela: tabela),
    );
    emit(newState.copyWith(carregandoTabela: false));
  }

  void buscarNaTabela(String texto) => emit(state.copyWith(buscaTabela: texto));

  /// Salva nome, unidade e colunas. Retorna `true` se salvou (para o diálogo fechar).
  Future<bool> salvarEstrutura({
    required String nome,
    required UnidadeTabela unidade,
    required List<ColunaEdicao> colunas,
  }) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return false;

    final result = await _repository.salvarEstrutura(codigo, nome: nome, unidade: unidade, colunas: colunas);
    final salvou = _aplicarTabela(result, 'Colunas salvas com sucesso!');
    if (salvou) {
      // A coluna da bitola acompanha a coluna, como no material salvo.
      final coluna = ColunaEdicao.remapear(state.colunaBitola, colunas);
      emit(state.copyWith(colunaBitola: coluna, limparColunaBitola: coluna == null));
      await carregar();
    }
    return salvou;
  }

  /// Inclui ou altera uma linha. Retorna `true` se salvou (para o diálogo fechar).
  Future<bool> salvarLinha(LinhaBitolaModel linha) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null) return false;

    final salvou = _aplicarTabela(await _repository.salvarLinha(codigo, linha), 'Linha salva com sucesso!');
    if (salvou) await carregar();
    return salvou;
  }

  Future<void> excluirLinha(LinhaBitolaModel linha) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null || linha.codigo == null) return;

    _aplicarTabela(await _repository.excluirLinha(codigo, linha.codigo!), 'Linha excluída com sucesso!');
    await carregar();
  }

  Future<void> moverLinha(LinhaBitolaModel linha, int deslocamento) async {
    final codigo = state.selecionado?.codigo;
    if (codigo == null || linha.codigo == null) return;

    _aplicarTabela(await _repository.moverLinha(codigo, linha.codigo!, deslocamento), null);
  }

  bool _aplicarTabela(Either<BaseException, TabelaBitolasModel> result, String? mensagem) {
    return result.fold(
      (erro) {
        emit(state.copyWith(aviso: MateriaisAviso(erro.message, sucesso: false)));
        return false;
      },
      (tabela) {
        emit(
          state.copyWith(
            tabela: tabela,
            aviso: mensagem == null ? null : MateriaisAviso(mensagem, sucesso: true),
          ),
        );
        return true;
      },
    );
  }

  void _limpar(MateriaisModo modo) {
    descricaoController.clear();
    const padrao = MaterialModel(grupo: GrupoMaterialModel(codigo: 0, nome: ''));
    emit(
      state.copyWith(
        modo: modo,
        limparSelecionado: true,
        aba: MaterialAba.dados,
        limparGrupo: true,
        medidas: padrao.medidas,
        limparColunaBitola: true,
        valorZero: padrao.valorZero,
        descricaoEmBranco: padrao.descricaoEmBranco,
        exibirNoSubitem: padrao.exibirNoSubitem,
        tabela: const TabelaBitolasModel(),
        carregandoTabela: false,
        limparErroTabela: true,
        buscaTabela: '',
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    descricaoController.dispose();
    super.dispose();
  }
}
