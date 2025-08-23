String getDateText(
  DateTime date, {
  bool day = false,
  bool month = false,
  bool year = false,
}) {
  DateTime today = DateTime.now();
  String dateString = date.toString().split(" ")[0];
  List<String> dateStringSplit = dateString.split("-");
  String dayString = dateStringSplit[2];
  String monthString = dateStringSplit[1];
  String yearString = dateStringSplit[0];
  String res = "";
  if (day) res = dayString;
  if (month) res = "$res-$monthString";
  if (year) res = "$res-$yearString";
  if (res.isEmpty || date.year != today.year) {
    return "$dayString-$monthString-$yearString";
  }
  return res;
}
