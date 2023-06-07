import 'package:flutter/material.dart';
import 'package:stalker/help/help_page.dart';
import 'package:stalker/home/add_user_form.dart';
import 'package:stalker/theme/loading_text.dart';
import 'package:stalker/user/users_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? addUserForm;
  bool _isShowingBg = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _isShowingBg = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (c) => const HelpPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.transparent,
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/right-eye2.jpg'),
                    ),
                  ),
                ),
                // const SizedBox(width: 2),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.transparent,
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/left-eye.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const LoadingText(),
                  Text(
                    'stalker',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  const Expanded(child: LoadingText(length: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _isShowingBg ? 0.15 : 0.35,
            duration: const Duration(milliseconds: 750),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const UsersListWidget(),
                if (addUserForm != null) addUserForm!,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: addUserForm != null
          ? null
          : FloatingActionButton(
              onPressed: () {
                _launchAddUserForm();
              },
              child: const Icon(Icons.person_add),
            ),
    );
  }

  void _launchAddUserForm() {
    setState(() {
      addUserForm = AddUserForm(
        onDone: () {
          setState(() {
            addUserForm = null;
          });
        },
      );
    });
  }
}
