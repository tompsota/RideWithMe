import 'package:flutter/material.dart';

//TODO idk ci je toto spravny sposob ako handlovat callbacky ale nic lepsie som nevymyslel

typedef TimeOfDayCallback = void Function(TimeOfDay);
typedef DateTimeCallback = void Function(DateTime);
typedef DynamicCallback = void Function(dynamic);
typedef RangeValuesCallback = void Function(RangeValues);
