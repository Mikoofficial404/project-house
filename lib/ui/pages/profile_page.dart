import 'package:flutter/material.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/home_page.dart';
import 'package:project_house/ui/pages/search_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_house/mobile/auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Widget> list = const [Text('Home'), Text('Exprole'), Text('User')];

  int _selectedIndex = 2;

  List<dynamic> menuItems = [
    {'icon': 'assets/images/home.svg', 'label': 'Home'},
    {'icon': 'assets/images/search.svg', 'label': 'Explore'},
    {'icon': 'assets/images/user.svg', 'label': 'User'},
  ];

  final List<Widget> _pages = [HomePage(), SearchPage(), ProfilePage()];

  final emailControllers = TextEditingController();
  final currentPasswordControllers = TextEditingController();
  final newPasswordControllers = TextEditingController();

  bool isObscure = true;

  void toggleObsecure() {
    setState(() {
      isObscure = !isObscure;
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
  void dispose() {
    emailControllers.dispose();
    currentPasswordControllers.dispose();
    newPasswordControllers.dispose();
    super.dispose();
  }

  void updatePassword() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswordControllers.text,
        newPassword: newPasswordControllers.text,
        email: emailControllers.text,
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/circle_avatar.png'),
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailControllers,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    'Email',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                  ),
                  suffixIcon: Icon(Icons.email),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'Current Password',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: currentPasswordControllers,
                obscureText: isObscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    'Current Password',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      toggleObsecure();
                    },
                    child: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password Tidak Boleh Kosong';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'New Password',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: newPasswordControllers,
                obscureText: isObscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    'New Password',
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      toggleObsecure();
                    },
                    child: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password Tidak Boleh Kosong';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.value.resetPasswordFromCurrentPassword(
                    currentPassword: currentPasswordControllers.text,
                    newPassword: newPasswordControllers.text,
                    email: emailControllers.text,
                  );
                } catch (e) {
                  throw Error();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  'Save Changes',
                  style: whiteTextSF.copyWith(
                    fontSize: 16,
                    fontWeight: extraBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.value.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  throw Error();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  'Logout',
                  style: whiteTextSF.copyWith(
                    fontSize: 16,
                    fontWeight: extraBold,
                  ),
                ),
              ),
            ),
          ],
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
                  // ignore: deprecated_member_use
                  child: SvgPicture.asset(i['icon'], color: Colors.white),
                ),
                // ignore: deprecated_member_use
                icon: SvgPicture.asset(i['icon'], color: Colors.grey),
                label: i['label'],
              );
            }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
