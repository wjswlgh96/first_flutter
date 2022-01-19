import 'package:first_app/pages/detail.dart';
import 'package:first_app/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation = "ara";
  ContentRepository contentRepository = ContentRepository();
  final Map<String, String> locationTypeToString = {
    "ara": '아라동',
    "ora": '오라동',
    "mia": "미아동"
  };

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // ignore: avoid_print
          print('Click');
        },
        onLongPress: () {
          // ignore: avoid_print
          print("Long pressed!!");
        },
        child: PopupMenuButton<String>(
          offset: const Offset(0, 25),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String where) {
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext _context) {
            return [
              const PopupMenuItem(value: 'ara', child: Text("아라동")),
              const PopupMenuItem(value: 'ora', child: Text("오라동")),
              const PopupMenuItem(value: 'mia', child: Text("미아동")),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation].toString()),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/svg/bell.svg', width: 22)),
      ],
    );
  }

  final oCcy = NumberFormat("#,###", 'ko_KR');
  String calcStringToWon(String priceString) {
    if (priceString == '무료나눔') return priceString;

    return "${oCcy.format(int.parse(priceString))}원";
  }

  _loadContents() {
    return contentRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return DetailContentView(data: datas[index]);
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: datas[index]["cid"].toString(),
                    child: Image.asset(
                      datas[index]["image"].toString(),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(datas[index]["title"].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 5),
                        Text(
                          datas[index]["location"].toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                        const SizedBox(height: 5),
                        Text(calcStringToWon(datas[index]["price"].toString()),
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/svg/heart_off.svg',
                                    width: 13, height: 13),
                                const SizedBox(width: 5),
                                Text(datas[index]["likes"].toString())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.1),
        );
      },
      itemCount: 10,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return _makeDataList(snapshot.data);
        } else if (!snapshot.hasData) {
          return const Center(child: Text("해당 지역에 데이터가 없습니다."));
        }

        return const Center(child: Text("데이터 오류"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
