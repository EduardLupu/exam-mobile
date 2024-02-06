import 'package:flutter/material.dart';
import 'package:share_items/models/item.dart';
import 'package:share_items/widgets/message.dart';
import 'package:share_items/widgets/text_box.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController nameController;
  late TextEditingController supplierController;
  late TextEditingController detailsController;
  late TextEditingController statusController;
  late TextEditingController quantityController;
  late TextEditingController typeController;

  @override
  void initState() {
    nameController = TextEditingController();
    supplierController = TextEditingController();
    detailsController = TextEditingController();
    statusController = TextEditingController();
    quantityController = TextEditingController();
    typeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a car'),
      ),
      body: ListView(
        children: [
          TextBox(nameController, 'Name'),
          TextBox(supplierController, 'Supplier'),
          TextBox(detailsController, 'Details'),
          TextBox(statusController, 'Status'),
          TextBox(quantityController, 'Quantity'),
          TextBox(typeController, 'Type'),
          ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String supplier = supplierController.text;
                String details = detailsController.text;
                String status = statusController.text;
                int? quantity = int.tryParse(quantityController.text);
                String? type = typeController.text;
                if (name.isNotEmpty &&
                    supplier.isNotEmpty &&
                    details.isNotEmpty &&
                    status.isNotEmpty &&
                    quantity != null &&
                    type.isNotEmpty) {
                  Navigator.pop(
                      context,
                      Item(
                          name: name,
                          supplier: supplier,
                          details: details,
                          status: status,
                          quantity: quantity,
                          type: type));
                } else {
                  if (name.isEmpty) {
                    message(context, 'Name is required', "Error");
                  } else if (supplier.isEmpty) {
                    message(context, 'supplier is required', "Error");
                  } else if (details.isEmpty) {
                    message(context, 'details is required', "Error");
                  } else if (status.isEmpty) {
                    message(context, 'status is required', "Error");
                  } else if (quantity == null) {
                    message(context, 'quantity must be an integer', "Error");
                  } else if (type.isEmpty) {
                    message(context, 'type is required', "Error");
                  }
                }
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
