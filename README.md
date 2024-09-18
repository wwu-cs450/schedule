# WWU Class Schedule

A Flutter application to work with WWU course schedules.

## Server

This reads the existing `classopen.wallawalla.edu` and creates a CSV file for the client.
In production, it is run as a background job to update the CSV file periodically.
In development, you can stop it using \<Ctrl\>+\<C\> once it generates a CSV file.

```
cd server
dart test
dart run
```

## Client

This runs the Flutter app that displays the class data.

```
cd client
flutter test
flutter run -d chrome
```
