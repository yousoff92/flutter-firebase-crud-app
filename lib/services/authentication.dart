import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseUser currentUser;

  Future<bool> isAnonymous() async {
    FirebaseUser user = await this.getCurrentUser();
    return user.isAnonymous;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  static Future<FirebaseUser> getStaticCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  Future<FirebaseUser> signInGoogle() async {
    debugPrint("[Authentication] Attempt to Google sign in...");
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("1");
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("2");
    FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    debugPrint("[Authentication] Sign in as ${user.displayName}");
    currentUser = user;
    return user;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    debugPrint("[Authentication] Sign out from Google");
    return _auth.signOut();
  }


}
