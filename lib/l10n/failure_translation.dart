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
    'authFail_en': 'Authentication failed',
    'groupNotFound_de': 'Die Gruppe konnte nicht gefunden werden',
    'groupNotFound_en': 'The Group couldn\'t be found',
    'unknownFailure_de': 'Unbekannter Fehler',
    'unknownFailure_en': 'Unknown Failure',
    'ownGroupLoadFailed_de': 'Das Laden der eigenen Gruppe ist fehlgeschlagen',
    'ownGroupLoadFailed_en': 'loading your own group failed',
    'removeUserGroup_de': 'Fehler beim löschen des Nutzer aus der Gruppe',
    'removeUserGroup_en': 'Failure while remove user from group',
    'responseNotFound_de': 'Keine Pois für Nutzer gefunden',
    'responseNotFound_en': 'No Pois found for user',
    'responseNoAccess_de': 'Kein Zugriff auf Pois',
    'responseNoAccess_en': 'No access for Pois',
    'responseUserInvalid_de': 'Nutzer hat keine Berechtigung ',
    'responseUserInvalid_en': 'User is not valid',
    'responseFailureRegister_de': 'Fehler beim Registrieren',
    'responseFailureRegister_en': 'Failure on registration',
    'responseNoUserFound_de': 'Kein Nutzer mit dieser Id gefunden',
    'responseNoUserFound_en': 'No user found with this Id',
    'responseNoMembershipFound_de': 'Nutzer besitzt keine Gruppe',
    'responseNoMembershipFound_en': 'User dosen\'t have a membership',
    'responseNoImageAvailable_de': 'Kein Foto verfügbar',
    'responseNoImageAvailable_en': 'No Image available',
    'responseUserExistAlready_de': 'Nutzer existiert bereits',
    'responseExistAlready_en': 'User already exists',
    'responsePoiNotFound_de': 'Dieses Poi ist nicht vorhanden',
    'responsePoiNotFound_en': 'This Poi is not available',
    'responseUnknownError_de': 'Unbekannter Fehler aufgetreten',
    'responseUnknownError_en': 'Unknown Error occurred',
    'responsePoiIdInvalid_de': 'Poi existiert nicht',
    'responsePoiIdInvalid_en': 'Poi does not exist',
    'responseCategoryIDInvalid_de': 'Diese Kategorie gibt es nicht',
    'responseCategoryIDInvalid_en': 'this Category does not exist'
  };
}
