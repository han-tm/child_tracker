

const String defaultErrorText = 'Произошла непредвиденная ошибка';


  String mapFirebaseErrorCodeToMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return 'Некорректный номер телефона.';
      case 'quota-exceeded':
        return 'Превышен лимит запросов. Пожалуйста, попробуйте позже.';
      case 'invalid-verification-code':
        return 'Неверный код подтверждения.';
      case 'session-expired':
        return 'Сессия подтверждения истекла. Пожалуйста, запросите код заново.';
      case 'operation-not-allowed':
        return 'Вход по номеру телефона не активирован в Firebase console.';
      default:
        return 'Произошла ошибка. Пожалуйста, попробуйте еще раз.';
    }
  }