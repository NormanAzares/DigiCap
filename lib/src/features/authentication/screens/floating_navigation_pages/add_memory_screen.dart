import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_capsule/src/features/authentication/models/memory_model.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen.dart';
import '../../controllers/add_memory_screen_controller.dart';

class SaveMemoryScreen extends StatefulWidget {
  @override
  State<SaveMemoryScreen> createState() => _SaveMemoryScreenState();
}

class _SaveMemoryScreenState extends State<SaveMemoryScreen> {
  File? myImage;
  File? myAudio;

  final MemoryController memoryController = Get.put(MemoryController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Memory'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                      10.0), // Optional: Add padding to the container
                  decoration: BoxDecoration(
                    // Optional: Add decoration properties to the container
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: memoryController.title,
                        decoration: InputDecoration(
                          hintText: 'My Memory on ' +
                              memoryController.formatTimeStamp(
                                  memoryController.getCurrentFormattedDate()),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(
                      10.0), // Optional: Add padding to the container
                  decoration: BoxDecoration(
                    // Optional: Add decoration properties to the container
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: memoryController.description,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Click here to write about this memory...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Click here to write about this memory';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Photo',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  width: 500,
                  padding: EdgeInsets.all(
                      10.0), // Optional: Add padding to the container
                  decoration: BoxDecoration(
                    // Optional: Add decoration properties to the container
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Click Upload Icon Below to Add Photo"),
                      SizedBox(height: 5.0),
                      InkWell(
                        onTap: () {
                          openBottomSheet();
                        },
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8)),
                          child: myImage == null
                              ? const Center(
                                  child: Icon(
                                    Icons.upload_file,
                                    size: 50,
                                  ),
                                )
                              : Image.file(
                                  myImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Implement your photo selection/capture widget here

                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                          300, 50), // Set the width and height of the button
                      backgroundColor:
                          Colors.orange, // Set the background color to orange
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // If the form is valid, save the memory
                        await uploadFile();
                        Get.to(() => MainScreen());
                      }
                      // If the form is valid, save the memory

                      // Handle save memory logic
                    },
                    child: Text(
                      'Save Memory',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        width: double.infinity,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildImageWidget(
                iconData: Icons.camera_alt,
                onPressed: () {
                  getImage(ImageSource.camera);
                }),
            BuildImageWidget(
                iconData: Icons.image,
                onPressed: () {
                  getImage(ImageSource.gallery);
                }),
          ],
        ),
      ),
    );
  }

  BuildImageWidget({required IconData iconData, required Function onPressed}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 30,
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      myImage = File(image.path);
      setState(() {});
      Get.back();
    }
  }

  getAudio() async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
    allowMultiple: false,
  );

  if (result != null && result.files.isNotEmpty) {
    myAudio = File(result.files.single.path!);
    setState(() {});
    Get.back();
  }
}

  Future<void> uploadFile() async {
    if (myImage != null) {
      final file = myImage;
      final metaData = SettableMetadata(contentType: 'image/jpeg');
      final storageRef = FirebaseStorage.instance.ref();
      Reference ref = storageRef
          .child('memories/${DateTime.now().microsecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file!, metaData);

      uploadTask.snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            print("File is uploading");
            break;
          case TaskState.success:
            ref.getDownloadURL().then((value) => {print(value)});
            memoryController.imageURL = await ref.getDownloadURL();
            final memory = MemoryModel(
              title: memoryController.title.text.trim(),
              description: memoryController.description.text.trim(),
              date: memoryController.getCurrentFormattedDate(),
              photoURL: memoryController.imageURL!.trim(),
            );
            memoryController.createMemories(memory);
            memoryController.title.text = "";
            memoryController.description.text = "";
            memoryController.imageURL = "";
            break;
          case TaskState.paused:
            print("File upload was paused");
            break;
          case TaskState.canceled:
            print("File upload was cancelled");
            break;
          case TaskState.error:
            print("File upload error!");
            break;
        }
      });
    } else {
      // Handle the case when no picture is selected
      final memory = MemoryModel(
        title: memoryController.title.text.trim(),
        description: memoryController.description.text.trim(),
        date: memoryController.getCurrentFormattedDate(),
      );
      memoryController.createMemories(memory);
      memoryController.title.text = "";
      memoryController.description.text = "";
      memoryController.imageURL = "";
    }
  }
}
