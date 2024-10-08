import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';


import '../data/dispatch.dart';
import '../data/dispatch_list.dart';
import '../theme/colors.dart';
import '../widget/button_widget.dart';


const List<String> list = <String>['Cash', 'Debit', 'BLUE'];
String dropdown = 'Cash';
final TextEditingController amountController = TextEditingController();

class CompletedDispatchPage extends StatelessWidget {
  Dispatch dispatch;

  CompletedDispatchPage(this.dispatch);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/yourtaxi.png',height: 75,width: 150,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 25,
                      right: 25,
                    ),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.03),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 10),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            // decoration: BoxDecoration(
                            //   color: arrowbgColor,
                            //   borderRadius: BorderRadius.circular(15),
                            //   // shape: BoxShape.circle
                            // ),
                            child: Center(
                                child: Icon(
                              Icons.payment,
                              color: Colors.black,
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children:  [
                                      Text(
                                        "Payment Type",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: black,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, left: 8.0),
                                        child: DropdownButtonExample(),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 24.0),
                                          child: TextField(
                                            controller: amountController,
                                            keyboardType:
                                                TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[CurrencyTextInputFormatter(
                                              decimalDigits: 1,
                                              locale: 'en',
                                              symbol: 'CAD \$',
                                            )],
                                            decoration: InputDecoration(
                                              hoverColor: Colors.black,
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 3,
                                                    color:
                                                        Colors.amberAccent),
                                              ),
                                              labelText: 'Enter Your Amount',
                                              labelStyle: TextStyle(
                                                fontSize: 15,
                                                color: black,
                                              ),
                                              alignLabelWithHint: false,
                                              hintText: 'Amount',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonWidget(
                text: 'Submit',
                onClicked: () async{
                  try{

                    //get dropdown value  = dropdown
                    String amountWithoutDollarSign = amountController.text.replaceAll("CAD \$", "");
                    amountController.text = '';
                    if(amountWithoutDollarSign !=''){
                      // final secondRow = {
                      //   'N/F': '15',
                      //   'WC': '1f',
                      //   'TC': '1Debit',
                      //   'label': '1f6',
                      // };
                      // };

                      //print('sending values to sheets');
                      //update dispatch
                      dispatch.paymentType = dropdown;
                      dispatch.fare = double.parse(amountWithoutDollarSign);
                      dispatch.submittedTime = DateTime.now().toString();
                      DispatchList.updateDispatch(dispatch);
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/", (r) => false);
                    }

                  }
                  catch(e){
                    print(e);
                  }

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          dropdown= value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
