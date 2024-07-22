import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300]!, blurRadius: 30, offset: Offset(0, 10))
];

class SkeletonRadioList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Row(
              children: [
                const SizedBox(width: 5,),
                const Radio(value: "", groupValue: "", onChanged: null),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor:
                              index % 2 != 0 ? Colors.grey : Colors.white54,
                          child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
