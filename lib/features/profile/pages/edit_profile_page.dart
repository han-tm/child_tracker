import 'dart:io';

import 'package:child_tracker/features/profile/controllers/profile/profile_cubit.dart';
import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final form = FormGroup(
    {
      'name': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(150),
        ],
      ),
      'city': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(150),
        ],
      ),
      'age': FormControl<int>(
        validators: [
          Validators.required,
        ],
      ),
    },
  );

  XFile? selectedFile;

  void onSaveTap(BuildContext context) {
    form.markAllAsTouched();

    if (form.valid) {
      context.read<ProfileCubit>().updateProfile(form.value, selectedFile);
    }
  }

  void onPick() async {
    final XFile? xfile = await CustomImagePicker.pickAvatarFromGallery(context);

    if (xfile == null) return;

    setState(() {
      selectedFile = xfile;
    });
  }

  void init() {
    final user = context.read<UserCubit>().state;
    form.value = {
      'name': user?.name,
      'city': user?.city,
      'age': user?.age,
    };
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(userCubit: sl()),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStateStatus.error) {
            SnackBarSerive.showErrorSnackBar(state.errorMessage ?? defaultErrorText);
          } else if (state.status == ProfileStateStatus.success) {
            SnackBarSerive.showSuccessSnackBar('Профиль успешно обновлён');
            context.pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ReactiveForm(
                  formGroup: form,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CachedClickableImage(
                        circularRadius: 100,
                        height: 100,
                        width: 100,
                        imageFile: selectedFile?.path != null ? File(selectedFile!.path) : null,
                        imageUrl: context.read<UserCubit>().state?.photo,
                        onTap: onPick,
                      ),
                      const SizedBox(height: 20),
                      ReactiveCustomInput(
                        formName: 'name',
                        label: 'Имя',
                        hint: 'Введите имя',
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        validationMessages: {
                          'required': (error) => 'Заполните поле',
                          'minLength': (error) => 'Минимум 3 символа',
                          'maxLength': (error) => 'Максимум 150 символов',
                        },
                      ),
                      const SizedBox(height: 20),
                      ReactiveCustomInput(
                        formName: 'city',
                        label: 'Город',
                        hint: 'Введите город',
                        inputType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        validationMessages: {
                          'required': (error) => 'Заполните поле',
                          'minLength': (error) => 'Минимум 3 символа',
                          'maxLength': (error) => 'Максимум 150 символов',
                        },
                      ),
                      const SizedBox(height: 20),
                      ReactiveCustomInput(
                        formName: 'age',
                        label: 'Возраст',
                        hint: 'Введите возраст',
                        inputType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validationMessages: {
                          'required': (error) => 'Заполните поле',
                        },
                      ),
                      const SizedBox(height: 20),
                      ReactiveFormConsumer(
                        builder: (context, formGroup, child) {
                          return FilledAppButton(
                            text: 'Сохранить',
                            onTap: () =>  state.status == ProfileStateStatus.saving ? null : onSaveTap(context),
                            isLoading: state.status == ProfileStateStatus.saving,
                            isActive: formGroup.valid,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
