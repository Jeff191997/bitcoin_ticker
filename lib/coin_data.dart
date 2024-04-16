import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '74EC9D4C-82AF-4EC7-9334-8EFE7B86A016';

class CoinData {
  Future getCoinData(String? selectedCurrency) async {
    String? currency = selectedCurrency;
    http.Response response = await http.get(Uri.parse('$coinAPIUrl/BTC/$currency?apikey=$apiKey'));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedJson = jsonDecode(data);
      var lastPrice = decodedJson['rate'];
      return lastPrice.toStringAsFixed(0);
    } else {
      print(response.statusCode);
    }
  }
}
