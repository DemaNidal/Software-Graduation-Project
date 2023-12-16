import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../controller/chat_controller.dart';
import '../../models/message.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController msgInputController = TextEditingController();
  Color purple = const Color(0xFF6c5ce7);
  Color black = const Color.fromARGB(255, 26, 26, 27);
  late IO.Socket socket;
  ChatController chatcontroller = ChatController();
  @override
  void initState() {
    socket = IO.io(
        baseUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection

            .build());

    socket.connect();
    setUpSocketListener();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
          child: Column(
        children: [
          Expanded(
              flex: 9,
              child: Obx(
                () => ListView.builder(
                  itemCount: chatcontroller.chatMessages.length,
                  itemBuilder: (context, index) {
                    var currentItem = chatcontroller.chatMessages[index];
                    return MessageItem(
                      sentByMe: currentItem.sentByMe == socket.id,
                      message: currentItem.message,
                    );
                  },
                ),
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: purple,
              controller: msgInputController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: purple,
                  ),
                  child: IconButton(
                    onPressed: () {
                      sendMessage(msgInputController.text);
                      msgInputController.text = "";
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )),
        ],
      )),
    );
  }

  void sendMessage(String text) {
    var messageJason = {"message": text, "sentByMe": socket.id};
    socket.emit('message', messageJason);
    chatcontroller.chatMessages.add(Message.fromJson(messageJason));
  }

  void setUpSocketListener() {
    socket.on('message-receive', (data) {
      print(data);
      chatcontroller.chatMessages.add(Message.fromJson(data));
    });
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.sentByMe, required this.message});
  final bool sentByMe;
  final String message;
  @override
  Widget build(BuildContext context) {
    Color purple = const Color(0xFF6c5ce7);
    Color black = const Color.fromARGB(255, 26, 26, 27);
    Color white = Colors.white;
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sentByMe ? purple : white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: sentByMe ? white : purple,
              ),
            ),
            const SizedBox(width: 5),
            Text("1:10 Am",
                style: TextStyle(
                  fontSize: 10,
                  color: (sentByMe ? white : purple).withOpacity(0.7),
                )),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Chat App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Chat(),
  ));
}
