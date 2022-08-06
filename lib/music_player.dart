import 'dart:math';
import 'package:text_scroll/text_scroll.dart';
import 'package:untitled5/beautyfy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'allsongs.dart';
class MusicPlayer extends StatefulWidget {

  SongInfo songInfo;
  Function changeTrack;

  final GlobalKey<MusicPlayerState> key;
  MusicPlayer({this.songInfo,this.changeTrack,this.key}):super(key: key);
  MusicPlayerState createState()=>MusicPlayerState();
}
class MusicPlayerState extends State<MusicPlayer> {
  double minimumValue=0.0, maximumValue=0.0, currentValue=0.0;
  String currentTime='0000', endTime='0001';
  bool isPlaying=false;
  final AudioPlayer player=AudioPlayer();
  AssetImage Wall = AssetImage('assets/images/img2.gif',);
  int loopval = 0;
  Icon loopicon = Icon(Icons.loop_sharp,color: Colors.greenAccent,);
  bool shmode = false;

  void initState()  {

    setSong(widget.songInfo);



    super.initState();


  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo=songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue=minimumValue;
    maximumValue=player.duration.inMilliseconds.toDouble();

    setState(() {
      currentTime=getDuration(currentValue);
      endTime=getDuration(maximumValue);

    });
    isPlaying=false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue=min(duration.inMilliseconds.toDouble(),maximumValue);
      setState(() {
        currentTime=getDuration(currentValue);
      });
    });

  }

  void changeStatus() {
    setState(() {
      isPlaying=!isPlaying;
    });
    if(isPlaying) {
      player.play();
      Wall = AssetImage('assets/images/img2.gif');

    } else  {
      player.pause();
      Wall = AssetImage('assets/images/crop.jpg');
    }
  }

  String getDuration(double value)  {
    Duration duration=Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds].map((element)=>element.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  Widget build(context) {
    return Scaffold(

      body: Container(


        margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:<Widget>[

          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(height:50,width:60,child: Center(child: Beautify(child: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){
                setState(() {
                  player.stop();
                });
                Navigator.pop(context);},),))),
              Container(height:50,width:150,child: Center(child: Text('Now Playing',style: TextStyle(fontSize: 18,color: Colors.grey.shade500),))),
              Container(height:50,width:60,child: Center(child: Beautify(child: IconButton(icon:Icon(Icons.home),onPressed: (){

                setState(() {
                  player.stop();
                });
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>allsongs()));
              },),))),
            ],
          ),

          
          SizedBox(height: 15,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 15,),
              Beautify(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ClipRRect(borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 350,width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/crop.jpg'),
                      ),
                    ),
                  ), ),
                  // Container(child: Image(image: AssetImage('assets/images/img2.gif'),height: 50,),),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(height: 30,width: 200,
                              margin: EdgeInsets.fromLTRB(10,5,0,5),
                              child: Flexible(
                                child: TextScroll(widget.songInfo.artist,
                                  style :TextStyle(color: Colors.black26, fontSize:20,fontWeight: FontWeight.w600),
                                  textDirection: TextDirection.ltr,
                                ),),
                            ),
                            Container(height: 50,width: 200,
                              margin: EdgeInsets.fromLTRB(10,0,0,2),
                              child: Flexible(
                                child: TextScroll(widget.songInfo.title,
                                  style :TextStyle(color: Colors.black54, fontSize:35,fontWeight: FontWeight.w500),
                                  textDirection: TextDirection.ltr,
                                ),),
                            ),
                          ],
                        ),
                        SizedBox(width:10 ,),

                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: (){setState(() {
                                  loopval = loopval^1;
                                });}, icon: loopval ==1 ? loopicon : Icon(Icons.loop_sharp)),

                                IconButton(onPressed: (){
                                  setState(() {

                                      if(shmode==false)
                                        {
                                          player.setShuffleModeEnabled(true);
                                        }
                                      else{
                                        player.setShuffleModeEnabled(false);
                                      }
                                      shmode^=true;
                                  });

                                },icon:  shmode ? Icon(Icons.shuffle,color: Colors.greenAccent,) : Icon(Icons.shuffle),
                                )],
                            ),

                          ],
                        ),
                      ],

                    ),

                  ],),
              ),
              SizedBox(width: 15,),
            ],
          ),
          

          Container(
            padding: EdgeInsets.all(15),
            child: Beautify(
              child: Row(
                children: [
                  Text((()
                  { if(currentTime==endTime && loopval==0)
                  {
                    widget.changeTrack(true);
                    return currentTime;
                  }
                  else if(currentTime==endTime && loopval==1)
                    {
                      player.seek(Duration(milliseconds: minimumValue.round()));

                      return currentTime;
                    }
                  else
                    return currentTime;
                  }
                    ())
                      , style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500)),


                  Container(
                    width: 290,
                    height: 20,
                    child: Slider(inactiveColor: Colors.black12,activeColor: Colors.lightGreenAccent,min: minimumValue,max: maximumValue+1,value: currentValue,onChanged: (value) {

                        currentValue = value;
                        player.seek(Duration(milliseconds: currentValue.round()));


                    },),
                  ),

                  Text(endTime, style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Beautify(
                child: Container(height: 70,width: 70,
                  child: GestureDetector(child: Icon(Icons.skip_previous, color: Colors.black54, size: 55), behavior: HitTestBehavior.translucent,onTap: () {
                    widget.changeTrack(false);
                  },),
                ),
              ),
            ),
            
            Beautify(

              child: Container(
                height: 70,width: 145,
                child: GestureDetector(child: Icon(isPlaying?Icons.pause:Icons.play_arrow, color: Colors.black54, size: 55), behavior: HitTestBehavior.translucent,onTap: () {
                  changeStatus();

                },),
              ),
            ),
            
            Beautify(
              child: Container(height: 70,width: 70,
                child: GestureDetector(child: Icon(Icons.skip_next, color: Colors.black54, size: 55), behavior: HitTestBehavior.translucent,onTap: () {
                  widget.changeTrack(true);
                },),
              ),
            ),
          ],),

          ]
      ),
    ));
  }
}

