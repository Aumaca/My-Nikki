import 'package:my_nikki/screens/widgets/entry.dart';
import 'package:my_nikki/screens/home/util.dart';
import 'package:my_nikki/utils/colors.dart';
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
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondaryColor,
          title: const Center(
            child: Text(
              "MyNikki",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
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
              return Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                                Entry(),
                                SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Center(child: Text('Content for Tab 2')),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: AppColors.tabBarBackground,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: const TabBar(
                      labelColor: AppColors.tabBarSelected,
                      unselectedLabelColor: AppColors.tabBarUnselected,
                      indicatorColor: AppColors.tabBarIndicator,
                      tabs: [
                        Tab(icon: Icon(Icons.bookmark)),
                        Tab(icon: Icon(Icons.calendar_today)),
                        Tab(icon: Icon(Icons.settings)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 45.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/newEntry');
              return;
            },
            backgroundColor: AppColors.secondaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
