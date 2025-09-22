import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'dart:html' as html;
import 'package:universal_html/html.dart' as html;
import 'package:flutter_web_plugins/url_strategy.dart';


class WebRouter {
  static late State<dynamic> lastPageState;
  static String lastPathname = ''; // currentUrl / currentPathname
  static int historyPosition = 1;
  static String appStartPath = '';
  static bool initStarted = false;

  static bool init(BuildContext context, String defaultPathname) {
    if (!kIsWeb || initStarted) {return false;} // run only once
    initStarted = true;


    print('START URL: ${html.window.location.pathname}');




    html.window.onPopState.listen((event) {
      if (lastPathname != (html.window.location.pathname??'')) {

        print('🌐 Browser Back/Forward pressed - using default behavior');
        print('Event state: ${event.state}');
        print('Current URL: ${html.window.location.href}');
        print('search URL: ${html.window.location.pathname}');
        print('last patname: ${lastPathname}');
        //Navigator.of(event.context).pushNamed('/page3');
        // Let browser handle it normally
        if (lastPathname.startsWith(html.window.location.pathname??'')) {//back
          if (lastPathname != '' && lastPathname != '/') { // pop only when its not in the root
            historyPosition--;
            print("POPSTATE BACK");
            Navigator.pop(context);
          }
        } else {// forward
          historyPosition++;
          print("POPSTATE FORWARD");
          // rebuild current widget page and show next page
          lastPageState.setState(() {});

        }
        print('History position: $historyPosition');

        lastPathname = html.window.location.pathname??'';
      } else {
        print("TWICE");
      }
    });

    // Set initial URL without hash
    print('search URL: ${html.window.location.pathname}');
    //html.window.history.replaceState({'serialCount' : 0, 'page': 1}, 'Page 1', '/page112');
    print(html.window.history.state);
    print('search URL: ${html.window.location.pathname}');
    print("initState");
    print('History position: $historyPosition');




    //currentUrl = html.window.location.pathname?? '';
    appStartPath = html.window.location.pathname?? '';
    lastPathname = html.window.location.pathname??'';


    // run only once

    if ((appStartPath == '' || appStartPath == '/' ||  appStartPath == defaultPathname) && defaultPathname.startsWith('/')) {
      html.window.history.replaceState({'page': 0}, '', defaultPathname); // default url
    } else {
      html.window.history.replaceState({'page': 0}, '', '/');//'serialCount' : 0,
    }

    print('INIT: '+ (html.window.location.pathname??''));

    return true;
  }

