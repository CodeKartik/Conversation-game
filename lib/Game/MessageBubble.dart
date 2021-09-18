import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.englishMessage,
    required this.hindiMessage,
    required this.index,
  });

  final int index;
  final List? englishMessage;
  final List? hindiMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            index % 2 == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   items[index],
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
          Row(
            mainAxisAlignment: index % 2 == 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                child: index % 2 != 0
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/boy.png"))
                    : Container(),
              ),
              SizedBox(width: 3),
              Flexible(
                child: Material(
                  borderRadius: index % 2 == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                  elevation: 3.0,
                  color: index % 2 == 0 ? Colors.lightBlueAccent : Colors.white,
                  // color: Colors.lightBlueAccent,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          englishMessage![index],
                          style: TextStyle(
                            fontSize: 16.0,
                            color:
                                index % 2 == 0 ? Colors.white : Colors.black54,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          hindiMessage![index],
                          style: TextStyle(
                            fontSize: 16.0,
                            color:
                                index % 2 == 0 ? Colors.white : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3),
              Container(
                child: index % 2 == 0
                    ? CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/girl.png"))
                    : Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
