part of masamune.location;

/// Mixin for using GoogleMap.
///
/// Please use with Google Map.
mixin UIMapMixin<T extends Object> on Widget {
  /// Map value.
  final UIMapValue<T> map = UIMapValue<T>();
}

/// Map value.
class UIMapValue<T extends Object> {
  /// Marker set.
  final Set<Marker> marker = SetPool.get();

  /// Polygon set.
  final Set<Polygon> polygons = SetPool.get();

  /// Polyline set.
  final Set<Polyline> polylines = SetPool.get();

  /// Circle set.
  final Set<Circle> circles = SetPool.get();

  /// Google map controller.
  GoogleMapController get controller => this._controller;
  GoogleMapController _controller;

  /// Initialize.
  ///
  /// [controller]: Google map controller.
  void initialize(GoogleMapController controller) {
    this._controller = controller;
  }

  /// Set the marker.
  ///
  /// The already set marker is replaced.
  ///
  /// [marker]: Marker.
  void setMarker(Marker marker) {
    if (marker == null) return;
    this.marker.removeWhere(
        (element) => element.markerId.value == marker.markerId.value);
    this.marker.add(marker);
  }

  /// Set the polygon.
  ///
  /// The already set polygon is replaced.
  ///
  /// [polygon]: Polygon.
  void setPolygon(Polygon polygon) {
    if (polygon == null) return;
    this.polygons.removeWhere(
        (element) => element.polygonId.value == polygon.polygonId.value);
    this.polygons.add(polygon);
  }

  /// Set the polyline.
  ///
  /// The already set polyline is replaced.
  ///
  /// [polyline]: Polyline.
  void setPolyline(Polyline polyline) {
    if (polyline == null) return;
    this.polylines.removeWhere(
        (element) => element.polylineId.value == polyline.polylineId.value);
    this.polylines.add(polyline);
  }

  /// Set the circle.
  ///
  /// The already set circle is replaced.
  ///
  /// [circle]: Circle.
  void setCircle(Circle circle) {
    if (circle == null) return;
    this.circles.removeWhere(
        (element) => element.circleId.value == circle.circleId.value);
    this.circles.add(circle);
  }
}
