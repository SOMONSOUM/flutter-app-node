import 'package:flutter/material.dart';
import 'package:flutter_app_node/models/todo_model.dart';
import 'package:flutter_app_node/models/user_model.dart';
import 'package:flutter_app_node/providers/todo_provider.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/services/auth_method.dart';
import 'package:flutter_app_node/services/todo_method.dart';
import 'package:flutter_app_node/widgets/list_todo.dart';
import 'package:flutter_app_node/widgets/loading.dart';
import 'package:flutter_app_node/widgets/modal_sheet.dart';
import 'package:flutter_app_node/utils/utility.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthResource authResource = AuthResource();
  final TodoResource todoResource = TodoResource();
  bool isEdit = false;
  bool isLoading = true;

  void showBottomSheetBar(
    TodoModel? todo,
    int? index,
    int? id,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => FractionallySizedBox(
        heightFactor: 1,
        child: ModalBottomSheet(
          todo: todo,
          isEdit: isEdit,
          index: index,
          id: id,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await todoResource.fetchDataTodo(context: context);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    final List<TodoModel> todo = Provider.of<TodoProvider>(context).todo;
    return isLoading
        ? const LoadingSpinkit()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() => isEdit = false);
                showBottomSheetBar(null, null, null);
              },
              backgroundColor: const Color.fromARGB(255, 87, 209, 91),
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.menu),
                          Row(
                            children: [
                              const Icon(Icons.notifications),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await authResource.authLogOut(
                                      context: context);
                                },
                                child: const Icon(
                                  Icons.logout,
                                  size: 23,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 35, bottom: 13),
                        child: Row(
                          children: [
                            const Text(
                              "What's up,",
                              style: kTextTitleHome,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              user?.name ?? '',
                              style: kTextTitleHome,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Today's task".toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            letterSpacing: 0.8,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        margin: todo.isEmpty
                            ? const EdgeInsets.only(top: 40)
                            : const EdgeInsets.only(top: 0),
                        child: todo.isEmpty
                            ? Column(
                                children: const [
                                  Image(
                                    height: 140,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "lib/assets/img/no-data.png"),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "No Data",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 170, 170, 170),
                                      fontSize: 15,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )
                            : null,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.only(top: 35),
                        child: Consumer<TodoProvider>(
                          builder: (context, data, child) {
                            return ListView.builder(
                              itemCount: todo.length,
                              itemBuilder: (context, index) {
                                return ListTodoTile(
                                  title: data.todo[index].title,
                                  update: () {
                                    setState(() => isEdit = true);
                                    showBottomSheetBar(data.todo[index], index,
                                        data.todo[index].id);
                                  },
                                  delete: () async {
                                    await todoResource.removeTodoData(
                                      context: context,
                                      id: data.todo[index].id,
                                      todo: data.todo[index],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
