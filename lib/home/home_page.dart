import 'package:flutter/material.dart';
import 'package:stalker/help/help_page.dart';
import 'package:stalker/home/add_user_form.dart';
import 'package:stalker/stalk/stalk_message_hub.dart';
import 'package:stalker/theme/loading_text.dart';
import 'package:stalker/user/active_user.dart';
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
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Color.lerp(Colors.pink.shade900, Colors.black, 0.3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.asset('assets/images/eye-left-fuzz.png'),
                ),
              ),
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
                  AnimatedBuilder(
                    animation: StalkMessageHub().getRecentMessagesNotifier(),
                    builder: (_, __) => LoadingText(key: GlobalKey()),
                  ),
                  Text('stalker',
                      style: Theme.of(context).textTheme.bodyMedium!),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: StalkMessageHub().getRecentMessagesNotifier(),
                      builder: (_, __) => LoadingText(
                          length: 100 +
                              StalkMessageHub()
                                  .getRecentMessagesNotifier()
                                  .value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: ActiveUser(),
            builder: (_, __) => AnimatedOpacity(
              opacity: (_isShowingBg ? 0.125 : 0.4) *
                  (ActiveUser().value!.isEnabled ? 1 : 0.25),
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
