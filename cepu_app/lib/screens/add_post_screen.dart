import 'package:cepu_app/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController =
      TextEditingController();
      String? _base64Image;
      String? _latitude;
      String? _longitude;
      String? _category;
      bool _isSubmitting = false;
      bool _isGettingLocation = false;
      List<String> get _categories {
        return[
        'Jalan Rusak',
        'Lampu Jalan Mati',
        'Lawan arah',
        'Merokok di tempat umum',
        'Buang sampah sembarangan',
        'Parkir sembarangan',
        'Kebisingan',
        ];
        }
        // Fungsi pilih, kompresi dan convert image
        Future<void> pickImageAndConvert() async {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
          await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            final bytes = await image.readAsBytes();
            setState(() {
              _base64Image = base64Encode(bytes);
              });
              }
              }

              // Fungsi tampil pilihan kategori
              void _showCategorySelector() {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ListView(
                      shrinkWrap: true,
                      children: _categories.map((cat) {
                        return ListTile(
                          title: Text(cat),
                          onTap: () {
                            setState(() {
                              _category = cat;
                            });

                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                );
              }
              //4. Fungsi widget tampil gambar
              Widget _buildImagePreview() {
                if (_base64Image == null) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    child: const Text('Belum ada gambar dipilih'),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(_base64Image!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }

              //5. Fungsi widget tampil lokasi
              Widget _buildLocationInfo() {
                if (_latitude == null || _longitude == null) {
                  return const Text('Lokasi belum diambil');
                }

                return Text(
                  'Lat: $_latitude | Long: $_longitude',
                  textAlign: TextAlign.center,
                );
              }

              //6. Fungsi submit post
              Future<void> _submitPost() async {
                if (_base64Image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih gambar terlebih dahulu.'),
                    ),
                  );
                  return;
                }

                if (_category == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih kategori terlebih dahulu.'),
                    ),
                  );
                  return;
                }

                if (_descriptionController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Masukkan deskripsi terlebih dahulu.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _isSubmitting = true;
                });
              }
              // Ambil user id dan full name dari FirebaseAuth
  final userId =
      FirebaseAuth.instance.currentUser?.uid;

  final fullName =
      FirebaseAuth.instance.currentUser?.displayName;

  try {
    if (_latitude == null || _longitude == null) {
      await getCurrentLocation();
    }

    PostService.addPost(
      Post(
        image: _base64Image,
        description:
            _descriptionController.text,
        category: _category,
        latitude: _latitude,
        longitude: _longitude,
        userId: userId,
        userFullname: fullName,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Posting berhasil disimpan",
        ),
      ),
    );

    Navigator.of(context).pop();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Posting gagal disimpan : $e",
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

@override
void dispose() {
  _descriptionController.dispose();
  super.dispose();
}







  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}