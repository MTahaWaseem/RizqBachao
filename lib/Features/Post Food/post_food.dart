import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Post%20Food/post_food_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/user_json.dart';

class PostFood extends StatefulWidget {
  const PostFood({Key? key}) : super(key: key);
  @override
  State<PostFood> createState() => _PostFoodState();
}

class _PostFoodState extends State<PostFood> {


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  bool value = false;

  File? pickedImage1;
  File? pickedImage2;
  File? pickedImage3;
  String? val;


  List<UserJson> users = [];

  void imagePickerOption(File? Image) {

    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera, Image);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery, Image);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType, File? Image) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      if(Image == pickedImage1) {
        setState(() {
          pickedImage1 = tempImage;
        });
      }

      else if(Image == pickedImage2) {
        setState(() {
          pickedImage2 = tempImage;
        });
      }

      else if(Image == pickedImage3) {
        setState(() {
          pickedImage3 = tempImage;
        });
      }


      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;


    TextEditingController title = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController quantity = TextEditingController();

    String dropdownValue = 'Ready Made Food';






    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Post Food'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF004643),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'About food',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Title refers to the name of the food like chicken biryani, achari handi, etc.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Enter title',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'A description about what it is, what is in the food you’re posting. Any important message you want the customers to know will also come here',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'How much do have? Enter the value and then in the field below select the quantity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: quantity,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Quantity',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '  Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),

              DropdownButtonFormField(
                decoration:  InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                //dropdownColor: Colors.greenAccent,
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Ready Made Food',
                  'Fruits',
                  'General',
                  'Others']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      // style: TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                    stack_container(image: pickedImage1),
                    stack_container(image: pickedImage2),
                    stack_container(image: pickedImage3),
                  ],

                ),
              ),



            ],
          ),



        ),
      ),
      floatingActionButton:  FloatingActionButton.extended(
        onPressed: () async {

          Position position = await _determinePosition();
          print(position.latitude);
          print(position.longitude);


          context.read<PostFoodProvider>().getUserDetails(user.uid);

          users = context.read<PostFoodProvider>().list;

          String name = users[users.length-1].name;
          String number = users[users.length-1].number;

          // String nname = users[users.length-1].name;
          // String nnumber = users[users.length-1].number;

          Provider.of<PostFoodProvider>(context, listen: false).addposts(title.text, description.text, quantity.text,user.uid,position.latitude,position.longitude, name, number);
          value = await alertBox();
          },

        label: Text(
          'Post',
          style:
          TextStyle(color: Color(0xFF004643), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFF9BC60),
      ),

    );
  }

  Future alertBox() async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Post Added Successfully!'),
          );
        });
  }

  stack_container({File? image}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo, width: 5),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: ClipOval(
            child
                : image != null
                ? Image.file(
              image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
                : Image.network(
              'https://pixsector.com/cache/d01b7e30/av7801257c459e42a24b5.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: IconButton(
            onPressed: (){imagePickerOption(image);},
            icon: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.blue,
              size: 50,
            ),
          ),
        ),

      ],
    );
  }



}