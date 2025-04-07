import 'package:alzahra/common/utils/player_widget.dart';
import 'package:alzahra/config/constants.dart';
import 'package:alzahra/features/feature_offline/widgets/offline_list_item.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  List audioesList = Constants.getStorage.read('audioes') ?? [];
  List pdfsList = Constants.getStorage.read('pdfs') ?? [];
  var _openResult = 'Unknown';
  late AudioPlayer player = AudioPlayer();
  bool showAudioPlayer = false;
  String? audioTitle;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

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
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...List.generate(audioesList.length, (index) {
                      return InkWell(
                        onTap: () async {
                          debugPrint('==================================');
                          debugPrint(audioesList.toString());
                          final permissionStatus = Permission.audio.request();
                          if (await permissionStatus.isDenied) {
                            await Permission.storage.request();
                            if (await permissionStatus.isDenied) {
                              Permission.audio.request();
                            }
                          } else if (await permissionStatus
                              .isPermanentlyDenied) {
                            Permission.audio.request();
                          } else {
                            setState(() {
                              showAudioPlayer = true;
                              audioTitle = audioesList[index]['audioName'];
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await player.play(
                                  DeviceFileSource(
                                    '/storage/emulated/0/Download/' +
                                        audioesList[index]['fileName'],
                                  ),
                                );
                                await player.resume();
                              });
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OfflineItemCard(
                            title: audioesList[index]?['audioName'] ?? '',
                            imagePath: 'assets/images/sound.png',
                          ),
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: showAudioPlayer,
                        child: PlayerWidget(
                          player: player,
                          title: audioTitle ?? '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...List.generate(
                      pdfsList.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            openFile(pdfsList[index]['fileName']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OfflineItemCard(
                              title: pdfsList[index]['pdfName'],
                              imagePath: 'assets/images/icons8-pdf-64.png',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openFile(String fileName) async {
    _openAndroidExternalImage(fileName);
  }

  _openAndroidExternalImage(String fileName) async {
    //open an external storage image file on android 13
    debugPrint('fileName--->  $fileName');
    if (await Permission.photos.request().isGranted) {
      final result =
          await OpenFilex.open("/storage/emulated/0/Download/" + fileName);
      setState(() {
        _openResult = "type=${result.type}  message=${result.message}";
      });
    }
  }
}
