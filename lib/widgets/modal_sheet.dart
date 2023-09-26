import 'package:flutter/material.dart';
import 'package:flutter_app_node/models/todo_model.dart';
import 'package:flutter_app_node/models/user_model.dart';
import 'package:flutter_app_node/providers/user_provider.dart';
import 'package:flutter_app_node/services/todo_method.dart';
import 'package:provider/provider.dart';

class ModalBottomSheet extends StatefulWidget {
  final TodoModel? todo;
  final int? index;
  final int? id;
  final bool isEdit;
  const ModalBottomSheet({
    Key? key,
    required this.todo,
    required this.isEdit,
    required this.index,
    required this.id,
  }) : super(key: key);

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final _globalKey = GlobalKey<FormState>();
  final TodoResource todoResource = TodoResource();

  final _textTitleController = TextEditingController();
  final _textContentController = TextEditingController();
  String title = '';
  String content = '';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      setState(() {
        _textTitleController.text = widget.todo!.title;
        _textContentController.text = widget.todo!.content;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textTitleController.dispose();
    _textContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Stack(
      children: [
        Positioned(
          top: 60,
          right: 25,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              size: 30,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        controller: _textTitleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter the text',
                        ),
                        onChanged: (values) => setState(() => title = values),
                        validator: (values) =>
                            values!.isEmpty ? "Enter the text" : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autocorrect: false,
                        controller: _textContentController,
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter the content',
                        ),
                        onChanged: (values) => setState(() => content = values),
                        validator: (values) =>
                            values!.isEmpty ? "Enter the content" : null,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_globalKey.currentState!.validate()) {
                            if (!widget.isEdit) {
                              todoResource.postTodoData(
                                context: context,
                                userId: user!.id,
                                token: user.token,
                                title: title,
                                content: content,
                              );
                            } else {
                              todoResource.editTodoData(
                                context: context,
                                title: _textTitleController.text.trim(),
                                content: _textContentController.text.trim(),
                                id: widget.todo!.id,
                                index: widget.index!,
                              );
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 35),
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Text(
                            "Submit".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Inter",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
