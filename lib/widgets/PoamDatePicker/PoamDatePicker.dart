import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PoamDatePicker extends StatefulWidget {

  final String? title;
  final TextEditingController? dateController;
  final TextEditingController? timeController;
  final DateTime? fromDate;
  final DateTime? fromTime;
  final bool? EditMode;

  const PoamDatePicker({ Key? key, this.title, this.timeController, this.dateController, this.fromDate, this.fromTime, this.EditMode }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  late Size size;
  late String _hour, _minute, _time;
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime(0,0,0, DateTime.now().hour, DateTime.now().minute + 1);
  late String dateTime;
  bool _pickedTime = false, _pickedDate = false;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    if (widget.dateController!.text == "") {
      widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }
    if (widget.timeController!.text == "") {
      widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(selectedTime);
    }
    ///if no date is pick, then update the time and the Date automatically
    if (widget.EditMode == false && _pickedDate == false && selectedDate.compareTo(DateTime.now()) < 0) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(DateTime.now());
      });
    }
    if (widget.EditMode == false && _pickedTime == false && selectedTime.compareTo(DateTime.now()) < 0) {
      DateTime now = DateTime.now();
      DateTime _now = DateTime(0, 0, 0, now.hour, now.minute + 1);

      SchedulerBinding.instance?.addPostFrameCallback((_) {
        widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(_now);
      });
    }
    ///if the fromTime or the fromDate is change, then it will be set the toDate or the toTime equal the fromTime or the fromDate
    if (widget.fromDate != null && widget.fromTime != null) {

      DateTime updatedToDate = DateFormat.yMd(Localizations.localeOf(context).languageCode).parse(widget.dateController!.text);
      DateTime updatedToTime = DateFormat.Hm(Localizations.localeOf(context).languageCode).parse(widget.timeController!.text);

      if (updatedToDate.isBefore(widget.fromDate!)) {
        selectedDate = widget.fromDate!;

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.fromDate!);
        });
      }

      if (updatedToTime.compareTo(widget.fromTime!) < 0) {
        selectedTime = widget.fromTime!;

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.fromTime!);
        });
      }
    }

    ///Opens DatePicker
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime(2015),
          lastDate: DateTime(2101));
      if (picked != null)
        selectedDate = picked;
        _pickedDate = true;
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }

    ///Opens TimePicker
    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
      );
      if (picked != null)
        setState(() {
          _pickedTime = true;
          TimeOfDay timeOfDay = picked;
          selectedTime = DateTime(0,0,0, timeOfDay.hour, timeOfDay.minute);
          _time = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(selectedTime);
          widget.timeController!.text = _time;
        });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Flexible(
          flex: 1,
          child: Text(
            widget.title!,
            style: GoogleFonts.novaMono(),
          ),
        ),

        ///Displays DatePicker
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: TextFormField(
                  style: GoogleFonts.novaMono(
                      fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: widget.dateController!,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.only(top: 0.0)),
                ),

              ),
            ),
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        ///Displays TimePicker
        Flexible(
          flex: 1,
          child: InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    style: GoogleFonts.novaMono(
                      fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                    controller: widget.timeController!,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.only(top: 0.0)),
                  ),
                ),
            ),
          ),
        ),

      ],
    );
  }
}