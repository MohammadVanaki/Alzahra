import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  //create stream subscription to listen to change with internet connction
  late final StreamSubscription _streamSubscription;

  //track connection with observable
  final isConnected = true.obs;
  //Check dialog
  bool _isDialogOpen = false;
  //Prevent initial online snak message
  bool _isOnline = false;

  //On initial open of application
  @override
  void onInit() {
    super.onInit();
    // _checkInternetConnectivity();
    // Listen
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectionChange);
  }

  void _handleConnectionChange(List<ConnectivityResult> connections) {
    //none represent not connected to any network
    if (connections.contains(ConnectivityResult.none)) {
      isConnected.value = false;
      _isOnline = false;
      //show no internet dialog/alert
      _showNoInternetDialog();
    } else if (connections.contains(ConnectivityResult.vpn)) {
      Get.snackbar(
        'VPN',
        'اتصال VPN الخاص بك قد يتداخل مع أداء التطبيق.',
        colorText: Colors.white,
        backgroundColor: const Color.fromARGB(200, 212, 191, 0),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      isConnected.value = true;
      //close alert when back online
      _closeDialog();
      if (_isOnline) {
        Get.snackbar(
          'تم الاتصال بالانترنت',
          'مرحبًا بعودتك',
          colorText: Colors.green[300],
          backgroundColor: Colors.green[50],
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  //alert
  void _showNoInternetDialog() {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    _isOnline = true;
    Get.dialog(
      AlertDialog(
        title: const Text('غير متصل بالإنترنت!'),
        content: const Text('أنت غير متصل بالإنترنت. اتصل وحاول مرة أخرى'),
        actions: [
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //retry functionality
                _retryConnection();
              },
              child: const Text(
                'أعد المحاولة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    ).then(
      (_) {
        _isDialogOpen = false;
      },
    );
  }

  Future<void> _retryConnection() async {
    List<ConnectivityResult> connections =
        await _connectivity.checkConnectivity();

    // check if the connection available doesnt contain a none connection meaning connected to network

    if (!connections.contains(ConnectivityResult.none)) {
      isConnected.value = true;
      Get.back();
    } else {
      Get.snackbar(
        'غير متصل بالإنترنت!',
        'تحقق من اتصال الإنترنت وحاول مرة أخرى',
        colorText: Colors.red[300],
        backgroundColor: Colors.red[50],
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _closeDialog() {
    if (_isDialogOpen) {
      Get.back();
      _isDialogOpen = false;
    }
  }

  @override
  void onClose() {
    // dispose stream
    _streamSubscription.cancel();
    _closeDialog();
    super.onClose();
  }
}
