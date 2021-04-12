import 'package:flutter/material.dart';

class PoiOverview extends StatelessWidget {
  final String title;
  final String description;


  PoiOverview({@required this.title,@required this.description});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.amber,
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 32,
                        child: Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        height: 22,
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text('Details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
