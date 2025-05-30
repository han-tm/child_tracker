// ignore_for_file: deprecated_member_use

import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AddConnectionScreen extends StatelessWidget {
  const AddConnectionScreen({super.key});

  void onAdd() {}

  void onShowQr(BuildContext context, String id) {
    showQRModalBottomSheet(context, id);
  }

  void onScanQr(BuildContext context) async {
    final UserModel? kid = await context.push('/scan_qr');
    print(kid?.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) return const SizedBox();
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            leadingWidth: 70,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.arrow_left),
              onPressed: () => context.pop(),
            ),
            title:
                AppText(text: user.isKid ? 'Добавить наставника' : 'Добавить ребенка', size: 24, fw: FontWeight.w700),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ConnectionCard(
                      onDelete: () {},
                      onChat: () {},
                      onAdd: onAdd,
                      isAdd: true,
                      user: user,
                    );
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      RichText(
                        text: const TextSpan(
                          text: 'Чтобы добавить нового участника в спиок, поделитесь своим  ',
                          style: TextStyle(
                            color: greyscale800,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: Involve,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                                text: 'QR-кодом',
                                style: TextStyle(
                                  color: greyscale800,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  fontFamily: Involve,
                                  height: 1.6,
                                )),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledSecondaryAppButton(
                        text: !user.isKid ? 'Сканируйте  QR-код' : 'Поделиться QR кодом',
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: !user.isKid
                              ? SvgPicture.asset('assets/images/scan_q.svg', color: primary900, width: 20, height: 20)
                              : SvgPicture.asset('assets/images/qr.svg', color: primary900, width: 20, height: 20),
                        ),
                        onTap: () {
                          if (user.isKid) {
                            onShowQr(context, user.id);
                          } else {
                            onScanQr(context);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
