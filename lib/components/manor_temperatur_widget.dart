import 'package:flutter/material.dart';

class ManorTemperature extends StatelessWidget {
  double? manorTemp;
  int level = 0;
  List<Color> temperColors = [
    const Color(0xff072038),
    const Color(0xff0d3a65),
    const Color(0xff186ec0),
    const Color(0xff37b24d),
    const Color(0xffffad13),
    const Color(0xfff76707),
  ];

  ManorTemperature({Key? key, this.manorTemp}) : super(key: key) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (manorTemp! <= 20) {
      level = 0;
    } else if (manorTemp! > 20 && manorTemp! <= 32) {
      level = 1;
    } else if (manorTemp! > 32 && manorTemp! <= 36.5) {
      level = 2;
    } else if (manorTemp! > 36.5 && manorTemp! <= 40) {
      level = 3;
    } else if (manorTemp! > 40 && manorTemp! <= 50) {
      level = 4;
    } else if (manorTemp! > 50) {
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$manorTemp℃",
            style: TextStyle(
                color: temperColors[level],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                height: 6,
                color: Colors.black.withOpacity(.2),
                child: Row(
                  children: [
                    Container(
                        height: 6,
                        width: 75 / 100 * manorTemp!,
                        color: temperColors[level])
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _makeTempLabelAndBar(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                width: 30,
                height: 30,
                child: Image.asset('assets/images/level-$level.jpg'),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("매너온도",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  color: Colors.grey)),
        ],
      ),
    );
  }
}
