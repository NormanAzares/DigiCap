import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_capsule/src/features/authentication/models/memory_model.dart';
import 'package:time_capsule/src/features/authentication/screens/main_screen.dart';
import '../../controllers/add_memory_screen.controller.dart';

class SaveMemoryScreen extends StatefulWidget {
  @override
  State<SaveMemoryScreen> createState() => _SaveMemoryScreenState();
}

class _SaveMemoryScreenState extends State<SaveMemoryScreen> {
  File? myImage;

  final MemoryController memoryController = Get.put(MemoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Memory'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
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
                      memoryController.getCurrentFormattedDate(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
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
                  hintText: 'Enter the description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Photos',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              InkWell(
                onTap: () {
                  openBottomSheet();
                },
                child: Container(
                  width: 200,
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
              // Implement your photo selection/capture widget here
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Handle save memory logic
                  await uploadFile();

                  Get.to(() => MainScreen());
                },
                child: Text('Save Memory'),
              ),
            ],
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

  Future<void> uploadFile() async {
    final file = myImage!;
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('memories/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metaData);

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
            photoURL: memoryController.imageURL.trim(),
          );
          memoryController.createMemories(memory);
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
  }
}
