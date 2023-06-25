import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hogwarts Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.8,
        child: MyHomePage(title: 'Hogwarts Calculator'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _possibleCombinationWidget = [];
  int _counter = 0;
  bool isLoading = false;
  final TextEditingController _textController = TextEditingController();

  void _countCurrencyCombinations() {
    context.loaderOverlay.show();
    //reset counter
    _counter = 0;
    String currencyType =
        _textController.text[_textController.text.length - 1].toLowerCase();
    if (currencyType != "g" && currencyType != "s") {
      return;
    }

    double? currency = double.tryParse(
        _textController.text.substring(0, _textController.text.length - 1));
    if (currency == null) {
      return;
    }
    switch (currencyType) {
      case "g":
        currency = currency * 100;
        break;
      default:
        break;
    }
    int parsedCurrency = currency.toInt();

    //start of easy solution, assuming the rest of currency will be fulfilled by 1s
    // //there are always 1 way to count it using 1s (i.e. 1g is always 100s)
    // _counter += 1;
    // //let's count using 5s
    // _counter += parsedCurrency ~/ 5;
    // //let's count using 10s
    // _counter += parsedCurrency ~/ 10;
    // //let's count using 25s
    // _counter += parsedCurrency ~/ 25;
    // //let's count using 50s
    // _counter += parsedCurrency ~/ 50;
    // //let's count using 1G
    // _counter += parsedCurrency ~/ 100;
    // // let's count using 2G
    // _counter += parsedCurrency ~/ 200;

    //end of easy solution
    List<List<int>> possibleCombination = [];
    for (var countFor200
        in List<int>.generate(parsedCurrency ~/ 200 + 1, (i) => i)) {
      for (var countFor100
          in List<int>.generate(parsedCurrency ~/ 100 + 1, (i) => i)) {
        for (var countFor50
            in List<int>.generate(parsedCurrency ~/ 50 + 1, (i) => i)) {
          for (var countFor25
              in List<int>.generate(parsedCurrency ~/ 25 + 1, (i) => i)) {
            for (var countFor10
                in List<int>.generate(parsedCurrency ~/ 10 + 1, (i) => i)) {
              for (var countFor5
                  in List<int>.generate(parsedCurrency ~/ 5 + 1, (i) => i)) {
                for (var countFor1
                    in List<int>.generate(parsedCurrency + 1, (i) => i)) {
                  if (200 * countFor200 +
                          100 * countFor100 +
                          50 * countFor50 +
                          25 * countFor25 +
                          10 * countFor10 +
                          5 * countFor5 +
                          1 * countFor1 ==
                      parsedCurrency) {
                    possibleCombination.add([
                      countFor200,
                      countFor100,
                      countFor50,
                      countFor25,
                      countFor10,
                      countFor5,
                      countFor1
                    ]);
                  }
                }
              }
            }
          }
        }
      }
    }
    List<Widget> possibleCombinationWidget = [];
    //render from highest currency
    for (var element in possibleCombination.reversed) {
      possibleCombinationWidget.add(Text(
          "${element[0].toString()}x2G + ${element[1].toString()}x1G + ${element[2].toString()}x50s + ${element[3].toString()}x25s + ${element[4].toString()}x10s + ${element[5].toString()}x5s + ${element[6].toString()}x1s "));
    }
    setState(() {
      context.loaderOverlay.hide();
      _counter = possibleCombination.length;
      _possibleCombinationWidget = possibleCombinationWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Input number of currency (i.e. 3.5G):',
              ),
              TextField(
                controller: _textController,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                'Possible combinations of the total currency:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _possibleCombinationWidget,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _countCurrencyCombinations,
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }
}
