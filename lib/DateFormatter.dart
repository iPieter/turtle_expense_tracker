class DateFormatter {
  static _getTranslation(int idx, [String language = "en"]){
  var translations = new Map();

  translations["en"] = new Map();

  translations["en"] = new Map();
  translations["en"][1] = "Just now";
  translations["en"][2] = "minute ago";
  translations["en"][3] = "minutes ago";
  translations["en"][4] = "hour ago";
  translations["en"][5] = "hours ago";
  translations["en"][6] = "day ago";
  translations["en"][7] = "days ago";
  translations["en"][8] = "month ago";
  translations["en"][9] = "months ago";

  translations["nl"] = new Map();
  translations["nl"][1] = "Zojuist";
  translations["nl"][2] = "minuut geleden";
  translations["nl"][3] = "minuten geleden";
  translations["nl"][4] = "uur geleden";
  translations["nl"][5] = "uur geleden";
  translations["nl"][6] = "dag geleden";
  translations["nl"][7] = "dagen geleden";
  translations["nl"][8] = "maand geleden";
  translations["nl"][9] = "maanden geleden";

  return translations[language][idx];
}

static String prettyPrint( DateTime date, [String language = "nl"] ){
  var now = new DateTime.now();

  var diff = (now.millisecondsSinceEpoch - date.millisecondsSinceEpoch) / 1000.0;

  String pretty = "";
  if( diff < 59.0 ) { //Seconds
    pretty = _getTranslation(1, language);
  } else if( diff < 60 * 60 ) { //Minutes
    if( diff < 60*2 )
      pretty = "${diff ~/ 60.0} ${_getTranslation(2, language)}";
    else
      pretty = "${diff ~/ 60.0} ${_getTranslation(3, language)}";
  } else if( diff < 60 * 60 * 24 ) { //Hours
    if( diff < 60 * 60 * 2)
      pretty = "${diff ~/ 3600.0} ${_getTranslation(4, language)}";
    else
      pretty = "${diff ~/ 3600.0} ${_getTranslation(5, language)}";
  } else if( diff < 60 * 60 * 24 * 30 ) { //Days
    if( diff < 60 * 60 * 24 * 2)
      pretty = "${diff ~/ (3600.0 * 24)} ${_getTranslation(6, language)}";
    else    
      pretty = "${diff ~/ (3600.0 * 24)} ${_getTranslation(7, language)}";
  } else if( diff < 60 * 60 * 24 * 365 ) { //Months
    if( diff < 60 * 60 * 24 * 60 )
      pretty = "${diff ~/ (3600.0 * 24 * 30)} ${_getTranslation(8, language)}";
    else
      pretty = "${diff ~/ (3600.0 * 24 * 30)} ${_getTranslation(9, language)}";
  } else {
    pretty = date.toString();
  }

  return pretty;
}
}