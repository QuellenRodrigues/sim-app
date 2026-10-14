import 'package:flutter/material.dart';

/// Destinos do menu lateral, na ordem em que aparecem.
///
/// [disponivel] indica se o módulo já foi migrado do sistema antigo.
enum MenuRoutesEnum {
  inicio(
    name: 'Início',
    route: '/menu/inicio/',
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard,
    disponivel: true,
  ),
  orcamentos(
    name: 'Orçamentos',
    route: '/menu/orcamentos/',
    icon: Icons.request_quote_outlined,
    selectedIcon: Icons.request_quote,
  ),
  encomendas(
    name: 'Encomendas',
    route: '/menu/encomendas/',
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
  ),
  programacao(
    name: 'Programação',
    route: '/menu/programacao/',
    icon: Icons.view_timeline_outlined,
    selectedIcon: Icons.view_timeline,
  ),
  compras(
    name: 'Compras',
    route: '/menu/compras/',
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
  ),
  almoxarifado(
    name: 'Almoxarifado',
    route: '/menu/almoxarifado/',
    icon: Icons.warehouse_outlined,
    selectedIcon: Icons.warehouse,
  ),
  qualidade(
    name: 'Qualidade',
    route: '/menu/qualidade/',
    icon: Icons.verified_outlined,
    selectedIcon: Icons.verified,
  ),
  cadastros(
    name: 'Cadastros',
    route: '/menu/cadastros/',
    icon: Icons.folder_shared_outlined,
    selectedIcon: Icons.folder_shared,
  ),
  relatorios(
    name: 'Relatórios',
    route: '/menu/relatorios/',
    icon: Icons.insert_chart_outlined,
    selectedIcon: Icons.insert_chart,
  );

  const MenuRoutesEnum({
    required this.name,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    this.disponivel = false,
  });

  final String name;
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final bool disponivel;
}
