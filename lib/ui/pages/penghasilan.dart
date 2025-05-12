import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_house/database/database_helper.dart';
import 'package:project_house/models/penghasilan.dart';
import 'package:sqflite/sqflite.dart';

class PenghasilanPage extends StatefulWidget {
  const PenghasilanPage({super.key});

  @override
  State<PenghasilanPage> createState() => _PenghasilanPageState();
}

class _PenghasilanPageState extends State<PenghasilanPage> {
  late Future<List<Penghasilan>> _penghasilanFuture;
  final currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _refreshPenghasilanList();
  }

  Future<void> _refreshPenghasilanList() async {
    setState(() {
      _penghasilanFuture = DatabaseHelper().getPenghasilan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Penghasilan')),
      body: FutureBuilder<List<Penghasilan>>(
        future: _penghasilanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data penghasilan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final penghasilan = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(penghasilan.sumber),
                    subtitle: Text(
                      DateFormat(
                        'dd MMMM yyyy',
                      ).format(DateTime.parse(penghasilan.tanggal)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currencyFormatter.format(penghasilan.jumlah),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        PopupMenuButton(
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TambahPenghasilanPage(
                                        penghasilan: penghasilan,
                                      ),
                                ),
                              );
                              _refreshPenghasilanList();
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(penghasilan);
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TambahPenghasilanPage(
                                penghasilan: penghasilan,
                              ),
                        ),
                      );
                      _refreshPenghasilanList();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const TambahPenghasilanPage(penghasilan: null),
            ),
          );
          _refreshPenghasilanList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(Penghasilan penghasilan) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseHelper().deletePenghasilan(penghasilan.id!);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil dihapus')),
                    );
                    _refreshPenghasilanList();
                  }
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }
}

class TambahPenghasilanPage extends StatefulWidget {
  final Penghasilan? penghasilan;
  const TambahPenghasilanPage({super.key, required this.penghasilan});

  @override
  State<TambahPenghasilanPage> createState() => _TambahPenghasilanPageState();
}

class _TambahPenghasilanPageState extends State<TambahPenghasilanPage> {
  final _formKey = GlobalKey<FormState>();
  final _sumberController = TextEditingController();
  final _jumlahController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.penghasilan != null) {
      _sumberController.text = widget.penghasilan!.sumber;
      _jumlahController.text = widget.penghasilan!.jumlah.toString();
      _selectedDate = DateTime.parse(widget.penghasilan!.tanggal);
    }
  }

  @override
  void dispose() {
    _sumberController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initialDate = _selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final data = Penghasilan(
        id: widget.penghasilan?.id,
        sumber: _sumberController.text,
        jumlah: double.parse(_jumlahController.text.replaceAll(',', '.')),
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
      );

      try {
        if (widget.penghasilan == null) {
          await DatabaseHelper().insertPenghasilan(data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil disimpan')),
            );
          }
        } else {
          await DatabaseHelper().updatePenghasilan(data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil diperbarui')),
            );
          }
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harap pilih tanggal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String tanggalText =
        _selectedDate != null
            ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
            : 'Pilih Tanggal';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.penghasilan == null
              ? 'Tambah Penghasilan'
              : 'Edit Penghasilan',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _sumberController,
                decoration: const InputDecoration(
                  labelText: 'Sumber Penghasilan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Wajib diisi';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tanggalText,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Pilih'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simpan,
        icon: const Icon(Icons.save),
        label: Text(widget.penghasilan == null ? 'Simpan' : 'Update'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
