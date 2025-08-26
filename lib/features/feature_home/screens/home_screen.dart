import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:alzahra/common/utils/costum_dialog_message.dart';
import 'package:alzahra/common/utils/costum_loading.dart';
import 'package:alzahra/config/constants.dart';
import 'package:alzahra/features/feature_home/widgets/notif_card.dart';
import 'package:alzahra/features/feature_intro/screens/login_screen.dart';
import 'package:alzahra/features/feature_offline/screens/main_offline_screen.dart';
import 'package:alzahra/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  bool loadContent = false;
  bool pageFinished = true;
  String pageContent = 'grid';
  String pdfName = '';
  // final ValueNotifier<bool> showDownloadPanelNotifier =
  //     ValueNotifier<bool>(false);

  WebViewController controller = WebViewController();
  final List<IconData> iconList = <IconData>[
    Icons.home,
    Icons.chat,
    Icons.menu_book_rounded,
    Icons.note_alt,
  ];
  final List servicesList = [
    {'title': 'المعلومات الشخصية', 'icon': 'information.png'},
    {'title': 'الصوتيات', 'icon': 'sound.png'},
    {'title': 'المرئيات', 'icon': 'video.png'},
    {'title': 'البث المباشر', 'icon': 'live_video.png'},
    {'title': 'المنهج الدراسي', 'icon': 'curriculum.png'},
    {'title': 'المنهج الاسبوعي', 'icon': 'curriculum.png'},
    {'title': 'المكتبة', 'icon': 'library.png'},
    // {'title': 'الاخبار ', 'icon': 'newspaper.png'},
    {'title': 'البوم الصور ', 'icon': 'gallery.png'},
    {'title': ' الحضور والغياب ', 'icon': 'date.png'},
    {'title': 'امتحان ', 'icon': 'check-box.png'},
    {'title': 'الرسائل ', 'icon': 'messages.png'},
    {'title': 'طباعة ', 'icon': 'print.png'},
    {'title': 'ملاحظات ', 'icon': 'notification.png'},
    {'title': 'من نحن ', 'icon': 'about.png'},
    {'title': 'الغاء العضوية', 'icon': 'delete-user.png'},
  ];
  List<String> titleContent = [];
  List<String> bodyContent = [];
  List<String> dateContent = [];
  _getContents() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      titleContent = pref.getStringList("titleContent") ?? [];
      bodyContent = pref.getStringList("bodyContent") ?? [];
      dateContent = pref.getStringList("dateContent") ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    bindBackgroundIsolate();
    controller
      ..addJavaScriptChannel(
        'Print11',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint(
              'js  audioName===========================>>>' + message.message);
          final dateList = message.message.split("+");

          setState(() {
            audioName = message.message;
          });
          debugPrint("js  audioName===========================>>>" +
              dateList[0] +
              '-----' +
              dateList[1]);
        },
      );
    _getContents();
    showDownloadPanelNotifier.addListener(() {
      if (showDownloadPanelNotifier.value) {
        print("Download panel should show");
      } else {
        print("Download panel should hide");
      }
    });
  }

  String newUrl = '';
  String oldUrl = '';
  String audioName = '';
  String fileName = '';
  String progressP = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<bool> _exitApp(BuildContext context) async {
      if (await controller.canGoBack()) {
        print("onwill goback");
        controller.goBack();
        return Future.value(true);
      } else {
        setState(() {
          loadContent = false;
          pageContent = 'grid';
          _bottomNavIndex = 0;
        });
        return Future.value(false);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _exitApp(context);
      },
      child: Scaffold(
        body: Container(
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorLight,
                  Colors.white,
                ],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                tileMode: TileMode.clamp),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 40,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          loadContent = true;
                          pageContent = 'notif';
                        });
                      },
                      icon: const Icon(Icons.notifications_active),
                      color: Colors.white,
                    ),
                    Text(
                      'منصة الزهراء الالكترونية',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 2,
                      child: IconButton(
                        onPressed: () {
                          dialogBuilder(
                            context: context,
                            titleText: 'هل تريد تسجيل الخروج من حسابك؟',
                            disableText: 'لا',
                            enableText: 'نعم',
                            enable: () {
                              Constants.getStorage.remove('userData');
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: const LoginPage(),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.exit_to_app),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 90,
                // right: 30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: loadContent ? 0 : 1,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/profile-vector.jpg',
                              // Use user photo if available, otherwise fallback to default avatar
                              image: (Constants.getStorage.read('userData') !=
                                          null &&
                                      Constants.getStorage
                                              .read('userData')['photo'] !=
                                          null)
                                  ? Constants.getStorage
                                      .read('userData')['photo']
                                  : 'https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff&rounded=true',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover, // Cover image in rounded box
                            ),
                          ),
                          const Gap(5),
                          Text(
                            Constants.getStorage.read('userData')['name'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            Constants.getStorage
                                    .read('userData')['study_stages'] ??
                                '',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: loadContent ? 100 : size.height * 0.3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    color: Colors.grey[200],
                  ),
                  width: size.width - 20,
                  height:
                      loadContent ? (size.height - 160) : size.height * 0.59,
                  child: pageContent == 'grid'
                      ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: loadContent ? 0 : 1,
                          child: GridView.count(
                            padding: const EdgeInsets.all(18),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            controller:
                                ScrollController(keepScrollOffset: false),
                            children: List.generate(
                              servicesList.length,
                              (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      pageContent = 'web';
                                    });
                                    switch (index) {
                                      case 0:
                                        fetchContent(uriTab: 'information');
                                        break;
                                      case 1:
                                        fetchContent(uriTab: 'sounds');
                                        break;
                                      case 2:
                                        fetchContent(uriTab: 'videos');
                                        break;
                                      case 3:
                                        fetchContent(uriTab: 'live');
                                        break;
                                      case 4:
                                        fetchContent(uriTab: 'course_study');
                                        break;
                                      case 5:
                                        fetchContent(uriTab: 'weekly_study');
                                        break;
                                      case 6:
                                        fetchContent(uriTab: 'library');
                                        break;
                                      // case 7:
                                      //   fetchContent(uriTab: 'news');
                                      //   break;
                                      case 7:
                                        fetchContent(uriTab: 'gallery');
                                        break;
                                      case 8:
                                        fetchContent(uriTab: 'attendance');
                                        break;
                                      case 9:
                                        fetchContent(uriTab: 'examination');
                                        break;
                                      case 10:
                                        fetchContent(uriTab: 'messages');
                                        break;
                                      case 11:
                                        fetchContent(uriTab: 'print');
                                        break;
                                      case 12:
                                        fetchContent(uriTab: 'notes');
                                        break;
                                      case 13:
                                        setState(() {
                                          pageContent = 'web';
                                          loadContent = true;
                                          pageFinished = false;
                                        });

                                        Future.delayed(
                                          Duration(milliseconds: 300),
                                          () {
                                            setState(() {
                                              pageFinished = true;

                                              controller.loadHtmlString("""
<div
  dir="rtl"
  style="
    text-align: justify !important;
    font: dijFont-Reg;
    padding: 10px;
    color: #8f8f8f;
  "
>
  <p dir="rtl" style="font-size: 40px">
    مرحبا بكم في منصة الزهراء عليها السلام للدراسة الدينية النسوية.
    <br />
    •⁠ ⁠تأسست هذه المنصة بهدف تقديم تجربة تعليمية متميزة للاخوات الراغبات
    بالانضمام الى الدراسة الحوزوية بالإضافة إلى تعزيز التعليم الديني ونشر
    المعرفة الشرعية عبر العالم الإفتراضي.
    <br />
    •⁠ ⁠تتميز منصة الزهراء عليها السلام بتقديمها دراسة دينية متكاملة انطلاقاً من
    المقدمات وصولاً إلى مرحلة البحث الخارج وبوساطة عدة وفق مستويات تتناسب مع
    إمكانية المتقدمة للدراسة.
    <br />
    •⁠ ⁠يتمتع أساتذة المنصة بخبرة وكفاءة عاليتين تميزهم بتقديم المعرفة الدينية
    بأسلوب شيق ومفيد.
    <br />
    •⁠ ⁠تسعى منصة الزهراء عليها السلام إلى توفير بيئة تعليمية محفزة تساعد
    الطالبة على تحقيق أهدافها العلمية بأقصى قدر من الفاعلية والراحة من خلال
    توفير الدروس الدينية الحوزوية عبر الإنترنت والوصول إلى التعليم بكل ما تتمتع
    به الدراسة الحضورية دون الحاجة إلى الحضور أو السفر.
    <br />
    •⁠ ⁠مقر المنصة في النجف الأشرف وبرعاية الحوزة العلمية الشريفة .
    <br />
    •⁠ ⁠انضموا إلينا اليوم وانطلقوا في رحلة العلم والتعلم المثمر.
  </p>
</div>
""");
                                            });
                                          },
                                        );
                                        controller.loadRequest(Uri.parse(
                                            'https://m-alzahra.com/Account?app'));
                                        break;
                                      case 14:
                                        setState(() {
                                          pageContent = 'grid';
                                       
                                        });
                                        dialogBuilder(
                                          context: context,
                                          titleText:
                                              'هل انت متأكد من حذف حسابك؟',
                                          disableText: 'لا',
                                          enableText: 'نعم',
                                          enable: () {
                                            Constants.getStorage
                                                .remove('userData');
                                            Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                child: const LoginPage(),
                                                type: PageTransitionType
                                                    .bottomToTop,
                                              ),
                                            );
                                          },
                                        );
                                        break;
                                      default:
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.asset(
                                            'assets/images/${servicesList[index]['icon']}',
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        const Gap(7),
                                        Text(
                                          servicesList[index]['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : pageContent == 'web'
                          ? AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: loadContent ? 1 : 0,
                              child: pageFinished
                                  ? WebViewWidget(
                                      controller: controller
                                        ..setJavaScriptMode(
                                            JavaScriptMode.unrestricted)
                                        ..setBackgroundColor(Colors.white)
                                        ..setNavigationDelegate(
                                          NavigationDelegate(
                                            onProgress: (int progress) {
                                              debugPrint(progress.toString());
                                              if (progress < 79) {
                                                progressP = progress.toString();
                                                setState(() {
                                                  pageFinished = false;
                                                });
                                              } else {
                                                setState(() {
                                                  pageFinished = true;
                                                });
                                              }
                                            },
                                            onNavigationRequest: (request) {
                                              final uri =
                                                  Uri.parse(request.url);

                                              // بررسی فایل صوتی mp3
                                              if (uri.path.endsWith('.mp3')) {
                                                // استخراج نام فایل و عنوان (بسته به ساختار خودت)
                                                final dateList = audioName.split(
                                                    "+"); // یا هر روش دیگه شما
                                                final fileName =
                                                    '${dateList[1]}.mp3';
                                                final fileTitle = dateList[0];

                                                // شروع دانلود
                                                checkShouldDownload(
                                                    context,
                                                    request.url,
                                                    fileName,
                                                    fileTitle);

                                                // جلوی حرکت WebView به اون URL رو بگیر
                                                return NavigationDecision
                                                    .prevent;
                                              }

                                              // بررسی فایل PDF
                                              if (uri.path.endsWith('.pdf')) {
                                                final fileName =
                                                    uri.pathSegments.isNotEmpty
                                                        ? uri.pathSegments.last
                                                        : 'file.pdf';
                                                final fragment =
                                                    uri.fragment.isNotEmpty
                                                        ? Uri.decodeFull(
                                                            uri.fragment)
                                                        : '';
                                                final cleanPdfName = fragment
                                                    .split('#')[0]
                                                    .trim();

                                                pdfName = cleanPdfName;

                                                checkShouldDownload(
                                                    context,
                                                    request.url,
                                                    fileName,
                                                    pdfName);

                                                return NavigationDecision
                                                    .prevent;
                                              }

                                              // اجازه ادامه مسیر برای سایر URL ها
                                              return NavigationDecision
                                                  .navigate;
                                            },
                                            onPageStarted: (url) async {
                                              debugPrint(
                                                  'onPageStarted==========-====>>>$url');

                                              final uri = Uri.parse(url);

                                              if (uri.path.endsWith('.mp3')) {
                                                final dateList =
                                                    audioName.split("+");
                                                final fileName =
                                                    '${dateList[1]}.mp3';
                                                final fileTitle = dateList[0];

                                                checkShouldDownload(context,
                                                    url, fileName, fileTitle);
                                              } else if (uri.path
                                                  .endsWith('.pdf')) {
                                                final fileName =
                                                    uri.pathSegments.isNotEmpty
                                                        ? uri.pathSegments.last
                                                        : 'file.pdf';

                                                var rawTitle =
                                                    uri.fragment.isNotEmpty
                                                        ? Uri.decodeFull(
                                                            uri.fragment)
                                                        : 'PDF Document';

                                                final cleanTitle = rawTitle
                                                    .split('#')[0]
                                                    .trim();

                                                checkShouldDownload(context,
                                                    url, fileName, cleanTitle);
                                              }
                                            },
                                            onPageFinished: (url) {
                                              debugPrint(
                                                  'onPageFinished==========-====>>>$url');

                                              // جاوااسکریپت برای تنظیم بک‌گراند صفحه به سفید
                                              controller.runJavaScript(
                                                "document.body.style.backgroundColor = 'white';",
                                              );
                                            },
                                          ),
                                        )
                                        ..runJavaScript("""
                                    let navLinks = document.querySelectorAll(".download_link");
                                    navLinks.forEach(function (link) {
                                      link.addEventListener("click", function (event) {
                                        var val = link.getAttribute("title") + "+" + link.getAttribute("data-id");
                                        Print11.postMessage(val);
                                      });
                                    });
                                  """),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LoadingProgress(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          Gap(10),
                                          Text(
                                            progressP + '%',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            )
                          : pageContent == 'offline'
                              ? OfflinePage()
                              : SingleChildScrollView(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bodyContent.isNotEmpty
                                        ? Column(
                                            children: [
                                              ...List.generate(
                                                  bodyContent.length, (index) {
                                                return NotifCard(
                                                  body: titleContent[index],
                                                  date: dateContent[index],
                                                );
                                              }),
                                            ],
                                          )
                                        : Center(
                                            child: Text(
                                              'لا توجد نتائج',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                ),
              ),
              Positioned.fill(
                child: ValueListenableBuilder<bool>(
                  valueListenable: showDownloadPanelNotifier,
                  builder: (context, show, _) {
                    if (!show) return const SizedBox.shrink();
                    return Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'تحميل الملف...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(16),
                              const LoadingProgress(),
                              const Gap(16),
                              // progress bar
                              ValueListenableBuilder<int>(
                                valueListenable: DownloadProgress.progress,
                                builder: (context, value, _) {
                                  return Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: value / 100,
                                        backgroundColor: Colors.white24,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$value%',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          onPressed: () {
            setState(() {
              pageContent = 'offline';
            });
            fetchContent(uriTab: 'sounds');
          },
          child: Icon(
            Icons.download_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          inactiveColor: Theme.of(context).primaryColor,
          iconSize: 30,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              switch (_bottomNavIndex) {
                case 0:
                  setState(() {
                    loadContent = false;
                    pageContent = 'grid';
                  });
                  break;
                case 1:
                  setState(() {
                    pageContent = 'web';
                  });
                  fetchContent(uriTab: 'messages');
                  break;
                case 2:
                  setState(() {
                    pageContent = 'web';
                  });
                  fetchContent(uriTab: 'library');
                  break;
                case 3:
                  setState(() {
                    pageContent = 'web';
                  });
                  fetchContent(uriTab: 'notes');
                  break;
                default:
              }
            });
          },
        ),
      ),
    );
  }

  fetchContent({
    required String uriTab,
  }) {
    debugPrint('token===========================>>>' +
        Constants.getStorage.read('userData')['token']);
    setState(() {
      loadContent = true;
      controller.loadRequest(
          Uri.parse('https://m-alzahra.com/Account?tab=$uriTab'),
          headers: {
            "Authorization":
                "Bearer ${Constants.getStorage.read('userData')['token']}",
            "Embed": '1',
          });
    });
  }

  Future<void> checkShouldDownload(
    BuildContext context,
    String url,
    String fileName,
    String filetitle,
  ) async {
    final cleanTitle = filetitle.split('#')[0].trim();
    final fileExtension = p.extension(fileName);
    print("fileExtension=====>$fileExtension");

    if (fileExtension == '.mp3' || fileExtension == '.pdf') {
      final boxName = fileExtension == '.mp3' ? 'audioes' : 'pdfs';
      final listKey = fileExtension == '.mp3' ? 'audioName' : 'pdfName';

      await GetStorage.init(boxName);
      final storage = GetStorage(boxName);
      List filesList = storage.read(boxName) ?? [];

      final alreadyExists =
          filesList.any((item) => item[listKey] == cleanTitle);
      if (alreadyExists) {
        dialogBuilder(
          context: context,
          titleText: 'تم تحميل هذا الملف مسبقا!',
          disableText: '',
          enableText: 'اغلاق',
          enable: () => Navigator.of(context).pop(),
        );
        return;
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final baseStorage =
          Platform.isAndroid ? '/storage/emulated/0/Download' : appDocDir.path;

      final downloadDir = Directory(baseStorage);
      if (!(await downloadDir.exists())) {
        await downloadDir.create(recursive: true);
      }

      final fullFilePath = '$baseStorage/$fileName';

      /// ✅ اینجا پنل رو فعال کن با استفاده از ValueNotifier
      DownloadProgress.progress.value = 0;
      showDownloadPanelNotifier.value = true; // مهم: تغییر مقدار notifier

      final taskId = await FlutterDownloader.enqueue(
        url: url.trim(),
        savedDir: baseStorage,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      // ذخیره فایل
      filesList.add({
        listKey: cleanTitle,
        'fileName': fileName,
        'filePath': fullFilePath,
      });
      storage.write(boxName, filesList);
      print('filesList after save: ${storage.read(boxName)}');
    }
  }

  /// باید توی initState ویجت اصلی اپلیکیشن صدا زده بشه
  void bindBackgroundIsolate() {
    final port = ReceivePort();

    IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.registerPortWithName(
        port.sendPort, 'downloader_send_port');

    port.listen((dynamic data) {
      final String id = data[0] as String;
      final int status = data[1] as int;
      final int progress = data[2] as int;

      DownloadProgress.progress.value = progress;

      if (status == DownloadTaskStatus.complete || progress == 100) {
        showDownloadPanelNotifier.value =
            false; // Hide the panel when download is complete
      } else if (status == DownloadTaskStatus.failed) {
        showDownloadPanelNotifier.value = false; // Also hide on failure
      } else {
        showDownloadPanelNotifier.value = true; // Show panel while downloading
      }
    });
  }
}
