import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/network_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const String kUrl = 'https://rest.coinapi.io/v1/exchangerate';
const String kApiKey = '664D34CD-B857-4E42-9D84-2BD808BCA57F';
// https://rest.coinapi.io/v1/exchangerate/ETH/USD?apikey=664D34CD-B857-4E42-9D84-2BD808BCA57F

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, int?> cryptoRates = {};
  // int? exchangeRate;

  @override
  void initState() {
    super.initState();
    _getAllExchangeRates();
  }
  Future<void> _getAllExchangeRates() async {
    for (String crypto in cryptoList) {
      await getExchangeRate(crypto);
    }
  }

  Future<dynamic> getExchangeRate(String cryptoName) async {
    NetworkHelper networkHelper =
    NetworkHelper('$kUrl/$cryptoName/$selectedCurrency?apikey=$kApiKey');
    var exchangeRateData = await networkHelper.getData();
    print(exchangeRateData);
    double exRate = exchangeRateData['rate'];

    // Trigger a rebuild when exchangeRate is updated
    setState(() {
      cryptoRates[cryptoName] = exRate.round();
    });

    return exchangeRateData;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;

        });
        _getAllExchangeRates();
      },
      value: selectedCurrency,
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          print(selectedCurrency);
        });
        _getAllExchangeRates();
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList.map((cryptoName) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $cryptoName = ${cryptoRates[cryptoName] ?? '?'} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
//TODO: 121224 currently watching "007 Introduction to Boss Level Challenge 3"
