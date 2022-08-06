
import 'package:flutter/material.dart';
import 'package:untitled5/beautyfy.dart';
import 'package:untitled5/tracks.dart';

class allsongs extends StatefulWidget {
  State<allsongs> createState() => _allsongsState();
}

class _allsongsState extends State<allsongs> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Beautify(
              child: ClipRRect(borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 450,width: 350,
                  // child: Icon(Icons.music_note_rounded, size: 200,color: Colors.orangeAccent,),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/crop.jpg'),
                    ),
                  ),
                ), ),
            ),
          ),
            
          
          Padding(

            padding: const EdgeInsets.fromLTRB(30,10,30,10),
            child: Beautify(
              child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GestureDetector(
                      child: Container(
                        height:60,
                        color: Colors.white38,
                        child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("ALL SONGS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black54),),
                          ]
                      )
                      ),
                      onTap: ()
                      {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Tracks()),
                      );}
                ),)),
            ),
          ),

        ]));
    }

}
