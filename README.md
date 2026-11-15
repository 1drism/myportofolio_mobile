Nama : Muhamad Idris Kamal

NPM : 2506637073

Kelas : PBP KKI

# MyPortfolio Mobile

Mobile version of my personal portfolio website ([myportofolio](https://github.com/1drism/myportofolio)), built with Flutter for the PBP course. The home screen shows my identity (NPM, name, class) and an action menu for my portfolio sections. It uses the same dark theme and colors as my Django site.

## How to Run

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and check it with `flutter doctor`.
2. Clone the repo and get the packages:
   ```bash
   git clone https://github.com/1drism/myportofolio_mobile.git
   cd myportofolio_mobile
   flutter pub get
   ```
3. Run the app in Chrome or on an Android emulator:
   ```bash
   flutter run -d chrome
   ```
4. Check code quality and run the tests:
   ```bash
   flutter analyze
   flutter test
   ```

### Assignment 7

1. In Flutter everything on the screen is a widget, and widgets are nested inside each other so the whole UI becomes a tree. The parent decides how much space its children get and where they go, and the child decides its size inside that space. In my app MyApp -> MaterialApp -> MyHomePage -> Scaffold, and the body has the InfoCards and the grid of ItemCards. For example the Row gives each `Expanded` a fixed part of the width, so my full name wraps to 2 lines instead of overflowing.

2. `MaterialApp` is the root with the theme, `Scaffold` is the page layout, and `AppBar` is the top bar. `SingleChildScrollView` makes the page scrollable, `Center` and `ConstrainedBox` keep the content in the middle and max 600px wide, and `DecoratedBox` draws the yellow glow at the top. `Column` and `Row` arrange widgets vertically and horizontally, `Expanded`, `Flexible` and `IntrinsicHeight` share the space and keep the InfoCards the same height, `Padding` and `SizedBox` add spacing, and `GridView.count` makes the 3 column button grid. `Card` is the InfoCard box, `Text` and `Icon` show content, `Material` gives each ItemCard its color and rounded corners, `InkWell` handles the tap and ripple, and `SnackBar` shows the message. The ones i made myself are `MyApp`, `MyHomePage`, `InfoCard` and `ItemCard`.

3. MaterialApp sets up what a Material app needs, like the theme, navigation, app title and a `ScaffoldMessenger` for SnackBars. It's the root because many widgets depend on it, Scaffold, AppBar, Card and InkWell all use its theme, and my SnackBar only works because `ScaffoldMessenger.of(context)` finds the messenger MaterialApp created. I put my whole dark theme there once so i didn't have to style every widget again.

4. A StatelessWidget has no state that changes, its `build` only depends on the values given to it. A StatefulWidget has a `State` object that stays between rebuilds, and `setState()` rebuilds it with new values. My `MyHomePage`, `InfoCard` and `ItemCard` are stateless because my NPM, name and buttons never change. StatefulWidget is needed when something changes on screen, like a counter, a form, a star toggle, or data loaded from my Django API later.

5. BuildContext is a widget's position in the widget tree, and it's used to find things from the widgets above it like `Theme.of(context)` or `ScaffoldMessenger.of(context)`. In my `ItemCard` onTap, `ScaffoldMessenger.of(context)` goes up the tree from the ItemCard until it finds the messenger from MaterialApp, then `hideCurrentSnackBar()` removes the old message and `showSnackBar()` shows the new one so fast taps don't queue up.

6. Hot reload puts the changed code into the running app and rebuilds the widgets but keeps the state, i used it the most when changing colors and padding. Hot restart also loads the new code but starts the app again from `main()` so the state resets. Hot reload isn't enough for code that already ran like `main()`, `initState()` or global variables, or when changing a widget between Stateful and Stateless like MyHomePage in Tutorial 8, those need a hot restart. Changes in native code like the `android/` folder or new packages with native parts need a full restart with `flutter run`.



### AI Usage Disclosure
For this assignment I used Claude in two ways:

- **Claude (web) as a tutor:** it helped me set up Flutter on my new Mac (Homebrew, PATH, `flutter doctor`), walked me through the assignment step by step with hints instead of full code, and explained why the `package:flutter/material.dart` import shows as deprecated in Flutter 3.50 (the new `material_ui` package). I wrote the InfoCard data, the `ItemHomepage` color field, the button list, and the layout myself.
- It wrote the widget tests in `test/widget_test.dart` and cleaned up the `flutter analyze` output (commit `1768c33 test(widget): add portfolio tests and clean analyzer output`). I read through the tests to understand what each one checks, and ran `flutter test` myself.