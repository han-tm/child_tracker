import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KidDetailScreen extends StatefulWidget {
  final DocumentReference kidRef;
  const KidDetailScreen({super.key, required this.kidRef});

  @override
  State<KidDetailScreen> createState() => _KidDetailScreenState();
}

class _KidDetailScreenState extends State<KidDetailScreen> {
  late UserModel kid;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final kidSnap = await widget.kidRef.get();
    kid = UserModel.fromFirestore(kidSnap);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: white,
        constraints: const BoxConstraints.expand(),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const AppText(text: 'Ребёнок', size: 24, fw: FontWeight.w700),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedClickableImage(
                  circularRadius: 100,
                  width: 80,
                  height: 80,
                  imageUrl: kid.photo,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: kid.name,
                        size: 20,
                        fw: FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        text: '${kid.age} лет, ${kid.city}',
                        size: 16,
                        fw: FontWeight.w500,
                        color: greyscale700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 48, thickness: 1, color: greyscale200),
            Column(
              children: [
                ProfileMenuCard(
                  onTap: () => {},
                  icon: 'diary',
                  title: 'Мой дневник',
                  color: const Color(0xFF246BFD).withOpacity(0.08),
                ),
                const Divider(height: 48, thickness: 1, color: greyscale200),
              ],
            ),
            ProfileMenuCard(
              onTap: () => {},
              icon: 'progress',
              title: 'Прогресс по заданиям',
              color: const Color(0xFF246BFD).withOpacity(0.08),
            ),
            const SizedBox(height: 24),
            ProfileMenuCard(
              onTap: () => {},
              icon: 'coin',
              title: 'Баллы по заданиям',
              color: orange.withOpacity(0.08),
            ),
            const Divider(height: 48, thickness: 1, color: greyscale200),
            ProfileMenuCard(
              onTap: () {
                final Map<String, dynamic> extra = {
                  'user': kid,
                  'canAdd': false,
                  'showChat': false,
                  'showDelete': false,
                };
                context.push('/connections', extra: extra);
              },
              icon: '3user',
              title: 'Мои наставники',
              iconColor: blue,
              color: const Color(0xFF235DFF).withOpacity(0.08),
            ),
          ],
        ),
      ),
    );
  }
}
