import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/widgets/buttons/base/base-button.widget.dart';

class PrimaryButton extends BaseButton {
  

  const PrimaryButton({
        super.key,
        required super.text,
        super.onPressed,
        super.fullWidth,
        super.disabled,
        super.loading,
        super.width
        }) : super(
          backgroundColor: PaleteColors.red,
        );
}
 
class SmallPrimaryButton extends SmallBaseButton {

  const SmallPrimaryButton({
        super.key,
        required super.text,
        super.onPressed,
        }) : super(
          backgroundColor: PaleteColors.red
        );

}


