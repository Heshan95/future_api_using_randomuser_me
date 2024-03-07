import 'package:flutter/material.dart';
import 'package:future_api_using_randomuser_me/model/User.dart';

class UserDetails extends StatelessWidget {
  const UserDetails(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.name),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
            )
          ],
        ),
      ),
    );
  }
}
