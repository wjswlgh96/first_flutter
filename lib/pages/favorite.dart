import 'package:first_app/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../repository/contents_repository.dart';
import 'detail.dart';

class MyFavoriteContents extends StatefulWidget {
  const MyFavoriteContents({Key? key}) : super(key: key);

  @override
  MyFavoriteContentsState createState() => MyFavoriteContentsState();
}

class MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentRepository contentRepository = ContentRepository();
  late Future<List<dynamic>> dataList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      dataList = _loadMyFavoriteContentList();
    });
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: const Text(
        "관심목록",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: dataList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('snapshot:  ${snapshot.data}');

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

  Future<List<dynamic>> _loadMyFavoriteContentList() async {
    return await contentRepository.loadFavoriteContents();
  }

  _makeDataList(List<dynamic> datas) {
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
            ).then((value) {
              setState(() {
                dataList = _loadMyFavoriteContentList();
              });
            });
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
                        Text(
                            DataUtils.calcStringToWon(
                                datas[index]["price"].toString()),
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
      itemCount: datas.length,
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
