sealed class UserInfoBase{}

class UserInfoLoading extends UserInfoBase{}

class UserInfoModel extends UserInfoBase {}

class UserInfoError extends UserInfoBase{
  final String message;

  UserInfoError({
    required this.message,
  });
}