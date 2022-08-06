
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:untitled5/beautyfy.dart';
import 'package:untitled5/music_player.dart';
import 'package:untitled5/Global.dart';

class Tracks extends StatefulWidget {
  _TracksState createState()=>_TracksState();
}
class _TracksState extends State<Tracks> {
  final FlutterAudioQuery audioQuery=FlutterAudioQuery();
  final GlobalKey<MusicPlayerState> key=GlobalKey<MusicPlayerState>();
  void initState()  {
    super.initState();
    getTracks();
  }

  void getTracks() async  {
    globals.songs=await audioQuery.getSongs();
    setState(() {
      globals.songs;
    });
  }
  void changeTrack(bool isNext) {
    if(isNext)  {

      if(globals.currentIndex!=globals.songs.length-1)  {
        globals.currentIndex++;
      }
      else{
        globals.currentIndex = 0;
      }
    } else  {
      if(globals.currentIndex!=0) {
        globals.currentIndex--;
      }
      else
        {
          globals.currentIndex= globals.songs.length-1;
        }
    }
    key.currentState?.setSong(globals.songs[globals.currentIndex]);
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Songs'),backgroundColor: Colors.white70,foregroundColor: Colors.black54,titleSpacing: 100,),
      body:


      Beautify(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),

          child: ListView.separated(separatorBuilder:(context,index)=>Divider(),itemCount: globals.songs.length,itemBuilder: (context,index)=>

              Padding(
                padding: EdgeInsets.fromLTRB(10,3,10,0),
                child: Beautify(
                  child: ListTile(leading: ClipRRect(borderRadius:BorderRadius.circular(10),child: Container(height:45,width:45,decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/crop.jpg'),
                    ),
                  ),),),title: Text(globals.songs[index].title),subtitle: Text(globals.songs[index].artist),onTap: ()  {
            globals.currentIndex=index;
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicPlayer(changeTrack: changeTrack,songInfo: globals.songs[globals.currentIndex],key: key)));
          },),
                ),
              ),),
        ),
      ),
    );
  }
}