import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    "Accept": "application/json, text/plain, */*",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36",
  };
  
  var response = await http.get(Uri.parse('https://kisskh.nl/api/DramaList/Episode/210121.png?isq=false'), headers: headers);
  print('Episode API response: \${response.statusCode}');
  print('Body: \${response.body}');
}
