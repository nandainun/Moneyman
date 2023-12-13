import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneyman/pages/category_page.dart';
import 'package:moneyman/pages/home_page.dart';
import 'package:moneyman/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        CategoryPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              accent: Color.fromRGBO(78, 83, 230, 1.0),
              locale: 'id',
              backButton: false,
              onDateChanged: (value) {
                setState(() {
                  selectedDate = value;
                  updateView(0, selectedDate);
                });
              },
              firstDate: DateTime.now().subtract(Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.poppins(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(100),
            ),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => TransactionPage(
                  transactionWithCategory: null,
                ),
              ),
            )
                .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Color.fromRGBO(78, 83, 230, 1.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: const Icon(Icons.home),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: const Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }
}
