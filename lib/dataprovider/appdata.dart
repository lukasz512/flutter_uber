import 'package:cab_rider/datamodels/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {

  late Address pickupAddress = Address();
  late Address destinationAddress;

  void updatePickupAddress(Address pickup) {
    pickupAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }
}