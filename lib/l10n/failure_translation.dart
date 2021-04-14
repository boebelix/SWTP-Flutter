import 'package:intl/intl.dart';

/// Da der BuildContext in Flutter in den Restschnittstellen nicht verfügbar
/// ist, ist dieser Umweg erforderlich
class FailureTranslation {
  /// Hier kann der Name des Fehlers eingetragen, werden und es wird ein
  /// String mit der richtigen Übersetzung zurückgegeben. Bei dem Eingabe-
  /// paramter ist nur der Teilstring notwendig bis zum Unterstich. Beispiel
  /// ``noConnection_de`` wird aufgerufen mit ``noConnection``
  static String text(String failureName) {
    return _translation['${failureName}_${Intl.defaultLocale}'];
  }

  /// Hier werden alle nötigen Fehler eingetragen
  static var _translation = {
    'noConnection_de': 'Keine Verbindung zum Server 😑',
    'noConnection_en': 'No connection to server 😑',
    'httpRestFailed_de': 'Fehler bei der Verbindung 😱',
    'httpRestFailed_en': 'Couldn\'t find the post 😱',
    'parseFailure_de': 'Fehler beim Umwandeln des Pakets 👎',
    'parseFailure_en': 'Bad response format 👎',
    'authFail_de': 'Fehler beim Anmelden',
    'authFail_en': 'Authentification failed',
    'groupNotFound_de': 'Die Gruppe konnte nicht gefunden werden',
    'groupNotFound_en': 'The Group could\'t found',
    'unknownFailure_de': 'Unbekannter Fehler',
    'unknownFailure_en': 'Unknown Failure',
    'removeUserGroup_de': 'Fehler beim löschen des Nutzer aus der Gruppe',
    'removeUserGroup_en': 'Failure while remove user from group',
  };
}
