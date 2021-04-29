import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ChatPage(),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  IO.Socket socket;
  List<String> messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  StreamSocket streamSocket = StreamSocket();
  @override
  void initState() {
    //Initializing the message list
    messages = List<String>();
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    connectAndListen();
    super.initState();
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    socket = IO.io('http://localhost:3000',
        OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    receiveMsg();
    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }

  void receiveMsg() {
    socket.on('receive_message', (jsonData) {
      print(jsonData.runtimeType);
      print(socket.id);
      print(socket.ids);
      //Convert the JSON data received into a Map
      var data = jsonDecode(jsonData.toString());
      this.setState(() => messages.add(data['data']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
  }

  Widget buildSingleMessage(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          messages[index],
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Expanded(
      child: Container(
        width: width,
        child: ListView.builder(
          controller: scrollController,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return buildSingleMessage(index);
          },
        ),
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textController,
        onSubmitted: (v) {
          sendMessage();
        },
      ),
    );
  }

  Widget buildSendButton() {
    return Container(
      margin: EdgeInsets.all(4),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          sendMessage();
        },
        child: Icon(
          Icons.send,
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      width: width,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.black12),
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: <Widget>[
          buildMessageList(),
          buildInputArea(),
        ],
      ),
    );
  }

  void sendMessage() {
    //Check if the textfield has text or not
    if (textController.text.isNotEmpty) {
      //Send the message as JSON data to send_message event
      socket.emit('send_message', json.encode({'data': textController.text}));
      //Add the message to the list
      // this.setState(() => messages.add(textController.text));
      textController.text = '';
      //Scrolldown the list to show the latest message
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    }
  }
}

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
