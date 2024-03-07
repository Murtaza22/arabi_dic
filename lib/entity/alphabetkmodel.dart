import 'Dictionar.dart';

class D_arabi {
  final int id;
  final String vag;
  final String tarjome;
  final int fav;


  const D_arabi({
    required this.id,
    required this.vag,
    required this.tarjome,
    required this.fav
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': vag,
      'detail': tarjome,
      'fav': fav

    };
  }

  factory D_arabi.fromMap(Map<dynamic, dynamic> map) {
    return D_arabi(
      id: map['id'] ?? 0,
        vag: map["vag"] ?? '',
        tarjome: map["tarjome"] ?? '',
      fav: map['fav']?? 0,


    );
  }

  @override
  String toString() {
    return 'isp(id: $id, vag: $vag, tarjome: $tarjome, fav:$fav)';
  }
}

extension TransactionBook on D_arabi {
  Future<int> get insert async => await Dictionary.insert(this);
  Future<int> get delete async => await Dictionary.deleteById(id);
  Future<int> get update async => await Dictionary.update(this);
}

