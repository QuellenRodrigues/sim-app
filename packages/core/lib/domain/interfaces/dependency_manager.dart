///
/// Utility class to manage dependencies
///
// ignore: one_member_abstracts
abstract class DependencyManager {
  ///
  /// Get an instance of type T from the DM
  ///
  T get<T extends Object>();

  /// Disposes an object of type T from the DM
  bool dispose<T extends Object>();

  /// Request an instance by [Type]
  /// <br>
  /// Return null if not found instance
  B? tryGet<B extends Object>({String? key});
}
