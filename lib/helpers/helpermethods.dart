import 'package:cab_rider/datamodels/address.dart';
import 'package:cab_rider/datamodels/directiondetails.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './requesthelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import '../global_variable.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static Future<String> findCoordinateAddress(Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position
    .longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if(response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = Address(longitude: position.longitude, latitude: position.latitude, placeName: placeAddress,);

      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails?> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

    String url ='https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition
        .longitude}&destination=${endPosition.latitude},'
        '${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if(response == 'failed') {
      return null;
    }
    
    DirectionDetails directionDetails = DirectionDetails(
        distanceText: response['routes'][0]['legs'][0]['distance']['text'],
        durationText: response['routes'][0]['legs'][0]['duration']['text'],
        durationValue: response['routes'][0]['legs'][0]['duration']['value'],
        distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
        encodedPoints: response['routes'][0]['overview_polyline']['points']);

    return directionDetails;
  }
}
