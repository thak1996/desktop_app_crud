import 'package:desktop_app_crud/app/modules/components/button.dart';
import 'package:desktop_app_crud/app/modules/components/input_field.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../SQLite/database_helper.dart';
import '../../json/accounts_json.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late DatabaseHelper handler;
  late Future<List<AccountsJson>> accounts;
  final db = DatabaseHelper();

  @override
  void initState() {
    handler = db;
    accounts = handler.getAccounts();
    handler.init().whenComplete(() {
      accounts = getAllRecords();
    });
    super.initState();
  }

  Future<List<AccountsJson>> getAllRecords() async {
    return await handler.getAccounts();
  }

  Future<void> _refreshAccounts() async {
    setState(() {
      accounts = getAllRecords();
    });
  }

  Future<List<AccountsJson>> filterAccounts() async {
    return await handler.filterAccounts(searchController.text);
  }

  final TextEditingController accHolder = TextEditingController();
  final TextEditingController accName = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  bool isSearchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          accHolder.clear();
          accName.clear();
          addAccountDialog();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        title: isSearchOn
            ? Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * .4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        blurRadius: 1,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        accounts = filterAccounts();
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  _refreshAccounts();
                                });
                              },
                              icon: const Icon(Icons.clear, size: 17),
                            )
                          : const SizedBox(),
                      border: InputBorder.none,
                      hintText: "Search accounts here",
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              )
            : const Text("Accounts"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSearchOn = !isSearchOn;
                });
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: accounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text("No Account found"));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            final items = snapshot.data ?? <AccountsJson>[];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? AppColors.primaryColor.withValues(alpha: 0.02)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        child: Text(items[index].accHolder[0].toUpperCase()),
                      ),
                      title: Text(items[index].accHolder),
                      subtitle: Text(items[index].accName),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            if (items[index].accId != null) {
                              deleteAccount(items[index].accId!);
                            }
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red.shade900),
                      ),
                      onTap: () {
                        accHolder.text = items[index].accHolder;
                        accName.text = items[index].accName;
                        updateAccountDialog(items[index].accId);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void addAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(
                hint: "Account Holder",
                icon: Icons.person,
                controller: accHolder,
              ),
              InputField(
                hint: "Account Name",
                icon: Icons.account_circle_rounded,
                controller: accName,
              ),
            ],
          ),
          actions: [
            Button(
              label: "Add Account",
              onPressed: () {
                addAccount();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void updateAccountDialog(accId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(
                hint: "Account Holder",
                icon: Icons.person,
                controller: accHolder,
              ),
              InputField(
                hint: "Account Name",
                icon: Icons.account_circle_rounded,
                controller: accName,
              ),
            ],
          ),
          actions: [
            Button(
              label: "Update Account",
              onPressed: () {
                updateAccount(accId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void addAccount() async {
    var res = await handler.insertAccount(
      AccountsJson(
        accHolder: accHolder.text,
        accName: accName.text,
        accStatus: 1,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    if (res > 0) {
      setState(() {
        _refreshAccounts();
      });
    }
  }

  void deleteAccount(int accId) async {
    var res = await handler.deleteAccount(accId);
    if (res > 0) {
      setState(() {
        _refreshAccounts();
      });
    }
  }

  void updateAccount(accId) async {
    var res = await handler.updateAccount(accHolder.text, accName.text, accId);
    if (res > 0) {
      setState(() {
        _refreshAccounts();
      });
    }
  }
}
