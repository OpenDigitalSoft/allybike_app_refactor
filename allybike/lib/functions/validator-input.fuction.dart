

import 'package:allybike/const/message-valitator.constans.dart';
import 'package:allybike/const/regexp.constans.dart';

String? validate(String? text, List<Validator> validators) {
   for (var validator in validators) {
      final errorMessage = validator.validate(text);
      if (errorMessage != null) {
        return errorMessage;
      }
    }
    return null; 
}

abstract class Validator {
  String? validate(String? text);
}

class MinLengthValidator  extends Validator {
  final int min;

  MinLengthValidator(this.min);
  
  @override
  String? validate(String? text) {
      if(text!.length < min ){
        return "Debe tener al menos $min caracteres";
      }
      return null;
  }
}

class RequiredValidator extends Validator {
  @override
  String? validate(String? text) {
    if (text == null || text.isEmpty) {
      return MessagesValitator.requiredMessage;
    }
    return null;
  }
}

class EmailValidator extends Validator {
  final RegExp _emailRegex = RegExp(RegexExpretion.emailRegex);

  @override
  String? validate(String? text) {
    if (!_emailRegex.hasMatch(text!)) {
      return MessagesValitator.emailMessage;
    }
    return null;
  }
}

