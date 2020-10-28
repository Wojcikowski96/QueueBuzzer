
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';

class pointHomescreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){

        }),
        title: Text("Nazwa restauracji"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){

          })
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed:(){

        }
      ),
      body: Container(
        color: Colors.white10,
        child:ListView(
          scrollDirection: Axis.vertical,
          children: <Widget> [
            Container(
              child: SimpleFoldingCell(
                frontWidget: FrontWidget(),
                innerTopWidget: InnerTopWidget(),
                innerBottomWidget: InnerBottomWidget(),
                
                cellSize: Size(MediaQuery.of(context).size.width, 175),
                padding: EdgeInsets.all(10.0)
              )
            ),
            Container(
                child: SimpleFoldingCell(
                    frontWidget: FrontWidget(),
                    innerTopWidget: InnerTopWidget(),
                    innerBottomWidget: InnerBottomWidget(),
                    cellSize: Size(MediaQuery.of(context).size.width, 175),
                    padding: EdgeInsets.all(10.0)
                )
            ),
            Container(
                child: SimpleFoldingCell(
                    frontWidget: FrontWidget(),
                    innerTopWidget: InnerTopWidget(),
                    innerBottomWidget: InnerBottomWidget(),
                    cellSize: Size(MediaQuery.of(context).size.width, 175),
                    padding: EdgeInsets.all(10.0)
                )
            ),
          ]
        )
      )
    );
  }
  Container FrontWidget(){
    return Container(
      color:Colors.white12,
      alignment: Alignment.center,
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child:Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color:Colors.deepOrange,
            ),
            child: Container(
              child:Row(children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('25,90 zł',
                    style: TextStyle(
                      color:Colors.white,
                      fontSize: 15,

                    ),),
                  ),
                ),
                Container(),
              ])
            ),
          )
        ),
        Expanded(
            flex: 2,
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color:Colors.white70,
              ),
            child: Container(
              child:Column(children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Pizza Neapolitana',
                      style: TextStyle(
                        color:Colors.black,
                        fontSize: 15,

                      ),),
                  ),
                ),
              Image.asset("pizza.jpg",
              height:100,
                width:100,
              ),
                SizedBox(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: (){

                    },
                    child: Text("Edytuj"),
                    color: Colors.deepOrange,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    splashColor: Colors.white,
                  ),
                  width: 100,
                  height:40,
                ),
              ]),


            )
            )
        )
      ])
    );
  }
  Container InnerTopWidget(){
    return Container(
      color: Colors.blueGrey

    );
  }
  Container InnerBottomWidget(){
    return Container(
        color: Colors.white
    );
  }
}
