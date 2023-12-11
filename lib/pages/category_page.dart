import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:moneyman/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print(row);
  }

  // CRUD CATEGORY
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  Future deleteCategoryRepo(int categoryId) async {
    return await database.deleteCategoryRepo(categoryId);
    // (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ADD BUTTON
  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
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
                    controller: categoryNameController,
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
                    onPressed: () {
                      (category == null)
                          ? insert(
                              categoryNameController.text, isExpense ? 2 : 1)
                          : update(category.id, categoryNameController.text);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {});
                      categoryNameController.clear();
                    },
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
  void deleteDialog(int categoryId) {
    Dialogs.materialDialog(
      msg: 'Are you sure ? you can\'t undo this',
      title: "Delete",
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {
            deleteCategoryRepo(categoryId).then((_) {
              // Setelah penghapusan selesai, tutup dialog dan refresh tampilan
              Navigator.pop(context);
              setState(() {});
            });
          },
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
                        type = val ? 2 : 1;
                      },
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    openDialog(null);
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
              future: getAllCategoryRepo(type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          deleteDialog(
                                              snapshot.data![index].id);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          openDialog(snapshot.data![index]);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    snapshot.data![index].name,
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
                            );
                          });
                    } else {
                      return Center(
                        child: Text('Tidak ada data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Tidak ada data'),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
