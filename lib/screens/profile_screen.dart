import 'package:flutter/material.dart';
import 'package:runon/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:runon/screens/chats_screen.dart';
import 'package:runon/screens/my_appointments.dart';
import 'package:runon/widgets/user_detail_card.dart';
import 'package:runon/screens/documents_screen.dart';
import 'package:runon/screens/feedback_screen.dart';
import 'package:runon/screens/about_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = 'profile-screen';
  Function() toggleTheme;
  ProfileScreen(this.toggleTheme, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Transform.translate(
              offset: const Offset(-10, 0),
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  user.logout();
                                  Navigator.popUntil(
                                    context,
                                    ModalRoute.withName('/'),
                                  );
                                  if (!Navigator.of(context).canPop()) {
                                    Navigator.of(context).pushNamed('/');
                                  }
                                },
                                child: const Text('Yes'))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.logout_rounded),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              UserDetailCard(user: user),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    '  CONTENT',
                    style: TextStyle(
                        fontFamily: 'MoonBold',
                        letterSpacing: 2.0,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Card(
                      elevation: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          ListTile(
                            title: const Text('Messages'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ChatsScreen.routeName);
                            },
                            leading: const Icon(Icons.chat),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          ),
                          ListTile(
                            title: const Text('Documents'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(DocumentsScreen.routeName);
                            },
                            leading: const Icon(Icons.file_present_rounded),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          ),
                          ListTile(
                            title: const Text('Previous Appointments'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(MyAppointmentsScreen.routeName);
                            },
                            leading: const Icon(Icons.person_pin_outlined),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          )
                        ]),
                      ))),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    '  PREFERENCES',
                    style: TextStyle(
                        fontFamily: 'MoonBold',
                        letterSpacing: 2.0,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Card(
                      elevation: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          ListTile(
                            title: const Text('Dark Theme'),
                            onTap: toggleTheme,
                            leading: const Icon(Icons.dark_mode),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          ),
                          ListTile(
                            title: const Text('Provide Feedback'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(FeedbackForm.routeName);
                            },
                            leading: const Icon(Icons.feedback),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          ),
                          ListTile(
                            title: const Text('About'),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AboutUsScreen.routeName);
                            },
                            leading: const Icon(Icons.info),
                            trailing: const Icon(Icons.chevron_right_sharp),
                          )
                        ]),
                      ))),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
