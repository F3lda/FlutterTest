import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart'; // flutter pub add pull_to_refresh
import 'dart:developer';



class ListViewInfinite extends StatefulWidget {
  const ListViewInfinite({super.key, required this.title});

  final String title;
  @override
  State<ListViewInfinite> createState() => _ListViewInfiniteState();
}

final listviewKey = GlobalKey();


class _ListViewInfiniteState extends State<ListViewInfinite> {

  List<Product> productsData =[];

  final int defaultOffset = 10;

  bool listViewDirectionReversed = false;

  int totalPages = 300;
  int offSet = -1;
  int lastLoadedOffset = -1;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);//

  Future<bool> getProductsData({bool isRefresh = false}) async {
    /*if(isRefresh == true && offSet == 0 && lastLoadedOffset == 0) {
      //refreshController.refreshCompleted();
      refreshController.refreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: const Text('Failed onRefresh')));
      return false;
    }*/

    if (offSet == -1) {
      offSet = 0;
    } else if (isRefresh) {
      if (offSet == 0) {
        refreshController.refreshCompleted();
        //refreshController.refreshFailed();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1), content: Text('onRefresh No more data!')));
        return false;
      } else {
        offSet -= defaultOffset;
      }
      listViewDirectionReversed = isRefresh;
    } else {
      offSet += defaultOffset;
      listViewDirectionReversed = isRefresh;
    }
    /*if(isRefresh == true) {
      offSet = 0;
    } else {
      if(offSet >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }*/
    log('offSet: $offSet');
    final Uri uri = Uri.parse("https://api.escuelajs.co/api/v1/products?offset=$offSet&limit=$defaultOffset");
    final response = await http.get(uri);

    if(response.statusCode == 200) {
      var bodyData = response.body;
      final List<dynamic> parsedList = jsonDecode(bodyData);
      List<Product> newProductsListData = parsedList.map((item) => Product.fromJson(item)).toList();


      log('lastLoadedOffset: $lastLoadedOffset');
      log('isRefresh: $isRefresh');
      log("Url: https://api.escuelajs.co/api/v1/products?offset=$offSet&limit=10");
      //log('Body: $bodyData');

      productsData = newProductsListData;



      if(parsedList.length < defaultOffset) {
        if (parsedList.isNotEmpty) {
          //List<Product> productsDataTemp = productsData;
          //productsData = [];

/*

          if(isRefresh) {
            double hh = 0.0;
            if (GlobalObjectKey(("List0").hashCode).currentContext != null) {

              //hh = hh + GlobalObjectKey(0.hashCode).currentContext!.size!.height;
              hh = GlobalObjectKey(("List0").hashCode).currentContext!.size!.height;
            }
            /*for (int index in Iterable.generate(10)) {
          if (GlobalObjectKey(("List$index").hashCode).currentContext != null) {
            hh += GlobalObjectKey(("List$index").hashCode).currentContext!.size!.height;
          }
          print(index);
        }*/
            double test = hh*10-_scrollController.position.maxScrollExtent;
            //double test2 = hh*10-listviewKey.currentContext!.size!.height+(listviewKey.currentContext!.size!.height-_scrollController.position.extentInside+hh);
            double test2 = _scrollController.position.extentTotal-listviewKey.currentContext!.size!.height;

            print("hh"+hh.toString());
            print("list"+listviewKey.currentContext!.size!.height.toString());
            print("max"+_scrollController.position.maxScrollExtent.toString());
            print("after"+_scrollController.position.extentAfter.toString());
            print("total"+_scrollController.position.extentTotal.toString());
            print("inside"+_scrollController.position.extentInside.toString());
            print("test"+test.toString());
            print("test2"+test2.toString());

            _scrollController.jumpTo(test2);
          } else {
            _scrollController.jumpTo(0);
            //_scrollController.animateTo(0.0,curve: Curves.easeOut,duration: const Duration(milliseconds: 1));
          }
          //setState(() {});

          await Future.delayed(const Duration(milliseconds: 3));
*/
          //productsData = productsDataTemp;
          setState(() {});
          refreshController.loadComplete();
        }
        refreshController.loadNoData(); // now cant scroll down anymore
        //offSet -= defaultOffset;
        log('offSetEndNoData: $offSet');
        return false;
      }

      refreshController.loadComplete(); // enable scroll down again


      /*if(isRefresh) {
        productsData = newProductsListData;
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.easeOut, duration: const Duration(milliseconds: 1));
        if (offSet != 0) {
          lastLoadedOffset = offSet;
          offSet -= defaultOffset;

        } else if (lastLoadedOffset == defaultOffset) {
          lastLoadedOffset = 0;
        }

        if (lastLoadedOffset == -1) {
          lastLoadedOffset = 0;
          offSet += defaultOffset;
        }

      } else {
        //productsData.addAll(newProductsListData);


        if(bodyData == "[]") {
          refreshController.loadNoData();
          offSet = lastLoadedOffset;
          return false;
        }

        productsData = newProductsListData;
        lastLoadedOffset = offSet;
        offSet += defaultOffset;


        _scrollController.animateTo(0.0,curve: Curves.easeOut,duration: const Duration(milliseconds: 1));
      }

*/
      //offSet += 10;
      log('offSetEnd: $offSet');
      //List<Product> productsDataTemp = productsData;
      //productsData = [];

/*
      if(isRefresh) {
        double hh = 0.0;
        if (GlobalObjectKey(("List0").hashCode).currentContext != null) {

          //hh = hh + GlobalObjectKey(0.hashCode).currentContext!.size!.height;
          hh = GlobalObjectKey(("List0").hashCode).currentContext!.size!.height;
        }
        double test = hh*10-_scrollController.position.maxScrollExtent;
        //double test2 = hh*10-listviewKey.currentContext!.size!.height-(listviewKey.currentContext!.size!.height-_scrollController.position.extentInside);
        double test2 = _scrollController.position.extentTotal-listviewKey.currentContext!.size!.height;

        print("hh"+hh.toString());
        print("list"+listviewKey.currentContext!.size!.height.toString());
        print("max"+_scrollController.position.maxScrollExtent.toString());
        print("after"+_scrollController.position.extentAfter.toString());
        print("total"+_scrollController.position.extentTotal.toString());
        print("inside"+_scrollController.position.extentInside.toString());
        print("test"+test.toString());
        print("test2"+test2.toString());

        _scrollController.jumpTo(test2);
        //_scrollController.animateTo(test, curve: Curves.easeOut, duration: const Duration(milliseconds: 1));
      } else {
        _scrollController.jumpTo(0);
        //_scrollController.animateTo(0.0,curve: Curves.easeOut,duration: const Duration(milliseconds: 1));
      }
      //setState(() {});

      await Future.delayed(const Duration(milliseconds: 3));
*/
      //productsData = productsDataTemp;
      setState(() {});


      return true;
    } else {
      refreshController.loadFailed();
      return false;
    }
  }


  void _ensureVisible(int attempt) {
    if (GlobalObjectKey(("List${defaultOffset-1}").hashCode).currentContext != null && GlobalObjectKey(("List${defaultOffset-1}").hashCode).currentContext!.findRenderObject() != null) {
      _scrollController.position.ensureVisible(GlobalObjectKey(("List${defaultOffset-1}").hashCode).currentContext!.findRenderObject()!, alignment: 1, duration: const Duration(milliseconds: 1));
    }/* else if (attempt > 10) {
      // if findRenderObject is still null -> add item size (hh) and jumpTo until last item is visible
      //_scrollController.jumpTo(test2+hh);
      //attempt = 0;
    }*/ else {
      Timer(const Duration(milliseconds: 3), () => _ensureVisible(attempt++));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      if (listViewDirectionReversed) {
        double hh = 0.0;
        if (GlobalObjectKey(("List0").hashCode).currentContext != null) {

          //hh = hh + GlobalObjectKey(0.hashCode).currentContext!.size!.height;
          hh = GlobalObjectKey(("List0").hashCode).currentContext!.size!.height;
        }
        /*for (int index in Iterable.generate(10)) {
          if (GlobalObjectKey(("List$index").hashCode).currentContext != null) {
            hh += GlobalObjectKey(("List$index").hashCode).currentContext!.size!.height;
          }
          print(index);
        }*/
        double test = hh*defaultOffset-_scrollController.position.maxScrollExtent;
        //double test2 = hh*10-listviewKey.currentContext!.size!.height-(listviewKey.currentContext!.size!.height-_scrollController.position.extentInside);
        double test2 = hh*defaultOffset-listviewKey.currentContext!.size!.height;

        print("hh"+hh.toString());
        print("list"+listviewKey.currentContext!.size!.height.toString());
        print("max"+_scrollController.position.maxScrollExtent.toString());
        print("after"+_scrollController.position.extentAfter.toString());
        print("total"+_scrollController.position.extentTotal.toString());
        print("inside"+_scrollController.position.extentInside.toString());
        print("test"+test.toString());
        print("test2"+test2.toString());

        _scrollController.jumpTo(test2);
        Timer(const Duration(milliseconds: 3), () => _ensureVisible(1));

        //_scrollController.jumpTo(test2);
        //_scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.elasticOut);
        //_scrollController.jumpTo(_scrollController.position.maxScrollExtent-500);
        //Scrollable.ensureVisible(GlobalObjectKey(defaultOffset.hashCode).currentContext!);
      } else {
        //_scrollController.animateTo(0, duration: Duration(milliseconds: 1), curve: Curves.elasticOut);
        _scrollController.jumpTo(0);
        //Scrollable.ensureVisible(GlobalObjectKey(0.hashCode).currentContext!);
      }

    } else {
      Timer(Duration(milliseconds: 1), () => _scrollToBottom());
    }
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: SmartRefresher(
        physics: const BouncingScrollPhysics(),
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          final result = await getProductsData(isRefresh: true);
          if(result) {
            refreshController.refreshCompleted();
            //refreshController.loadComplete();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: const Text('Complete onRefresh')));
          } else {
            //refreshController.refreshFailed();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: const Text('Failed onRefresh')));
          }
        },
        onLoading: () async {
          final result = await getProductsData();
          if(result) {
            refreshController.loadComplete();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: const Text('Completed')));
          } else {
            //refreshController.loadNoData();

            //refreshController.loadFailed();
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 1), content: const Text('Failed')));
          }
        },
        child: ListView.separated(
          restorationId: 'items_feed',
          key: listviewKey,
          controller: _scrollController,
          //reverse: listViewDirectionReversed,
          itemCount: productsData.length,
          itemBuilder: (context, index) {
            Product cProduct = productsData[index];
            return Card(
              key: GlobalObjectKey(("List$index").hashCode),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(5)
                    ),
                    child: Image(
                      image: NetworkImage(cProduct.images!.first),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      errorBuilder: (_,d,s) {
                        return Container(
                          color: Colors.grey.shade300,
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                              child: Text(
                                "Image Not Found -_-",
                                style: TextStyle(
                                    color: Colors.grey
                                ),
                              )
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(right: 10, left: 5),
                    title: Text(
                      cProduct.title!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      cProduct.description!,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700
                      ),
                      maxLines: 2, // Limit to two lines
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          cProduct.images!.last
                      ),
                    ),
                    trailing: Text(
                      "\$${cProduct.price.toString() }",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(),
          ),
        ),
      ),
    );
  }
/*
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }*/
}


class Product {
  int? id;
  String? title;
  int? price;
  String? description;
  List<String>? images;
  String? creationAt;
  String? updatedAt;
  Category? category;

  Product(
      {this.id,
        this.title,
        this.price,
        this.description,
        this.images,
        this.creationAt,
        this.updatedAt,
        this.category});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    images = json['images'].cast<String>();
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['images'] = images;
    data['creationAt'] = creationAt;
    data['updatedAt'] = updatedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;
  String? creationAt;
  String? updatedAt;

  Category({this.id, this.name, this.image, this.creationAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['creationAt'] = creationAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}