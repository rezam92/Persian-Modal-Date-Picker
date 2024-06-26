import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'button_style.dart';

enum YearDirection {
  backward,
  forward,
  both,
}

Future showPersianDatePicker(
  BuildContext context,
  Future<void> Function(BuildContext context, Jalali date) onSubmit, {
  final int? initYear,
  final int? initMonth,
  final int? initDay,
  final BorderRadiusGeometry? border,
  final YearDirection yearDirection = YearDirection.backward,
  final Color backgroundColor = Colors.white,
  final EdgeInsets margin = EdgeInsets.zero,
  final ButtonsStyle submitButtonStyle = const ButtonsStyle(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    radius: 5,
    text: 'تایید',
    visible: true,
  ),
  final ButtonsStyle cancelButtonStyle = const ButtonsStyle(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    radius: 5,
    text: 'انصراف',
    visible: true,
  ),
  final bool Function(BuildContext context, Jalali date)? validate,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());

  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: border ?? BorderRadius.all(Radius.zero),
      ),
      builder: (context) {
        Jalali j;
        if (initYear != null && initMonth != null && initDay != null) {
          j = Jalali(initYear, initMonth, initDay);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: (border as BorderRadius),
              //BorderRadius.circular(50),
              child: DatePickerModal(
                onSubmit: onSubmit,
                validate: validate,
                initDay: j.day,
                initMonth: j.month,
                initYear: j.year,
                yearDirection: yearDirection,
                backgroundColor: backgroundColor,
                margin: margin,
                submitButtonStyle: submitButtonStyle,
                cancelButtonStyle: cancelButtonStyle,
              ),
            ),
          );
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: ClipRRect(
            borderRadius: (border as BorderRadius), //BorderRadius.circular(50),
            child: DatePickerModal(
              onSubmit: onSubmit,
              validate: validate,
              yearDirection: yearDirection,
              backgroundColor: backgroundColor,
              margin: margin,
              submitButtonStyle: submitButtonStyle,
              cancelButtonStyle: cancelButtonStyle,
            ),
          ),
        );
      });
}

class DatePickerModal extends StatefulWidget {
  final int? initYear;
  final int? initDay;
  final int? initMonth;
  final YearDirection yearDirection;
  final Color? backgroundColor;
  final EdgeInsets? margin;
  final BorderRadiusGeometry? border;
  final ButtonsStyle submitButtonStyle;
  final ButtonsStyle cancelButtonStyle;
  final bool Function(BuildContext context, Jalali date)? validate;
  final Future<void> Function(BuildContext context, Jalali date)? onSubmit;

  DatePickerModal({
    Key? key,
    @required this.onSubmit,
    this.validate,
    this.yearDirection = YearDirection.backward,
    this.initYear,
    this.initDay,
    this.initMonth,
    this.border,
    this.backgroundColor,
    this.margin,
    this.submitButtonStyle = const ButtonsStyle(radius: 5, text: 'تایید', visible: true),
    this.cancelButtonStyle = const ButtonsStyle(radius: 5, text: 'انصراف', visible: true),
  }) : assert(onSubmit != null);

  @override
  _DatePickerModalState createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<DatePickerModal> {
  late Jalali jalali;
  bool? loading;

  String monthTitle(Date d) => (d.formatter).mN;

  String weekDayTitle(Date d) => (d.formatter).wN;

  FixedExtentScrollController? dayController;
  FixedExtentScrollController? monthController;
  FixedExtentScrollController? yearController;

  @override
  void initState() {
    dayController = FixedExtentScrollController(initialItem: (widget.initDay ?? Jalali.now().day) - 1);
    monthController = FixedExtentScrollController(initialItem: (widget.initMonth ?? Jalali.now().month) - 1);

    if (widget.yearDirection == YearDirection.forward)
      yearController = FixedExtentScrollController(initialItem: 0);
    else if (widget.yearDirection == YearDirection.both) {
      yearController = FixedExtentScrollController(
        initialItem: 100,
      );
    } else {
      yearController = FixedExtentScrollController(
        initialItem: (100 - (Jalali.now().year - (widget.initYear ?? Jalali.now().year))) > 0
            ? (100 - (Jalali.now().year - (widget.initYear ?? Jalali.now().year)))
            : 0,
      );
    }

    jalali = Jalali(widget.initYear ?? Jalali.now().year, widget.initMonth ?? Jalali.now().month,
        widget.initDay ?? Jalali.now().day);
    // loading = widget.loading;
    super.initState();
  }

  String format(Date d) {
    final formatter = d.formatter;
    return '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets.add(EdgeInsets.all(8)),
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.border,
      ),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  format(jalali),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (widget.validate != null && !widget.validate!(context, jalali))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'تاریخ انتخاب شده صحیح نیست',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                    )
                  ],
                ),
              Divider(thickness: 1),
              Container(
                height: 150,
                child: Row(
                  children: [
                    ///dayPicker
                    Expanded(
                      child: Container(
                        height: 150,
                        child: CupertinoPicker.builder(
                          scrollController: dayController,
                          itemExtent: 50,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              jalali = jalali.withDay(value + 1);
                            });
                          },
                          childCount: jalali.monthLength,
                          itemBuilder: (context, index) => Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///monthPicker
                    Expanded(
                      child: Container(
                        height: 150,
                        child: CupertinoPicker.builder(
                          scrollController: monthController,
                          itemExtent: 50,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              dayController?.jumpTo(1);
                              jalali = jalali.withMonth(value + 1);
                            });
                          },
                          childCount: 12,
                          itemBuilder: (context, index) => Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: Text(
                              monthTitle(jalali.copy(month: index + 1, day: 1)),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///yearPicker
                    Expanded(
                      child: Container(
                        height: 150,
                        child: CupertinoPicker.builder(
                          scrollController: yearController,
                          itemExtent: 50,
                          onSelectedItemChanged: (value) {
                            setState(() {
                              dayController?.jumpTo(1);
                              if (widget.yearDirection == YearDirection.forward) {
                                jalali = jalali.withYear((Jalali.now().year) + value);
                                return;
                              }
                              jalali = jalali.withYear((Jalali.now().year - 100) + value);
                            });
                          },
                          childCount: widget.yearDirection == YearDirection.both ? 201 : 101,
                          itemBuilder: (context, index) => Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: Text(
                                ((widget.yearDirection == YearDirection.forward
                                            ? Jalali.now().year
                                            : (Jalali.now().year - 100)) +
                                        index)
                                    .toString(),
                                style:
                                    Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (!widget.submitButtonStyle.visible) Expanded(flex: 1, child: Container()),
                  if (widget.submitButtonStyle.visible)
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () async {
                          if (widget.validate != null && !widget.validate!(context, jalali)) return;
                          setState(() {
                            loading = true;
                          });
                          await widget.onSubmit!(context, jalali);
                          setState(() {
                            loading = false;
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.submitButtonStyle.backgroundColor ?? Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.submitButtonStyle.radius),
                          ),
                        ),
                        child: Text(
                          (widget.submitButtonStyle.text as String),
                          // style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          //       color: widget.submitButtonStyle.textColor,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                        ),
                      ),
                    ),
                  if (!widget.cancelButtonStyle.visible) Expanded(flex: 1, child: Container()),
                  if (widget.cancelButtonStyle.visible)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: widget.cancelButtonStyle.backgroundColor ?? Colors.grey[100]!,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.cancelButtonStyle.radius),
                            ),
                          ),
                          child: Text(
                            (widget.cancelButtonStyle.text as String),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: widget.cancelButtonStyle.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
