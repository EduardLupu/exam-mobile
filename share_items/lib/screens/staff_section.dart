import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:share_items/api/api.dart';
import 'package:share_items/models/item.dart';
import 'package:share_items/screens/edit_item.dart';
import 'package:share_items/widgets/message.dart';

import '../api/network.dart';
import '../services/database_helper.dart';

class StaffSection extends StatefulWidget {
  @override
  _StaffSectionState createState() => _StaffSectionState();
}

class _StaffSectionState extends State<StaffSection> {
  var logger = Logger();
  bool online = true;
  late List<Item> carsTypes = [];
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
      getCarsTypes();
    });
  }

  getCarsTypes() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    logger.log(Level.info, 'getDiscountedItems');
    try {
      if (online) {
        carsTypes = await ApiService.instance.getNotSoldCars();
      } else {
        message(context, "No internet connection", "Error");
      }
    } catch (e) {
      logger.log(Level.error, e.toString());
      message(context, "Error loading items from server", "Error");
    }
    setState(() {
      isLoading = false;
    });
  }

  // updatePrice(Item item) async {
  //   if (!mounted) return;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   logger.log(Level.info, 'updatePrice');
  //   try {
  //     if (online) {
  //       ApiService.instance.updatePrice(item.id!, item.type);
  //     } else {
  //       message(context, "No internet connection", "Error");
  //     }
  //   } catch (e) {
  //     logger.log(Level.error, e.toString());
  //     message(context, "Error updating price", "Error");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Staff section'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ListView(children: [
                ListView.builder(
                  itemCount: carsTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(carsTypes[index].name!),
                      subtitle: Text(
                          '${carsTypes[index].supplier}, ${carsTypes[index].details}, ${carsTypes[index].status}, ${carsTypes[index].quantity}, ${carsTypes[index].type}'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditItemPage(item: carsTypes[index])))
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              //updatePrice(value);
                            });
                          }
                        });
                      },
                    );
                  },
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                )
              ])));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
