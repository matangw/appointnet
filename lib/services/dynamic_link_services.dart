import 'package:appointnet/models/link_details.dart';
import 'package:appointnet/repositories/link_repository.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/utils/globals/flags.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  void listenToDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((deepLink) async {
      print("listenToDynamicLinks: deeplink found");
      Uri link = deepLink.link;
      String prefix = link.path.split('/')[1];
      if (prefix.contains("group")) {
        String code = link.path.split('/')[2];
        LinkDetails? linkDetails =
            await LinksRepository().getByInvitationCode(code);
        if (linkDetails == null) {
          print('No link found');
          return;
        }
        dynamicLinkFunction(linkDetails.code);
      }
    }).onError((e) {
      print("deeplink error");
      print(e.message);
    });
  }

  Future<void> dynamicLinkFunction(String code) async {
    LinkDetails? link = await LinksRepository().getByInvitationCode(code);
    print('[!] group id from dynamic link: ' +
        (link?.groupId ?? 'no group id found'));
    if (link?.groupId == null) {
      print('[!] Group from link does not exist');
      return;
    }
    print('parlament id found');
    ParlamentsRepository()
        .addMemberViaLink(parlamentId: link?.groupId as String);
    Flags.needDynamicLinksUpdate = true;
  }

  Future<void> initialLinkFunction() async {
    try {
      final PendingDynamicLinkData? deepLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      if (deepLink != null) {
        print("checkInitialLink: deeplink found");
        Uri link = deepLink.link;
        String prefix = link.path.split('/')[1];
        if (prefix.contains("invitation")) {
          String invitationCode = link.path.split('/')[2];
          print('invitation code:' + invitationCode.toString());

          await LinksRepository().getByInvitationCode(invitationCode);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
