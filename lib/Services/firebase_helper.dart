import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
    static Future<String> imageUpload(imageFile, name) async {
    var image;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(name);
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.then((res) {
      image = res.ref.getDownloadURL();
    });
    return image;
  }
}