class DataProperties {
  final String token;

  static const DataProperties Empty = DataProperties('');

  const DataProperties(this.token);

  DataProperties.fromJson(Map<String,dynamic> json)
      : token = json['token'];

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}
