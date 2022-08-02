import 'package:get/get.dart';

import '../components/Model/Chat/ChatList.dart';

class ChatListController extends GetxController {
  RxList<ChatListData> friendList = <ChatListData>[].obs;
}
