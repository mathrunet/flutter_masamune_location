// Copyright 2020 mathru. All rights reserved.

/// Masamune location framework library.
///
/// To use, import `package:masamune_location/masamune_location.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.location;

import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:masamune_core/masamune_core.dart';
import 'package:masamune_flutter/masamune_flutter.dart';
export 'package:masamune_mobile/masamune_mobile.dart';
export 'package:masamune_flutter/masamune_flutter.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

part 'hooks/mapcontroller.dart';

part 'locationcore.dart';
part 'uimapmixin.dart';
part 'uigooglemap.dart';
part 'mapstyle.dart';
