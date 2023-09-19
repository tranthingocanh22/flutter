import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constant/dimension_constant.dart';
import '../core/hepper/ImageHelper.dart';
import '../core/hepper/TextStyles.dart';
import '../widgets/app_bar_container.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Place {
  final int id;
  final String thumbnail;
  final String name;
  final int star;

  Place({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.star,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      thumbnail: json['thumbnail'],
      name: json['name'],
      star: json['star'],
    );
  }
}

class HomePageNew extends StatefulWidget {
  const HomePageNew({Key? key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  Future<List<Place>> fetchData() async {
    try {
      final String url = 'http://10.0.2.2:8888/tour';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Place.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  Widget _buildImageHomeScreen(String name, String image) {
    return Container(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.network(
            image,
            width: double.maxFinite,
            height: 200,
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Positioned(
            left: kDefaultPadding,
            bottom: kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.defaultStyle.whiteTextColor.bold,
                ),
                const SizedBox(
                  height: kItemPadding,
                ),
                Container(
                  padding: const EdgeInsets.all(kMinPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMinPadding),
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xffFFC107),
                      ),
                      SizedBox(
                        width: kItemPadding,
                      ),
                      Text('4.5')
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: AppBarContainer(
            titleString: 'home',
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi Guy',
                        style: TextStyles
                            .defaultStyle.fontHeader.whiteTextColor.bold,
                      ),
                      const SizedBox(
                        height: kMediumPadding,
                      ),
                      Text(
                        'Where are you going next ?',
                        style:
                            TextStyles.defaultStyle.fontCaption.whiteTextColor,
                      )
                    ],
                  )
                ],
              ),
            ),
            implementLeading: false,
            child: Column(
              children: [
                TextField(
                  enabled: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Search your destination',
                    // Corrected typo
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.8),
                      child: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          kItemPadding,
                        ),
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: kItemPadding),
                  ),
                  style: TextStyles.defaultStyle,
                  onChanged: (value) {},
                  onSubmitted: (String submitValue) {},
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildButton(
                          "Hotel", "https://i.ibb.co/HhyMJ20/ico-hotel.png"),
                      buildButton("Flights",
                          "https://i.ibb.co/PtFzX2j/ico-hotel-plane.png"),
                      buildButton("All",
                          "https://i.ibb.co/PtFzX2j/ico-hotel-plane.png"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kMediumPadding,
                ),
                Row(
                  children: [
                    Text(
                      'Popular Destinations',
                      style: TextStyles.defaultStyle.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: kMediumPadding,
                ),
                FutureBuilder<List<Place>>(
                  future: fetchData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Place>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    List<Place> place = snapshot.data!;

                    return Expanded(
                      child: CustomScrollView(
                        primary: false,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(0),
                            sliver: SliverGrid.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: place
                                  .map(
                                    (e) => _buildImageHomeScreen(
                                      e.name,
                                      e.thumbnail,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildButton(String label, String imagePath) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.pink, // Đặt màu nền
        ),
        child: Image.network(
          imagePath,
          height: 80, // Đặt chiều cao của hình ảnh
        ),
      ),
      SizedBox(height: 8),
      Text(label),
    ],
  );
}
