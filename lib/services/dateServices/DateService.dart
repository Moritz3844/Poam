import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:poam/services/itemServices/ItemModel.dart';

class DateService extends ChangeNotifier {

  ///Gets the Date of the Monday in this week
  DateTime getMondayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 1));
  }

  ///Gets the Date of the Sunday in this week
  DateTime getSundayDate() {
    var d = DateTime.now();
    var weekDay = d.weekday;
    return d.subtract(Duration(days: weekDay - 7));
  }

  ///Get a List of all dates
  List<DateTime> getListOfAllDates(Iterable<ItemModel> getItems) {
    List<DateTime> dates = List.generate(getItems.length, (index) => DateTime(0));
    for (int i = 0;i < dates.length; i++) {

      if (!dates.contains(getItems.elementAt(i).date)) {
        dates[i] = getItems.elementAt(i).date;
      }
    }
    for (int i = 0;i < getItems.length; i++) {
      dates.remove(DateTime(0));
    }

    dates.sort((a, b){ //sorting in ascending order
      return a.compareTo(b);
    });

    return dates;
  }

  List<dynamic> sortItemsByDate(List<ItemModel> items) {
    items.sort((a, b){
      DateTime getDateTime_A = DateTime(a.date.year, a.date.month, a.date.day, a.time.hour, a.time.minute);
      DateTime getDateTime_B = DateTime(b.date.year, b.date.month, b.date.day, b.time.hour, b.time.minute);

      return getDateTime_A.compareTo(getDateTime_B);
    });

    return items;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  String displayDate(DateTime dateTime) {
    return DateFormat.E().format(dateTime);
  }
}