import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = false;
  // ADD BUTTON
  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense) ? 'Add Expense' : 'Add Income',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // DELETE BUTTON
  void deleteDialog() {
    Dialogs.materialDialog(
      msg: 'Are you sure ? you can\'t undo this',
      title: "Delete",
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {},
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {},
          text: 'Delete',
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterSwitch(
                  activeText: "Expense",
                  inactiveText: "Income.",
                  activeColor: Colors.red,
                  inactiveColor: Colors.green,
                  value: isExpense,
                  valueFontSize: 12.0,
                  width: 80,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(
                      () {
                        isExpense = val;
                      },
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    openDialog();
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteDialog();
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                title: Text(
                  'Sedekah',
                  style: TextStyle(fontSize: 18),
                ),
                leading: (isExpense)
                    ? Icon(
                        Icons.upload,
                        color: Colors.red,
                        size: 30,
                      )
                    : Icon(
                        Icons.download,
                        color: Colors.green,
                        size: 30,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteDialog();
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                title: Text(
                  'Makan',
                  style: TextStyle(fontSize: 18),
                ),
                leading: (isExpense)
                    ? Icon(
                        Icons.upload,
                        color: Colors.red,
                        size: 30,
                      )
                    : Icon(
                        Icons.download,
                        color: Colors.green,
                        size: 30,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
