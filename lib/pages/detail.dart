import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<String> imgList;
  int _current = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
      widget.data["image"].toString(),
    ];

    print(imgList);
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _bodyWidget() {
    return Container(
      child: Column(
        children: [
          Hero(
            tag: widget.data["cid"].toString(),
            child: CarouselSlider(
              items: List.generate(5, (index) {
                return Image.asset(widget.data["image"].toString(),
                    width: size.width, fit: BoxFit.fill);
              }),
              // carouselController: _controller,
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: imgList.asMap().entries.map((entry) {
          //     return GestureDetector(
          //       child: Container(
          //         width: 12.0,
          //         height: 12.0,
          //         margin: const EdgeInsets.symmetric(
          //             vertical: 8.0, horizontal: 4.0),
          //         decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: (Theme.of(context).brightness == Brightness.dark
          //                     ? Colors.white
          //                     : Colors.black)
          //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ],
      ),
    );
  }

  Widget _bottomBarWidget() {
    return Container(width: size.width, height: 55, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
      extendBodyBehindAppBar: true,
    );
  }
}
