import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseError implements Exception {
  String _errorMessage = "An unexpected error occurred.";

  FirebaseError.withError({required dynamic error}) {
    _handleError(error);
  }

  String getErrorMessage() {
    return _errorMessage;
  }

  void _handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          _errorMessage = "The email address is not valid.";
          break;
        case 'user-disabled':
          _errorMessage = "This user has been disabled.";
          break;
        case 'user-not-found':
          _errorMessage = "No user found for this email.";
          break;
        case 'wrong-password':
          _errorMessage = "Incorrect password. Please try again.";
          break;
        case 'email-already-in-use':
          _errorMessage = "The email is already in use by another account.";
          break;
        case 'operation-not-allowed':
          _errorMessage = "This operation is not allowed.";
          break;
        case 'weak-password':
          _errorMessage = "The password is too weak.";
          break;
        case 'network-request-failed':
          _errorMessage = "Network error. Please check your connection.";
          break;
        default:
          _errorMessage = error.message ?? "An unknown error occurred.";
          break;
      }
    } else {
      _errorMessage = "An unexpected error occurred.";
    }

    Fluttertoast.showToast(msg: _errorMessage);
  }
}
