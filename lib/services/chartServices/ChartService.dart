import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:poam/services/chartServices/Objects/ChartSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import '../dateServices/DateService.dart';
import '../itemServices/Objects/Database.dart';
import 'Objects/BartChartModel.dart';
import 'Objects/ChartModel.dart';

part 'ChartService.g.dart';

@HiveType(typeId: 5)
class ChartService extends ChangeNotifier {

  DateService dateService = DateService();

  ///TODO: ChartService: if a ItemModel is checked, then the right chart must be down and the left chart must be up

  @HiveField(0)
  final int isNotChecked;
  @HiveField(1)
  final int isChecked;
  @HiveField(2)
  final DateTime dateTime;

  ChartService(this.isChecked, this.isNotChecked, this.dateTime);

  List<ChartService> _chartItemList = <ChartService>[];
  List<ChartService> get chartItemList => _chartItemList;

  void getCharts() async {
    final box = await Hive.openBox<ChartService>(Database.ChartName);

    _chartItemList = box.values.toList();
    notifyListeners();
  }

  void initialize() async {

    final box = await Hive.openBox<ChartService>(Database.ChartName);

    if (box.values.length == 0) {
      List<DateTime> listOfDates = this.dateService.getDaysInBetween(this.dateService.getMondayDate(), this.dateService.getSundayDate());
      
      for (int i = 0;i < listOfDates.length;i++) {
        box.add(ChartService(0, 0, listOfDates.elementAt(i)));
      }
    }

    notifyListeners();
  }

  void putNotChecked(DateTime dateTime, int numberOfNotChecked) async {

    final box = await Hive.openBox<ChartService>(Database.ChartName);

    ChartService chartService = box.values.firstWhere((element) => element.dateTime.year == dateTime.year && element.dateTime.month == dateTime.month && element.dateTime.day == dateTime.day);
    int index = box.values.toList().indexOf(chartService);

    if (numberOfNotChecked < 0) {
      numberOfNotChecked = box.values.elementAt(index).isNotChecked;
    }

    box.putAt(index, ChartService(chartService.isChecked, numberOfNotChecked, chartService.dateTime));

    notifyListeners();
  }

  void putChecked(DateTime dateTime, int numberOfChecked) async {

    final box = await Hive.openBox<ChartService>(Database.ChartName);

    ChartService chartService = box.values.firstWhere((element) => element.dateTime.year == dateTime.year && element.dateTime.month == dateTime.month && element.dateTime.day == dateTime.day);
    int index = box.values.toList().indexOf(chartService);

    box.putAt(index, ChartService(numberOfChecked, chartService.isNotChecked, chartService.dateTime));

    notifyListeners();
  }

  int getNumberOfChecked(List<ChartService> chartList, DateTime dateTime) {

    if (chartList.length == 0) {
      return 0;
    }

    ChartService chartService = chartList.firstWhere(
            (element) => element.dateTime.year == dateTime.year && element.dateTime.month == dateTime.month && element.dateTime.day == dateTime.day);

    return chartService.isChecked;
  }

  int getNumberOfNotChecked(List<ChartService> chartList, DateTime dateTime) {

    if (chartList.length == 0) {
      return 0;
    }

    ChartService chartService = chartList.firstWhere(
            (element) => element.dateTime.year == dateTime.year && element.dateTime.month == dateTime.month && element.dateTime.day == dateTime.day);

    return chartService.isNotChecked;
  }

  void weekIsOver() async {

    final box = await Hive.openBox<ChartService>(Database.ChartName);
    DateService dateService = DateService();

    if (box.values.length != 0) {

      if (box.values.last.dateTime.compareTo(dateService.getSundayDate()) > 0) {
        box.clear();
        notifyListeners();
      }
    }
  }

  Future<List<charts.Series<dynamic, String>>> getSeries(context, List<ChartService> items, Color primaryColor) async {

    DateService dateService = DateService();

    ChartModel chartModel = ChartModel([

      for (int i = 0;i < items.length; i++)
      BarChartModel(
          day: dateService.displayDate(context, items.elementAt(i).dateTime),
          tasks: items.elementAt(i).isNotChecked,
          finishedTasks: items.elementAt(i).isChecked,
        ),
    ]);

    ChartSeries chartSeries = ChartSeries([
      charts.Series(
          id: "Tasks",
          data: chartModel.barChartModels,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.tasks,
          colorFn: (BarChartModel series, _) => charts.ColorUtil.fromDartColor(primaryColor)),
      charts.Series(
          id: "Tasks Done",
          data: chartModel.barChartModels,
          domainFn: (BarChartModel series, _) => series.day!,
          measureFn: (BarChartModel series, _) => series.finishedTasks,
          colorFn: (BarChartModel series, _) => charts.ColorUtil.fromDartColor(primaryColor.withGreen(240))),
    ]);
    return chartSeries.series;
  }
}