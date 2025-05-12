import 'package:flutter/material.dart';
import 'package:project_house/database/database_helper.dart';
import 'package:project_house/models/pemilik_model.dart';

class PemilikManagment extends StatefulWidget {
  const PemilikManagment({super.key});

  @override
  State<PemilikManagment> createState() => _PemilikManagmentState();
}

class _PemilikManagmentState extends State<PemilikManagment> {
  final noKtpController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();
  List<PemilikModel> dataPmk = [];
  bool isLoading = true;

  final Color primaryColor = Colors.indigo;
  final Color accentColor = Colors.indigoAccent;

  Future<void> loadPmk() async {
    setState(() {
      isLoading = true;
    });

    try {
      dataPmk = await DatabaseHelper().getPemilik();
      print('Loaded ${dataPmk.length} items');
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPmk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Manajemen Pemilik',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadPmk,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                    SizedBox(height: 16),
                    Text(
                      'Memuat data...',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
              : dataPmk.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada data pemilik',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showAddDialog(context),
                      icon: Icon(Icons.add),
                      label: Text('Tambah Pemilik Baru'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Text(
                            dataPmk[index].nama.isNotEmpty
                                ? dataPmk[index].nama[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          dataPmk[index].nama,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('KTP: ${dataPmk[index].noKtp}'),
                            Text('HP: ${dataPmk[index].noHp}'),
                            Text('Email: ${dataPmk[index].email}'),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed:
                                    () => _showEditDialog(context, index),
                                icon: Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                onPressed:
                                    () =>
                                        _showDeleteConfirmation(context, index),
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                        ),
                        onTap: () => _showEditDialog(context, index),
                      ),
                    );
                  },
                  itemCount: dataPmk.length,
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        tooltip: 'Tambah Pemilik Baru',
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    noKtpController.clear();
    nameController.clear();
    emailController.clear();
    noHpController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Wrap(
            children: [
              Icon(Icons.person_add, color: primaryColor),
              SizedBox(width: 10),
              Text('Tambah Pemilik Kosan'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: noKtpController,
                  decoration: InputDecoration(
                    labelText: 'No KTP',
                    prefixIcon: Icon(Icons.credit_card, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: noHpController,
                  decoration: InputDecoration(
                    labelText: 'No HP',
                    prefixIcon: Icon(Icons.phone, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () async {
                if (noKtpController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No KTP tidak boleh kosong')),
                  );
                  return;
                }

                final dataPmk = PemilikModel(
                  noKtp: noKtpController.text,
                  nama: nameController.text,
                  email: emailController.text,
                  noHp: noHpController.text,
                );

                await DatabaseHelper().insertPemilik(dataPmk);
                Navigator.pop(context);
                loadPmk();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Simpan'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    String noKtp = dataPmk[index].noKtp;
    nameController.text = dataPmk[index].nama;
    emailController.text = dataPmk[index].email;
    noHpController.text = dataPmk[index].noHp;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Wrap(
            children: [
              Icon(Icons.edit, color: primaryColor),
              SizedBox(width: 10),
              Text('Edit Pemilik Kosan'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'KTP: $noKtp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: noHpController,
                  decoration: InputDecoration(
                    labelText: 'No HP',
                    prefixIcon: Icon(Icons.phone, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedPmk = PemilikModel(
                  noKtp: noKtp,
                  nama: nameController.text,
                  email: emailController.text,
                  noHp: noHpController.text,
                );

                await DatabaseHelper().updatePemilik(updatedPmk);
                Navigator.pop(context);
                loadPmk();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Update'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Wrap(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 10),
                Text('Konfirmasi Hapus'),
              ],
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus data pemilik ${dataPmk[index].nama}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: Colors.grey[700])),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper().deletePemilik(dataPmk[index].noKtp);
                  Navigator.pop(context);
                  loadPmk();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Hapus'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }
}
