import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? Column(
      children: [
        SizedBox(height: 20,),
        Text(
          'Nenhuma Transação Cadastrada!',
          style: Theme
              .of(context)
              .textTheme
              .titleLarge,
        ),
        SizedBox(height: 20,),
        Container(
          height: 200,
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    ) : ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final tr = transactions[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                    child: Text(
                      'R\$ ${tr.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                ),
              ),
            ),
            title: Text(
              tr.title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('d MMM y').format(tr.date),
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              onPressed: () => onRemove(tr.id),
              icon: Icon(Icons.delete),
              color: Colors.red[700],
            ),
          ),
        );
      },
    );
  }
}
