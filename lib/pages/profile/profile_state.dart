import 'package:get/get.dart';
import '../../model/user_model.dart';

class ProfileState {
  Rx<UserModel> user = UserModel.fromJson({}).obs;

  ProfileState() {
    ///Initialize variables
  }
}

class ProfilePageArgs {
  final UserModel user;

  ProfilePageArgs({required this.user});
}
