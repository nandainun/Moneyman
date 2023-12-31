import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyman/models/database.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({super.key, required this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  late int type;
  final AppDatabase database = AppDatabase();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Category? selectedCategory;

  // CRUD TRANSACTIONS
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
    print('Test :' + row.toString());
  }

  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String nameDesc) async {
    return await database.updateTransactionRepo(
        transactionId, amount, categoryId, transactionDate, nameDesc);
  }

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    descController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat('dd-MM-yyyy')
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = transactionWithCategory.category;
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

              // DROPDOWN BUTTON
              FutureBuilder<List<Category>>(
                  future: getAllCategoryRepo(type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        selectedCategory = (selectedCategory == null)
                            ? snapshot.data!.first
                            : selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<Category>(
                              value: (selectedCategory == null)
                                  ? snapshot.data!.first
                                  : selectedCategory,
                              isExpanded: true,
                              onChanged: (Category? value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: snapshot.data!.map((Category item) {
                                return DropdownMenuItem<Category>(
                                  value: item,
                                  child: Text(item.name),
                                );
                              }).toList()),
                        );
                      } else {
                        return Center(
                          child: Text('Tidak ada kategori'),
                        );
                      }
                    }
                  }),
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
                  controller: descController,
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
                  onPressed: () async {
                    String formattedDate = DateFormat("yyyy-MM-dd").format(
                      DateFormat("dd-MM-yyyy").parse(dateController.text),
                    );
                    dateController.text = formattedDate;
                    (widget.transactionWithCategory == null)
                        ? insert(
                            int.parse(amountController.text),
                            DateTime.parse(formattedDate),
                            descController.text,
                            selectedCategory!.id)
                        : await update(
                            widget.transactionWithCategory!.transaction.id,
                            int.parse(amountController.text),
                            selectedCategory!.id,
                            DateTime.parse(formattedDate),
                            descController.text,
                          );
                    Navigator.pop(context, true);
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
