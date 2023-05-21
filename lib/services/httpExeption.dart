// ignore: file_names
// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, duplicate_ignore
class HttpExeption implements Exception{
  String message;
  HttpExeption(
     this.message,
  );
  

  @override
  String toString() {
      return message;
  }
}
