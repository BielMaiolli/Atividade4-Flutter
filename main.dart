import 'package:flutter/material.dart';

void main() {
  runApp(BankApp());
}

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransactionFormPage(),
    );
  }
}

class TransactionFormPage extends StatefulWidget {
  @override
  _TransactionFormPageState createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _transactions = [];
  final TextEditingController _transactionController = TextEditingController();

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _transactions.add(_transactionController.text);
      });
      _transactionController.clear();
    }
  }

  void _navigateToListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionListPage(transactions: _transactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _transactionController,
                    decoration: InputDecoration(labelText: 'Descrição da Transação'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addTransaction,
                    child: Text('Adicionar Transação'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToListPage,
              child: Text('Ver Transações'),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionListPage extends StatefulWidget {
  final List<String> transactions;

  TransactionListPage({required this.transactions});

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  void _deleteTransaction(int index) {
    setState(() {
      widget.transactions.removeAt(index);
    });
  }

  void _editTransaction(int index, String newValue) {
    setState(() {
      widget.transactions[index] = newValue;
    });
  }

  void _showEditDialog(int index) {
    final _editController = TextEditingController(text: widget.transactions[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Transação'),
          content: TextFormField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Descrição da Transação'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _editTransaction(index, _editController.text);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transações'),
      ),
      body: widget.transactions.isEmpty
          ? Center(child: Text('Nenhuma transação cadastrada.'))
          : ListView.builder(
              itemCount: widget.transactions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(widget.transactions[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteTransaction(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
