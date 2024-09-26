import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedCity = '';
  String _selectedDistrict = '';
  List<String> _cities = [];
  Map<String, List<String>> _districts = {};

  final List<Map<String, String>> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadAddresses();
  }

  Future<void> _loadCities() async {
    String data = await rootBundle.loadString('assets/cities.json');
    final jsonResult = json.decode(data) as Map<String, dynamic>;
    setState(() {
      _cities = jsonResult.keys.toList();
      _districts = jsonResult.map((key, value) => MapEntry(key, List<String>.from(value)));
    });
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addresses = prefs.getStringList('addresses') ?? [];
    setState(() {
      _addresses.addAll(addresses.map((address) => Map<String, String>.from(json.decode(address) as Map<String, dynamic>)).toList());
    });
  }

  Future<void> _saveAddress(Map<String, String> address) async {
    final prefs = await SharedPreferences.getInstance();
    _addresses.add(address);
    await prefs.setStringList('addresses', _addresses.map((address) => json.encode(address)).toList());
    setState(() {});
  }

  Future<void> _deleteAddress(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _addresses.removeAt(index);
    await prefs.setStringList('addresses', _addresses.map((address) => json.encode(address)).toList());
    setState(() {});
  }

  void _editAddress(int index) {
    final address = _addresses[index];
    _address1Controller.text = address['address1']!;
    _address2Controller.text = address['address2']!;
    _postalCodeController.text = address['postalCode']!;
    _emailController.text = address['email']!;
    _selectedCity = address['city']!;
    _selectedDistrict = address['district']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adresi Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _address1Controller,
                  decoration: InputDecoration(
                    labelText: 'Adres 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _address2Controller,
                  decoration: InputDecoration(
                    labelText: 'Adres 2',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'Posta Kodu',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCity.isNotEmpty ? _selectedCity : null,
                  hint: Text('İl Seçin'),
                  items: _cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue!;
                      _selectedDistrict = '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'İl',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
                  hint: Text('İlçe Seçin'),
                  items: (_districts[_selectedCity] ?? []).map((String district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDistrict = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'İlçe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () {
                final updatedAddress = {
                  'address1': _address1Controller.text,
                  'address2': _address2Controller.text,
                  'postalCode': _postalCodeController.text,
                  'email': _emailController.text,
                  'city': _selectedCity,
                  'district': _selectedDistrict,
                };
                _addresses[index] = updatedAddress;
                _saveAddress(updatedAddress);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adres Ayarları')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _address1Controller,
              decoration: InputDecoration(
                labelText: 'Adres 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _address2Controller,
              decoration: InputDecoration(
                labelText: 'Adres 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _postalCodeController,
              decoration: InputDecoration(
                labelText: 'Posta Kodu',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCity.isNotEmpty ? _selectedCity : null,
              hint: Text('İl Seçin'),
              items: _cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCity = newValue!;
                  _selectedDistrict = '';
                });
              },
              decoration: InputDecoration(
                labelText: 'İl',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
              hint: Text('İlçe Seçin'),
              items: (_districts[_selectedCity] ?? []).map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'İlçe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final address = {
                  'address1': _address1Controller.text,
                  'address2': _address2Controller.text,
                  'postalCode': _postalCodeController.text,
                  'email': _emailController.text,
                  'city': _selectedCity,
                  'district': _selectedDistrict,
                };
                if (address.values.any((value) => value.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                  );
                  return;
                }
                _saveAddress(address);
                _address1Controller.clear();
                _address2Controller.clear();
                _postalCodeController.clear();
                _emailController.clear();
                setState(() {
                  _selectedCity = '';
                  _selectedDistrict = '';
                });
              },
              child: Text('Adres Ekle'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return ListTile(
                    title: Text('${address['address1']}'),
                    subtitle: Text('Adres 2: ${address['address2']}\nPosta Kodu: ${address['postalCode']}\nEmail: ${address['email']}\nİl: ${address['city']}\nİlçe: ${address['district']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editAddress(index);
                          },
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String result) {
                            if (result == 'Sil') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Adresi Sil'),
                                    content: Text('Bu adresi silmek istediğinize emin misiniz?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Hayır'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Evet'),
                                        onPressed: () {
                                          _deleteAddress(index);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Sil',
                              child: Text('Sil'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