  static void navigateToPage(BuildContext context, String pagePath, Map<String,Widget> routes, VoidCallback setStateCallback) {

    print('📱 Navigating to Page $pagePath using history.pushState');

    if (!kIsWeb) {
      List<String> listRoutes = routes.keys.toList();
      for(var i = 0; i < listRoutes.length; i++){

        if (pagePath.startsWith(listRoutes[i])) {
          lastPathname = pagePath;

          Future.microtask(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
            routes[listRoutes[i]]!)).then((onValue) {
              //lastPageState = thisPageState;
              setStateCallback();
              //print("PAGE1 END");
            });
          });

        }
      }


    } else {


      historyPosition++;

      // Push new state to browser history with clean URL
      html.window.history.pushState(
          {'page': pagePath},
          'Page $pagePath',
          pagePath
      );

      lastPathname = html.window.location.pathname ?? '';


      //setState(() {});
      //RouteTracker.rebuildCurrent(context);
      setStateCallback();
    }
  }

  static bool goBack() {
    if (!kIsWeb) {return false;}

    if (html.window.location.pathname != '' && html.window.location.pathname != '/') {
      //if (historyPosition > 1) {
      print('📱 Flutter back button - using history.back()');

      /*setState(() {
      });*/

      print('History position: $historyPosition');

      // Use browser's history.back()
      html.window.history.back();
      return true;
    } else {
      print('📱 No history to go back - history position: $historyPosition');
      return false;
    }
  }

  static bool goBackApp(BuildContext context, String parentPagePath) {
    if (!kIsWeb) {
      lastPathname = parentPagePath;
      Navigator.pop(context);
      return true;
    } else {
      if (html.window.location.pathname != '' && html.window.location.pathname != '/') {
        historyPosition++;

        if (parentPagePath == '') {
          parentPagePath = '/';
        }


        html.window.history.pushState(
            {'page': parentPagePath},
            'Page $parentPagePath',
            parentPagePath
        );
        lastPathname = html.window.location.pathname ?? '';

        Navigator.pop(context);
        return true;
      } else {
        print('📱 No history to go back - history position: $historyPosition');
        return false;
      }
    }
  }

  static bool initPath(BuildContext context, Map<String,Widget> routes, bool pathStarted, VoidCallback setStateCallback) {
    if (!kIsWeb || pathStarted) return true; // run only if web or once in initState() in current widget

    List<String> listRoutes = routes.keys.toList();
    for(var i = 0; i < listRoutes.length; i++){
      if(appStartPath.startsWith(listRoutes[i])) {
        navigateToPage(context, listRoutes[i], routes, setStateCallback);
        return true;
      }
    }

    return true;
  }

  static String navigatePath(BuildContext context, Map<String,Widget> routes, State<dynamic> thisPageState, String childPageActive, VoidCallback onPopPage) {
    if (!kIsWeb) {return '';}

    //print("navigatePath: "+ thisPagePath + ' : ' + lastPathname);
    List<String> listRoutes = routes.keys.toList();
    for(var i = 0; i < listRoutes.length; i++){

      if (lastPathname.startsWith(listRoutes[i])) {
        if (childPageActive != listRoutes[i]) {
          Future.microtask(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                routes[listRoutes[i]]!)).then((onValue) {
              lastPageState = thisPageState;
              onPopPage();
              //print("PAGE1 END");
            });});

          //print("navigatePath: "+ thisPagePath + ' : ' + listRoutes[i] + ' : ' + lastPathname);

          //childPageActive = '/page1';
          return listRoutes[i];
        }
      }

    }


    return '';
  }

  static (List<String>, String) checkForParams(int thisPageParamsCount, String thisPagePath, bool pathStarted) {
    List<String> params = [];

    if (!kIsWeb) {

      params = (lastPathname)
          .replaceFirst(thisPagePath, '')
          .split('/');


    } else {
      if (appStartPath != '' && appStartPath != '/' && !pathStarted) {
        String currentPathnameParams = (appStartPath).replaceFirst(
            thisPagePath, '');
        params = currentPathnameParams.split('/')
            .take(thisPageParamsCount * 2)
            .toList();

        // replaceState with params

        String newPath = thisPagePath + params.join('/');
        print(newPath);

        html.window.history.replaceState(
            {'page': newPath},
            'Page $newPath',
            newPath
        );

        lastPathname = html.window.location.pathname ?? '';
      } else {
        params = (html.window.location.pathname ?? '')
            .replaceFirst(thisPagePath, '')
            .split('/');
      }


      print('checkForParams: ');
      //print('INIT PATH PARAMS:');
      print(appStartPath);
      //print(currentPathnameParams);
      print(lastPathname);
      print(thisPagePath);
      print(html.window.location.pathname ?? '');
    }

    print(params);
    print(params.join('/'));
    return (params, params.join('/'));
  }
}


void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(null); //https://github.com/flutter/flutter/issues/108114#issuecomment-1642097114

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebRouter Test',
      home: Page0(),
    );
  }
}


