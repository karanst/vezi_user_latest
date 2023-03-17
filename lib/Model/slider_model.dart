/// error : false
/// data : [{"id":"47","type":"categories","slider":"Slider_type1","type_id":"3","image":"https://vezi.global/uploads/media/2022/Organic_product_banner.jpg","date_added":"2022-12-08 19:10:36","data":[{"id":"3","name":"vegetables","parent_id":"0","slug":"vegetables-1","image":"https://vezi.global/uploads/media/2022/thumb-sm/Vegetables_New1.jpg","banner":"https://vezi.global/","row_order":"3","status":"1","clicks":"14","children":[],"text":"vegetables","state":{"opened":true},"icon":"jstree-folder","level":0,"total":21}]},{"id":"40","type":"products","slider":"Slider_type1","type_id":"30","image":"https://vezi.global/uploads/media/2022/Grocery_banner_2.jpg","date_added":"2022-09-25 12:51:02","data":[{"total":"12","sales":"1","stock_type":"2","is_prices_inclusive_tax":"1","type":"simple_product","attr_value_ids":" ","seller_rating":"5.0","seller_slug":"vezi-global-mart-1","seller_no_of_ratings":"1","seller_profile":"https://vezi.global/uploads/media/2022/Vezi_Main1.jpeg","store_name":"Vezi Global Mart","store_description":"","seller_id":"602","seller_name":"Vezi","id":"30","stock":"10001","name":"Surendra","category_id":"2","short_description":"Grapes Black","slug":"surendra","description":"<p>Grapes Black<br></p>","total_allowed_quantity":"100","deliverable_type":null,"deliverable_zipcodes":null,"minimum_order_quantity":"1","quantity_step_size":"1","cod_allowed":"1","row_order":"0","rating":"0","no_of_ratings":"0","image":"https://vezi.global/assets/no-image.png","is_returnable":"1","is_cancelable":"1","cancelable_till":null,"indicator":"0","other_images":[],"video_type":"","video":"","product_id":"30","tags":[" Grapes Black"],"warranty_period":"","guarantee_period":"","made_in":"India","availability":1,"category_name":"Fruit","tax_percentage":"5","product_status":"1","review_images":[],"attributes":[],"variants":[{"id":"33","product_id":"30","attribute_value_ids":"","attribute_set":"","price":"5000","special_price":"4000","sku":"","stock":"0","images":[],"availability":1,"status":"1","date_added":"2023-01-05 22:28:07","seller_id":"602","variant_ids":"","attr_name":"","variant_values":"","swatche_type":"","swatche_value":"","images_md":[],"images_sm":[],"cart_count":"0"}],"min_max_price":{"min_price":5000,"max_price":5000,"special_price":4000,"max_special_price":4000,"discount_in_percentage":20},"deliverable_zipcodes_ids":" 452015","is_deliverable":false,"is_purchased":false,"is_favorite":"0","image_md":"https://vezi.global/assets/no-image.png","image_sm":"https://vezi.global/assets/no-image.png","other_images_sm":[],"other_images_md":[],"variant_attributes":[]}]},{"id":"26","type":"default","slider":"Slider_type1","type_id":"2023","image":"https://vezi.global/uploads/media/2022/Vezi_Main_Banner.png","date_added":"2022-03-31 11:32:09","data":[]},{"id":"46","type":"categories","slider":"Slider_type1","type_id":"1","image":"https://vezi.global/uploads/media/2022/Grocery.png","date_added":"2022-12-02 15:40:00","data":[{"id":"1","name":"Grocery","parent_id":"0","slug":"grocery","image":"https://vezi.global/uploads/media/2022/thumb-sm/Groceries.jpg","banner":"https://vezi.global/","row_order":"2","status":"1","clicks":"23","children":[],"text":"Grocery","state":{"opened":true},"icon":"jstree-folder","level":0,"total":21}]},{"id":"41","type":"default","slider":"Slider_type1","type_id":"2009","image":"https://vezi.global/uploads/media/2022/Veggies-Offer-Banner1.jpg","date_added":"2022-11-27 18:25:26","data":[]}]

class SliderModel {
  SliderModel({
      bool? error, 
      List<Data>? data,}){
    _error = error;
    _data = data;
}

  SliderModel.fromJson(dynamic json) {
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  List<Data>? _data;
SliderModel copyWith({  bool? error,
  List<Data>? data,
}) => SliderModel(  error: error ?? _error,
  data: data ?? _data,
);
  bool? get error => _error;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "47"
/// type : "categories"
/// slider : "Slider_type1"
/// type_id : "3"
/// image : "https://vezi.global/uploads/media/2022/Organic_product_banner.jpg"
/// date_added : "2022-12-08 19:10:36"
/// data : [{"id":"3","name":"vegetables","parent_id":"0","slug":"vegetables-1","image":"https://vezi.global/uploads/media/2022/thumb-sm/Vegetables_New1.jpg","banner":"https://vezi.global/","row_order":"3","status":"1","clicks":"14","children":[],"text":"vegetables","state":{"opened":true},"icon":"jstree-folder","level":0,"total":21}]

class Data1 {
  Data1({
      String? id, 
      String? type, 
      String? slider, 
      String? typeId, 
      String? image, 
      String? dateAdded, 
      List<Data1>? data,}){
    _id = id;
    _type = type;
    _slider = slider;
    _typeId = typeId;
    _image = image;
    _dateAdded = dateAdded;
    _data = data;
}

  Data1.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _slider = json['slider'];
    _typeId = json['type_id'];
    _image = json['image'];
    _dateAdded = json['date_added'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data1.fromJson(v));
      });
    }
  }
  String? _id;
  String? _type;
  String? _slider;
  String? _typeId;
  String? _image;
  String? _dateAdded;
  List<Data1>? _data;
