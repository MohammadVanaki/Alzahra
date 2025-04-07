import 'package:alzahra/common/utils/costum_loading.dart';
import 'package:alzahra/common/widgets/input.dart';
import 'package:alzahra/features/feature_intro/data/data_source/forgot_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  Future? _forgotPasswordFuture;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/Sprinkle.svg',
            fit: BoxFit.fill,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 30,
            ),
            width: size.width * 0.9,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'نسيت كلمة المرور',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(20),
                  FormInput(
                    labelText: 'البريد الالكتروني',
                    obscureText: false,
                    controller: _controllerEmail,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _forgotPasswordFuture =
                            userForgotPassword(email: _controllerEmail.text);
                      });
                    },
                    child: Text(
                      'ارسال',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            child: FutureBuilder(
                future: _forgotPasswordFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const SizedBox();
                    case ConnectionState.waiting:
                      return const Column(
                        children: [
                          LoadingProgress(),
                          Gap(15),
                          Text(
                            'يرجى الانتظار..',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    case ConnectionState.done:
                      debugPrint('${snapshot.data?['errors']}');
                      return snapshot.data?['errors'] != null
                          ? Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const Gap(5),
                                Text(
                                  snapshot.data['errors'][0] ?? '',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const Gap(5),
                                Text(
                                  'تم ارسال الرمز الجديد على البريد الالكتروني',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                    default:
                      return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
