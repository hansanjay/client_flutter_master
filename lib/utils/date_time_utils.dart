import 'package:intl/intl.dart';

String? dateFormat(String? time) {
  if (time != null) {
    var oldDateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    var oldDate = oldDateFormat.parse(time);
    var newDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var newDate = newDateFormat.parse(oldDate.toString());

    time = DateFormat.d().format(newDate) +
        ' ' +
        DateFormat.MMM().format(newDate) +
        ' ' +
        DateFormat.jm().format(newDate);
  }
  return time ?? 'N/A';
}
