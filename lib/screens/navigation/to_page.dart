
//import 'dart:html';
/*
import 'dart:ui';

import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_place/google_place.dart';
import 'package:expandable/expandable.dart';
import '../../.env.dart';
import 'location_details.dart';


class UserPosition {
  final Map<String, dynamic>? position;
  //final String? place_id;
  final map_controller;
  final LatLng? center;
  //final String user_id;

  UserPosition(this.map_controller, this.center ,{this.position});//,{this.place_id});
  //UserPosition.position(this.map_controller,this.position, {this.place_id , this.center});//this.user_id);
  //UserPosition.place_id(this.map_controller,this.place_id, { this.position, this.center});//this.user_id);

}

class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}




class _ToPageState extends State<ToPage> {
  late GoogleMapController mapController;
  bool first = true;
  LatLng _center = const LatLng(51.507399, -0.127689);
  final _google_geocode_API = GoogleGeocodingApi(googleAPIKey, isLogged: true); 
  final googlePlace = GooglePlace(googleAPIKey);
  Icon customIcon = const Icon(Icons.search);
  List<LatLng> list_of_destinations = <LatLng>[];
  Set<Marker>? _markers;
  List<AutocompletePrediction> predictions = [];
  bool isSelected = false;
  bool _showDetail = false;
  AutocompletePrediction? currPrediction = null;
  _handleNavigateToNextPage(UserPosition args){
    if(list_of_destinations.isNotEmpty){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
        title : const Text("Have you added all the places you want to visit?"),
        actions : <Widget>[
          TextButton(onPressed: () => Navigator.pop(context, "No")/*_navigateToNextPage(args)*/, child: const Text("Yes")),
          TextButton(onPressed: () => Navigator.pop(context, "No") , child: const Text("No"))
        ]
      )
      );
    }
    else{
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have not added any destinations in your plan! Please choose a destination!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );
    }
  }

  
  _navigateToNextPage(UserPosition args){
    Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyData(
      args, list_of_destinations
    ));

  }

  void autoCompleteSearch(String value) async {
    String edited_value = value + " london";
    var result = await googlePlace.autocomplete.get(edited_value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions as List<AutocompletePrediction>;
      });
    }
  }
  
  _handleSearchBarChange(String destination) async{
    if (destination.isNotEmpty) {
      autoCompleteSearch(destination);
    } else {
      if (predictions.isNotEmpty && mounted) {
        setState(() {
          predictions = [];
        });
      }
    }
  }

  _handleSearchBarSubmit(String destination) async{
      String edited_destination = destination + " London"; 
      GoogleGeocodingResponse loc = await _google_geocode_API.search(edited_destination, region: "uk");
      //Pop that you are adding new destination
      setState(() {
        LatLng pos = LatLng(loc.results.first.geometry!.location.lat, loc.results.first.geometry!.location.lng);
        Marker curr_marker = Marker(markerId: MarkerId(destination), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), position : pos);
        _markers?.add(curr_marker);
        _center = pos;
        list_of_destinations.add(pos);
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
      });
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have added " + destination + " in your plan!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );

      //Navigate to next page
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _handleSuggestionTap(AutocompletePrediction prediction){
    _showDetail = true;
    currPrediction = prediction;
    print(prediction.description as String);
  }

  Widget _showDetailPage(){
    return DetailsPage(placeId: currPrediction!.placeId, googlePlace: googlePlace, closePage: () => 
      setState(() {
        _showDetail = false;
      })
    );
 }

 Widget _getPotentialSearches(BuildContext context, int index) {
  return Card(
    color : Colors.white, 
    child :ListTile(
      tileColor: isSelected ? Colors.white : Colors.blue,
      leading: CircleAvatar(
        child: Icon(
          Icons.pin_drop,
          color: Colors.white,
        ),
      ),
      title:  Text(predictions[index].description as String),
      onTap: _handleSuggestionTap(predictions[index])  
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserPosition;
    _center = args.center as LatLng;
    if(args.center!=null && first) {
      first = false;
      _markers = {Marker(markerId:const MarkerId("current location"), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), position : args.center as LatLng)};
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Destination_Retriever(
              onSubmitted: _handleSearchBarSubmit,
              onChanged: _handleSearchBarChange,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          ),

          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _center, zoom: 15),
                  markers: _markers as Set<Marker>,
                  
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index){
                    return Card(
                      color : Colors.white, 
                      child :ListTile(
                        tileColor: isSelected ? Colors.white : Colors.blue,
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(predictions[index].description as String),
                        onTap: _handleSuggestionTap(predictions[index])  
                      ),
                    );
                  }
                )
              ),
              TextButton(
                onPressed: _handleNavigateToNextPage(args), 
                child: const Text("Lets Go!")
              ),
              
              if(_showDetail) _showDetailPage(),
            ]
          ),
      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever({ Key? key,required this.onSubmitted ,required this.onChanged }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  _Destination_RetrieverState createState() => _Destination_RetrieverState();
}

