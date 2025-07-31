part of 'edit_bonus_cubit.dart';

enum EditBonusStatus { initial, loading, success, error }

class EditBonusState extends Equatable {
  final String? errorMessage;
  final EditBonusStatus status;
  final bool isEditMode;
  final String? name;
  final String? link;
  final String? emoji;
  final String? photoUrl;
  final XFile? photo;
  final UserModel? kid;
  final UserModel? mentor;
  final int? point;
  final int step;

  const EditBonusState({
    this.errorMessage,
    this.status = EditBonusStatus.initial,
    this.isEditMode = false,
    this.name,
    this.link,
    this.emoji,
    this.photoUrl,
    this.photo,
    this.kid,
    this.mentor,
    this.point,
    this.step = 0,
  });

  EditBonusState copyWith({
    String? errorMessage,
    EditBonusStatus? status,
    bool? isEditMode,
    String? name,
    String? link,
    String? emoji,
    String? photoUrl,
    XFile? photo,
    UserModel? kid,
    UserModel? mentor,
    int? point,
    int? step,
  }) {
    return EditBonusState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isEditMode: isEditMode ?? this.isEditMode,
      name: name ?? this.name,
      link: link ?? this.link,
      photo: photo == null
          ? this.photo
          : photo.path == 'delete'
              ? null
              : photo,
      emoji: emoji == null
          ? this.emoji
          : emoji == 'delete'
              ? null
              : emoji,
      photoUrl: photoUrl ?? this.photoUrl,
      kid: kid ?? this.kid,
      mentor: mentor ?? this.mentor,
      point: point ?? this.point,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        isEditMode,
        name,
        link,
        emoji,
        photo,
        kid,
        mentor,
        point,
        step,
      ];

  EditBonusState reset() => const EditBonusState();
}
