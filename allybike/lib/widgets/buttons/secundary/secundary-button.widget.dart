// ignore_for_file: overridden_fields

import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/widgets/buttons/base/base-button.widget.dart';


class SecundaryButton extends BaseButton {

  const SecundaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.loading,
    super.disabled,
    super.fullWidth,
  }) : super(backgroundColor: PaleteColors.blue);
}

class SmallSecundaryButton extends SmallBaseButton {
  const SmallSecundaryButton({
    super.key,
    required super.text,
    super.onPressed,
  }) : super(
         backgroundColor: PaleteColors.blue,
       );
}