Data1 copyWith({  String? id,
  String? type,
  String? slider,
  String? typeId,
  String? image,
  String? dateAdded,
  List<Data1>? data,
}) => Data1(  id: id ?? _id,
  type: type ?? _type,
  slider: slider ?? _slider,
  typeId: typeId ?? _typeId,
  image: image ?? _image,
  dateAdded: dateAdded ?? _dateAdded,
  data: data ?? _data,
);
  String? get id => _id;
  String? get type => _type;
  String? get slider => _slider;
  String? get typeId => _typeId;
  String? get image => _image;
  String? get dateAdded => _dateAdded;
  List<Data1>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['slider'] = _slider;
    map['type_id'] = _typeId;
    map['image'] = _image;
    map['date_added'] = _dateAdded;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "3"
/// name : "vegetables"
/// parent_id : "0"
/// slug : "vegetables-1"
/// image : "https://vezi.global/uploads/media/2022/thumb-sm/Vegetables_New1.jpg"
/// banner : "https://vezi.global/"
/// row_order : "3"
/// status : "1"
/// clicks : "14"
/// children : []
/// text : "vegetables"
/// state : {"opened":true}
/// icon : "jstree-folder"
/// level : 0
/// total : 21

class Data {
  Data({
      String? id, 
      String? name, 
      String? parentId, 
      String? slug, 
      String? image, 
      String? banner, 
      String? rowOrder, 
      String? status, 
      String? clicks, 
      List<dynamic>? children, 
      String? text, 
      State? state, 
      String? icon, 
      num? level, 
      num? total,}){
    _id = id;
    _name = name;
    _parentId = parentId;
    _slug = slug;
    _image = image;
    _banner = banner;
    _rowOrder = rowOrder;
    _status = status;
    _clicks = clicks;
    _children = children;
    _text = text;
    _state = state;
    _icon = icon;
    _level = level;
    _total = total;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _slug = json['slug'];
    _image = json['image'];
    _banner = json['banner'];
    _rowOrder = json['row_order'];
    _status = json['status'];
    _clicks = json['clicks'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(v.fromJson(v));
      });
    }
    _text = json['text'];
    _state = json['state'] != null ? State.fromJson(json['state']) : null;
    _icon = json['icon'];
    _level = json['level'];
    _total = json['total'];
  }
  String? _id;
  String? _name;
  String? _parentId;
  String? _slug;
  String? _image;
  String? _banner;
  String? _rowOrder;
  String? _status;
  String? _clicks;
  List<dynamic>? _children;
  String? _text;
  State? _state;
  String? _icon;
  num? _level;
  num? _total;
Data copyWith({  String? id,
  String? name,
  String? parentId,
  String? slug,
  String? image,
  String? banner,
  String? rowOrder,
  String? status,
  String? clicks,
  List<dynamic>? children,
  String? text,
  State? state,
  String? icon,
  num? level,
  num? total,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  parentId: parentId ?? _parentId,
  slug: slug ?? _slug,
  image: image ?? _image,
  banner: banner ?? _banner,
  rowOrder: rowOrder ?? _rowOrder,
  status: status ?? _status,
  clicks: clicks ?? _clicks,
  children: children ?? _children,
  text: text ?? _text,
  state: state ?? _state,
  icon: icon ?? _icon,
  level: level ?? _level,
  total: total ?? _total,
);
  String? get id => _id;
  String? get name => _name;
  String? get parentId => _parentId;
  String? get slug => _slug;
  String? get image => _image;
  String? get banner => _banner;
  String? get rowOrder => _rowOrder;
  String? get status => _status;
  String? get clicks => _clicks;
  List<dynamic>? get children => _children;
  String? get text => _text;
  State? get state => _state;
  String? get icon => _icon;
  num? get level => _level;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['parent_id'] = _parentId;
    map['slug'] = _slug;
    map['image'] = _image;
    map['banner'] = _banner;
    map['row_order'] = _rowOrder;
    map['status'] = _status;
    map['clicks'] = _clicks;
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    map['text'] = _text;
    if (_state != null) {
      map['state'] = _state?.toJson();
    }
    map['icon'] = _icon;
    map['level'] = _level;
    map['total'] = _total;
    return map;
  }

}

/// opened : true

class State {
  State({
      bool? opened,}){
    _opened = opened;
}

  State.fromJson(dynamic json) {
    _opened = json['opened'];
  }
  bool? _opened;
State copyWith({  bool? opened,
}) => State(  opened: opened ?? _opened,
);
  bool? get opened => _opened;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['opened'] = _opened;
    return map;
  }

}