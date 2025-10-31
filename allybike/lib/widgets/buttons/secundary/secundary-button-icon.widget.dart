import 'package:allybike/const/colors.conts.dart';
import 'package:allybike/widgets/buttons/base/base-button-icon.widget.dart';

class SecundaryIconButton extends BaseIconButton {
  
  const SecundaryIconButton({
        super.key,
        required super.icon,
        super.onPressed,
        super.fullWidth,
        super.disabled,
        super.loading,
        super.width,
        super.height
        }) : super(
          backgroundColor: PaleteColors.blue,
        );

}