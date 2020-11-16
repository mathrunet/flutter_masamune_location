part of masamune.location;

class _MapControllerHookCreator {
  const _MapControllerHookCreator();

  MapController call() {
    return use(_MapControllerHook());
  }
}

/// You can use a Google map controller in your hook.
const useMapController = _MapControllerHookCreator();

class _MapControllerHook extends Hook<MapController> {
  const _MapControllerHook();

  @override
  _MapControllerHookState createState() {
    return _MapControllerHookState();
  }
}

class _MapControllerHookState
    extends HookState<MapController, _MapControllerHook> {
  MapController _controller;

  @override
  void initHook() {
    _controller = MapController._();
    LocationCore.listen().then(
      (core) {
        _controller._core = core;
        this.setState(() {});
      },
    );
  }

  @override
  MapController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller?.dispose();
  }

  @override
  String get debugLabel => 'useMapController';
}

/// Map controller.
class MapController<T extends Object> {
  MapController._();

  /// LocationCore.
  LocationCore get core => this._core;
  LocationCore _core;

  /// Current GPS Location.
  LatLng get location {
    LocationData data = this.core?.data?.location;
    if (data == null) return LatLng(0, 0);
    return LatLng(data.latitude, data.longitude);
  }

  /// Current Location.
  LatLng get current => this._current;
  LatLng _current = LatLng(0, 0);

  /// Target Location.
  LatLng get target => this._target;
  LatLng _target = LatLng(0, 0);

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

  /// Dispose controller.
  void dispose() {
    this._controller?.dispose();
  }

  void _initialize(GoogleMapController controller) {
    this._controller = controller;
  }

  /// Set the target location.
  ///
  /// [latitude]: Latitude.
  /// [longitude]: Longitude.
  void setTarget(double latitude, double longitude) {
    this._target = LatLng(latitude, longitude);
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
