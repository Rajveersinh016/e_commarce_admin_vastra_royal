import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {

  var isLoading = false.obs;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  RxString selectedCategory = "Men's Ethnic".obs;
  RxString selectedSubcategory = "Sherwanis".obs;

  List<String> categoryList = [
    "Men's Ethnic",
    "Women's Ethnic",
    "Accessories"
  ];

  List<String> subcategoryList = [
    "Sherwanis",
    "Kurta Sets",
    "Nehru Jackets"
  ];

  // =========================
  // COVER IMAGE
  // =========================

  File? coverImageFile;
  String? coverImageUrl;

  final ImagePicker picker = ImagePicker();

  Future<void> pickCoverImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (image != null) {
      coverImageFile = File(image.path);
      update();
    }
  }

  Future<String> uploadCoverImage(File file) async {
    String fileName =
        "${DateTime.now().millisecondsSinceEpoch}_cover.jpg";

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("products")
        .child("covers")
        .child(fileName);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;

    return await snap.ref.getDownloadURL();
  }

  // =========================
  // COLORS
  // =========================

  RxList<Map<String, dynamic>> colorList = <Map<String, dynamic>>[].obs;
  RxString selectedColor = "".obs;
  Map<String, List<File>> colorImages = {};

  void addColor(String name, Color color) {
    if (name.isEmpty) return;

    colorList.add({
      "name": name,
      "color": color,
    });
  }

  void deleteColor(String name) {
    colorList.removeWhere((c) => c["name"] == name);
    colorImages.remove(name);
  }

  Future pickImagesForColor() async {
    if (selectedColor.value.isEmpty) {
      Get.snackbar("Select color", "Please select a color first");
      return;
    }

    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (images.isEmpty) return;

    List<File> files = images.map((e) => File(e.path)).toList();

    if (colorImages.containsKey(selectedColor.value)) {
      colorImages[selectedColor.value]!.addAll(files);
    } else {
      colorImages[selectedColor.value] = files;
    }

    update();
  }

  // =========================
  // SIZE & STOCK
  // =========================

  RxBool isOneSize = false.obs;

  Map<String, TextEditingController> sizeControllers = {
    "S": TextEditingController(text: "0"),
    "M": TextEditingController(text: "0"),
    "L": TextEditingController(text: "0"),
    "XL": TextEditingController(text: "0"),
    "XXL": TextEditingController(text: "0"),
  };

  Map<String, int> getSizeStock() {
    Map<String, int> data = {};
    sizeControllers.forEach((size, controller) {
      int value = int.tryParse(controller.text) ?? 0;
      data[size] = value;
    });
    return data;
  }

  TextEditingController totalStockController =
  TextEditingController(text: "0");
  TextEditingController lowStockController =
  TextEditingController(text: "5");

  void calculateTotalStock() {
    int total = 0;
    sizeControllers.forEach((size, controller) {
      int value = int.tryParse(controller.text) ?? 0;
      total += value;
    });
    totalStockController.text = total.toString();
  }

  // =========================
  // VISIBILITY
  // =========================

  RxBool isActive = true.obs;
  RxBool isFeatured = false.obs;
  RxBool showOnHomepage = true.obs;

  // =========================
  // SAVE PRODUCT
  // =========================

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (coverImageFile == null) {
      Get.snackbar("Cover Image Required",
          "Please upload a product cover image");
      return;
    }

    try {
      isLoading(true);

      String productId =
      databaseReference.child("products").push().key!;

      // Upload Cover Image
      coverImageUrl =
      await uploadCoverImage(coverImageFile!);

      // Upload Color Images
      Map<String, List<String>> colorImageUrls = {};

      for (var entry in colorImages.entries) {
        String colorName = entry.key;
        List<File> files = entry.value;

        List<String> urls = [];

        for (File file in files) {
          String fileName =
              "${DateTime.now().millisecondsSinceEpoch}.jpg";

          Reference ref = FirebaseStorage.instance
              .ref()
              .child("products")
              .child(productId)
              .child(colorName)
              .child(fileName);

          UploadTask uploadTask = ref.putFile(file);
          TaskSnapshot snap = await uploadTask;
          String url =
          await snap.ref.getDownloadURL();

          urls.add(url);
        }

        colorImageUrls[colorName] = urls;
      }

      List<Map<String, String>> colorsJson =
      colorList.map((item) {
        Color c = item["color"] as Color;
        String hex =
            '#${c.value.toRadixString(16).substring(2).toUpperCase()}';

        return {
          "name": item["name"] as String,
          "hexCode": hex
        };
      }).toList();

      Map<String, dynamic> productData = {
        "id": productId,
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "category": selectedCategory.value,
        "subcategory": selectedSubcategory.value,
        "price": double.tryParse(priceController.text) ?? 0.0,
        "discount":
        double.tryParse(discountController.text) ?? 0.0,
        "tags": tagsController.text.trim(),
        "coverImage": coverImageUrl,
        "colors": colorsJson,
        "images": colorImageUrls,
        "sizes": getSizeStock(),
        "totalStock":
        int.tryParse(totalStockController.text) ?? 0,
        "lowStock":
        int.tryParse(lowStockController.text) ?? 5,
        "active": isActive.value,
        "featured": isFeatured.value,
        "homepage": showOnHomepage.value,
        "createdAt": DateTime.now().toString(),
      };

      await databaseReference
          .child("products")
          .child(productId)
          .set(productData);

      Get.back();

      Get.snackbar(
        "Success",
        "Product saved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}