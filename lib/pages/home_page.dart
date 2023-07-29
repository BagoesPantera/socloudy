import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<Weather> futureWeather;
  final now = DateTime.now();

  List<String> days = ["Today" ,"Tomorrow"];

  // Weather Details
  List<String> details = ["Wind Speed", "Wind Gust", "Humidity", "Cloud Cover", "Visibility", "UV"];
  List<String> detailsData = [];

  // TEMPORARY
  List<String> weatherTempo = ["Light rain", "Patchy rain possible", "Partly cloudy", "Heavy rain", "Moderate rain"];
  List<String> tempTempo = ["28", "30", "29", "27", "29"];
  List<String> imgcodeTempo = ["296", "176", "116", "308", "302"];


  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: FutureBuilder<Weather>(
              future: futureWeather,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text(snapshot.data!.location);
                }else{
                  return const Text("Loading...");
                }
              },
            ),
            backgroundColor: Colors.black,
            actions: <Widget>[
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {

                },
              ),
              PopupMenuButton(
                offset: const Offset(0, 50), // X,Y
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                icon: const Icon(Icons.more_vert),  //don't specify icon if you want 3 dot menu
                color: const Color(0xFF262626),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Settings",style: TextStyle(color: Colors.white),),
                  ),
                ],
                onSelected: (item) => {

                },
              ),
            ],
          )
        ],
        body: Container(
          margin: const EdgeInsets.only(left: 10),
          // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
          child : FutureBuilder<Weather>(
            future: futureWeather,
            builder: (context, snapshot) {
              List<Widget> children = [];

              if (snapshot.connectionState == ConnectionState.waiting){
                return  Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              else if (snapshot.hasData) {

                // Adding data to list
                detailsData.add("${snapshot.data!.windSpd.round()} km/h");
                detailsData.add("${snapshot.data!.windGst.round()} km/h");
                detailsData.add("${snapshot.data!.hum}%");
                detailsData.add("${snapshot.data!.cloud}%");
                detailsData.add("${snapshot.data!.vis.round()} km");
                // https://en.wikipedia.org/wiki/Ultraviolet_index#Index_usage
                int uv = snapshot.data!.uv.round();
                String uvString = "Loading";
                if(uv < 3){ // 0 - 2
                  uvString = "Low";
                }else if(uv > 2 && uv < 6){ // 3 - 5
                  uvString = "Moderate";
                }else if(uv > 5 && uv < 8){ // 6 - 7
                  uvString = "High";
                }else if(uv > 7 && uv < 11){
                  uvString = "Very High";
                }else {
                  uvString = "Extreme";
                }
                detailsData.add(uvString);

                // Forecast
                days.add(DateFormat.EEEE().format(DateTime(now.year, now.month, now.day + 2)).toString());
                days.add(DateFormat.EEEE().format(DateTime(now.year, now.month, now.day + 3)).toString());
                days.add(DateFormat.EEEE().format(DateTime(now.year, now.month, now.day + 4)).toString());

                children = <Widget>[
                  // https://stackoverflow.com/questions/49279736/how-can-i-display-buttons-side-by-side-in-flutter
                  Row(
                    children: <Widget>[
                      // https://api.flutter.dev/flutter/widgets/Align-class.html
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot.data!.temp.round().toString(),
                          style: const TextStyle(fontSize: 120, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text( "\u2103",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text( snapshot.data!.weather,
                              style: const TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    // https://flutteragency.com/format-datetime-in-flutter/
                    child: Text(DateFormat.MMMMEEEEd().format(now).toString(),
                        style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
                  ),

                  const Divider(
                    height: 50,
                    thickness: 2,
                    indent: 0,
                    endIndent: 5,
                    color: Color(0xFF262626),
                  ),

                  // Forecast
                  GridView.count(
                    padding: EdgeInsets.zero, // https://github.com/flutter/flutter/issues/14842#issuecomment-598224765
                    crossAxisCount: 1,
                    primary: false, // Scrollable
                    mainAxisSpacing: 1,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    childAspectRatio: 10.0,
                    children: List.generate(5, (index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children : <Widget>[
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(days[index],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children : <Widget>[
                                    Image.network(
                                      'http://cdn.weatherapi.com/weather/64x64/day/${imgcodeTempo[index]}.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text("${weatherTempo[index].substring(0,8)}...",
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("${tempTempo[index]}\u2103",
                                  style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        )  ,
                      );
                    }),
                  ),

                  // Forecast Button
                  Container(
                    margin : const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled:true, // https://stackoverflow.com/a/53318679/13079820
                            context: context,
                            builder: (BuildContext context){
                              return SizedBox(
                                height: 700,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF262626),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      // Rounded top
                                      Container(
                                        margin: const EdgeInsets.only(top: 20.0),
                                        width: 40.0,
                                        height: 5.0,
                                        decoration:
                                        BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                                        child: Column(
                                          children: <Widget>[
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Today",
                                                  style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))
                                              ),
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                children: <Widget>[
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Image.network(
                                                      'http://cdn.weatherapi.com/weather/64x64/day/116.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      // https://api.flutter.dev/flutter/widgets/Align-class.html
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          snapshot.data!.temp.round().toString(),
                                                          style: const TextStyle(fontSize: 50, color: Colors.white),
                                                        ),
                                                      ),
                                                      Text(
                                                        "\t \u2103 \n \t${snapshot.data!.weather}",
                                                        style: const TextStyle(fontSize: 20, color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  const Align(
                                                    alignment: Alignment.topRight,
                                                    child: VerticalDivider(
                                                      color: Color(0xFF929292),
                                                      thickness: 2,
                                                      width: 20,
                                                      endIndent: 10,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.network(
                                                            'https://cdn.icon-icons.com/icons2/1370/PNG/512/if-weather-27-2682824_90788.png',
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                          const Text(
                                                            "jam sunrise",
                                                            style: TextStyle(fontSize: 15, color: Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.network(
                                                            'https://cdn.icon-icons.com/icons2/1370/PNG/512/if-weather-26-2682825_90789.png',
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                          const Text(
                                                            "jam sunset",
                                                            style: TextStyle(fontSize: 15, color: Colors.white),
                                                          ),
                                                        ],
                                                      )

                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),


                                            const Divider(
                                              height: 1,
                                              thickness: 2,
                                              indent: 0,
                                              endIndent: 5,
                                              color: Color(0xFF929292),
                                            ),
                                          ],
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(380, 40),
                        backgroundColor: const Color(0xFF262626),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: const Text('More Forecast'),
                    ),
                  ),

                  Container(
                    margin : const EdgeInsets.only(top: 30.0, left: 20.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Weather details",
                          style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                  ),

                  // Weather Details
                  // https://docs.flutter.dev/cookbook/lists/grid-lists
                  SizedBox(
                    height: 350,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      crossAxisCount: 2,
                      childAspectRatio: 16/8,
                      children: List.generate(6, (index) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                details[index],
                                style: const TextStyle(fontSize: 15, color: Color(0xFFa4a4a4)),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                detailsData[index],
                                style: const TextStyle(fontSize: 30, color: Color(0xFFFFFFFF)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.zero,
                    child:
                    const Text("Powered by WeatherAPI.com",
                      style: TextStyle(fontSize: 15, color: Color(0xFF8b8b8b)),
                    ),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Text('${snapshot.error}')
                ];
              }

              return RefreshIndicator(
                onRefresh: refreshFuture,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: SizedBox(
                    height: 920.0,
                    child : Column(
                      children: children,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Future<void> refreshFuture() async {
    setState(() {
      futureWeather = fetchWeather();
    });
  }
}