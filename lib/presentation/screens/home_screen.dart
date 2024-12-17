import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_test/core/static_body.dart';
import 'package:practical_test/core/strings.dart';
import 'package:practical_test/data/models/get_product.dart';
import 'package:practical_test/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:practical_test/presentation/blocs/home_screen/home_screen_repository.dart';
import 'package:practical_test/presentation/blocs/home_screen/home_screen_state.dart';
import 'package:practical_test/presentation/screens/Signature_screen.dart';
import 'package:practical_test/presentation/widgets/button_widget.dart';
import 'package:practical_test/presentation/widgets/circular_icon_button.dart';
import 'package:practical_test/presentation/widgets/dropdown_widget.dart';
import '../../core/app_color.dart';
import '../../core/routes/routes.dart';
import '../../data/data_sources/local/database_helper.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeScreen> {
  HomeScreenBloc bloc = HomeScreenBloc(HomeScreenRepository());
  late Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;
  ConnectivityResult? _lastResult;

  List<Map<String, dynamic>> itemsList = [];

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged.map(
        (results) => results.isEmpty ? ConnectivityResult.none : results.first);
    fetchLocalData();
    var staticBody = StaticBody();
    staticBody.fetchCustomer(bloc);
    staticBody.fetchCategory(bloc);
    staticBody.fetchProduct(bloc);
  }

  late List<String> customerList = [];
  late List<String> categoryList = [];
  late List<GetProductsResult> productList = [];
  String? selectedCustomer;
  String? selectedCategory;
  GetProductsResult? selectedProduct;
  TextEditingController qtyController = TextEditingController();

  Future<void> fetchLocalData() async {
    customerList = await DatabaseHelper.instance.fetchCustomers();
    categoryList = await DatabaseHelper.instance.fetchCategories();
    productList = await DatabaseHelper.instance.fetchProducts();

    customerList = customerList.toSet().toList();
    categoryList = categoryList.toSet().toList();
    productList = productList.toSet().toList();
  }

  void showConnectivitySnackBar(
      BuildContext context, ConnectivityResult result) {
    if (_lastResult == result)
      return; // Prevent duplicate SnackBars for the same status
    _lastResult = result;
    String message;

    switch (result) {
      case ConnectivityResult.wifi:
        message = appStrings.connectedToWIFI;
        break;
      case ConnectivityResult.mobile:
        message = appStrings.connectToMobileNetwork;
        break;
      case ConnectivityResult.none:
        message = appStrings.noInterNetConnection;
        break;
      default:
        message = appStrings.unknowConnectivityStatus;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              result == ConnectivityResult.none ? Colors.red : Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
      bloc: bloc,
      listener: (context, state) async {
        if (state is HomeScreenLoading) {
        } else if (state is HomeScreenError) {
        } else if (state is HomeScreenCustomerLoaded) {
          await DatabaseHelper.instance.clearCustomers();
          for (var customer in state.customers.getCustomersResult!) {
            customerList.add(customer.name!);
            if (customer.name != null) {
              await DatabaseHelper.instance.insertCustomer(customer.name!);
            }
          }
        } else if (state is HomeScreenCategoryLoaded) {
          categoryList.addAll(state.category.getCategoriesResult!.toList());
          state.category.getCategoriesResult!.forEach((element) {
            DatabaseHelper.instance.insertCategory(element);
          });
        } else if (state is HomeScreenProductLoaded) {
          productList.addAll(state.product.getProductsResult!.toList());
          state.product.getProductsResult!.forEach((element) {
            DatabaseHelper.instance.insertProduct(element);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColor.primaryColor,
            title: Text(
              appStrings.addOrder,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              Icon(
                Icons.more_vert,
                color: Colors.white,
              )
            ],
          ),
          body: StreamBuilder<ConnectivityResult>(
              stream: _connectivityStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  showConnectivitySnackBar(context, snapshot.data!);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          appStrings.totalUnits2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        dropdownWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text(
                                    appStrings.selectQty,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.primaryColor,
                                        fontSize: 16),
                                  ),
                                  TextField(
                                    controller: qtyController,
                                    keyboardType: TextInputType.number,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CommonButton(
                                        text: appStrings.add,
                                        onPressed: () {
                                          addItemsToList();
                                        },
                                      ),
                                      CommonButton(
                                        text: appStrings.sub,
                                        onPressed: () {
                                          itemsSubToList();
                                        },
                                      ),
                                      CommonButton(
                                        text: appStrings.rem,
                                        onPressed: () {
                                          removeItemsToList();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        listItemsWidget(),
                      ],
                    ),
                  ),
                );
              }),
          bottomNavigationBar: bottomNavigationBarWidget(),
        );
      },
    );
  }

  Widget dropdownWidget() {
    return Column(
      children: [
        CommonDropdown(
          label: appStrings.selectCustomer,
          items: customerList,
          selectedItem: selectedCustomer,
          hintText: appStrings.chooseAnyCustomer,
          onChanged: (value) {
            setState(() {
              selectedCustomer = value;
            });
          },
          itemToString: (item) => item,
        ),
        SizedBox(
          height: 10,
        ),
        CommonDropdown(
          label: appStrings.selectCategory,
          items: categoryList,
          selectedItem: selectedCategory,
          hintText: appStrings.chooseAnyCategory,
          onChanged: (value) {
            if (categoryList.contains(value)) {
              setState(() {
                selectedCategory = value;
              });
            }
          },
          itemToString: (item) => item,
        ),
        SizedBox(
          height: 10,
        ),
        CommonDropdown<GetProductsResult>(
          label: appStrings.selectProduct,
          items: productList,
          selectedItem: selectedProduct,
          hintText: appStrings.chooseAnyProduct,
          onChanged: (GetProductsResult? value) {
            setState(() {
              selectedProduct = value;
            });
          },
          itemToString: (GetProductsResult? item) => item?.name ?? '',
        ),
      ],
    );
  }

  Widget listItemsWidget() {
    return itemsList.isEmpty
        ? Center(
          child: Text(
              appStrings.itemsNotFound,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        )
        : Column(
            children: [
              Container(
                color: Colors.black54,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appStrings.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        appStrings.qty,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: itemsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext, index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 250,
                                child: Text(
                                  itemsList[index]['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Text(
                              itemsList[index]['qty'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          );
  }

  Widget bottomNavigationBarWidget() {
    return BottomAppBar(
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.signatureScreen)
                    .then((_) {
                  setState(() {});
                });
              },
              child: Text(appStrings.tapToSign,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey))),
          GestureDetector(
              onTap: () {},
              child: signature == null
                  ? Container(
                      width: 100,
                      color: Colors.white,
                    )
                  : Image.memory(signature)),
          CircularIconButton(
            icon: Icons.done,
            onTap: () {
              if (signature == null) {
                _showError(appStrings.pleaseAddSignature);
              } else {
                Navigator.pushNamed(context, RouteNames.orderDetailScreen, arguments: {'itemsList': itemsList});
              }
            },
          )
        ],
      ),
    );
  }

  void clearListWidget() {
    selectedCustomer = null;
    selectedCategory = null;
    selectedProduct = null;
    qtyController.clear();
  }

  void addItemsToList() {
    if (selectedCustomer == null) {
      _showError(appStrings.pleaseSelectACustomer);
      return;
    }

    if (selectedCategory == null || selectedCategory!.isEmpty) {
      _showError(appStrings.pleaseSelectACategory);
      return;
    }

    if (selectedProduct == null) {
      _showError(appStrings.pleaseSelectAProduct);
      return;
    }

    final qtyText = qtyController.text;
    if (qtyText.isEmpty) {
      _showError(appStrings.quantityCanNotBeEmpty);
      return;
    }

    final qty = int.tryParse(qtyText);
    if (qty == null || qty <= 0) {
      _showError('Quantity must be a positive whole number!');
      return;
    }

    final int existingIndex =
        itemsList.indexWhere((item) => item['name'] == selectedProduct!.name);

    if (existingIndex != -1) {
      itemsList[existingIndex]['qty'] =
          (itemsList[existingIndex]['qty'] ?? 0) + qty;
    } else {
      itemsList.add({
        'name': selectedProduct!.name,
        'qty': qty,
        'price': selectedProduct!.price
      });
    }
    clearListWidget();
    setState(() {});
  }

  void itemsSubToList() {
    if (selectedCustomer == null) {
      _showError(appStrings.pleaseSelectACustomer);
      return;
    }

    if (selectedCategory == null || selectedCategory!.isEmpty) {
      _showError(appStrings.pleaseSelectACategory);
      return;
    }

    if (selectedProduct == null) {
      _showError(appStrings.pleaseSelectAProduct);
      return;
    }

    final qtyText = qtyController.text;
    if (qtyText.isEmpty) {
      _showError(appStrings.quantityCanNotBeEmpty);
      return;
    }

    final qty = int.tryParse(qtyText);
    if (qty == null || qty <= 0) {
      _showError(appStrings.quantityMustBeaPositiveWholeNumber);
      return;
    }

    final int existingIndex =
        itemsList.indexWhere((item) => item['name'] == selectedProduct!.name);

    if (existingIndex != -1) {
      setState(() {
        final currentQty = itemsList[existingIndex]['qty'] ?? 0;

        if (currentQty < qty) {
          _showError('Not enough quantity to subtract! Available: $currentQty');
          return;
        }

        itemsList[existingIndex]['qty'] = currentQty - qty;

        if (itemsList[existingIndex]['qty'] == 0) {
          itemsList.removeAt(existingIndex);
        }
        clearListWidget();
      });
    } else {
      _showError(appStrings.itemNotFoundInTheList);
    }
  }

  void removeItemsToList() {
    if (selectedProduct == null) {
      _showError(appStrings.pleaseSelectAProduct);
      return;
    }
    final int existingIndex =
        itemsList.indexWhere((item) => item['name'] == selectedProduct!.name);

    if (existingIndex != -1) {
      setState(() {
        itemsList.removeWhere((item) => item['name'] == selectedProduct!.name);
        clearListWidget();
      });
    } else {
      _showError(appStrings.itemNotFoundInTheList);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appStrings.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
