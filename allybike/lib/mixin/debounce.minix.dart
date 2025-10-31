import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin DebounceMixin on BlocBase {
  Timer? _debounce;

  void runDebounce(VoidCallback action, {int milliseconds = 500}) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds), action);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
