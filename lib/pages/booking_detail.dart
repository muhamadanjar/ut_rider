import 'package:flutter/material.dart';
import 'package:ut_order/models/trip.dart';
import 'package:ut_order/components/verticaldivider.dart';

TripInfo tripInfo = new TripInfo();

class BookingFragment extends StatefulWidget {
  static const img = "https://flutter.io/tutorials/layout/images/card-flutter-gallery.png";
  static const String routeName = '/material/cards';

  @override
  Booking createState() => new Booking();
}


class Booking extends State<BookingFragment> {
  ShapeBorder _shape;

  static const double height = 366.0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
    theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return new Scaffold(
        body: new SafeArea(
            top: false,
            bottom: false,
            child: new Container(
                padding: const EdgeInsets.all(8.0),
                height: height,
                child: new Card(
                    shape: _shape,
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // photo and title
                          new SizedBox(
                            child: new Stack(
                              children: <Widget>[
                                buildProfileItem(
                                    "location", "name", "completed")
                              ],
                            ),
                          ),
                          new Divider(),
                          new Expanded(
                            child: tripItem(),
                          )
                          // description and share/explore buttons
                        ]
                    )
                )
            )
        )
    );
  }

  Container tripItem() {
    return new Container(
      padding: EdgeInsets.all(4.0),
      child: new Column(children: <Widget>[
        //region fare
        new Row(children: <Widget>[
          new Expanded(
            child: new Text("Fare"),
          ),
          new Row(children: <Widget>[
            new Container(
                padding: EdgeInsets.only(right: 8.0),
                child: new Text("2.9") //new Text(t.payBy),
            ),
            new Text("2.0")
          ])
        ]),
        //endregion
        //region book
        new Row(children: <Widget>[
          new Expanded(
            child: new Text("Booking Id"),
          ),
          new Column(children: <Widget>[
            new Text("tafgasg"),
          ]),
        ]),
        //endregion
        //region class
        new Row(children: <Widget>[
          new Expanded(
            child: new Text("Class"),
          ),
          new Column(children: <Widget>[
            new Text("Economy"),
          ]),
        ]),
        //endregion
        //region pickup
        new Row(children: <Widget>[
          new Column(children: <Widget>[

            new Icon(Icons.send),
            new Icon(Icons.send),
          ]),
          new Expanded(

              child: new DefaultTextStyle(
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subhead,
                child: new Column(
                    children: <Widget>[

                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          new Text(
                            "Pickup",
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          new Container(
                            child: new Text(
                              "Le Centre",
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),


                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          new Text(
                            "Destination",
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                          new Container(
                            child: new Text(
                              "Louis vuitton foundation",
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),

              )),
        ]),


        new Expanded(
          child: new Column(
            children: <Widget>[
              new Text(
                "Driver note",
                style: new TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              new Container(
                  child: new Text(
                    "In Front of restaurant",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
              )
            ],
          ),
        )
      ])
      ,

    );
  }

  Container buildProfileItem(String location, String name, String completed) {
    const img =
        "https://flutter.io/tutorials/layout/images/card-flutter-gallery.png";

    return new Container(
        padding: const EdgeInsets.all(25.0),
        child: new Row(children: [
          new Column(children: [
            new Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new CircleAvatar(
                  backgroundImage: NetworkImage(img),
                ))
          ]),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  child: new Text(
                    location,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  name,
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Column(children: [
            new Container(
              decoration: new BoxDecoration(
                color: Colors.black45,
              ),
              child: new Text(
                completed,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ])
        ]));
  }
}
