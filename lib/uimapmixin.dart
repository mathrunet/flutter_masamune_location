part of masamune.location;

/// Mixin for using GoogleMap.
///
/// Please use with Google Map.
mixin UIMapMixin<T extends Object> on UIPage {
  final _UIMapValue _mapValue = _UIMapValue();

  /// Controller for maps.
  MapController get controller => this._mapValue?._controller;

  /// Executed when the widget is loaded.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  @mustCallSuper
  void onInit(BuildContext context) {
    super.onInit(context);
    this._mapValue._controller = useMapController();
  }
}

class _UIMapValue {
  MapController _controller;
}
