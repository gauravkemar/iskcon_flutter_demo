import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 3,
            width: 40,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: Colors.grey,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.yellow.shade800),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Srila Krsnadasa Kaviraja Gosvami Samadhi',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'PLACE :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            textAlign: TextAlign.justify,
                            'Srila Krsnadasa Kaviraja Gosvami Samadhi',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          /* SizedBox(height: 10),
                          Text(
                            'TITLE 2',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                              margin: EdgeInsets.all(10),
                              height: 200,
                              child: ViewPagerWidget()
                          )], // Replace with your custom ViewPager widget
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Speak button action
                            },
                            icon: Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            onPressed: () {
                              // Stop button action
                            },
                            icon: Icon(Icons.stop),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Slider(
                                value: 0.0, // Set initial value here
                                onChanged: (double value) {
                                  // Slider value change action
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Volume button action
                            },
                            icon: Icon(Icons.volume_up),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            textAlign: TextAlign.justify,
                            'DESCRIPTION :',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            textAlign: TextAlign.justify,
                            "He was a brahmana by caste from the Varendra clan," +
                                " and a disciple of Narottama Thakura. " +
                                " He was also known as Thakura Cakravarti.Ganganarayana's" +
                                " Shripata is situated at the village Gambhila, now known as Gamla," +
                                " falling within Baluchar of the Mursidabad district.  He was a highly respected erudite scholar." +
                                " It is said that he provided his five hundred students with food daily.  " +
                                " His wife was Narayani devi and daughter Vishnupriya, both of whom were deeply religious and " +
                                " received their diksa from Ganganarayana.  As he had no son of his own, Ganganarayana adopted " +
                                " Krishnacarana, the youngest son of his God-brother, Ramakrishna Acarya (alias Cakravarti). " +
                                " \n\n Ganganarayana's exemplary performance of sadhana, bhajan, and austerity made him popular amongst the" +
                                " devotees of Vrndavana.  The wellA known Visvanatha Cakravarti was one of Ganganarayana's students.  " +
                                " Books such as Bhaktiratnakara, Premavilasa, and Narottamavilasa provide references on Ganganarayana.   " +
                                " \n\n During the earlier stages of Ganganarayana's life he was an arrogant scholar, so much so, " +
                                " that he even had no respect for Narottama Thakura. However, through the association of Harirama Acarya," +
                                " a disciple of Narottama Thakura, Ganganarayana was eventually convinced of the spiritual " +
                                " excellence of Narottama.  Later Narottama showered his blessings upon Ganganarayana (Narottamavilasa)." +
                                " \n\n When Ganganarayana approached Narottama for diksa the latter remarked: You are a brahmana by caste, " +
                                " if you behave like this (i.e. if you seek diksa from a Kayastha who is considered lower than a brahmana) " +
                                " then what will be the reaction of the brahmanas of the land?    At this Ganganarayana replied, Does he, " +
                                " on whom you choose to shower your mercy, care about what a brahmana who is devoid of bhakti thinks?    " +
                                " Because he took diksa from a Kayastha, Ganganarayana, who had a large number of disciples, " +
                                " had to bear the criticisms hurled at him by countless brahmanas. However, in due course of time, " +
                                " all those brahmanas who had previously " +
                                " antagonized Ganganarayana, eventually surrendered at his feet and received diksa from him.",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
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
}

class ViewPagerWidget extends StatelessWidget {
  List<String> image = [
    'asset/d6.jpeg',
    'asset/d8.png',
    'asset/d9.jpg',
    'asset/d10.jpg',

  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
            // height: MediaQuery.of(context).size.height * .4,
            autoPlay: true,
            autoPlayAnimationDuration: Duration(milliseconds: 1500)),
        items: <Widget>[
          /*Card(
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.yellow.shade800, width: 4.0),
                  borderRadius: BorderRadius.circular(4.0)),
              shadowColor: Colors.black54,
              elevation: 5,
              // color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'About GEV',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          for (int i = 0; i < image.length; i++)
            GestureDetector(
              onTap: () {},
              child: Card(
                color: Colors.transparent,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(image[i]),
                      // Use AssetImage instead of NetworkImage for local assets
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
        ]);
  }
}
