// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  const MySlider({super.key});

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _currentValue = 50.0; // Initial value
  double _minValue = 20;
  double _maxValue = 540;

  @override
  Widget build(BuildContext context) {
    int currentInt = _currentValue.toInt();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Row(
            children: [
              const Text(
                'PRICE PER NIGHT',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all()),
                child: Center(
                    child: Text(
                  '$currentInt+ \$',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        Slider(
          value: _currentValue,
          min: _minValue,
          max: _maxValue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' \$$_minValue',
                style: TextStyle(
                    color: const Color.fromARGB(255, 131, 130, 130),
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '\$$_maxValue+',
                style: TextStyle(
                    color: const Color.fromARGB(255, 131, 130, 130),
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
