import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_app/components/manor_temperatur_widget.dart';
import 'package:first_app/repository/contents_repository.dart';
import 'package:first_app/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ContentRepository contentRepository = ContentRepository();
  Size? size;
  List<String>? imgList;
  int _current = 0;
  double scrollPosition = 0;
  final ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  bool isMyFavoriteContent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    _loadMyFavoriteContentState();

    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollPosition = 255;
        } else {
          scrollPosition = _controller.offset;
        }

        _animationController.value = scrollPosition / 255;
      });
    });
  }

  _loadMyFavoriteContentState() async {
    bool ck = await contentRepository
        .isMyFavoriteContents(widget.data["cid"].toString());

    setState(() {
      isMyFavoriteContent = ck;
    });
  }

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
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: _colorTween.value),
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPosition.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: () async {
          await contentRepository.loadFavoriteContents();
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.share),
        ),
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"].toString(),
            child: CarouselSlider(
              items: imgList!.map((url) {
                return Image.asset(url, width: size!.width, fit: BoxFit.fill);
              }).toList(),
              // carouselController: _controller,
              options: CarouselOptions(
                  height: size!.width,
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList!.asMap().entries.map((entry) {
                return GestureDetector(
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("호오지",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                "제주시 도담동",
              ),
            ],
          ),
          Expanded(
            child: ManorTemperature(
              manorTemp: 37.5,
            ),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 1,
        color: Colors.grey.withOpacity(0.3));
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          Text(widget.data["title"].toString(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Text("디지털/가전 • 22시간 전",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          const Text("선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
              style: TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 15),
          const Text("채팅 3 • 관심 17 • 조회 295",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "모두 보기",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _makeSliderImage(),
              _sellerSimpleInfo(),
              _line(),
              _contentDetail(),
              _line(),
              _otherCellContents(),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            delegate: SliverChildListDelegate(
              List.generate(
                20,
                (index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey,
                            height: 120,
                          ),
                        ),
                        const Text(
                          "상품 제목",
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          "금액",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: size!.width,
      height: 65,
      child: Row(
        children: [
          ScaffoldMessenger(
            key: scaffoldKey,
            child: GestureDetector(
              onTap: () async {
                if (isMyFavoriteContent) {
                  await contentRepository
                      .deleteMyFavoriteContent(widget.data['cid'].toString());
                } else {
                  await contentRepository.addMyFavoriteContent(widget.data);
                }
                setState(() {
                  isMyFavoriteContent = !isMyFavoriteContent;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 1000),
                    content: Text(isMyFavoriteContent
                        ? "관심목록에 추가됐습니다."
                        : "관심목록에서 제거됐습니다."),
                  ),
                );
              },
              child: SvgPicture.asset(
                isMyFavoriteContent
                    ? "assets/svg/heart_on.svg"
                    : 'assets/svg/heart_off.svg',
                width: 25,
                height: 25,
                color: const Color(0xfff08f4f),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DataUtils.calcStringToWon(widget.data["price"].toString()),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xfff08f4f),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
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
