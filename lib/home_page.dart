// ignore_for_file: library_private_types_in_public_api, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hotel_app/HotelCard.dart';
import 'package:hotel_app/slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  _HotelListScreenState createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  late Future<List<Map<String, dynamic>>> hotels;
  int selectedSortIndex = -1;
  bool _sortingInProgress = false;
  bool _sortingInPrice = false;
  int line = 0;

  @override
  void initState() {
    super.initState();
    hotels = fetchHotels();
  }

  Future<List<Map<String, dynamic>>> fetchHotels() async {
    final response =
        await http.get(Uri.parse('https://www.hotelsgo.co/test/hotels'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> hotels =
          data.map((dynamic item) => item as Map<String, dynamic>).toList();

      // Sort hotels based on the rating if "Rating only" is selected

      return hotels;
    } else {
      throw Exception('Failed to fetch hotels from the API');
    }
  }

  void _sortCards() {
    if (!_sortingInProgress) {
      setState(() {
        _sortingInProgress = true;
      });

      hotels = hotels.then((cards) {
        cards.sort((a, b) => b['review_score'].compareTo(a['review_score']));
        setState(() {
          _sortingInProgress = false;
        });
        return cards;
      });
    } else {}
  }

  void _sortCardsPrice() {
    if (!_sortingInPrice) {
      setState(() {
        _sortingInPrice = true;
      });

      hotels = hotels.then((cards) {
        cards.sort((a, b) => a['price'].compareTo(b['price']));
        setState(() {
          _sortingInPrice = false;
        });
        return cards;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your expanded content
          Positioned.fill(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: hotels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hotels available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final hotel = snapshot.data![index];
                      return HotelCard(hotel: hotel);
                    },
                  );
                }
              },
            ),
          ),
          // Your fixed container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    ),
                  ],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _showFilterModalBottomSheet(context);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          line = 1;
                        });

                        _showFilterModalBottomSheet(context);
                      },
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 22,
                          decoration: line == 1
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          //  fontWeight: FontWeight.w500,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.sort,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _showSortModalBottomSheet(context);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          line = 2;
                        });

                        _showSortModalBottomSheet(context);
                      },
                      child: Text(
                        'Sort',
                        style: TextStyle(
                          decoration: line == 2
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontSize: 22,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ink(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Sort by',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_outlined),
                        onPressed: () {
                          setState(() {
                            line = 0;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),

                ListTile(
                  title: const Text(
                    'Our recommendations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: selectedSortIndex == 0
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    // Handle sorting by recommendations
                    setState(() {
                      line = 0;
                      selectedSortIndex = selectedSortIndex == 0 ? -1 : 0;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pop(context);
                    });
                    // Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Rating & Recommended',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 1
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      line = 0;
                      // Handle sorting by recommendations
                      setState(() {
                        selectedSortIndex = selectedSortIndex == 1 ? -1 : 1;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    } // Navigator.pop(context);
                    ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Price & Recommended',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 2
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      line = 0;
                      // Handle sorting by recommendations
                      setState(() {
                        selectedSortIndex = selectedSortIndex == 2 ? -1 : 2;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    } //
                    ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Distance & Recommended',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 3
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      line = 0;
                      // Handle sorting by recommendations
                      setState(() {
                        selectedSortIndex = selectedSortIndex == 3 ? -1 : 3;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    } //
                    ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Rating only',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 4
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        line = 0;
                        selectedSortIndex = selectedSortIndex == 4 ? -1 : 4;
                        _sortCards(); // Reload hotels after sorting option is changed
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    }),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Price only',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 5
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      // Handle sorting by recommendations
                      setState(() {
                        line = 0;
                        selectedSortIndex = selectedSortIndex == 5 ? -1 : 5;
                        _sortCardsPrice();
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    } //
                    ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Distance only',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: selectedSortIndex == 6
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      // Handle sorting by recommendations
                      setState(() {
                        line = 0;
                        selectedSortIndex = selectedSortIndex == 6 ? -1 : 6;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    } //
                    ),
                const Divider(),
                // Add more sorting options as needed
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.99, // Set the desired height
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ink(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.31,
                            ),
                            const Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_outlined),
                      onPressed: () {
                        setState(() {
                          line = 0;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const MySlider(),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                child: Text(
                  'RATING',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    RatingContainer(
                      number: '0+',
                      backgroundColor: Color.fromARGB(255, 218, 51, 39),
                    ),
                    RatingContainer(
                      number: '7+',
                      backgroundColor: Color.fromARGB(255, 231, 139, 0),
                    ),
                    RatingContainer(
                      number: '7.5+',
                      backgroundColor: Color.fromARGB(255, 71, 163, 74),
                    ),
                    RatingContainer(
                      number: '8+',
                      backgroundColor: Color.fromARGB(255, 55, 126, 57),
                    ),
                    RatingContainer(
                      number: '8.5+',
                      backgroundColor: Color.fromARGB(255, 36, 90, 38),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'HOTEL CLASS',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StarRatingContainer(
                        borderColor: Colors.yellow,
                        numberOfStars: 2,
                        starColor: Colors.yellow,
                        starSize: 15),
                    StarRatingContainer(
                        borderColor: Colors.yellow,
                        numberOfStars: 2,
                        starColor: Colors.yellow,
                        starSize: 15),
                    StarRatingContainer(
                        borderColor: Colors.yellow,
                        numberOfStars: 3,
                        starColor: Colors.yellow,
                        starSize: 15),
                    StarRatingContainer(
                        borderColor: Colors.yellow,
                        numberOfStars: 4,
                        starColor: Colors.yellow,
                        starSize: 15),
                    StarRatingContainer(
                        borderColor: Colors.yellow,
                        numberOfStars: 5,
                        starColor: Colors.yellow,
                        starSize: 15),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                child: Text(
                  'DISTANCE FROM',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 20, bottom: 5),
                    child: Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 128, 126, 126)),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Text(
                            'City Center',
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          )
                        ],
                      ))
                ],
              ),
              const Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.11,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Show results',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class StarRatingContainer extends StatelessWidget {
  final int numberOfStars;
  final Color starColor;
  final Color borderColor;
  final double starSize;

  StarRatingContainer({
    required this.numberOfStars,
    required this.starColor,
    required this.borderColor,
    required this.starSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (numberOfStars >= 2)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStar(0),
                _buildStar(1),
              ],
            ),
          if (numberOfStars == 3 || numberOfStars == 5)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStar(2),
              ],
            ),
          if (numberOfStars == 4)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStar(0),
                _buildStar(1),
              ],
            ),
          if (numberOfStars == 5)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStar(3),
                _buildStar(4),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    return Container(
      // padding: EdgeInsets.all(1.0),
      child: Icon(
        index < numberOfStars ? Icons.star : Icons.star_border,
        size: starSize,
        color: index < numberOfStars ? starColor : borderColor,
      ),
    );
  }
}

// rt 'package:flutter/material.dart';
class RatingContainer extends StatelessWidget {
  final String number;
  final Color backgroundColor;
  final double width;
  final double height;

  const RatingContainer({
    super.key,
    required this.number,
    this.backgroundColor = Colors.blue,
    this.width = 60.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

// class ImageContainer extends StatelessWidget {
//   final String assetPath;
//   final double containerWidth;
//   final double containerHeight;
//   final Color borderColor;

//   ImageContainer({
//     required this.assetPath,
//     required this.containerWidth,
//     required this.containerHeight,
//     required this.borderColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: containerWidth,
//       height: containerHeight,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: borderColor,
//           width: 2.0, // Set your desired border width
//         ),
//       ),
//       child: Center(
//         child: Image.asset(
//           assetPath,
//           fit: BoxFit.fill,
//         ),
//       ),
//     );
//   }
// }