class _Destination_RetrieverState extends State<Destination_Retriever> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String destination){
    widget.onSubmitted!(destination);
  }

  void _handleChange(String destination){
    if(destination.length > 3){
      widget.onChanged!(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children : <Widget> [
        Expanded(
          child:
            TextField(
              decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              ),
              style: TextStyle(
              color: Colors.white,
              ),
              controller: _controller,
              onSubmitted: (String destination) async {_handleSubmit(destination);},
              onChanged: (String destination) async {_handleChange(destination);},
            )
        )
      ]
    );
  }
}

*/
import 'dart:ui';

import 'package:bike_tour_app/screens/markers/destination_marker.dart';
import 'package:bike_tour_app/screens/navigation/route_choosing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_place/google_place.dart';

import '../../.env.dart';
import 'location_details.dart';


class UserPosition {
  final LatLng? center;
  //final String user_id;

  UserPosition(this.center);//,{this.place_id});
  //UserPosition.position(this.map_controller,this.position, {this.place_id , this.center});//this.user_id);
  //UserPosition.place_id(this.map_controller,this.place_id, { this.position, this.center});//this.user_id);

}

class Destination{
  LatLng position;
  String name;
  Destination({required this.position, required this.name});

}


class ToPage extends StatefulWidget {
  const ToPage({Key? key}) : super(key: key);
  static const routeName = '/toPage';
  @override
  _ToPageState createState() => _ToPageState();
}




class _ToPageState extends State<ToPage> {
  late GoogleMapController mapController;
  bool first = true;
  LatLng _center = const LatLng(51.507399, -0.127689);
  final _google_geocode_API = GoogleGeocodingApi(googleAPIKey, isLogged: true); 
  final googlePlace = GooglePlace(googleAPIKey);
  Icon customIcon = const Icon(Icons.search);
  List<Destination> list_of_destinations = <Destination>[];
  Set<Marker>? _markers;
  List<AutocompletePrediction> predictions = [];
  AutocompletePrediction? currPrediction = null;
  bool isSelected = false;
  bool _showDetail = false;
  Marker? _suggestedMarker = null;

