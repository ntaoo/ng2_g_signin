// Copyright (c) 2016, ntaoo. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:ng2_g_signin/ng2_g_signin.dart';

@Component(selector: 'my-app', templateUrl: 'app_component.html', directives: const [NgIf, GoogleSignin])
class AppComponent {
  bool isSignedIn = false;
  String id;
  String name;
  String imageUrl;
  String email;

  void onGoogleSigninSuccess(GoogleSignInSuccess event) {
    GoogleUser googleUser = event.googleUser;
    String id = googleUser.getId();
    assert(googleUser.isSignedIn());
    BasicProfile profile = googleUser.getBasicProfile();
    print('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    assert(profile.getId() == id);
    print('Name: ' + profile.getName());
    print('Image URL: ' + profile.getImageUrl());
    print('Email: ' + profile.getEmail());
    AuthResponse response = googleUser.getAuthResponse();
    print('id_token: ' + response.id_token);
    print('access_token: ' + response.access_token.toString());
    print('login_hint: ' + response.login_hint);
    print('scope: ' + response.scope.toString());
    print('expires_in: ' + response.expires_in.toString());
    print('first_issued_at: ' + response.first_issued_at.toString());
    print('expires_at: ' + response.expires_at.toString());
    GoogleAuth auth = getAuthInstance();
    GoogleUser user = auth.currentUser.get();
    assert(user.hashCode == googleUser.hashCode);

    this.id = profile.getId();
    this.name = profile.getName();
    this.imageUrl = profile.getImageUrl();
    this.email = profile.getEmail();
    isSignedIn = googleUser.isSignedIn();
  }

  void signOut() {
    getAuthInstance().signOut();
    isSignedIn = false;
  }
}
