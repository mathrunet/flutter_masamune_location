part of masamune.location;

/// This class manages and monitors location information.
///
/// Execute [listen()] to request location permission and monitor for changes.
class LocationCore extends Task<LocationCompassData> {
  StreamSubscription<double> _compassEventSubscription;
  StreamSubscription<LocationData> _locationEventSubscription;

  /// Create a Completer that matches the class.
  ///
  /// Do not use from external class
  @override
  @protected
  Completer createCompleter() => Completer<LocationCore>();

  /// Process to create a new instance.
  ///
  /// Do not use from outside the class.
  ///
  /// [path]: Destination path.
  /// [isTemporary]: True if the data is temporary.
  @override
  @protected
  T createInstance<T extends IClonable>(String path, bool isTemporary) =>
      LocationCore._(path: path) as T;
  Location get _location {
    if (this.__location == null) return this.__location = Location();
    return this.__location;
  }

  Location __location;

  /// This class manages and monitors location information.
  ///
  /// Execute [listen()] to request location permission and monitor for changes.
  factory LocationCore() {
    LocationCore unit = PathMap.get<LocationCore>(_systemPath);
    if (unit != null) return unit;
    Log.warning(
        "No data was found from the pathmap. Please execute [listen()] first.");
    return null;
  }

  /// This class manages and monitors location information.
  ///
  /// Execute [listen()] to request location permission and monitor for changes.
  ///
  /// [location]: Initial position.
  /// [compass]: Initial compass.
  static Future<LocationCore> listen(
      {LocationData location,
      CompassData compass,
      Duration timeout = Const.timeout}) {
    LocationCore unit = PathMap.get<LocationCore>(_systemPath);
    if (unit != null) {
      if (location != null) unit.data._location = location;
      if (compass != null) unit.data._compass = compass;
      return unit.future;
    }
    if (location == null) {
      location = LocationData.fromMap({
        'latitude': 0,
        'longitude': 0,
        'accuracy': 0,
        'altitude': 0,
        'speed': 0,
        'speed_accuracy': 0,
        'heading': 0,
        'time': 0
      });
    }
    if (compass == null) {
      compass = CompassData(0);
    }
    unit = LocationCore._(
        path: _systemPath,
        value: LocationCompassData._(location: location, compass: compass));
    unit._listenLocation(timeout: timeout);
    return unit.future;
  }

  /// Abandon location information acquisition.
  static void unlisten() {
    LocationCore()?.dispose();
  }

  static const String _systemPath = "system://location";
  LocationCore._({String path, LocationCompassData value})
      : super(path: path, value: value, isTemporary: false, group: -1);
  void _listenLocation({Duration timeout}) async {
    try {
      if (this._location == null) this.__location = Location();
      if (!await this._location.serviceEnabled().timeout(timeout)) {
        if (!await this._location.requestService().timeout(timeout)) {
          this.error("Location service not available. "
                  "The platform may not be supported or it may be disabled in the settings. "
                  "please confirm."
              .localize());
          return;
        }
      }
      PermissionStatus status =
          await this._location.hasPermission().timeout(timeout);
      if (status == PermissionStatus.denied) {
        status = await this._location.requestPermission().timeout(timeout);
      }
      if (status != PermissionStatus.granted) {
        this.error(
            "You are not authorized to use the location information service. "
                    "Check the permission settings."
                .localize());
        return;
      }
      this.data._location = await this._location.getLocation().timeout(timeout);
      this._compassEventSubscription = FlutterCompass.events.listen((angle) {
        if (this.data.compass._degree == angle) return;
        this.init();
        this.data.compass._degree = angle;
        this.done();
      });
      this._locationEventSubscription =
          this._location.onLocationChanged.listen((location) {
        if (location == null) return;
        this.init();
        this.data._location = location;
        this.done();
      });
      this.done();
    } on TimeoutException catch (e) {
      this.timeout(e.toString());
    } catch (e) {
      this.error(e.toString());
    }
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    if (this.isDisposed || !this.isDisposable) return;
    this._compassEventSubscription?.cancel();
    this._locationEventSubscription?.cancel();
    super.dispose();
  }

  /// Get the protocol of the path.
  @override
  String get protocol => Protocol.system;
}

/// Class for saving location information and compass information.
class LocationCompassData {
  /// Location data.
  LocationData get location => this._location;
  LocationData _location;

  /// Compass data.
  CompassData get compass => this._compass;
  CompassData _compass;
  LocationCompassData._({LocationData location, CompassData compass})
      : this._location = location,
        this._compass = compass;
}

/// Class that stores compass data.
class CompassData {
  /// Current angle (in degrees).
  double get degree => this._degree;

  /// Current angle in radians.
  double get radian => -1 * pi * (_degree / 180);
  double _degree;

  /// Class that stores compass data.
  CompassData(double angle) : this._degree = angle;
}
