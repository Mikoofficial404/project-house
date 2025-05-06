import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

void main() => runApp(const ServicesCusotmer());

class ServicesCusotmer extends StatelessWidget {
  const ServicesCusotmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('Customer Services Chat'),
          backgroundColor: const Color(0XFFF7931E),
          elevation: 0,
        ),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/680e201dcaa9eb190d43195b/1ipriqsvt',
          visitor: TawkVisitor(name: 'John Doe', email: 'johndoe@gmail.com'),
          onLoad: () {
            print('Hello Tawk!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: const Center(child: Text('Loading...')),
        ),
      ),
    );
  }
}
