import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/calendar/v3.dart' as calendar;

import 'google_api_client.dart';

class GoogleAuthController extends ChangeNotifier {
  static const scopes = <String>[
    drive.DriveApi.driveMetadataReadonlyScope,
    sheets.SheetsApi.spreadsheetsReadonlyScope,
    calendar.CalendarApi.calendarEventsScope,
  ];

  GoogleSignInAccount? account;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _subscription;
  bool initialized = false;
  bool pluginReady = false;
  String? error;

  bool get signedIn => account != null;

  bool get platformSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  Future<void> initialize(String webClientId) async {
    if (initialized) return;
    initialized = true;
    if (!platformSupported) {
      error = 'google_sign_in_platform_unsupported';
      notifyListeners();
      return;
    }
    if (kIsWeb && webClientId.trim().isEmpty) {
      error = 'google_drive_not_configured';
      notifyListeners();
      return;
    }
    final signIn = GoogleSignIn.instance;
    _subscription ??= signIn.authenticationEvents.listen(
      (event) {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            account = event.user;
            error = null;
          case GoogleSignInAuthenticationEventSignOut():
            account = null;
        }
        notifyListeners();
      },
      onError: (Object value) {
        error = value.toString();
        notifyListeners();
      },
    );
    try {
      await signIn.initialize(clientId: kIsWeb ? webClientId.trim() : null);
      pluginReady = true;
      error = null;
    } on Object catch (value) {
      error = value.toString();
    }
    notifyListeners();
  }

  Future<void> signIn() async {
    if (!pluginReady) return;
    try {
      await GoogleSignIn.instance.authenticate();
    } on Object catch (value) {
      error = value.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    account = null;
    notifyListeners();
  }

  Future<GoogleApiClient> authorizedClient() async {
    final current = account;
    if (current == null) throw StateError('google_sign_in_required');
    final headers = await current.authorizationClient.authorizationHeaders(
      scopes,
      promptIfNecessary: true,
    );
    if (headers == null) throw StateError('google_authorization_required');
    return GoogleApiClient(headers);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
