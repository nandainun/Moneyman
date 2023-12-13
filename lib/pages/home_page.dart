import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyman/models/database.dart';
import 'package:moneyman/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DASHBOARD INCOME AND EXPENSE
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.download,
                            color: Colors.green,
                            size: 38,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '3.800.000',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.upload,
                            color: Colors.red,
                            size: 38,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '3.800.000',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(78, 83, 230, 1.0),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // TEXT TRANSACTION
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Transactions',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),

            StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(
                                              snapshot
                                                  .data![index].transaction.id);
                                          setState(() {});
                                        },
                                        icon: (Icon(Icons.delete))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionPage(
                                              transactionWithCategory:
                                                  snapshot.data![index],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: (Icon(Icons.edit)),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  'Rp. ' +
                                      snapshot.data![index].transaction.amount
                                          .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    snapshot.data![index].category.name +
                                        ' (' +
                                        snapshot.data![index].transaction.name +
                                        ')'),
                                leading: Container(
                                  child: (snapshot.data![index].category.type ==
                                          2)
                                      ? Icon(Icons.upload, color: Colors.red)
                                      : Icon(Icons.download,
                                          color: Colors.green),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Tidak ada transaksi'),
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
          ],
        ),
      ),
    );
  }
}
