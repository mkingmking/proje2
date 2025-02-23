import 'package:flutter/material.dart';
import 'user.dart';
import 'UserAdress.dart';
import 'package:firebase_database/firebase_database.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // Controllers for user input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  late UserAddress address;

  void _addAddressToDatabase(UserAddress userAddress, String userId) {
    DatabaseReference addressRef = FirebaseDatabase.instance
        .ref()
        .child('users') //TODO  doesn't work as intended.
        .child(userId)
        .child('address');

    addressRef.set(userAddress.toJson());
  }

  void _addUserToDatabase() {
    // Create a User object
    UserAddress newAdress = UserAddress(
        street: streetController.text,
        city: cityController.text,
        state: stateController.text,
        postalCode: postalCodeController.text);

    User newUser = User(
      name: nameController.text,
      surname: surnameController.text,
      email: emailController.text,
      sex: sexController.text,
      age: int.tryParse(ageController.text) ?? 0,
      address: newAdress,
      userID: 'test',
    );

    // Write the user to the database
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').push();
    userRef.set(newUser.toJson());

    _addAddressToDatabase(newAdress, newUser.userID);

    // ... Clear other text controllers
    // Clear all input fields
    nameController.clear();
    surnameController.clear();
    emailController.clear();
    sexController.clear();
    ageController.clear();
    postalCodeController.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(labelText: 'Surname'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: sexController,
                decoration: InputDecoration(labelText: 'Sex'),
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              SizedBox(height: 20),
              Text('Addresses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'Street'),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                controller: postalCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Postal Code'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add the entered address to the list
                  //TODO

                  // Clear the address input fields
                  streetController.clear();
                  cityController.clear();
                  stateController.clear();
                  postalCodeController.clear();
                },
                child: const Text('Add Address'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addUserToDatabase, // Corrected
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
