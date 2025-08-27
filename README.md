# todo_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


##

Next steps:
- fix issue with updating ui aswell as the db at the same time, without refreshing the whole screen, just the item
- the added task doesnt show up right away, in main screen, need to access home state and refresh it of access future and refresh it

### IMPORTANT SOLUTION

- use local state = local variables -> fetch tasks right away, as the widget is initState, then manipulate the lists, as well as the db. THE CHANGES MADE TO THE LOCAL LIST NEED TO BE REFLECTED IN THE DB