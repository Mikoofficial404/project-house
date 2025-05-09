import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_house/models/kosan.dart';
import 'package:project_house/services/kosan_service.dart';
import 'package:project_house/shared/theme.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final KosanService _kosanService = KosanService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    // Check if user is admin
    checkAdminStatus();
  }

  void checkAdminStatus() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // Not logged in, redirect to login page
      Navigator.pushReplacementNamed(context, '/login');
    }
    // For simplicity, we're considering any logged-in user as admin
    // In a real app, you would check admin claims or a specific admin collection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: purpleColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Kosan>>(
        stream: _kosanService.getKosans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No kosan listings found'));
          }

          List<Kosan> kosans = snapshot.data!;
          
          return ListView.builder(
            itemCount: kosans.length,
            itemBuilder: (context, index) {
              Kosan kosan = kosans[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: kosan.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            kosan.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: Icon(Icons.error),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.home),
                        ),
                  title: Text(
                    kosan.deskripsi.split('\n').first, // Use first line as title
                    style: blackTextStyle.copyWith(
                      fontWeight: bold,
                    ),
                  ),
                  subtitle: Text(
                    'Rp ${kosan.harga.toString()} - ${kosan.lokasi}',
                    style: greyTextStyle,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditKosanDialog(context, kosan);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, kosan.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // View details
                    _showKosanDetailsDialog(context, kosan);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        child: Icon(Icons.add),
        onPressed: () {
          _showAddKosanDialog(context);
        },
      ),
    );
  }

  void _showAddKosanDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _imageUrlController = TextEditingController();
    final TextEditingController _deskripsiController = TextEditingController();
    final TextEditingController _lokasiController = TextEditingController();
    final TextEditingController _hargaController = TextEditingController();
    final TextEditingController _fasilitasController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Kosan Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'URL Gambar',
                      hintText: 'https://example.com/image.jpg',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'URL Gambar tidak boleh kosong';
                      }
                      if (!value.startsWith('http')) {
                        return 'URL harus dimulai dengan http:// atau https://';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(
                      labelText: 'Nama/Deskripsi Kosan',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lokasiController,
                    decoration: InputDecoration(
                      labelText: 'Lokasi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hargaController,
                    decoration: InputDecoration(
                      labelText: 'Harga (Rp)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fasilitasController,
                    decoration: InputDecoration(
                      labelText: 'Fasilitas (pisahkan dengan koma)',
                      hintText: 'AC, WiFi, Kamar Mandi Dalam',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fasilitas tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
              ),
              child: Text('Simpan'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Create new kosan object
                    Kosan newKosan = Kosan(
                      id: '', // Will be assigned by Firestore
                      imageUrl: _imageUrlController.text.trim(),
                      deskripsi: _deskripsiController.text.trim(),
                      lokasi: _lokasiController.text.trim(),
                      harga: int.parse(_hargaController.text.trim()),
                      fasilitas: _fasilitasController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                    );

                    // Save to Firestore
                    await _kosanService.createKosan(newKosan);
                    Navigator.of(context).pop(); // Tutup dialog
                    
                    // Navigasi langsung ke halaman home
                    Navigator.pushReplacementNamed(context, '/home');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kosan berhasil ditambahkan')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditKosanDialog(BuildContext context, Kosan kosan) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _imageUrlController = TextEditingController(text: kosan.imageUrl);
    final TextEditingController _deskripsiController = TextEditingController(text: kosan.deskripsi);
    final TextEditingController _lokasiController = TextEditingController(text: kosan.lokasi);
    final TextEditingController _hargaController = TextEditingController(text: kosan.harga.toString());
    final TextEditingController _fasilitasController = TextEditingController(
        text: kosan.fasilitas.join(', '));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Kosan'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'URL Gambar',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'URL Gambar tidak boleh kosong';
                      }
                      if (!value.startsWith('http')) {
                        return 'URL harus dimulai dengan http:// atau https://';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(
                      labelText: 'Nama/Deskripsi Kosan',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lokasiController,
                    decoration: InputDecoration(
                      labelText: 'Lokasi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hargaController,
                    decoration: InputDecoration(
                      labelText: 'Harga (Rp)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fasilitasController,
                    decoration: InputDecoration(
                      labelText: 'Fasilitas (pisahkan dengan koma)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fasilitas tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
              ),
              child: Text('Update'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Update kosan object
                    Kosan updatedKosan = Kosan(
                      id: kosan.id,
                      imageUrl: _imageUrlController.text.trim(),
                      deskripsi: _deskripsiController.text.trim(),
                      lokasi: _lokasiController.text.trim(),
                      harga: int.parse(_hargaController.text.trim()),
                      fasilitas: _fasilitasController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                    );

                    // Update in Firestore
                    await _kosanService.updateKosan(updatedKosan);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kosan berhasil diupdate')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String kosanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus kosan ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Hapus'),
              onPressed: () async {
                try {
                  await _kosanService.deleteKosan(kosanId);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kosan berhasil dihapus')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showKosanDetailsDialog(BuildContext context, Kosan kosan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detail Kosan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kosan.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          kosan.imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(Icons.error, size: 50),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.home, size: 50),
                      ),
                SizedBox(height: 16),
                Text(
                  'Deskripsi:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(kosan.deskripsi),
                SizedBox(height: 16),
                Text(
                  'Lokasi:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(kosan.lokasi),
                SizedBox(height: 16),
                Text(
                  'Harga:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text('Rp ${kosan.harga.toString()}'),
                SizedBox(height: 16),
                Text(
                  'Fasilitas:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kosan.fasilitas.map((facility) {
                    return Chip(
                      label: Text(facility),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
