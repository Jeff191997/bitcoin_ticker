import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'AUD';
  // String? bitCoinValue = '?';
  // String? ethereumValue = '?';
  // String? liteCoinValue = '?';
  //
  // CoinData coinData = CoinData();

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      print(data);
      isWaiting = false;
      setState(() {
        // for (String crypto in data.keys) {
        //   if (crypto == 'BTC') {
        //     bitCoinValue = data[crypto];
        //   } else if (crypto == 'ETH') {
        //     ethereumValue = data[crypto];
        //   } else {
        //     liteCoinValue = data[crypto];
        //   }
        // }
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in coinValues.keys) {
      cryptoCards.add(
        CryptoCard(
          crypto: crypto,
          coinValue: coinValues[crypto],
          selectedCurrency: selectedCurrency,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      DropdownMenuItem<String> newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      Text newPickerItem = Text(currency);
      pickerItems.add(newPickerItem);
    }

    return CupertinoPicker(
      useMagnifier: false,
      backgroundColor: Colors.lightBlue,
      itemExtent: 30,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // If I don't use isWaiting here like this and use only makeCards(), the start screen is only showing only white background. If I write
          // like below, the start screen is not blank anymore.
          isWaiting
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CryptoCard(
                      crypto: 'BTC',
                      coinValue: '?',
                      selectedCurrency: selectedCurrency,
                    ),
                    CryptoCard(
                      crypto: 'ETH',
                      coinValue: '?',
                      selectedCurrency: selectedCurrency,
                    ),
                    CryptoCard(
                      crypto: 'LTC',
                      coinValue: '?',
                      selectedCurrency: selectedCurrency,
                    ),
                  ],
                )
              : makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.crypto,
    required this.coinValue,
    required this.selectedCurrency,
  });
  final String? crypto;
  final String? coinValue;
  final String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $coinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
