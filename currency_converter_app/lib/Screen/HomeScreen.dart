import 'package:flutter/material.dart';
import 'package:currency_converter_app/services/api_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiClient client = ApiClient();
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  List<String> currencies = [];
  String from = '';
  String to = '';
  double rate = 0.0;
  String result = "";

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  void fetchCurrencies() async {
    List<String>? list = await client.getCurrencies();
    setState(() {
      currencies = list ?? [];
      if (currencies.isNotEmpty) {
        from = currencies[0];
        to = currencies.length > 1 ? currencies[1] : currencies[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 208,
                child: Text(
                  "CURRENCY CONVERTER",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onSubmitted: (value) async {
                          rate = await client.getRate(from, to);
                          setState(() {
                            result =
                                (rate * double.parse(value)).toStringAsFixed(3);
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Input Value to Convert',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: secondColor,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropDown(currencies, from, (val) {
                            setState(() {
                              from = val!;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                String temp = from;
                                from = to;
                                to = temp;
                              });
                            },
                            child: Icon(Icons.swap_horiz),
                            elevation: 0,
                            backgroundColor: secondColor,
                          ),
                          customDropDown(currencies, to, (val) {
                            setState(() {
                              to = val!;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Result",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              result,
                              style: TextStyle(
                                color: secondColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customDropDown(
  List<String> items,
  String value,
  ValueChanged<String?> onChange,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: DropdownButton<String>(
      value: value.isNotEmpty ? value : null,
      hint: Text("Select Currency"),
      onChanged: onChange,
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
    ),
  );
}
