import 'dart:io';
import 'dart:math';

import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
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
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(onPressed: fn, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? Icons.list : Icons.show_chart,
          () => setState(() {
            _showChart = !_showChart;
          }),
        ),
      _getIconButton(
        Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Despesas Pessoais',
              style: TextStyle(fontSize: 20),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: DefaultTextStyle(
              style: TextStyle(fontSize: 20),
              child: const Text(
                'Despesas Pessoais',
                style: TextStyle(fontSize: 20),
              ),
            ),
            backgroundColor: Colors.blue,
            actions: actions,
          );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (isLandscape)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text('Exibir Gráfico'),
          //       Switch(
          //         value: _showChart,
          //         onChanged: (value) {
          //           setState(() {
          //             _showChart = value;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          if (_showChart || !isLandscape)
            Container(
              height: availableHeight * (isLandscape ? 0.7 : 0.25),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
              height: availableHeight * (isLandscape ? 1 : 0.75),
              child: TransactionList(_transactions, _removeTransaction),
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _openTransactionFormModal(context)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
