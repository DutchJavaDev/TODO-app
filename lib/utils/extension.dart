import 'package:validators/validators.dart';

var _specialChars = "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";

extension StringUtils on String
{
  
  bool isNullOrEmpty()
  {
    if(this == null) return true;

    if(this.length == 0) return true;

    return false;
  }

  int lowerCaseCount(){

    if(this == null) return 0;

    int count = 0;

    for(var i = 0; i < this.length; i++)
    {
      if(isLowercase(this[i]))
      {
        count++;
      }
    }

    return count;
  }

  int uppercaseCount(){

    if(this == null) return 0;

    int count = 0;

    for(var i = 0; i < this.length; i++)
    {
      if(isUppercase(this[i]))
      {
        count++;
      }
    }

    return count;
  }

  bool validEmail(){
    if(this.isNullOrEmpty()) return false;
    return isEmail(this);
  }

  bool containsSpecialCharacter()
  {
    int count = 0;

    for(var i = 0; i < _specialChars.length; i++)
    {
      if(this.contains(_specialChars[i]))
      {
        count++;
      }
    }

    return count > 0;
  }
}