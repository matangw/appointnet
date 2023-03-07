import 'package:appointnet/models/link_details.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/link_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class ShareLinkService {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;



   Future<void> shareGroup(
      {required String platform, required Parlament group}) async {
    LinksRepository linksRepository = LinksRepository();
    LinkDetails? link = LinkDetails(groupId: group.id as String, creatorID: FirebaseAuth.instance.currentUser?.uid as String);
      String url = await _createDynamicLink(link);
      link.url = url;

    String message = "You have been invited to ${group.name} ";
    String messageWithLink = message + "Join group link: ${link.url}";
    linksRepository.update(link);
    if (platform != "_") _shareByPlatform(platform, messageWithLink);
  }

  static void _shareByPlatform(String platform, String message) {
    FlutterShareMe shareService = FlutterShareMe();
    if (platform == "telegram") {
      shareService.shareToTelegram(msg: message);
    } else if (platform == "whatsapp") {
      shareService.shareToWhatsApp(msg: message);
    } else {
      shareService.shareToSystem(msg: message);
    }
  }

  Future<String> _createDynamicLink(LinkDetails link) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://appointnet.page.link',
      link: Uri.parse('https://appointnet.page.link/groupInvitation/${link.code}'),
      androidParameters: const AndroidParameters(
          packageName: 'com.appointent.appointnet', minimumVersion: 0),
      iosParameters: const IOSParameters(
          bundleId: 'com.appointent.appointnet',
          minimumVersion: '0',
          
          ),
    );

    final ShortDynamicLink shortLink =
    await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }
}