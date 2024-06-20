import '../models/User.dart';
import '../utils/network_util.dart';

class RestData{
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "";
  static final LOGIN_URL = BASE_URL + "/";
  //You can use this to login into a web service We are still working on it

  Future<User> login(String email, String password) {
    //expected success from web service
    return new Future.value(new User(id_usuario: 0,name:'',dni: '',email: email, password: password));
  }
  Future<User> register(String email, String password) {
    //expected success from web service
    return new Future.value(new User(id_usuario: 0,name:'',dni: '',email: email, password: password));
  }
}