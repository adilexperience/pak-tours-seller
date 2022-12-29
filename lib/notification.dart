import 'package:flutter/material.dart';
class NotificationDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 18,),
            Text("New booking Request",style: TextStyle(fontSize: 18),),
            SizedBox(height: 30,),
            Padding(padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/laptop.jpg",width: 100,height: 100,),
                      SizedBox(width: 20,),
                      Expanded(child: Container(child: Text(" Buy Hp Laptop core i5",style: TextStyle(fontSize: 18),))),
                      SizedBox(height: 15,),

                    ],
                  ),
                  SizedBox(height: 15,),
                  /*Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/main_bg.jpg",width: 16,height: 16,),
                      SizedBox(width: 20,),
                      Expanded(child: Container(child: Text("booking",style: TextStyle(fontSize: 18),))),
                      SizedBox(height: 15,),

                    ],
                  ),*/
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(height: 2.0,color: Colors.black,thickness: 2.0,),
            SizedBox(height: 8,),
            Padding(padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8),
                    onPressed: (){
                     /* assestsAudioPlayer.stop();
                      Navigator.pop(context);*/
                    },
                    child: Text("Cancel".toUpperCase(),style: TextStyle(fontSize: 14),),

                  ),
                  SizedBox(width: 25,),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Colors.green),
                    ),
                    color: Colors.white,
                    textColor: Colors.green,
                    padding: EdgeInsets.all(8),
                    onPressed: (){
                     /* assestsAudioPlayer.stop();
                      checkAvailabilityOfRide(context);*/

                    },
                    child: Text("Accept".toUpperCase(),style: TextStyle(fontSize: 14),),

                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),



          ],
        ),

      ),

    );
  }

}
