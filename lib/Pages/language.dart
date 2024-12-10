import 'package:flutter/material.dart';
import '../main.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});


  List<Widget> _buildButtonsWithNames(BuildContext context, List<String> langs) {
    List<TextButton> buttonsList = [];
    for (String lang in langs) {
      buttonsList.add(TextButton(onPressed: () {MyApp.of(context).localization.setLocale(Locale.fromSubtags(languageCode: lang));}, child: Text("Set locale to $lang")));
    }
    return buttonsList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: Text(MyApp.of(context).localization.translate("change_language")),
          centerTitle: true,
    ),
    body: Center(child: Column(
      children: [
        const Text("Select language:"),
        ..._buildButtonsWithNames(context, MyApp.of(context).localization.getSupported()),
        Text("Selected language: ${MyApp.of(context).localization.getLocale().toLanguageTag()}"),
        Text("Selected language: ${MyApp.of(context).localization.translate("home_page")}"),
      ],
    )
    )
    );
  }
}
