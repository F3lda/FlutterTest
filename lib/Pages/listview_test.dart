import 'package:flutter/material.dart';



class ListsWithCards extends StatelessWidget {
  final items = ['Horse', 'Cow', 'Camel', 'Sheep', 'Goat'];

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
        title: Text("ListView"),
    ),
    body: ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Row(children: [


          Expanded(child: Card( //                           <-- Card
            clipBehavior: Clip.antiAlias,
            child:  Dismissible(
              background: Container(
                alignment: Alignment.center,
                color: Colors.redAccent,
                child: const Row( // Wrap with a row here
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 50),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),

                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.center,
                color: Colors.greenAccent,
                child: const Row( // Wrap with a row here
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),

                    Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text('$index Delete')));
                  /// edit item
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text('$index Play')));
                  /// delete
                  return false;
                }
              },
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(items[index]),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (DismissDirection direction) {
                // Remove the item from the data source.


                // Then show a snackbar.

              },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTileCustom(items:items,index:index),

                  /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),*/

                ],
              ),
            ),
            /*ListTile(
            title: Text(items[index]),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage(productModel(name: items[index], price: "100", category: "chicken"))));
              },
          ),*/
          ),),



          if(items[index] == "Camel") Expanded(child: Card( //                           <-- Card
            clipBehavior: Clip.antiAlias,
            child:  Dismissible(
              background: Container(
                alignment: Alignment.center,
                color: Colors.redAccent,
                child: const Row( // Wrap with a row here
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 50),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),

                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.center,
                color: Colors.greenAccent,
                child: const Row( // Wrap with a row here
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),

                    Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text('$index Delete')));
                  /// edit item
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: Text('$index Play')));
                  /// delete
                  return false;
                }
              },
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(items[index]),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (DismissDirection direction) {
                // Remove the item from the data source.


                // Then show a snackbar.

              },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTileCustom(items:items,index:index),

                  /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),*/

                ],
              ),
            ),
            /*ListTile(
            title: Text(items[index]),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage(productModel(name: items[index], price: "100", category: "chicken"))));
              },
          ),*/
          )
          )
        ]);
      },
      )
    );
  }
}


class ListTileCustom extends StatefulWidget {
  final List<String> items;
  final int index;

  // cardy({required this.items, required this.index});
  const ListTileCustom ({ Key? key, required this.items, required this.index }): super(key: key);

  @override
  _cardyState createState() => new _cardyState();
}

class _cardyState extends State<ListTileCustom> {
  var isSelected = false;
  var mycolor=Colors.white;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        selected: isSelected,
        leading: (widget.items[widget.index] == "Camel") ? const Icon(Icons.album) :  const CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/250?image=9')//AssetImage("..."), // No matter how big it is, it won't overflow
        ),
        title: Text(widget.items[widget.index]),
        subtitle: (widget.items[widget.index] == "Cow") ? Container() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            if(widget.items[widget.index] == "Camel") Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            )
          ],
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetailPage(productModel(name: widget.items[widget.index], price: "100", category: "chicken"))));
        },
        isThreeLine: true,
        trailing: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.close),
          ],
        ),
        onLongPress: toggleSelection // what should I put here,

    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor=Colors.white;
        isSelected = false;
      } else {
        mycolor=Colors.grey;
        isSelected = true;
      }
    });
  }
}


class DetailPage extends StatefulWidget {
  productModel model;

  DetailPage(this.model, {super.key});

  @override
  DetailPageState createState() => DetailPageState();
}

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
<(AnimationStyles, String)>[
  (AnimationStyles.defaultStyle, 'Default'),
  (AnimationStyles.custom, 'Custom'),
  (AnimationStyles.none, 'None'),
];

class DetailPageState extends State<DetailPage> {
  Set<AnimationStyles> _animationStyleSelection = <AnimationStyles>{
    AnimationStyles.defaultStyle
  };
  AnimationStyle? _animationStyle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: [
            Text("Name:" + widget.model.name.toString()),
            Text("Category:" + widget.model.category.toString()),
            Text("price:" + widget.model.price.toString()),
            SegmentedButton<AnimationStyles>(
              selected: _animationStyleSelection,
              onSelectionChanged: (Set<AnimationStyles> styles) {
                setState(() {
                  _animationStyle = switch (styles.first) {
                    AnimationStyles.defaultStyle => null,
                    AnimationStyles.custom => AnimationStyle(
                      duration: const Duration(seconds: 3),
                      reverseDuration: const Duration(seconds: 1),
                    ),
                    AnimationStyles.none => AnimationStyle.noAnimation,
                  };
                  _animationStyleSelection = styles;
                });
              },
              segments: animationStyleSegments
                  .map<ButtonSegment<AnimationStyles>>(
                      ((AnimationStyles, String) shirt) {
                    return ButtonSegment<AnimationStyles>(
                        value: shirt.$1, label: Text(shirt.$2));
                  }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 10.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {

        }),
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}


class productModel {
  String? name;
  String? price;
  String? category;
  bool isShow = false;
  int index = 0;

  productModel({this.name, this.price, this.category, this.isShow = false});

  productModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    category = json['category'];
    isShow = json['isShow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['category'] = this.category;
    data['isShow'] = this.isShow;
    return data;
  }
}

class Diohelper {
  static List<productModel> getdata() {
    List<productModel> list = [];
    list.add(productModel(name: "broast", price: "100", category: "chicken"));
    list.add(productModel(name: "mandi", price: "100", category: "pork"));
    list.add(productModel(name: "mandi", price: "100", category: "veg"));

    return list;
  }
}
