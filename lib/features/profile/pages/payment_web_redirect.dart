import 'dart:async';

import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentWebRedirectScreen extends StatefulWidget {
  final String orderId;
  const PaymentWebRedirectScreen({super.key, required this.orderId});

  @override
  State<PaymentWebRedirectScreen> createState() => _PaymentWebRedirectScreenState();
}

class _PaymentWebRedirectScreenState extends State<PaymentWebRedirectScreen> {
  bool isProcessing = true;

  StreamSubscription<DocumentSnapshot>? _orderSubscription;

  void _listenToChatUpdates() {
    final orderRef = FirebaseFirestore.instance.collection('orders').doc(widget.orderId);
    _orderSubscription = orderRef.snapshots().listen((snapshot) async {
      if (!snapshot.exists) return;

      if (snapshot.exists && snapshot.data() != null) {
        final orderDoc = snapshot.data() as Map;

        if ((orderDoc['paid'] == true) && mounted) {
          await context.read<UserCubit>().onPurchasePlan(orderDoc);
          bool isGift = orderDoc['is_gift'] ?? false;
          if (isGift && mounted) {
            final receiver = await context.read<UserCubit>().getUserByRef(orderDoc['user']);
            if (mounted) context.replace('/payment_success', extra: receiver.name);
          } else {
            if (mounted) context.replace('/payment_success');
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenToChatUpdates();
  }

  @override
  dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, me) {
        if (me == null) {
          return Container(
            constraints: const BoxConstraints.expand(),
            child: const Center(
              child: AppText(text: '404'),
            ),
          );
        }
        return Scaffold(backgroundColor: white, body: processingLoading());
      },
    );
  }

  Widget processingLoading() {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.black38,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 45),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              AppText(
                text: 'purchase_loading'.tr(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
