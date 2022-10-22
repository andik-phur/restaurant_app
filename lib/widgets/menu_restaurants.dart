import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final String image;

  const MenuCard({Key? key, required this.name, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: 150,
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(image),
              Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width * 0.015,
                ),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: screenSize.width * 0.03,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Text(
            'Rp 165k',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenSize.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }
}
