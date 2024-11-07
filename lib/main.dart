import 'dart:math';

import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

import 'components/chart.dart';

void main() {
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: 't0',
        title: 'Transaction Antiga',
        value: 310.99,
        date: DateTime.now().subtract(Duration(days: 33))
    ),
    Transaction(
        id: 't1',
        title: 'Transaction 01',
        value: 310.99,
        date: DateTime.now().subtract(Duration(days: 3))
    ),
    Transaction(
        id: 't2',
        title: 'Transaction 02',
        value: 230.79,
        date: DateTime.now().subtract(Duration(days: 4))
    )
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)
      ));
    }).toList();
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now()
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    
    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        }
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Despesas Pessoais'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () => _openTransactionFormModal(context),
                icon: Icon(Icons.add)
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(transactions: _transactions),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }
