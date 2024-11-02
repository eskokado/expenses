import 'dart:math';

import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

import 'transaction_form.dart';
import 'transaction_list.dart';

class TransactionUser extends StatefulWidget {
  TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
        id: 't1',
        title: 'Transaction 01',
        value: 310.99,
        date: DateTime.now()
    ),
    Transaction(
        id: 't2',
        title: 'Transaction 02',
        value: 230.79,
        date: DateTime.now()
    )
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionList(transactions: _transactions),
        TransactionForm(onSubmit: _addTransaction,),
      ]
    );
  }
}
