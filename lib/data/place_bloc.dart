import 'dart:async';

import 'package:ut_order/utils/place.dart';

class PlaceBloc {
  StreamController _placeController = StreamController();
  Stream get placeStream => _placeController.stream;
  StreamSink get placeSink => _placeController.sink;

  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    placeSink.add("start");
    PlaceService.searchPlace(keyword).then((rs) {
      placeSink.add(rs);
    }).catchError(() {
      placeSink.add("stop");
    });
  }

  void dispose() {
    print("dispose place controller");
    _placeController.close();
  }
}
