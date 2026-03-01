import 'dart:io';
import 'package:e_commarce_admin/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//import 'Controller/add_product_controller.dart';
import 'package:e_commarce_admin/Controller/add_product_controller.dart';


class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final AddProductController controller =
  Get.put(AddProductController());


  Widget basicInformationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(Icons.info, color: Appcolor.primary),
              const SizedBox(width: 8),
              const Text(
                "Basic Information",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          buildLabel("Product Name"),
          buildTextField(
            controller.nameController,
            "e.g. Royal Silk Sherwani",
          ),

          const SizedBox(height: 15),

          buildLabel("Description"),
          buildTextField(
            controller.descriptionController,
            "Describe the craftsmanship and fabric...",
            maxLines: 4,
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: buildCategoryDropdown()),
              const SizedBox(width: 10),
              Expanded(child: buildSubcategoryDropdown()),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: buildTextField(
                  controller.priceController,
                  "0.00",
                  label: "Price (₹)",
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: buildTextField(
                  controller.discountController,
                  "0.00",
                  label: "Discount Price (₹)",
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          buildTextField(
            controller.tagsController,
            "silk, wedding, festive, blue",
            label: "Tags",
          ),
          const SizedBox(height: 5),
          const Text(
            "Separate with commas",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }


  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }


  Widget buildTextField(
      TextEditingController controller,
      String hint, {
        String? label,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) buildLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: (value) =>
          value == null || value.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Appcolor.field,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }


  Widget buildCategoryDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      isExpanded: true,
      value: controller.selectedCategory.value,
      items: controller.categoryList.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) =>
      controller.selectedCategory.value = value!,
      decoration: InputDecoration(
        labelText: "Category",
        filled: true,
        fillColor: Appcolor.field,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ));
  }


  Widget buildSubcategoryDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      isExpanded: true,
      value: controller.selectedSubcategory.value,
      items: controller.subcategoryList.map((subcategory) {
        return DropdownMenuItem(
          value: subcategory,
          child: Text(subcategory),
        );
      }).toList(),
      onChanged: (value) =>
      controller.selectedSubcategory.value = value!,
      decoration: InputDecoration(
        labelText: "Subcategory",
        filled: true,
        fillColor: Appcolor.field,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ));
  }


  Widget colorVariantSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Color Variants",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: showAddColorDialog,
                child: const Text("+ Add Color"),
              )
            ],
          ),

          const SizedBox(height: 10),

          Obx(() => Column(
            children: controller.colorList.map((item) {
              String name = item["name"];
              Color color = item["color"];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Appcolor.field,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: color,
                    ),
                    const SizedBox(width: 10),
                    Text(name),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.deleteColor(name);
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }


  void showAddColorDialog() {
    TextEditingController nameController = TextEditingController();
    Rx<Color> pickedColor = Colors.blue.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.85,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Add Color",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// COLOR GRID
                    Obx(() => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.black,
                        Colors.orange,
                        Colors.purple,
                        Colors.pink,
                        Colors.brown,
                        Colors.grey,
                        Colors.teal,
                      ].map((c) {
                        bool selected = pickedColor.value == c;

                        return GestureDetector(
                          onTap: () => pickedColor.value = c,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: c,
                              radius: 18,
                            ),
                          ),
                        );
                      }).toList(),
                    )),

                    const SizedBox(height: 15),

                    /// PREVIEW
                    Obx(() => Row(
                      children: [
                        const Text("Selected: "),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: pickedColor.value,
                        ),
                      ],
                    )),

                    const SizedBox(height: 15),

                    /// NAME FIELD
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Color name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.addColor(
                            nameController.text,
                            pickedColor.value,
                          );
                          Get.back();
                        },
                        child: const Text("Add Color"),
                      ),
                    ),

                    /// keyboard spacing
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ===============================
  // COLOR-WISE IMAGE SECTION
  // ===============================
  Widget colorImageSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Color-wise Images",
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

          const SizedBox(height: 15),

          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedColor.value.isEmpty
                ? null
                : controller.selectedColor.value,
            hint: const Text("Select Color"),
              items: controller.colorList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item["name"] as String,
                  child: Text(item["name"]),
                );
              }).toList(),
            onChanged: (v) =>
            controller.selectedColor.value = v!,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: controller.pickImagesForColor,
            child: const Text("Upload Images"),
          ),

          const SizedBox(height: 15),

          GetBuilder<AddProductController>(
            builder: (_) {
              String color = controller.selectedColor.value;
              if (color.isEmpty) return const SizedBox();

              List<File> imgs =
                  controller.colorImages[color] ?? [];

              return Wrap(
                spacing: 10,
                children: imgs.map((img) {
                  return Image.file(
                    img,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }


  Widget sizeStockSection() {

    return Container(

      //height: Get.height*0.450,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Row(
            children: [
              Icon(Icons.straighten, color: Appcolor.primary),
              const SizedBox(width: 8),
              const Text(
                "Size & Stock",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// ONE SIZE TOGGLE
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "One Size Product",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Enable if size doesn’t apply",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Switch(
                value: controller.isOneSize.value,
                onChanged: (val) {
                  controller.isOneSize.value = val;
                },
              ),
            ],
          )),

          const SizedBox(height: 20),

          /// SIZE GRID
          /// SIZE GRID
          Obx(() => IgnorePointer(
            ignoring: controller.isOneSize.value,
            child: Opacity(
              opacity: controller.isOneSize.value ? 0.4 : 1,

              /// IMPORTANT: use LayoutBuilder to get width
              child: LayoutBuilder(
                builder: (context, constraints) {

                  double itemWidth = (constraints.maxWidth - 15) / 2;

                  return Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: controller.sizeControllers.keys.map((size) {

                      return SizedBox(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              size,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            SizedBox(
                              height: 45,
                              child: TextField(
                                onChanged: (value) {
                                  controller.calculateTotalStock();
                                },

                                controller: controller.sizeControllers[size],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Appcolor.field,
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    }).toList(),
                  );
                },
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget inventorySection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(Icons.inventory, color: Appcolor.primary),
              const SizedBox(width: 8),
              const Text(
                "Inventory",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              /// TOTAL STOCK (AUTO)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Stock",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.totalStockController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Appcolor.field,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 15),

              /// LOW STOCK ALERT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Low Stock Alert",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.lowStockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Appcolor.field,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget visibilitySection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(Icons.remove_red_eye, color: Appcolor.primary),
              const SizedBox(width: 8),
              const Text(
                "Visibility & Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// ACTIVE
          Obx(() => SwitchListTile(
            title: const Text("Product Active"),
            value: controller.isActive.value,
            onChanged: (v) => controller.isActive.value = v,
          )),

          /// FEATURED
          Obx(() => SwitchListTile(
            title: const Text("Featured Product"),
            value: controller.isFeatured.value,
            onChanged: (v) => controller.isFeatured.value = v,
          )),

          /// HOMEPAGE
          Obx(() => SwitchListTile(
            title: const Text("Show on Homepage"),
            value: controller.showOnHomepage.value,
            onChanged: (v) => controller.showOnHomepage.value = v,
          )),
        ],
      ),
    );
  }





  Widget coverImageSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Product Cover Image",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 15),

          GetBuilder<AddProductController>(
            builder: (_) {
              return Column(
                children: [

                  controller.coverImageFile == null
                      ? Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor.field,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child:
                      Text("No Cover Image Selected"),
                    ),
                  )
                      : ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),
                    child: Image.file(
                      controller.coverImageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed:
                    controller.pickCoverImage,
                    child:
                    const Text("Upload Cover Image"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }







  // ===============================
  // BUILD
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add Product",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              basicInformationCard(),
              coverImageSection(),
              colorVariantSection(),
              colorImageSection(),
              sizeStockSection(),
              inventorySection(),
              visibilitySection(),

            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// SAVE + DRAFT
              Row(
                children: [

                  /// SAVE PRODUCT
                  Expanded(
                    flex: 2,
                    child: Obx(() => ElevatedButton(    // ← Obx wraps the WHOLE button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.primary,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: controller.isLoading.value
                          ? null
                          : controller.saveProduct,

                      child: controller.isLoading.value

                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      // Show text normally
                          : const Text(
                        "Save Product",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )),
                  ),


                  const SizedBox(width: 12),

                  /// SAVE DRAFT
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Appcolor.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        print("Saved Draft");
                      },
                      child: const Text(
                        "Save Draft",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// CANCEL
              TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Appcolor.border),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black,fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}