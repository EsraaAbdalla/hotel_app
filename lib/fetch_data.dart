// ignore_for_file: prefer_const_declarations, avoid_print

import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final String apiUrl = "https://www.hotelsgo.co/test/hotels";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Request was successful
      print("Response data: ${response.body}");
      // You can parse the response data here or return it as needed
    } else {
      // Request failed with an error code
      print("Request failed with status: ${response.statusCode}");
      print("Error message: ${response.body}");
    }
  } catch (e) {
    // An error occurred
    print("Error: $e");
  }
}

// Example of calling the function
void main() {
  fetchData();
}
