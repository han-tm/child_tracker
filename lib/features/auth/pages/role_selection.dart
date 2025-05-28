import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: BlocBuilder<FillDataCubit, FillDataState>(
        builder: (context, state) {
          final valid = state.userType != null;
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: MaskotMessage(
                  message: 'Выберите роль',
                  maskot: '2188-min',
                  flip: true,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    UserSelector(
                      onTap: () => context.read<FillDataCubit>().onChangeType(UserType.mentor),
                      name: 'Наставник',
                      radius: 10,
                      placeholder: SvgPicture.asset('assets/images/select_mentor.svg'),
                      isSelected: state.userType == UserType.mentor,
                    ),
                    const SizedBox(height: 20),
                    UserSelector(
                      onTap: () => context.read<FillDataCubit>().onChangeType(UserType.kid),
                      name: 'Ребёнок',
                      radius: 10,
                      placeholder: SvgPicture.asset('assets/images/select_kid.svg'),
                      isSelected: state.userType == UserType.kid,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FilledAppButton(
                        text: 'Далее',
                        isActive: valid,
                        onTap: !valid ? null : () => context.push('/auth/fill_data'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
