import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyman/model/database.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  final AppDatabase database = AppDatabase();
  List<String> list = ['Makan', 'Minum', 'Nonton'];
  late int type;
  late String dropdownValue = list.first;
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Category? selectedCategory;

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  // INSERT DATA
  Future insert(
      int amount, DateTime date, String nameDesc, int categoryId) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            name: nameDesc,
            category_id: categoryId,
            transaction_date: date,
            amount: amount,
            createdAt: now,
            updatedAt: now,
          ),
        );
    print('Apa ini : ' + row.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    type = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BUTTON SWITCH
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isExpense ? 'Expense' : 'Income',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: isExpense,
                      onChanged: (bool value) {
                        setState(() {
                          isExpense = value;
                          type = (isExpense) ? 2 : 1;
                          selectedCategory = null;
                        });
                      },
                      activeColor: Colors.red,
                      activeTrackColor: Colors.red[200],
                      inactiveThumbColor: Colors.green,
                      inactiveTrackColor: Colors.green[200],
                    ),
                  ],
                ),
              ),

              // FIELD AMOUNT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 40),
                    ),
                    labelText: 'Amount',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // TEKS CATEGORY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Category :',
                  style: GoogleFonts.poppins(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  print('Apanih ' + snapshot.toString());
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        selectedCategory = snapshot.data!.first;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<Category>(
                            value: (selectedCategory == null)
                                ? snapshot.data!.first
                                : selectedCategory,
                            isExpanded: true,
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: snapshot.data!.map(
                              (Category item) {
                                return DropdownMenuItem<Category>(
                                  value: item,
                                  child: Text(item.name),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('Belum ada kategory'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Tidak ada data'),
                      );
                    }
                  }
                },
              ),

              // DROPDOWN BUTTON

              SizedBox(
                height: 20,
              ),

              // DATE PICKER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 40),
                    ),
                    labelText: 'Enter Date',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      dateController.text = formattedDate;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 40),
                    ),
                    labelText: 'Description',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // SAVE BUTTON
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    DateTime parsedDate =
                        DateFormat('dd-MM-yyyy').parse(dateController.text);
                    insert(int.parse(amountController.text), parsedDate,
                        descriptionController.text, selectedCategory!.id);
                    print('amount: ' + amountController.text);
                    print('date: ' + dateController.text);
                    print('desc: ' + descriptionController.text);
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
