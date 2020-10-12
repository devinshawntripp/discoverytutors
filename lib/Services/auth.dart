import 'package:disc_t/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //create user obj based on firebase user
  UserTutor _userFromFirebaseUser(User user) {
    return user != null
        ? UserTutor(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  //auth change user stream
  Stream<UserTutor> get user {
    return _auth.authStateChanges().map((user) => _userFromFirebaseUser(user));
  }

  //register with facebook

  //register with google

  //anon sign in
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithApple() async {
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(appleIdCredential.familyName);
      print(appleIdCredential.givenName);

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
          accessToken: appleIdCredential.authorizationCode,
          idToken: appleIdCredential.identityToken);
      UserCredential result = await _auth.signInWithCredential(credential);

      User user = result.user;
      await user.updateProfile(
          displayName:
              appleIdCredential.givenName + " " + appleIdCredential.familyName);
      print(user.displayName);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //sign in with email and password
  Future signInEAP(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    // await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final User firebaseUser =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // assert(!user.isAnonymous);
      // assert(await user.getIdToken() != null);

      // final User currentUser = _auth.currentUser;
      // assert(user.uid == currentUser.uid);
      print('signInWithGoogle succeeded: $user');
      return _userFromFirebaseUser(firebaseUser);

      // return '$user';
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  //register with email and password
  Future signUp(email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
