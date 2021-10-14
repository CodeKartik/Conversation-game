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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: index % 2 != 0
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        backgroundImage: AssetImage("assets/girl.png"))
                    : Container(),
              ),
              SizedBox(width: 3),
              Flexible(
                child: Material(
                  borderRadius: index % 2 == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                  elevation: 2.1,
                  color: index % 2 == 0 ? Colors.blueGrey : Colors.white,
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
                        backgroundColor: Colors.blueGrey.shade300,
                        radius: 24,
                        backgroundImage: AssetImage("assets/boy.png"))
                    : Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
