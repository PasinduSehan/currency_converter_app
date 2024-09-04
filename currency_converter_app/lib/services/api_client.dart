import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final Uri currencyURL = Uri.https("free.currconv.com", "/api/v7/currencies", {"apiKey": "ef6ef6f6c136f9f2e860"});

  Future<List<String>> getCurrencies() async {
    try {
      http.Response res = await http.get(currencyURL);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body["results"] != null) {
          var list = body["results"];
          List<String> currencies = (list.keys).toList();
          return currencies;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching currencies: $e");
      return [];
    }
  }

  Future<double> getRate(String from, String to) async {
    final Uri rateURL = Uri.https("free.currconv.com", "/api/v7/convert", {"apiKey": "ef6ef6f6c136f9f2e860", "q": "$from\_$to", "compact": "ultra"});
    try {
      http.Response res = await http.get(rateURL);
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        return body["$from\_$to"];
      }
      return 0.0;
    } catch (e) {
      print("Error fetching rate: $e");
      return 0.0;
    }
  }
}
