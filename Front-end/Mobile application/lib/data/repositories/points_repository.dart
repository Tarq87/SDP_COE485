import 'dart:convert';

import 'package:sdp/data/data_providers/points_api.dart';
import 'package:sdp/data/models/points.dart';

class PointsRepository {
  PointsRepository();
  final PointsAPI api = PointsAPI();

  Future<Points> sendPointsRequest(String username) async {
    String rawPointsResponse = await api.requestPoints(username);
    Points points = Points.fromJson(jsonDecode(rawPointsResponse));
    return points;
  }
}
