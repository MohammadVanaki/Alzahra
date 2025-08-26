import 'dart:io';

import 'package:alzahra/common/utils/costum_dialog_message.dart';
import 'package:alzahra/common/utils/player_widget.dart';
import 'package:alzahra/features/feature_offline/widgets/offline_list_item.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  List audioesList = [];
  List pdfsList = [];

  @override
  void initState() {
    super.initState();
    print('🟡 initState called');
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    loadOfflineFiles();
  }

  var _openResult = 'Unknown';
  late AudioPlayer player = AudioPlayer();
  bool showAudioPlayer = false;
  String? audioTitle;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.headphones),
                text: 'الصوتيات',
              ),
              Tab(
                icon: Icon(Icons.menu_book_rounded),
                text: 'الكتب',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // This makes the ListView take all remaining space
                  Expanded(
                    child: ListView.builder(
                      itemCount: audioesList.length,
                      itemBuilder: (context, index) {
                        final audioItem = audioesList[index];
                        return InkWell(
                          onTap: () async {
                            debugPrint('==================================');
                            debugPrint(audioesList.toString());

                            // Request permission on Android
                            if (Platform.isAndroid) {
                              final permissionStatus =
                                  await Permission.audio.request();

                              if (permissionStatus.isDenied) {
                                final storagePermission =
                                    await Permission.storage.request();
                                if (storagePermission.isDenied) {
                                  return;
                                }
                              } else if (permissionStatus.isPermanentlyDenied) {
                                openAppSettings();
                                return;
                              }
                            }

                            final filePath = audioItem['filePath'];
                            final fileExists = await File(filePath).exists();

                            if (!fileExists) {
                              dialogBuilder(
                                context: context,
                                titleText: 'الملف غير موجود!',
                                disableText: '',
                                enableText: 'إغلاق',
                                enable: () => Navigator.of(context).pop(),
                              );
                              return;
                            }

                            setState(() {
                              showAudioPlayer = true;
                              audioTitle = audioItem['audioName'];

                              // Start the audio playback
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await player.play(DeviceFileSource(filePath));
                                await player.resume();
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OfflineItemCard(
                              title: audioItem['audioName'] ?? '',
                              imagePath: 'assets/images/sound.png',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Audio player widget appears below the list
                  Visibility(
                    visible: showAudioPlayer,
                    child: PlayerWidget(
                      player: player,
                      title: audioTitle ?? '',
                      onClose: () {
                        setState(() {
                          showAudioPlayer = false;
                          player.stop();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: pdfsList.length,
                itemBuilder: (context, index) {
                  final pdfItem = pdfsList[index];
                  return InkWell(
                    onTap: () async {
                      final filePath = pdfItem['filePath'];
                      final fileExists = await File(filePath).exists();

                      if (!fileExists) {
                        dialogBuilder(
                          context: context,
                          titleText: 'الملف غير موجود!',
                          disableText: '',
                          enableText: 'إغلاق',
                          enable: () => Navigator.of(context).pop(),
                        );
                        return;
                      }
                      openFile(filePath);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OfflineItemCard(
                        title: pdfItem['pdfName'] ?? '',
                        imagePath: 'assets/images/icons8-pdf-64.png',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openFile(String fullPath) async {
    debugPrint('openFile -> $fullPath');

    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      debugPrint("❌ Permission denied");
      return;
    }

    final fileExists = await File(fullPath).exists();
    debugPrint('File exists: $fileExists');

    if (!fileExists) {
      dialogBuilder(
        context: context,
        titleText: 'الملف غير موجود!',
        disableText: '',
        enableText: 'إغلاق',
        enable: () => Navigator.of(context).pop(),
      );
      return;
    }

    final result = await OpenFilex.open(fullPath);
    debugPrint(
        "📂 OpenFilex result: type=${result.type}, message=${result.message}");
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }

    return true;
  }

  Future<void> loadOfflineFiles() async {
    print('🟢 loadOfflineFiles started');

    // Initialize GetStorage boxes
    await GetStorage.init('audioes');
    await GetStorage.init('pdfs');

    // Create storage instances
    final audioStorage = GetStorage('audioes');
    final pdfStorage = GetStorage('pdfs');

    // Read audio list from storage
    final audioListRaw =
        audioStorage.read('audioes'); // If saved under key 'audioes'
    print('🔵 audioes from storage: $audioListRaw');

    // Read pdf list from storage
    final pdfListRaw = pdfStorage.read('pdfs'); // If saved under key 'pdfs'
    print('🟣 pdfs from storage: $pdfListRaw');

    // Update the state with retrieved data
    setState(() {
      audioesList = audioListRaw ?? [];
      pdfsList = pdfListRaw ?? [];
    });
  }
}
