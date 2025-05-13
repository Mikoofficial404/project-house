import 'package:flutter/material.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/favorite.dart';
import 'package:project_house/ui/pages/home_page.dart';
import 'package:project_house/ui/pages/search_page.dart';
import 'package:project_house/ui/pages/profile_page.dart';
import 'package:project_house/ui/pages/change_username_page.dart';
import 'package:project_house/ui/pages/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_house/mobile/auth_services.dart';
import 'package:project_house/ui/pages/profile_delete.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  final List<Widget> list = const [Text('Home'), Text('Exprole'), Text('User')];

  int _selectedIndex = 3;

  List<dynamic> menuItems = [
    {'icon': 'assets/images/home.svg', 'label': 'Home'},
    {'icon': 'assets/images/search.svg', 'label': 'Explore'},
    {'icon': 'assets/images/love.svg', 'label': 'love'},
    {'icon': 'assets/images/user.svg', 'label': 'User'},
  ];

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    FavoritePage(),
    ProfileSettingPage(),
  ];
  String username = '';
  String email = '';
  String? avatarPath = 'assets/images/circle_avatar.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = authService.value.currenctUser;
    if (user != null) {
      setState(() {
        username = user.displayName ?? 'User Name';
        email = user.email ?? 'user@example.com';
      });
    }
  }

  void _changeUsername() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeUsernamePage(currentUsername: username),
      ),
    ).then((newUsername) {
      if (newUsername != null && newUsername.isNotEmpty) {
        setState(() {
          username = newUsername;
        });
        authService.value.updateUsername(username: newUsername);
      }
    });
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  void popPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/circle_avatar.png'),
              ),
              const SizedBox(height: 20),
              Text(username, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(email, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 30),
              _buildSettingsCard(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Colors.black87,
        elevation: 32.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(height: 1.5, fontSize: 12),
        unselectedLabelStyle: const TextStyle(height: 1.5, fontSize: 12),
        items:
            menuItems.map((i) {
              return BottomNavigationBarItem(
                activeIcon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: SvgPicture.asset(i['icon'], color: Colors.white),
                ),
                icon: SvgPicture.asset(i['icon'], color: Colors.grey),
                label: i['label'],
              );
            }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: purpleColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.person,
            title: 'Change Username',
            onTap: _changeUsername,
          ),
          const Divider(height: 1),
          _buildListTile(
            context,
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const Divider(height: 1),
          _buildListTile(
            context,
            icon: Icons.safety_check,
            title: 'Delete Account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileDelete()),
              );
            },
          ),
          const Divider(height: 1),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              _showLogoutDialog(context);
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await authService.value.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