  _handleNavigateToNextPage(UserPosition args){
    if(list_of_destinations.isNotEmpty){
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
        title : const Text("Have you added all the places you want to visit?"),
        actions : <Widget>[
          TextButton(onPressed: () =>_navigateToNextPage(args), child: const Text("Yes")),
          TextButton(onPressed: () => Navigator.pop(context, "No") , child: const Text("No"))
        ]
      )
      );
    }
    else{
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have not added any destinations in your plan! Please choose a destination!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );
    }
  }

  
  _navigateToNextPage(UserPosition args){
    Navigator.pushNamed(context, RoutingMap.routeName, arguments : JourneyData(
      args, list_of_destinations
    ));

  }

  void autoCompleteSearch(String value) async {
    String edited_value = value + " london";
    var result = await googlePlace.autocomplete.get(edited_value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        _showDetail = false;
        predictions = result.predictions as List<AutocompletePrediction>;
      });
    }
  }
  _handleSearchBarChange(String destination) async{
    if (destination.isNotEmpty) {
      autoCompleteSearch(destination);
    } else {
      if (predictions.isNotEmpty && mounted) {
        setState(() {
          predictions = [];
        });
      }
    }
  }

  _handleSearchBarSubmit(String destination) async{
      String edited_destination = destination + " London"; 
      String description =' ';
      GoogleGeocodingResponse loc = await _google_geocode_API.search(edited_destination, region: "uk");
      //Pop that you are adding new destination
      setState(() {
        LatLng pos = LatLng(loc.results.first.geometry!.location.lat, loc.results.first.geometry!.location.lng);
        description = loc.results.first.formattedAddress;
        Destination dest = Destination(position: pos, name: description);
        Marker curr_marker = DestinationMarker(destination: dest); 
        _markers?.add(curr_marker);
        _center = pos;
        list_of_destinations.add(dest);
        mapController.animateCamera(CameraUpdate.newLatLng(_center));
      });
      showDialog(context: context, builder: (BuildContext context)=> AlertDialog(
      title : Text("You have added " + description + " in your plan!"),
      actions : <Widget>[
        TextButton( onPressed: () => Navigator.pop(context, "No") , child: const Text("Ok!"))
      ]
    )
    );

      //Navigate to next page
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _handleSuggestionTap(AutocompletePrediction prediction) async{
    GoogleGeocodingResponse loc = await _google_geocode_API.search(prediction.description as String, region: "uk");
    setState(() {
      _showDetail = true;
      currPrediction = prediction;
      LatLng pos = LatLng(loc.results.first.geometry!.location.lat, loc.results.first.geometry!.location.lng);
      _suggestedMarker = Marker(markerId: MarkerId(prediction.description as String), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), position : pos);
      _markers?.add(_suggestedMarker as Marker);
      print(_markers?.length);
      _center = pos;
      mapController.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  _closePage() async{
    setState(() {
      _showDetail = false;
      _markers?.remove(_suggestedMarker);
      _suggestedMarker = null;
    });
    //_showDetail = false;
    //_markers?.remove(_suggestedMarker);
    //_suggestedMarker = null;
  }

   Widget _showDetailPage(){
    return DetailsPage(placeId: currPrediction!.placeId, googlePlace: googlePlace, 
    closePage: _closePage
    );
  }



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserPosition;
    _center = args.center as LatLng;
    if(args.center!=null && first) {
      first = false;
      _markers = {Marker(markerId:const MarkerId("current location"), icon : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), position : args.center as LatLng)};
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Destination_Retriever(
              onSubmitted: _handleSearchBarSubmit,
              onChanged: _handleSearchBarChange,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
              IconButton(
                icon : Icon(Icons.arrow_circle_right_outlined),
                onPressed:()=> _handleNavigateToNextPage(args), 
              ),
              IconButton(icon: Icon(Icons.route_outlined),onPressed: () => _showDestinations() ),
          ],
          ),

          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _center, zoom: 15),
                  markers: _markers as Set<Marker>,
                  
                ),
              ),
              if(!_showDetail) 
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color : Colors.white, 
                      child :ListTile(
                        tileColor: isSelected ? Colors.white : Colors.blue,
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(predictions[index].description as String),
                        onTap: () { _handleSuggestionTap(predictions[index]);
                          //need to shrink it too
                          // argument is predictions[index], AutoComplete thing
                          //first fill
                          //debugPrint(predictions[index].placeId);
                          //Navigator.push(
                          //  context,
                          //  MaterialPageRoute(
                          //    builder: (context) => DetailsPage(
                          //      placeId: predictions[index].placeId,
                          //      googlePlace: googlePlace,
                          //    ),
                          //  ),
                          //);

                        },
                      )
                    );
                  },
                ),
              ),

              if(_showDetail && currPrediction != null ) _showDetailPage(),
            ]
          ),
      )
    );
  }


  //void _generateBikeMarkers(){
    //List<BikeDockPoint> stations = FirebaseFunctions.instance('getBikeStations');

  //}

}

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever({ Key? key,required this.onSubmitted ,required this.onChanged }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  _Destination_RetrieverState createState() => _Destination_RetrieverState();
}

class _Destination_RetrieverState extends State<Destination_Retriever> {



  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String destination){
    widget.onSubmitted!(destination);
  }

  void _handleChange(String destination){
    if(destination.length > 3){
      widget.onChanged!(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children : <Widget> [
        Expanded(
          child:
            TextField(
              decoration: InputDecoration(
              hintText: 'Where do you want to go?',
              hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              ),
              style: TextStyle(
              color: Colors.white,
              ),
              controller: _controller,
              onSubmitted: (String destination) async {_handleSubmit(destination);},
              onChanged: (String destination) async {_handleChange(destination);},
            )
        )
      ]
    );
  }
}