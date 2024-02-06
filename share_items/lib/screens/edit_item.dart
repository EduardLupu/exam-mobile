import 'package:flutter/material.dart';
import 'package:share_items/widgets/message.dart';

import '../models/item.dart';

class EditItemPage extends StatefulWidget {
  final Item item;

  const EditItemPage({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<EditItemPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car details'),
      ),
      body: ListView(
        children: [
          Text('ID: ${widget.item.id}'),
          Text('Name: ${widget.item.name}'),
          Text('Supplier: ${widget.item.supplier}'),
          Text('Details: ${widget.item.details}'),
          Text('Status: ${widget.item.status}'),
          Text('Quantity: ${widget.item.quantity.toString()}'),
          Text('Type: ${widget.item.type}'),
          ElevatedButton(onPressed: () {}, child: const Text('Save')),
        ],
      ),
    );
  }
}
