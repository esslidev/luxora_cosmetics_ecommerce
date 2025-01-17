/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../locator.dart';
import 'localization_service.dart';
import 'network_util.dart';

class AuthUtil {
  static final LocalizationService _localizationService =
      locator<LocalizationService>();

  static Future<UserCredential?> signInWithGoogle() async {
    await NetworkUtil.checkConnectivity();

    try {
      if (kIsWeb) {
        // Web specific code
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // Trigger the authentication flow
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
        print('User signed in: ${userCredential.user!.toString()}');
        return userCredential;
      } else {
        // Mobile specific code
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'google-sign-in-error',
            message: _localizationService
                .translate('global.errors.googleSignInError.message'),
          );
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      // Handle specific exceptions if needed
      print('Error signing in with Google: $e');
      return null;
    }
  }

  static Future<UserCredential?> signInWithFacebook() async {
    await NetworkUtil.checkConnectivity();

    try {
      if (kIsWeb) {
        // Create a new provider
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();

        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
      } else {
        // Trigger the sign-in flow
        final LoginResult loginResult = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        // Once signed in, return the UserCredential
        return FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
      return null;
    }
  }

  static Future<UserCredential?> signInWithTwitter() async {
    await NetworkUtil.checkConnectivity();

    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'smKoVBF5fwn9f8nykbvkFp4Xm',
        apiSecretKey: 'CmtYp6C1TLhhA3SEjOEa9vqIlb14TqThahTh5OTAIXH0ZpPAaa',
        redirectURI:
            'https://verdant-lifestyle.firebaseapp.com/__/auth/handler',
      );

      final authResult = await twitterLogin.login();
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Twitter: $e');
      return null;
    }
  }

  /* static Future<UserCredential> signInWithMicrosoft() async {
    await NetworkUtil.checkConnectivity();

    try {
      final clientId = 'YOUR_MICROSOFT_CLIENT_ID';
      final redirectUri = 'YOUR_REDIRECT_URI';
      final scope = 'openid profile email';

      final result = await FlutterWebAuth.authenticate(
        url: 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize'
            '?client_id=$clientId'
            '&response_type=code'
            '&redirect_uri=$redirectUri'
            '&response_mode=query'
            '&scope=$scope',
        callbackUrlScheme: 'your.callback.scheme',
      );

      final code = Uri.parse(result).queryParameters['code'];

      final response = await http.post(
        Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
          'code': code,
          'scope': scope,
          'client_secret': 'YOUR_MICROSOFT_CLIENT_SECRET',
        },
      );

      final json = jsonDecode(response.body);
      final accessToken = json['access_token'];

      final credential = OAuthProvider('microsoft.com').credential(
        accessToken: accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Microsoft: $e');
      throw FirebaseAuthException(
        code: 'auth-error',
        message:
            _localizationService.translate('errors.connectivityError.message'),
      );
    }
  }*/

  static Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}*/
