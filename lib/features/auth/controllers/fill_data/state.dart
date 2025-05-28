part of 'fill_data_cubit.dart';

enum FillDataStatus { initial, loading, success, error }

class FillDataState extends Equatable {
  final String? errorMessage;
  final FillDataStatus status;
  final UserType? userType;
  final String? name;
  final XFile? photo;
  final int? age;
  final String? city;
  final int step;

  const FillDataState({
    this.errorMessage,
    this.status = FillDataStatus.initial,
    this.userType,
    this.name,
    this.photo,
    this.age,
    this.city,
    this.step = 0,
  });

  FillDataState copyWith({
    String? errorMessage,
    FillDataStatus? status,
    UserType? userType,
    String? name,
    XFile? photo,
    int? age,
    String? city,
    int? step,
  }) {
    return FillDataState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      age: age ?? this.age,
      city: city ?? this.city,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        userType,
        name,
        photo,
        age,
        city,
        step,
      ];

    FillDataState reset() => const FillDataState();
}
