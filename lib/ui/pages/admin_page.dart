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
      Navigator.pushReplacementNamed(context, '/login');
    }
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
    final TextEditingController _namaController = TextEditingController();
    final TextEditingController _deskripsiController = TextEditingController();
    final TextEditingController _lokasiController = TextEditingController();
    final TextEditingController _hargaController = TextEditingController();
    final TextEditingController _fasilitasController = TextEditingController();
    final TextEditingController _bedroomsController = TextEditingController(text: '2');
    final TextEditingController _bathroomsController = TextEditingController(text: '2');
    final TextEditingController _kitchensController = TextEditingController(text: '1');
    final TextEditingController _latitudeController = TextEditingController(text: '-6.200000');
    final TextEditingController _longitudeController = TextEditingController(text: '106.816666');
    
    // Track room availability
    bool _isAvailable = true;

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
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kosan',
                      hintText: 'Masukkan nama kosan',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama kosan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi Kosan',
                      hintText: 'Masukkan deskripsi lengkap kosan',
                    ),
                    maxLines: 3,
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _bedroomsController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah Kamar Tidur',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah kamar tidur tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Harus berupa angka';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _bathroomsController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah Kamar Mandi',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah kamar mandi tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Harus berupa angka';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _kitchensController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah Dapur',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah dapur tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Harus berupa angka';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _latitudeController,
                          decoration: InputDecoration(
                            labelText: 'Latitude',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Latitude tidak boleh kosong';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Harus berupa angka';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Longitude tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: _isAvailable,
                        onChanged: (bool? value) {
                          if (value != null) {
                            _isAvailable = value;
                          }
                        },
                      ),
                      Text('Kamar Tersedia', style: blackTextStyle),
                    ],
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Combine nama and deskripsi for the deskripsi field
                  String fullDeskripsi = _namaController.text;
                  if (_deskripsiController.text.isNotEmpty) {
                    fullDeskripsi += '\n' + _deskripsiController.text;
                  }
                  
                  Kosan newKosan = Kosan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    imageUrl: _imageUrlController.text,
                    deskripsi: fullDeskripsi,
                    lokasi: _lokasiController.text,
                    harga: int.parse(_hargaController.text),
                    fasilitas: _fasilitasController.text.split(',').map((e) => e.trim()).toList(),
                    bedrooms: int.parse(_bedroomsController.text),
                    bathrooms: int.parse(_bathroomsController.text),
                    kitchens: int.parse(_kitchensController.text),
                    latitude: double.parse(_latitudeController.text),
                    longitude: double.parse(_longitudeController.text),
                    isAvailable: _isAvailable, // Set availability
                  );

                  _kosanService.createKosan(newKosan);
                  Navigator.of(context).pop();
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
    
    List<String> descriptionParts = kosan.deskripsi.split('\n');
    String name = descriptionParts.first;
    String description = descriptionParts.length > 1 ? descriptionParts.sublist(1).join('\n') : '';
    
    final TextEditingController _imageUrlController = TextEditingController(text: kosan.imageUrl);
    final TextEditingController _namaController = TextEditingController(text: name);
    final TextEditingController _deskripsiController = TextEditingController(text: description);
    final TextEditingController _lokasiController = TextEditingController(text: kosan.lokasi);
    final TextEditingController _hargaController = TextEditingController(text: kosan.harga.toString());
    final TextEditingController _fasilitasController = TextEditingController(text: kosan.fasilitas.join(', '));
    final TextEditingController _bedroomsController = TextEditingController(text: kosan.bedrooms.toString());
    final TextEditingController _bathroomsController = TextEditingController(text: kosan.bathrooms.toString());
    final TextEditingController _kitchensController = TextEditingController(text: kosan.kitchens.toString());
    final TextEditingController _latitudeController = TextEditingController(text: kosan.latitude.toString());
    final TextEditingController _longitudeController = TextEditingController(text: kosan.longitude.toString());
    
    // Track room availability
    bool _isAvailable = kosan.isAvailable;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Kosan',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama kosan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _deskripsiController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Kosan',
                        ),
                        maxLines: 3,
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _bedroomsController,
                              decoration: InputDecoration(
                                labelText: 'Jumlah Kamar Tidur',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jumlah kamar tidur tidak boleh kosong';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _bathroomsController,
                              decoration: InputDecoration(
                                labelText: 'Jumlah Kamar Mandi',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jumlah kamar mandi tidak boleh kosong';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _kitchensController,
                              decoration: InputDecoration(
                                labelText: 'Jumlah Dapur',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jumlah dapur tidak boleh kosong';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeController,
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Latitude tidak boleh kosong';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _longitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Longitude tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      // Room availability checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _isAvailable,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                _isAvailable = value ?? true;
                              });
                            },
                          ),
                          Text('Kamar Tersedia', style: blackTextStyle),
                        ],
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Combine nama and deskripsi for the deskripsi field
                      String fullDeskripsi = _namaController.text;
                      if (_deskripsiController.text.isNotEmpty) {
                        fullDeskripsi += '\n' + _deskripsiController.text;
                      }
                      
                      Kosan updatedKosan = Kosan(
                        id: kosan.id,
                        imageUrl: _imageUrlController.text,
                        deskripsi: fullDeskripsi,
                        lokasi: _lokasiController.text,
                        harga: int.parse(_hargaController.text),
                        fasilitas: _fasilitasController.text.split(',').map((e) => e.trim()).toList(),
                        bedrooms: int.parse(_bedroomsController.text),
                        bathrooms: int.parse(_bathroomsController.text),
                        kitchens: int.parse(_kitchensController.text),
                        latitude: double.parse(_latitudeController.text),
                        longitude: double.parse(_longitudeController.text),
                        isAvailable: _isAvailable, // Set availability
                      );

                      _kosanService.updateKosan(updatedKosan);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kosan.imageUrl.isNotEmpty)
                  ClipRRect(
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
                          child: Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  'Nama:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  kosan.deskripsi.split('\n').first,
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Deskripsi:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  kosan.deskripsi,
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Lokasi:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  kosan.lokasi,
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Harga:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Rp ${kosan.harga.toString()}',
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Fasilitas:',
                  style: blackTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  kosan.fasilitas.join(', '),
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Kamar Tidur: ${kosan.bedrooms}',
                  style: blackTextStyle,
                ),
                Text(
                  'Kamar Mandi: ${kosan.bathrooms}',
                  style: blackTextStyle,
                ),
                Text(
                  'Dapur: ${kosan.kitchens}',
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Koordinat: ${kosan.latitude}, ${kosan.longitude}',
                  style: blackTextStyle,
                ),
                SizedBox(height: 8),
                // Availability status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kosan.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    kosan.isAvailable ? 'Kamar Tersedia' : 'Kamar Tidak Tersedia',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
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

  void _showDeleteConfirmationDialog(BuildContext context, String kosanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus kosan ini?'),
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
              onPressed: () {
                _kosanService.deleteKosan(kosanId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
