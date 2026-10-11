# WWU Class Schedule

A Flutter application to work with WWU course schedules.

## Server

This reads the existing `classopen.wallawalla.edu` and creates a CSV file for the client.
In production, it is run as a background job to update the CSV file periodically.
In development, you can stop it using \<Ctrl\>+\<C\> once it generates a CSV file.

```bash
cd server
dart test
dart run
```

## Client

This runs the Flutter app that displays the class data.

```bash
cd client
flutter test
flutter run -d chrome
```

## Design

The class list can change often (particularly regarding the number of students enrolled), so is read from the server. Other things, such as the course descriptions come from the bulletin so rarely change. These are generated once and then built into the client.

## CPTR450 Branch

This branch is being developed on by the CPTR450 Software Engineering team. Jay Cisneros, Elyssa Sumendap, and Jaime Garcia.
The project's objective is to develop an AI Advisor that helps students build their quarter or year class schedule based on user
preferences and overall recommendations. More description to come soon
