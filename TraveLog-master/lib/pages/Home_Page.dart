import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trave_log/cubit/app_cubit.dart';
import 'package:trave_log/models/data_model.dart';
import 'package:trave_log/msic/AppColors.dart';
import 'package:trave_log/widgets/appLargeText.dart';


import '../cubit/app_cubit_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 1, vsync: this);
    return Scaffold(
      body: BlocBuilder<AppCubit,CubitStates>(
        builder: (context,state){
          
          if(state is LoadedState){
            late List<DataModel> info=state.places;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 70,
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.short_text,
                        size: 40,
                        color: Colors.black54,
                      ),
                      Expanded(child: Container()),
                      Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: AppLargeText(text: 'Discover'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelPadding: const EdgeInsets.only(left: 20, right: 20),
                        labelColor: Colors.black,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        controller: _tabController,
                        indicator:
                        CircleIndicator(color: AppColors.mainColor, radius: 4),
                        tabs: [
                          Tab(text: "Places"),
                          
                        ]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 300,
                  width: double.maxFinite,
                  child: TabBarView(controller: _tabController, children: [
                    ListView.builder(
                      itemCount: info.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap:(){
                            BlocProvider.of<AppCubit>(context).detailState(info[index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 15, top: 10),
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: NetworkImage("http://mark.bslmeiyu.com/uploads/${info[index].img}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                
                SizedBox(
                  height: 10,
                ),
                
              ],
            );
          }
          else{
            return Container();
          }
        },
      )
    );
  }
}

class CircleIndicator extends Decoration {
  final Color color;
  final double radius;
  const CircleIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    return _CirclePaint(color: color, radius: radius);
  }
}

class _CirclePaint extends BoxPainter {
  final Color color;
  final double radius;

  const _CirclePaint({required this.color, required this.radius});
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset CircleOffset = Offset(
        configuration.size!.width / 2 - radius / 2, configuration.size!.height-radius);
    canvas.drawCircle(CircleOffset + offset, radius, _paint);
    // TODO: implement paint
  }
}
