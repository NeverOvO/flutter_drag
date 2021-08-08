import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter拖动组件Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.asset("image/1.png",fit: BoxFit.fitHeight,),
            flex: 1,
          ),
          _dragWidgetHead(),
          Offstage(
            offstage: !_drageWidgetShow,
            child: Container(
              child: Image.asset("image/2.png",fit: BoxFit.fitHeight,),
              height: _drageWidgetHeight,
            ),
          )
        ],
      ),
    );
  }

  /*
  _drageWidgetHeight 为 拖动时需要改变高度的组件的 实际的高度，
  _drageWidgetHeightTemp 为 拖动时高度的临时量，

  初始值为120
   */
  double _drageWidgetHeight = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;
  double _drageWidgetHeightTemp = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;//temp
  bool _drageWidgetShow = true;

  /*
  实际拖动组件，可以在里面任何东西，例如菜单，标题，分割线，或者是被拖动的组件，例子中为高度的改变
  onVerticalDragDown：记录下当拖动开始时组件的高度，赋值给_drageWidgetHeightTemp；
  onVerticalDragUpdate：
        因为实时变动高度，所以高度的赋值需要在Update中进行
        这里的hi值，用来记录组件在拖动过程时的高度变化，若小于自定义最低高度，则不再进行更新，
        hi > (MediaQuery.of(context).size.height / 1.5) 则是对最高高度的显示，可以根据实际需要动态调整
        (s.localPosition.dy - 10) ：这里是为了避免在鼠标按下去刚开始拖动时出现的闪动情况，个人感觉取值10-20较为合适
  onVerticalDragEnd ：拖动结束后将目前高度赋值给赋值给_drageWidgetHeightTemp，可以不写
   */
  Widget _dragWidgetHead(){
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Text("拖动此处"),
            ),
            IconButton(
              icon: Icon(_drageWidgetShow ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded),
              onPressed: (){
                setState(() {
                  _drageWidgetShow = !_drageWidgetShow;
                });
              },
            ),
          ],
        ),
        color: Colors.deepPurpleAccent,
        alignment: Alignment.center,
      ),
      behavior: HitTestBehavior.opaque,
      onVerticalDragDown: (s){
        _drageWidgetHeightTemp =  _drageWidgetHeight;
      },
      onVerticalDragUpdate: (s){
        if(_drageWidgetShow){ //屏蔽在组件隐藏时的拖动动作
          setState(() {
            double hi = _drageWidgetHeightTemp - (s.localPosition.dy - 10);
            if(hi < 120){
              _drageWidgetHeight = 120;
            }else if (hi > (MediaQuery.of(context).size.height / 1.5)){
              _drageWidgetHeight = MediaQuery.of(context).size.height / 1.5;
            }else{
              _drageWidgetHeight = _drageWidgetHeightTemp - (s.localPosition.dy - 10);
            }

          });
        }
      },
      onVerticalDragEnd: (s){
        setState(() {
          _drageWidgetHeightTemp =  _drageWidgetHeight;
        });
      },
    ); //头部选择
  }
}