class Page0 extends StatefulWidget {



  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> {

  String thisPageFullPath = '';
  String childPageActive = '';
  static bool pathStarted = false;
  Map<String,Widget> routes = {};

  @override
  void initState() {
    super.initState();

    WebRouter.init(context, '');

    WebRouter.lastPageState = this;
    //widget.thisPageFullPath = widget.parentPath+widget.thisPageFullPath;
    routes = {
      thisPageFullPath+Page1.thisPagePath : Page1(parentPath: thisPageFullPath)
    };
    pathStarted = WebRouter.initPath(context, routes, pathStarted, () {setState(() {});});
  }



  @override
  Widget build(BuildContext context) {
    childPageActive = WebRouter.navigatePath(context, routes, this, childPageActive, () {childPageActive = ''; setState(() {});});

    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
          print("BACKBUTTON");
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 0'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true, // Remove default back button
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (kIsWeb) ? html.window.location.pathname??'' : thisPageFullPath,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the page: 0'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => WebRouter.navigateToPage(context, thisPageFullPath+Page1.thisPagePath+'/param1', routes, () {setState(() {});}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 1',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));

  }
}


class Page1 extends StatefulWidget {

  static String thisPagePath = '/page1';
  final String _thisPagePath = thisPagePath;

  final String parentPath; // url till parent page

  Page1({super.key, required this.parentPath}); // url when app loaded

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  String thisPageFullPath = '';
  String childPageActive = '';
  static bool pathStarted = false;
  Map<String,Widget> routes = {};
  final int thisPageParamsCount = 1;

  @override
  void initState() {

    thisPageFullPath = widget._thisPagePath;
    WebRouter.lastPageState = this;

    var (paramsValues, paramsPath) = WebRouter.checkForParams(thisPageParamsCount, widget.parentPath+widget._thisPagePath, pathStarted);
    thisPageFullPath = widget.parentPath+widget._thisPagePath+paramsPath;
    routes = {
      thisPageFullPath+Page2.thisPagePath : Page2(parentPath: thisPageFullPath),
      thisPageFullPath+Page3.thisPagePath : Page3(parentPath: thisPageFullPath)
    };
    pathStarted = WebRouter.initPath(context, routes, pathStarted, () {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    childPageActive = WebRouter.navigatePath(context, routes, this, childPageActive, () {childPageActive = ''; setState(() {});});

    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
          //onGoBack();
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 1'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true, // Remove default back button
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {WebRouter.goBackApp(context, widget.parentPath);},
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (kIsWeb) ? html.window.location.pathname??'' : thisPageFullPath,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the page: 1'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => WebRouter.navigateToPage(context, thisPageFullPath+Page2.thisPagePath, routes, () {setState(() {});}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 2',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => WebRouter.navigateToPage(context, thisPageFullPath+Page3.thisPagePath, routes, () {setState(() {});}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 3',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}

class Page2 extends StatefulWidget {

  static String thisPagePath = '/page2';
  final String _thisPagePath = thisPagePath;

  final String parentPath; // url till parent page

  Page2({super.key, required this.parentPath}); // url when app loaded

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  String thisPageFullPath = '';
  String childPageActive = '';
  static bool pathStarted = false;
  Map<String,Widget> routes = {};

  @override
  void initState() {

    thisPageFullPath = widget._thisPagePath;
    WebRouter.lastPageState = this;
    thisPageFullPath = widget.parentPath+thisPageFullPath;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
        },
        child: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('Page 2'),
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {WebRouter.goBackApp(context, widget.parentPath);},
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (kIsWeb) ? html.window.location.pathname??'' : thisPageFullPath,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the page: 2'),
                SizedBox(height: 40),
              ],
            ),
          ),
        ));
  }
}

class Page3 extends StatefulWidget {

  static String thisPagePath = '/page3';
  final String _thisPagePath = thisPagePath;

  final String parentPath; // url till parent page

  Page3({super.key, required this.parentPath}); // url when app loaded

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {

  String thisPageFullPath = '';
  String childPageActive = '';
  static bool pathStarted = false;
  Map<String,Widget> routes = {};

  @override
  void initState() {
    thisPageFullPath = widget._thisPagePath;
    WebRouter.lastPageState = this;
    thisPageFullPath = widget.parentPath + thisPageFullPath;
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
        },
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text('Page 3'),
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {WebRouter.goBackApp(context, widget.parentPath);},
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (kIsWeb) ? html.window.location.pathname??'' : thisPageFullPath,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the page: 3'),
                SizedBox(height: 40),
              ],
            ),
          ),
        )
    );
  }
}
