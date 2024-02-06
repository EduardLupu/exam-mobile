import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:share_items/api/api.dart';
import 'package:share_items/models/item.dart';
import 'package:share_items/widgets/message.dart';

import '../api/network.dart';
import '../services/database_helper.dart';

class ItemsListPage extends StatefulWidget {
  final int _id;
  const ItemsListPage(this._id, {super.key});

  @override
  State<StatefulWidget> createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  var logger = Logger();
  bool online = true;
  late Item item;
  bool isLoading = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _connectivity = NetworkConnectivity.instance;
  String string = '';

  @override
  void initState() {
    super.initState();
    connection();
  }

  void connection() {
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      _source = source;
      var newStatus = true;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: online' : 'Mobile: offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'Wifi: online' : 'Wifi: offline';
          newStatus = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
          newStatus = false;
      }
      if (online != newStatus) {
        online = newStatus;
      }
      getCarById();
    });
  }

  getCarById() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, "Online - $online");
    try {
      if (online) {
        item = await ApiService.instance.getCarById(widget._id);
      } else {
        item = await DatabaseHelper.getCarById(widget._id);
      }
    } catch (e) {
      logger.e(e);
      message(context, "Error when retreiving data from server", "Error");
      item = await DatabaseHelper.getCarById(widget._id);
    }
    setState(() {
      isLoading = false;
    });
  }

  // void deleteData(Item item) async {
  //   if (!mounted) return;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     if (online) {
  //       setState(() {
  //         ApiService.instance.deleteItem(item.id!);
  //         DatabaseHelper.deleteItem(item.id!);
  //         items.remove(item);
  //         Navigator.pop(context);
  //       });
  //     } else {
  //       message(context, "Operation not available", "Info");
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //     message(context, "Error when deleting data from server", "Error");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // removeItem(BuildContext context, int id) {
  //   showDialog(
  //       context: context,
  //       builder: ((context) => AlertDialog(
  //             title: const Text("Delete Item"),
  //             content: const Text("Are you sure you want to delete this item?"),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Cancel"),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   deleteData(items.firstWhere((element) => element.id == id));
  //                 },
  //                 child:
  //                     const Text("Delete", style: TextStyle(color: Colors.red)),
  //               ),
  //             ],
  //           )));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget._id} car details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ListView(
              children: [
                ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(item.name!),
                      subtitle: Text(
                          '${item.supplier}, ${item.details}, ${item.status}, ${item.quantity}, ${item.type}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          //removeItem(context, items[index].id!);
                        },
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    );
                  }),
                  itemCount: 1,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                ),
              ],
            )),
    );
  }
}
