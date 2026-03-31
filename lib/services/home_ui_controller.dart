import 'dart:async';

import 'package:get/get.dart';

class HomeUiController extends GetxController {
  static const fabReplayGap = Duration(seconds: 10);
  static const fabCollapseDelay = Duration(milliseconds: 1400);
  static const fabLabelRevealDelay = Duration(milliseconds: 220);

  final RxBool showFab = false.obs;
  final RxBool collapseFab = false.obs;
  final RxBool showFabLabel = false.obs;

  Timer? _fabReplayTimer;

  @override
  void onInit() {
    super.onInit();
    _playFabAnimation();
    _fabReplayTimer = Timer.periodic(fabReplayGap, (_) {
      _playFabAnimation();
    });
  }

  void _playFabAnimation() {
    showFab.value = true;
    collapseFab.value = false;
    showFabLabel.value = false;

    Future<void>.delayed(fabLabelRevealDelay, () {
      if (isClosed || collapseFab.value) return;
      showFabLabel.value = true;
    });

    Future<void>.delayed(fabCollapseDelay, () {
      if (isClosed) return;
      showFabLabel.value = false;
      collapseFab.value = true;
    });
  }

  @override
  void onClose() {
    _fabReplayTimer?.cancel();
    super.onClose();
  }
}
