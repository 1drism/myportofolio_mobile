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

### Assignment 8

This week i added an Add Education form. The fields follow the `Education` model from my Django site, so institution, faculty/major, degree, start date, end date and description. You can open it from the Add Education card or from the drawer.

1. `push()` opens a new page on top and the old one stays underneath, so Back takes you back to it. `pushReplacement()` swaps the current page with the new one, so you can't go back to the page that got replaced. `pop()` just removes the top page, i also use it to close the dialog and the drawer. My Add Education card uses `push()`, so pressing Back on the form brings you back home. For Home in the drawer, the tutorial used `pushReplacement(MyHomePage())`, but i noticed that if you opened the form from a card it puts a second home page on top of the first one. So i changed it to `popUntil((route) => route.isFirst)`, which keeps popping until it reaches the first page, and the first page is always my home page because it's the `home` in MaterialApp. Between the two forms the drawer uses `pushReplacement`, otherwise every switch would add another page and Back would take forever.

2. All my pages use a `Scaffold` with an `appBar`, a `drawer` and a `body`, so the only thing that really changes is the body. I use the same `LeftDrawer` everywhere, and the menu items are in one enum, so if i want to add another page later i just add it there once instead of fixing three drawers. Colors are set once in the `ThemeData` in `main.dart`. My yellow color (same one from `tokens.css` on my Django site) is the Save button on both forms and also the drawer header on every page. The tutorial form had indigo hardcoded and it looked weird next to my dark home screen, so i moved everything into the theme.

3. I wanted it to look ok on a small phone and also in a big Chrome window. `SafeArea` keeps things away from the notch and status bar. `SingleChildScrollView` is the important one, without it the form is too tall on a small screen or when the keyboard opens and you get the yellow black overflow error, i actually got that error on the tutorial drawer at 360px. `keyboardDismissBehavior: onDrag` hides the keyboard when you scroll the form. `ConstrainedBox(maxWidth: 600)` with `Center` stops the fields from stretching across the whole screen on Chrome, on a phone it doesn't change anything. `Column(spacing: 16)` gives the space between fields and `CrossAxisAlignment.stretch` makes them full width. I tried it at 360x640 with the keyboard open and Save is still reachable by scrolling.

4. When i press Save, `_save()` gets the form through `_formKey.currentState!`, that's what the `GlobalKey<FormState>` is for. Then `validate()` runs each field's `validator`. If a validator returns a message it shows under the field, and if every validator returns null the form is valid. After that `save()` stores the values and the dialog shows them. I put the rules in `lib/models/education.dart` so they match my Django model in one place, like the 100 character limit. One thing my form rejects is typing only spaces in Institution, it gets trimmed to nothing so it says "Institution is required.". Picking the right widget isn't enough because the keyboard still lets you type spaces. I also set `maxLengthEnforcement: none` on purpose so you can type past 100 characters, the counter turns red and the validator is what blocks it. Same with dates, the date picker still lets you choose an end date before the start date, so the validator has to catch that.

### AI Usage Disclosure

- I used Claude in VS Code this time. It gave me the git message for commiting so it stays profesional and it helped me finding bugs.
- I wrote most of the code while being asisted like if theres a bug in my progress (the `Education` model, the form, the date field, the drawer and card changes and the tests). I picked Education as the section, asked for the form to reset after OK like the Project form.