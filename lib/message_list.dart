import 'package:emailapp/screens/message_detail.dart';
import 'package:emailapp/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessageList extends StatefulWidget {
  final String title;
  final String status;
  const MessageList({Key key, this.title, this.status = "important"}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  Future<List<Message>> future;
  List<Message> messages;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    future = Message.browse(status: widget.status);
    messages = await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('There was an error !${snapshot.error}');
            var messages = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (BuildContext contex, int index) {
                Message message = messages[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.blue,
                      icon: Icons.archive,
                      onTap: () => {},
                    ),
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.indigo,
                      icon: Icons.share,
                      onTap: () => {},
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'More',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () => {},
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => {
                        setState(() {
                          messages.removeAt(index);
                        })
                      },
                    ),
                  ],
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("PJ"),
                    ),
                    isThreeLine: true,
                    title: Text(message.subject),
                    subtitle: Text(
                      message.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MessageDetail(
                                  message.subject, message.body)));
                    },
                  ),
                  key: ObjectKey(message),
                );
              },
              itemCount: messages.length,
            );
        }
      },
    );
    // floatingActionButton: FutureBuilder(
    //     future: future,
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return ComposeButton(messages);
    //       }
    //     }));
  }
}
