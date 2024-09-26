import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter, FilteringTextInputFormatter, TextInputFormatter;

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final List<Map<String, String>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cards = prefs.getStringList('cards') ?? [];
    setState(() {
      _cards.addAll(cards.map((card) => Map<String, String>.from(json.decode(card) as Map)).toList());
    });
  }

  Future<void> _saveCard(Map<String, String> card) async {
    final prefs = await SharedPreferences.getInstance();
    _cards.add(card);
    await prefs.setStringList('cards', _cards.map((card) => json.encode(card)).toList());
    setState(() {});
  }

  Future<void> _updateCard(int index, Map<String, String> card) async {
    final prefs = await SharedPreferences.getInstance();
    _cards[index] = card;
    await prefs.setStringList('cards', _cards.map((card) => json.encode(card)).toList());
    setState(() {});
  }

  Future<void> _deleteCard(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _cards.removeAt(index);
    await prefs.setStringList('cards', _cards.map((card) => json.encode(card)).toList());
    setState(() {});
  }

  void _editCard(int index) {
    final card = _cards[index];
    _nameController.text = card['name']!;
    _cardNumberController.text = card['cardNumber']!;
    _cvvController.text = card['cvv']!;
    _expiryDateController.text = card['expiryDate']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kartı Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'İsim Soyisim',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Kart Numarası',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(19), // 16 hane + 3 boşluk
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberFormatter(),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Son Kullanma Tarihi (AA/YY)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.digitsOnly,
                    CardExpiryDateFormatter(),
                  ],
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
                final updatedCard = {
                  'name': _nameController.text,
                  'cardNumber': _cardNumberController.text,
                  'cvv': _cvvController.text,
                  'expiryDate': _expiryDateController.text,
                };
                _updateCard(index, updatedCard);
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
      appBar: AppBar(title: Text('Kart Ayarları')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'İsim Soyisim',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Kart Numarası',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(19), // 16 hane + 3 boşluk
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cvvController,
              decoration: InputDecoration(
                labelText: 'CVV',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                labelText: 'Son Kullanma Tarihi (AA/YY)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
                FilteringTextInputFormatter.digitsOnly,
                CardExpiryDateFormatter(),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final card = {
                  'name': _nameController.text,
                  'cardNumber': _cardNumberController.text,
                  'cvv': _cvvController.text,
                  'expiryDate': _expiryDateController.text,
                };
                if (card.values.any((value) => value.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                  );
                  return;
                }
                _saveCard(card);
                _nameController.clear();
                _cardNumberController.clear();
                _cvvController.clear();
                _expiryDateController.clear();
              },
              child: Text('Kart Ekle'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  final cardNumber = card['cardNumber']!;
                  final last4Digits = cardNumber.length > 4
                      ? cardNumber.substring(cardNumber.length - 4)
                      : cardNumber;
                  return ListTile(
                    title: Text('${card['name']}'),
                    subtitle: Text('Kart Numarası: **** **** **** $last4Digits\nSon Kullanma Tarihi: ${card['expiryDate']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editCard(index);
                          },
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String result) {
                            if (result == 'Sil') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Kartı Sil'),
                                    content: Text('Bu kartı silmek istediğinize emin misiniz?'),
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
                                          _deleteCard(index);
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

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 19) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class CardExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 5) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
