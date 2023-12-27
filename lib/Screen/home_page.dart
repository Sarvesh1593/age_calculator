import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Age {
  final int years;
  final int months;
  final int weeks;
  final int days;
  final int hours;
  final int minutes;
  final DateTime nextBirthday;

  Age({
    required this.years,
    required this.months,
    required this.weeks,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.nextBirthday,
  });
}

class _HomePageState extends State<HomePage> {
  DateTime todaydate = DateTime.now();
  DateTime dob = DateTime(2000, 1, 1);
  Age age = Age(
    years: 0,
    months: 0,
    weeks: 0,
    days: 0,
    hours: 0,
    minutes: 0,
    nextBirthday: DateTime.now(),
  );

  // Function to calculate age
  void calculateAge() {
    int years = todaydate.year - dob.year;
    int months = todaydate.month - dob.month;
    int days = todaydate.day - dob.day;

    if (days < 0) {
      final daysInPreviousMonth =
          DateTime(todaydate.year, todaydate.month - 1, 0).day;
      days += daysInPreviousMonth;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    final difference = todaydate.difference(dob);
    final weeks = difference.inDays ~/ 7;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;

    // Calculate the next birthday
    DateTime nextBirthday = DateTime(todaydate.year, dob.month, dob.day);
    if (nextBirthday.isBefore(todaydate) || nextBirthday == todaydate) {
      nextBirthday = DateTime(todaydate.year + 1, dob.month, dob.day);
    }

    setState(() {
      age = Age(
        years: years,
        months: months,
        weeks: weeks,
        days: days,
        hours: hours,
        minutes: minutes,
        nextBirthday: nextBirthday,
      );
    });
  }

  Future<Null> _selectedtodaydate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: todaydate,
      firstDate: dob,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != todaydate) {
      setState(() {
        todaydate = picked;
        calculateAge();
      });
    }
  }

  Future<void> _selectedDOBdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dob,
      firstDate: DateTime(1900),
      lastDate: todaydate,
    );
    if (picked != null && picked != todaydate) {
      setState(() {
        dob = picked;
        calculateAge();
      });
    }
  }

  final List<String> _month = [
    "months",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String calculateMonthsAndDaysUntilBirthday(DateTime birthday, DateTime today) {
    DateTime nextBirthday = DateTime(today.year, birthday.month, birthday.day);
    if (nextBirthday.isBefore(today) || nextBirthday == today) {
      // If the next birthday is before or on today, calculate for the next year.
      nextBirthday = DateTime(today.year + 1, birthday.month, birthday.day);
    }

    final difference = nextBirthday.difference(today);
    final months = difference.inDays ~/ 30;
    final days = difference.inDays % 30;

    if (months == 0) {
      return "$days Days";
    } else if (days == 0) {
      return "$months Months";
    } else {
      return "$months Months $days Days";
    }
  }



  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }


  @override
  void initState() {
    super.initState();
    calculateAge();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                width: double.maxFinite,
              ),
              Text(
                "Age Calculator",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${todaydate.day} ${_month[todaydate.month]} ${todaydate.year}",
                          style: TextStyle(
                              color: Color(0xffCDDC39),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectedtodaydate(context);
                          },
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date of Birth",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Text(
                          "${dob.day} ${_month[dob.month]} ${dob.year}",
                          style: TextStyle(
                              color: Color(0xffCDDC39),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectedDOBdate(context);
                          },
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                    color: Color(0xff333333),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "AGE",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${age.years}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 76,
                                        color: Color(0xffCDDC39)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: Text(
                                      "YEARS",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "${age.months} Months | ${age.days} Days",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 170,
                          width: 1,
                          color: Color(0xff999999),
                        ),
                        Container(
                          height: 200,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Color(0xff333333),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "NEXT BIRTHDAY",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.cake,
                                color: Color(0xffCDDC39),
                                size: 60,
                              ),
                              Text(
                                _getDayOfWeek(age.nextBirthday.weekday),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                calculateMonthsAndDaysUntilBirthday(age.nextBirthday, todaydate),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: Color(0xff999999),
                      margin: EdgeInsets.symmetric(horizontal: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "SUMMARY",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xffCDDC39)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "YEARS",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.years}",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "MONTHS",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.months}",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "WEEKS",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.weeks}",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "DAYS",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.days}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "HOURS",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.hours}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "MINUTES",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${age.minutes}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
