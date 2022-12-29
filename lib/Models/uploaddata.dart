class UploadModel {
  String? uid;
  String? description;
  String? name;
  String? address;
  String? phone;
  String? image;


  UploadModel(
      {this.uid,
      this.description,
      this.name,
      this.address,
      this.phone,
      this.image}); // receiving data from server
  factory UploadModel.fromMap(map) {
    return UploadModel(
      uid: map['uid'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      image: map['image'],
      description: map['description'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'address': address,
      'image': image,
      'description': description,
    };
  }
}
