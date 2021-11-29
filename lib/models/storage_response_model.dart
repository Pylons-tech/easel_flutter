/// ok : true
/// value : {"cid":"bafkreihlusofe353lfwntp7xcwvpzjvqzsohb7iykni3z7525gidsg3wqa","created":"2021-11-08T13:34:51.769+00:00","type":"image/jpeg","scope":"Easel_test","files":[],"size":101453,"pin":{"cid":"bafkreihlusofe353lfwntp7xcwvpzjvqzsohb7iykni3z7525gidsg3wqa","created":"2021-11-08T13:34:51.769+00:00","size":101453,"status":"queued"},"deals":[]}

class StorageResponseModel {
  bool? ok;
  Value? value;

  StorageResponseModel({this.ok, this.value});

  StorageResponseModel.fromJson(dynamic json) {
    ok = json['ok'];
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['ok'] = ok;
    if (value != null) {
      map['value'] = value?.toJson();
    }
    return map;
  }
}

/// cid : "bafkreihlusofe353lfwntp7xcwvpzjvqzsohb7iykni3z7525gidsg3wqa"
/// created : "2021-11-08T13:34:51.769+00:00"
/// type : "image/jpeg"
/// scope : "Easel_test"
/// files : []
/// size : 101453
/// pin : {"cid":"bafkreihlusofe353lfwntp7xcwvpzjvqzsohb7iykni3z7525gidsg3wqa","created":"2021-11-08T13:34:51.769+00:00","size":101453,"status":"queued"}
/// deals : []

class Value {
  String? cid;
  String? created;
  String? type;
  String? scope;
  int? size;
  Pin? pin;

  Value({
    this.cid,
    this.created,
    this.type,
    this.scope,
    this.size,
    this.pin,
  });

  Value.fromJson(dynamic json) {
    cid = json['cid'];
    created = json['created'];
    type = json['type'];
    scope = json['scope'];
    size = json['size'];
    pin = json['pin'] != null ? Pin.fromJson(json['pin']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cid'] = cid;
    map['created'] = created;
    map['type'] = type;
    map['scope'] = scope;
    map['size'] = size;
    if (pin != null) {
      map['pin'] = pin?.toJson();
    }
    return map;
  }
}

/// cid : "bafkreihlusofe353lfwntp7xcwvpzjvqzsohb7iykni3z7525gidsg3wqa"
/// created : "2021-11-08T13:34:51.769+00:00"
/// size : 101453
/// status : "queued"

class Pin {
  String? cid;
  String? created;
  int? size;
  String? status;

  Pin({this.cid, this.created, this.size, this.status});

  Pin.fromJson(dynamic json) {
    cid = json['cid'];
    created = json['created'];
    size = json['size'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cid'] = cid;
    map['created'] = created;
    map['size'] = size;
    map['status'] = status;
    return map;
  }
}
