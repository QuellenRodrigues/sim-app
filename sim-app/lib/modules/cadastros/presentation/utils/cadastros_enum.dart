import 'package:flutter/material.dart';

/// Cadastros do SIM, na ordem em que aparecem na página de Cadastros.
///
/// [rota] é `null` enquanto o cadastro não foi migrado do sistema antigo.
enum CadastrosEnum {
  clientes(
    nome: 'Clientes',
    descricao: 'Empresas atendidas, contatos e impostos padrão dos orçamentos.',
    icone: Icons.groups_outlined,
    grupo: 'Comercial',
    rota: '/menu/cadastros/clientes/',
  ),
  fornecedores(
    nome: 'Fornecedores',
    descricao: 'Fornecedores de material e serviço, e o que cada um fornece.',
    icone: Icons.local_shipping_outlined,
    grupo: 'Comercial',
  ),
  maquinas(
    nome: 'Máquinas e operações',
    descricao: 'Operações, valor da hora, equipamentos e horários de trabalho.',
    icone: Icons.precision_manufacturing_outlined,
    grupo: 'Fábrica',
  ),
  operadores(
    nome: 'Operadores',
    descricao: 'Quem opera as máquinas na programação da produção.',
    icone: Icons.engineering_outlined,
    grupo: 'Fábrica',
  ),
  materiais(
    nome: 'Materiais e tabelas de valores',
    descricao: 'Barras, chapas, perfis e tubos com medidas, peso e preço.',
    icone: Icons.view_in_ar_outlined,
    grupo: 'Fábrica',
  ),
  tabelasAuxiliares(
    nome: 'Tabelas auxiliares',
    descricao: 'Grupos de máquina, tipos de material, destinos e outras listas.',
    icone: Icons.list_alt_outlined,
    grupo: 'Fábrica',
    rota: '/menu/cadastros/tabelas/',
  ),
  unidades(
    nome: 'Empresas',
    descricao: 'Dados e logotipo que saem nos orçamentos e relatórios.',
    icone: Icons.apartment_outlined,
    grupo: 'Administração',
  ),
  icms(
    nome: 'ICMS por estado',
    descricao: 'Alíquota usada nos orçamentos conforme o estado do cliente.',
    icone: Icons.percent,
    grupo: 'Administração',
  ),
  usuarios(
    nome: 'Usuários e permissões',
    descricao: 'Quem acessa o SIM e o que cada pessoa pode fazer.',
    icone: Icons.admin_panel_settings_outlined,
    grupo: 'Administração',
  );

  const CadastrosEnum({
    required this.nome,
    required this.descricao,
    required this.icone,
    required this.grupo,
    this.rota,
  });

  final String nome;
  final String descricao;
  final IconData icone;
  final String grupo;
  final String? rota;

  bool get disponivel => rota != null;
}
