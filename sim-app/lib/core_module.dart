import 'package:core/core.dart';

/// Binds globais do app (HTTP, storage, sessão…).
///
/// Ainda vazio: o SIM não consome API. Quando houver backend, registre aqui o
/// `IHttpClient` e demais adapters compartilhados, como no Smart.
class CoreModule extends Module {
  @override
  void exportedBinds(i) {}
}
