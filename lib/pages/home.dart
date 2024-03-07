import 'dart:io';
import 'dart:typed_data';
import 'package:arabi_dic/ads/banner/banner_view.dart';
import 'package:arabi_dic/pages/MainText.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:arabi_dic/entity/Dictionar.dart';
import 'package:arabi_dic/entity/alphabetkmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../ads/AppLifecycleReactor.dart';
import '../ads/AppOpenAdManager.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'فارسی به عربی'; // Move this here to make it a member variable

  static const String _dbName = 'data.db';
  bool _isDbCreated = false;
  bool visibility=true;
  bool listvisibility=false;

  final List<D_arabi> _listm = [];
  String text="";

  late ScrollController _scrollController; // Add ScrollController

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    _copyDatabase();
    _scrollController = ScrollController(); // Initialize ScrollController
    _scrollController.addListener(_scrollListener); // Add listener

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has scrolled to the end of the list, load more data if needed
      // For example, you can call a function here to load more data
      // _loadMoreData();
    }
  }

  Future<void> _copyDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, _dbName);
    final File file = File(path);
    if (!file.existsSync()) {
      final ByteData data = await rootBundle.load(join('assets/', _dbName));
      final List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes);
      print('database succuffully copied to $path');
      setState(() {
        _isDbCreated = true;
      });
    } else {
      print('database already exist path: $path');
      setState(() {
        _isDbCreated = true;
      });
    }
  }

  List<D_arabi> _list = [];
  void _performSearch(String query, String table) async {
    final results = await Dictionary.search(query, table);
    if(results.isEmpty) {
      setState(() {
        _list.clear();
      });
    } else {
      setState(() {
        _list.clear();
        _list = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      'فارسی به عربی',
      'عربی به فارسی',
    ];

    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title:   Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder:  OutlineInputBorder(
                        borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(Icons.search),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: Colors.grey, width: 0.0),
                        borderRadius: BorderRadius.circular(5),// Remove focus underline
                      ),
                      hintText: 'جستجو',
                    ),
                    onChanged: (query){
                      setState(() {
                        String table='';
                        if(dropdownValue=="فارسی به عربی"){
                          table="fa";
                        } else if(dropdownValue=="عربی به فارسی"){
                          table='ar';
                        }
                        if(query.isEmpty){
                          searchController.clear();
                          _list.clear();
                        } else {
                          _performSearch(query, table);
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 5,),// Add some space between the TextField and DropdownButton
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: Colors.black12, style: BorderStyle.solid, width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.black), // Set text color of dropdown
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!; // Assign newValue directly to dropdownValue
                        print(dropdownValue);
                        searchController.clear();
                        _list.clear();
                      });
                    },
                    dropdownColor: Colors.white, // Set dropdown background color
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white10,
      ),
      body:  Column(
        children: [
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0.0, -0.0, 0.0),
              child: _list.isNotEmpty
                  ? ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: _list.length,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemBuilder: (c, index) {
                  return Container(
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: ListTile(
                          minLeadingWidth : 0,
                          dense:true,
                          minVerticalPadding: -6,
                          contentPadding: const EdgeInsets.fromLTRB(3, 0, 3, 5),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          title: InkWell(
                            onTap: (){
                              Get.to(MainText(vag: _list[index].vag, tarjoma:_list[index].tarjome,));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              elevation: 1,
                              shadowColor: Colors.black,
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(_list[index].vag, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),)
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                          children: [
                                            Flexible(child: Text(_list[index].tarjome, style: const TextStyle(fontSize: 14,color: Colors.black54),maxLines: 1,softWrap: true,overflow: TextOverflow.ellipsis,))
                                          ]
                                      ),
                                    ],
                                  ), //Column
                                ), //Padding
                              ), //SizedBox
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(''),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BannerComponent(),
    );
  }
}
