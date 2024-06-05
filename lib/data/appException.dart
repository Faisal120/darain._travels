class AppException implements Exception{
  final _message ;
  final _prefix ;

  AppException([this._message, this._prefix]);

  String toString(){
    return '$_message$_prefix';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Error during communication!');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Bad request!');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, 'Unauthorized Exception!');
}


class UnauthoriedException extends AppException {
  UnauthoriedException([String? message]) : super(message, 'Unauthorized Exception!');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Credentials!');
}