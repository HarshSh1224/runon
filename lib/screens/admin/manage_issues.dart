import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/issue_data.dart';

class ManageIssues extends StatelessWidget {
  static const routeName = '/manage-issues';
  const ManageIssues({super.key});

  Future<void> _fetchData(IssueData issueProvider) async {
    await issueProvider.fetchAndSetIssues();
    print(issueProvider.issueData);
  }

  @override
  Widget build(BuildContext context) {
    bool isExpanded = false;
    bool isLoading = false;
    final issueProvider = Provider.of<IssueData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Issues'),
      ),
      body: FutureBuilder(
          future: _fetchData(issueProvider),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Active Issues',
                          style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: issueProvider.issueData.length + 1,
                          itemBuilder: (context, index) {
                            if (index == issueProvider.issueData.length) {
                              return ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        TextEditingController addController =
                                            TextEditingController();
                                        return StatefulBuilder(builder: (context, setState) {
                                          return AlertDialog(
                                            content: TextFormField(
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              controller: addController,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter Issue Title',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: addController.text.trim().isEmpty
                                                    ? null
                                                    : () async {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        await issueProvider
                                                            .addIssue(addController.text);
                                                        Navigator.of(context).pop();
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      },
                                                child: isLoading
                                                    ? const SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: FittedBox(
                                                            child: CircularProgressIndicator()))
                                                    : const Text('Add'),
                                              )
                                            ],
                                          );
                                        });
                                      });
                                },
                                minVerticalPadding: 8,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                  child: const FittedBox(child: Icon(Icons.add)),
                                ),
                                title: const Text('Add New Issue'),
                              );
                            }
                            final issue = issueProvider.issueData[index];
                            return StatefulBuilder(builder: (context, setState) {
                              TextEditingController controller = TextEditingController();
                              controller.text = issue.title;
                              return Column(
                                children: [
                                  ListTile(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      minVerticalPadding: 8,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                                      leading: CircleAvatar(
                                        child: FittedBox(child: Text(issue.title[0])),
                                      ),
                                      title: Text(issue.title),
                                      trailing: Icon(
                                        !isExpanded
                                            ? Icons.expand_more_outlined
                                            : Icons.expand_less,
                                      )),
                                  AnimatedContainer(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                    duration: const Duration(milliseconds: 100),
                                    height: isExpanded ? 100 : 0,
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    child: !isExpanded
                                        ? null
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: TextFormField(
                                                  controller: controller,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Edit Title',
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 2),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: isLoading
                                                    ? const SizedBox(
                                                        height: 15,
                                                        child: FittedBox(
                                                            child: CircularProgressIndicator()),
                                                      )
                                                    : IconButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          try {
                                                            await FirebaseFirestore.instance
                                                                .collection('issues')
                                                                .doc(issue.id)
                                                                .set({'title': controller.text});

                                                            issueProvider.issueData[index].title =
                                                                controller.text;
                                                            issueProvider.notifyyListeners();
                                                          } catch (error) {
                                                            debugPrint(error.toString());
                                                          }
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                        icon: const Icon(Icons.done),
                                                      ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              // IconButton(
                                              //     onPressed: () {}, icon: const Icon(Icons.delete))
                                            ],
                                          ),
                                  )
                                ],
                              );
                            });
                          },
                        ),
                      )
                    ]),
                  );
          }),
    );
  }
}
