import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CitySearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  final List<String> cities = [
    "Agra", "Ahmedabad", "Aligarh", "Amreli", "Anand", "Bareilly", "Bengaluru",
    "Bharuch", "Bhavnagar", "Bhopal", "Botad", "Bhubaneswar", "Chandigarh","Chalala",
    "Chennai", "Chhota Udaipur", "Deesa", "Delhi", "Dhanbad", "Dholka", "Dhoraji",
    "Faridabad", "Gandhinagar", "Ghaziabad", "Godhra", "Gondal", "Guntur",
    "Gurgaon", "Guwahati", "Halvad", "Hubli–Dharwad", "Hyderabad", "Indore",
    "Jaipur", "Jalandhar", "Jamnagar", "Jamshedpur", "Jasdan","Jetpur", "Jodhpur",
    "Junagadh", "Kalol", "Kanpur", "Kapadvanj", "Kadi", "Kalyan-Dombivli", "Kolkata",
    "Kota", "Lucknow", "Ludhiana", "Lunawada", "Manavadar", "Mahuva", "Mandvi",
    "Mehsana", "Meerut", "Modasa", "Moradabad", "Morbi", "Mumbai", "Mysore",
    "Nadiad", "Nagpur", "Nashik", "Navsari", "Noida", "Palanpur", "Patdi", "Patna",
    "Pune", "Porbandar", "Raipur", "Rajkot", "Rajpur Sonarpur", "Ranchi",
    "Salem", "Savarkundla", "Solapur", "Srinagar", "Surat", "Surendranagar",
    "Thane", "Tiruchirappalli", "Tiruppur", "Udaipur", "Una", "Vadodara", "Valsad",
    "Varanasi", "Vapi", "Vasai-Virar", "Veraval", "Visakhapatnam", "Wankaner",
    "Warangal"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text("Search City"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TypeAheadField<String>(
          controller: _controller,
          suggestionsCallback: (pattern) async {
            return cities
                .where((city) =>
                city.toLowerCase().startsWith(pattern.toLowerCase()))
                .toList();
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Enter city name",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade800,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
            );
          },
          itemBuilder: (context, city) {
            return ListTile(
              title: Text(city),
            );
          },
          onSelected: (city) {
            Navigator.pop(context, city);
          },
        ),
      ),
    );
  }
}
