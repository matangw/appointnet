import 'package:appointnet/screens/add_friend_screen/add_friend_view.dart';
import 'package:appointnet/utils/general_utils.dart';

class AddFriendModel {
  AddFriendView view;

  AddFriendModel(this.view);

  Future<void> addFriend(String rawPhoneNumber) async {
    String? validationError =
        GeneralUtils().phoneValidationError(rawPhoneNumber);
    if (validationError != null) {
      view.error(validationError);
      return;
    }
  }
}
