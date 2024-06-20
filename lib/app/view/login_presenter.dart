import '../models/User.dart';
import '../service/database_helper.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  //RestData api = new RestData();
  LoginPagePresenter(this._view);

  doLogin(String username, String password) async {
    //print("HI");
    DatabaseHelper db = DatabaseHelper.instance;

    await db.checkUser(username,password).
    then((user) =>  _view.onLoginSuccess(user))
        .catchError((onError) {
      //print("Trying to Catch"+onError.toString());
      return _view.onLoginError(onError.toString());
    });

  }
}