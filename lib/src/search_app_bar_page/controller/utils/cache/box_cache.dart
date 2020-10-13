abstract class CacheJson {
  CacheJson fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}

class BoxJsonCache<T extends CacheJson> {
  T object;

  Map<String, dynamic> jsonEncode() => object.toMap();

  CacheJson jsonDecode(Map<String, dynamic> mapObject) =>
      object.fromMap(mapObject);
}
