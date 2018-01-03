import 'package:flutter/material.dart';

/**
 * 聊天室
 */

const String _name = "Your Name";

void main() {
  runApp(new FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "FriendlyChat",
      home: new ChatScreen(),
    );
  }

}

class ChatScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }


}


class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
                color: Theme
                    .of(context)
                    .cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //如果app有多于一个页面时，当切换到其他页面，这个方法会被调用释放动画资源
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme
          .of(context)
          .accentColor),

      child: new Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child
                  : new TextField(
                controller: _textEditingController,
                onSubmitted:
                _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText
                        : "Send a message"),
              ),
            ),

            new Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () =>
                    _handleSubmitted(_textEditingController.text
                    )
                ,
              )
              ,
            )
            ,
          ]
          ,
        ),
      )
      ,


    );
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();

    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

}

class ChatMessage extends StatelessWidget {
  final String text;
  final AnimationController animationController;

  ChatMessage({this.text, this.animationController});

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    // TODO: implement build
    //Create a fade-in animation effect by wrapping the Container in a FadeTransition widget instead of a SizeTransition.
    return new SizeTransition( //SizeTransition与CurvedAnimation配合使用，动画效果是由快至慢到最终停止。
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut
        ),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),

              new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme
                        .of(context)
                        .textTheme
                        .subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ]

              )
            ],
          ),
        )
    );
  }
}



