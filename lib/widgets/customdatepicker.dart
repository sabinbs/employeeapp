import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final bool? isStartDate;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final Function onNoDateClicked;

  CustomDatePicker({this.isStartDate,this.initialDate, required this.onDateSelected,required this.onNoDateClicked});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate = DateTime.now();
  Key _calendarKey = UniqueKey();
  int activeCategory = 0;
  int activeCategoryEnd = 0;

  List<String> quickButtons = [
    "Today",
    "Next Monday",
    "Next Tuesday",
    "After 1 week"
  ];

  List<String> quickButtonsforenddate = [
    "No Date",
    "Today",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate!;
    }
  }

  // Function to update selected date
  void _updateDate(DateTime date) {
    setState(() {
      selectedDate = date;
      _calendarKey = UniqueKey();
    });
  }

  // Function to calculate quick selection dates
  DateTime getNextMonday() {
    DateTime now = DateTime.now();
    int daysUntilMonday = (DateTime.monday - now.weekday) % 7;
    return now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
  }

  DateTime getNextTuesday() {
    DateTime now = DateTime.now();
    int daysUntilTuesday = (DateTime.tuesday - now.weekday) % 7;
    return now
        .add(Duration(days: daysUntilTuesday == 0 ? 7 : daysUntilTuesday));
  }

  DateTime getAfterOneWeek() {
    return DateTime.now().add(Duration(days: 7));
  }

  DateTime getBeforeOneWeek() {
    return DateTime.now().subtract(Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick selection buttons

           widget.isStartDate==true? GridView.builder(
              shrinkWrap: true,
              itemCount: quickButtons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: (1 / .2),
              ),
              itemBuilder: (BuildContext context, int index){
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeCategory = index;
                      if(index==0){
                        _updateDate(DateTime.now());
                      }else if(index==1){
                        _updateDate(getNextMonday());
                      }else if(index==2){
                        _updateDate(getNextTuesday());
                      }else{
                        _updateDate(getAfterOneWeek());
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeCategory == index ?Colors.blue:Colors.grey,
                    padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    quickButtons[index].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ):GridView.builder(
             shrinkWrap: true,
             itemCount: quickButtonsforenddate.length,
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               crossAxisSpacing: 4.0,
               mainAxisSpacing: 4.0,
               childAspectRatio: (1 / .2),
             ),
             itemBuilder: (BuildContext context, int index){
               return ElevatedButton(
                 onPressed: () {
                   setState(() {
                     activeCategoryEnd = index;
                     if(index==0){
                      widget.onNoDateClicked();
                      Navigator.pop(context);
                     }else if(index==1){
                       _updateDate(DateTime.now());
                     }
                   });
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: activeCategoryEnd == index ?Colors.blue:Colors.grey,
                   padding:
                   EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(5),
                   ),
                 ),
                 child: Text(
                   quickButtonsforenddate[index].toString(),
                   style: TextStyle(color: Colors.white),
                 ),
               );
             },
           ),

            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateDate(DateTime.now()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Today",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateDate(getNextMonday()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Next Monday",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateDate(getNextTuesday()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Next Tuesday",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateDate(getAfterOneWeek()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "After 1 week",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),*/
            /*  Wrap(
              spacing: 10,
              children: [
                _quickSelectButton("Today", DateTime.now()),
                _quickSelectButton("Next Monday", getNextMonday()),
                _quickSelectButton("Next Tuesday", getNextTuesday()),
                _quickSelectButton("After 1 week", getAfterOneWeek()),
              ],
            ),*/

            SizedBox(height: 10),

            // Calendar picker
            CalendarDatePicker(
              key: _calendarKey,
              initialDate: selectedDate,
              firstDate: widget.isStartDate==true?DateTime(2000):DateTime.now(),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),

            // Selected date display

            // Cancel & Save buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black12,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {

                    widget.onDateSelected(selectedDate!);
                    Navigator.pop(context);

                   /* if(widget.isStartDate==true){
                      widget.onDateSelected(selectedDate!);
                      Navigator.pop(context);
                    }else{
                      if(activeCategoryEnd==0){
                        widget.onDateSelected(selectedDate!);
                        Navigator.pop(context);

                      }else{
                        widget.onDateSelected(selectedDate!);
                        Navigator.pop(context);
                      }

                    }*/

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Quick selection button
  Widget _quickSelectButton(String label, DateTime date) {
    return ElevatedButton(
      onPressed: () => _updateDate(date),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDate == date ? Colors.blue : Colors.grey[200],
        foregroundColor: selectedDate == date ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
