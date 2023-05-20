import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'bottomsheetwidget.dart';

class BottomSheetMap extends StatefulWidget {
  const BottomSheetMap({Key? key}) : super(key: key);

  @override
  State<BottomSheetMap> createState() => _BottomSheetMapState();
}

class _BottomSheetMapState extends State<BottomSheetMap> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Btm Sheet"),
        onPressed: (){
          showModalBottomSheet(
            isDismissible: true,
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            builder: (BuildContext context) {
              return  Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BottomSheetWidget(),
              );
            },
          );

        },


          /*showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                expand: true,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    // Your BottomSheet content
                    // ...
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 100,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },*/

        /*{
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: BottomSheetWidget(),
                  );
            },
          );
          */ /*showModalBottomSheet(context: context, builder: (BuildContext context){
            return SizedBox(
              height: 400,
              child: Center(
                child: ElevatedButton(
                  child: const Text('Close'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          });*/ /*
        },*/
      ),
    );
  }
}
