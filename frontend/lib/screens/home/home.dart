import 'package:my_nikki/screens/home/util.dart';
import 'package:my_nikki/models/user.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<UserModel?> _user;

  @override
  void initState() {
    super.initState();
    _user = _fetchUser();
  }

  Future<UserModel?> _fetchUser() async {
    Map<String, dynamic>? userData = await getUser();
    if (userData != null) {
      var user = UserModel.fromJson(userData);
      return user;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google SignIn"),
      ),
      body: FutureBuilder<UserModel?>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data available.'));
          } else {
            final user = snapshot.data!;
            return Center(
              child: Text('Welcome, ${user.name}!'),
            );
          }
        },
      ),
    );
  }
}
