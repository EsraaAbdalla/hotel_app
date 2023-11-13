// ignore_for_file: file_names

import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int numberOfStars;

  const StarRating({Key? key, required this.numberOfStars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          size: 15,
          color: index < numberOfStars ? Colors.yellow : Colors.grey,
        ),
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for the shadow
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Set border radius
      ),

      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  widget.hotel['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StarRating(numberOfStars: widget.hotel['starts']),
                    const SizedBox(
                      width: 1,
                    ),
                    const Text('Hotel'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.hotel['name'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 30,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 24, 77, 26),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          ' ${widget.hotel['review_score']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.hotel['review']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    const Icon(
                      Icons.location_on_sharp,
                      size: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Text(
                      '${widget.hotel['address']}',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 169, 221, 226),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Our lowest price',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 82, 80, 80),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                color: const Color.fromRGBO(38, 129, 41, 1),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            Text(
                              '${widget.hotel['price']}',
                              style: TextStyle(
                                  color: const Color.fromRGBO(38, 129, 41, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Text(
                                    'View Deal',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                    size: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Renaissance'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'More prices',
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
