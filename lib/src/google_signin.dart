import 'dart:async';

import 'package:angular/angular.dart';
import 'package:js/js.dart';

import 'events.dart';
import 'google_signin_js/gapi.dart';
import 'google_signin_js/gapi/auth2.dart' as auth2;
import 'google_signin_js/gapi/signin2.dart';

class ClientIdNotFoundError extends StateError {
  ClientIdNotFoundError(String message) : super(message);
}

@Component(
    selector: 'google-signin', template: '<div [id]="id"></div>', changeDetection: ChangeDetectionStrategy.OnPush)
class GoogleSignin implements AfterViewInit {
  final String id = 'google-signin2';

  // Render options
  @Input()
  String scope;

  String get width => _width.toString();

  @Input()
  void set width(String s) {
    _width = s == null ? null : int.parse(s);
  }

  int _width;

  String get height => _height.toString();

  @Input()
  void set height(String s) {
    _width = s == null ? null : int.parse(s);
  }

  int _height;

  String get longTitle => _longTitle.toString();

  @Input()
  void set longTitle(String s) {
    _longTitle = _nullableParseBool(s);
  }

  bool _longTitle;

  @Input()
  String theme;

  // Init params
  @Input()
  String clientId;
  @Input()
  String cookiePolicy;

  String get fetchBasicProfile => _fetchBasicProfile.toString();

  @Input()
  void set fetchBasicProfile(String s) {
    _fetchBasicProfile = _nullableParseBool(s);
  }

  bool _fetchBasicProfile;

  @Input()
  String hostedDomain;
  @Input()
  String openidRealm;

  StreamController _googleSigninSuccessController = StreamController<GoogleSignInSuccess>();
  StreamController _googleSignInFailureController = StreamController<GoogleSignInFailure>();

  @Output()
  Stream<GoogleSignInSuccess> googleSigninSuccess;

  @Output()
  Stream<GoogleSignInFailure> googleSignInFailure;

  GoogleSignin(){
    googleSigninSuccess = _googleSigninSuccessController.stream;
    googleSignInFailure = _googleSignInFailureController.stream;
  }

  ngAfterViewInit() {
    _auth2Init();
    _renderButton();
  }

  _auth2Init() {
    if (clientId == null)
      throw new ClientIdNotFoundError(
          'clientId property is necessary. (<google-signin clientId="..."></google-signin>)');

    load('auth2', allowInterop(() {
      auth2.init(new auth2.Params(
          client_id: clientId,
          cookie_policy: cookiePolicy,
          fetch_basic_profile: _fetchBasicProfile,
          hosted_domain: hostedDomain,
          openid_realm: openidRealm));
    }));
  }

  void _handleFailure() {
    _googleSignInFailureController.add(new GoogleSignInFailure());
  }

  void _handleSuccess(auth2.GoogleUser googleUser) {
    _googleSigninSuccessController.add(new GoogleSignInSuccess(googleUser));
  }

  bool _nullableParseBool(String boolString) {
    if (boolString == 'true') return true;
    if (boolString == 'false') return false;
    if (boolString == null) return null;
    throw new ArgumentError('Only true, false, and null are valid.');
  }

  _renderButton() {
    render(
        id,
        new Options(
            scope: scope,
            width: _width,
            height: _height,
            longtitle: _longTitle,
            theme: theme,
            onsuccess: allowInterop((auth2.GoogleUser googleUser) => _handleSuccess(googleUser)),
            onfailure: allowInterop(() => _handleFailure())));
  }
}
