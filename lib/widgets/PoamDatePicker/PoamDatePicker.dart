import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PoamDatePicker extends StatefulWidget {

  final String? title;
  final TextEditingController? dateController;
  final TextEditingController? timeController;
  final DateTime? fromDate;
  final DateTime? fromTime;

  const PoamDatePicker({ Key? key, this.title, this.timeController, this.dateController, this.fromDate, this.fromTime }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    if (widget.dateController!.text == "") {
      widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }
    if (widget.timeController!.text == "") {
      widget.timeController!.text = selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
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
          TimeOfDay timeOfDay = picked;
          selectedTime = DateTime(0,0,0, timeOfDay.hour, timeOfDay.minute);
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ':' + _minute;
          widget.timeController!.text = _time;
        });
    }

    ///if the fromTime or the fromDate is change, then it will be set the toDate or the toTime equal the fromTime or the fromDate
    ///TODO: Error message
    /*if (widget.fromDate != null && widget.fromTime != null) {

      DateTime toDate = selectedDate;
      DateTime toTime = selectedTime;

      if (toTime.compareTo(widget.fromTime!) < 0) {
        selectedTime = widget.fromTime!;
        widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.fromTime!);
      }
      if (toDate.compareTo(widget.fromDate!) < 0) {
        selectedDate = widget.fromDate!;
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.fromDate!);
      }
    }*/

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
                )
            ),
          ),
        ),

      ],
    );
  }
}

/*class PoamDatePicker extends StatefulWidget {

  final String? title;
  final String? test;
  final TextEditingController? dateController;
  final TextEditingController? timeController;
  final DateTime? fromDate;
  final DateTime? fromTime;

  const PoamDatePicker({ Key? key, this.title, this.test, this.dateController, this.timeController, this.fromDate, this.fromTime }) : super(key: key);

  @override
  _PoamDatePickerState createState() => _PoamDatePickerState();
}

class _PoamDatePickerState extends State<PoamDatePicker> {

  late Color primaryColor;
  late Size size;
  late String _hour, _minute, _time;
  late String _setTime, _setDate;
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime(0,0,0, DateTime.now().hour, DateTime.now().minute + 1);
  late String dateTime;

  @override
  Widget build(BuildContext context) {

    ///initialize
    primaryColor = Theme.of(context).primaryColor;
    size = MediaQuery.of(context).size;

    if (widget.dateController!.text == "") {
      widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate);
    }
    if (widget.timeController!.text == "") {
      widget.timeController!.text = selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
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
          TimeOfDay timeOfDay = picked;
          selectedTime = DateTime(0,0,0, timeOfDay.hour, timeOfDay.minute);
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ':' + _minute;
          widget.timeController!.text = _time;
        });
    }

    ///if the fromTime or the fromDate is change, then it will be set the toDate or the toTime equal the fromTime or the fromDate
    ///TODO: Error message
    /*if (widget.fromDate != null && widget.fromTime != null) {

      DateTime toDate = selectedDate;
      DateTime toTime = selectedTime;

      if (toTime.compareTo(widget.fromTime!) < 0) {
        selectedTime = widget.fromTime!;
        widget.timeController!.text = DateFormat.Hm(Localizations.localeOf(context).languageCode).format(widget.fromTime!);
      }
      if (toDate.compareTo(widget.fromDate!) < 0) {
        selectedDate = widget.fromDate!;
        widget.dateController!.text = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(widget.fromDate!);
      }
    }*/

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
                    controller: widget.dateController,
                    onChanged: ((String? value) {
                      _setDate = value!;
                    }),
                    decoration: InputDecoration(
                        //hintText: DateFormat.yMd(Localizations.localeOf(context).languageCode).format(selectedDate),
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
                      controller: widget.timeController,
                      onChanged: ((String? value) {
                        _setTime = value!;
                      }),
                      decoration: InputDecoration(
                          //hintText: selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
                          hintStyle: const TextStyle(color: Colors.white),
                          disabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.only(top: 0.0)),
                    ),
                  )
              ),
            ),
        ),

      ],
    );
  }
}*/
