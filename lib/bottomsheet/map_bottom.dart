import 'package:flutter/material.dart';

class MapBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      'Show Details',
                      style: TextStyle(
                        color: Colors.purple[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'drawable/navigation',
                      width: 20,
                      height: 20,
                      color: Colors.purple[500],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'RE-CENTER',
                      style: TextStyle(
                        color: Colors.purple[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
