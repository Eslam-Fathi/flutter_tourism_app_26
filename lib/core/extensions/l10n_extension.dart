import 'package:flutter/widgets.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';

/// Extension on [BuildContext] to provide easy access to localizations.
///
/// This allows using `context.l10n.someKey` instead of 
/// `AppLocalizations.of(context)!.someKey`.
extension L10nExtension on BuildContext {
  /// Returns the [AppLocalizations] instance for the current context.
  /// 
  /// Throws if [AppLocalizations] is not found in the widget tree.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
