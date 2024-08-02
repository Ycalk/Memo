
import 'dart:io';

import 'package:memo_mind/config/secret.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnon() => _auth.signInAnonymously().then((value) => value.user);

  Future<User?> signInWithGoogle() async {
    late AuthCredential credential;
    if (Platform.isMacOS||Platform.isWindows||Platform.isLinux){
      final authManage = AuthManager();
      final auth = await authManage.login();
      credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    } else {
      final googleAccount = await GoogleSignIn().signIn();
      final googleAuth = await googleAccount?.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    }
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> signOut() async => await _auth.signOut();
}



class AuthManager{
  static const String googleAuthApi= "https://accounts.google.com/o/oauth2/v2/auth";
  static const String googleTokenApi= "https://oauth2.googleapis.com/token";
  static const String redirectUrl= 'http://localhost:';
  HttpServer? redirectServer;

  Future<oauth2.Client> _getOauthClient(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      SecretData.googleClientId,
      Uri.parse(googleAuthApi),
      Uri.parse(googleTokenApi),
      httpClient: _JsonAcceptingHttpClient(), 
      secret: SecretData.authClientSecret
    );

    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl, scopes: ['email', 'profile', 'openid']);
    await _redirect(authorizationUrl);
    var responseQueryParameters = await _listen();
    var client = await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<void> _redirect(Uri authorizationUri) async {
    if(await canLaunchUrl(authorizationUri)){
      await launchUrl(authorizationUri);
    } else{
      throw Exception('Can not launch $authorizationUri');
    }
  }

  Future<Map<String, String>> _listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront.activate();

    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln("You can close this tab");
    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;

    return params;
  }

  Future<oauth2.Credentials> login() async {
    await redirectServer?.close();
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = redirectUrl + redirectServer!.port.toString();

    oauth2.Client authenticatedHttpClient = await _getOauthClient(Uri.parse(redirectURL));
    return authenticatedHttpClient.credentials;
  }
}
class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}