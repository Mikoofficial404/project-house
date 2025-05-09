import 'package:flutter/material.dart';
import 'package:project_house/models/kosan.dart';
import 'package:project_house/services/kosan_service.dart';
import 'package:project_house/shared/theme.dart';

class KosanListPage extends StatefulWidget {
  const KosanListPage({Key? key}) : super(key: key);

  @override
  State<KosanListPage> createState() => _KosanListPageState();
}

class _KosanListPageState extends State<KosanListPage> {
  final KosanService _kosanService = KosanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kosan'),
        backgroundColor: purpleColor,
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
            return Center(child: Text('Belum ada kosan tersedia'));
          }

          List<Kosan> kosans = snapshot.data!;
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: kosans.length,
            itemBuilder: (context, index) {
              Kosan kosan = kosans[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(kosan: kosan),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: kosan.imageUrl.isNotEmpty
                            ? Image.network(
                                kosan.imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 50),
                                  );
                                },
                              )
                            : Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(Icons.home, size: 50),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kosan.deskripsi.split('\n').first, // Use first line as title
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.grey, size: 16),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    kosan.lokasi,
                                    style: greyTextStyle.copyWith(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp ${kosan.harga}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: kosan.fasilitas.take(3).map((facility) {
                                return Chip(
                                  label: Text(
                                    facility,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.grey[200],
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Kosan kosan;

  const DetailPage({Key? key, required this.kosan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content = kosan.deskripsi;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Property Details'),
        actions: [
          Icon(Icons.favorite_border),
          const SizedBox(width: 20),
          Icon(Icons.share),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: kosan.imageUrl.isNotEmpty
                      ? Image.network(
                          kosan.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.error, size: 50),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.home, size: 50),
                        ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              kosan.deskripsi.split('\n').first,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Rp ${kosan.harga}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Display facilities as icons if possible
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: kosan.fasilitas.map((facility) {
                          IconData icon;
                          // Map common facilities to icons
                          if (facility.toLowerCase().contains('wifi')) {
                            icon = Icons.wifi;
                          } else if (facility.toLowerCase().contains('ac') || 
                                    facility.toLowerCase().contains('air')) {
                            icon = Icons.ac_unit;
                          } else if (facility.toLowerCase().contains('tv')) {
                            icon = Icons.tv;
                          } else if (facility.toLowerCase().contains('kamar mandi') || 
                                    facility.toLowerCase().contains('shower')) {
                            icon = Icons.shower;
                          } else if (facility.toLowerCase().contains('dapur') || 
                                    facility.toLowerCase().contains('kitchen')) {
                            icon = Icons.kitchen;
                          } else if (facility.toLowerCase().contains('kasur') || 
                                    facility.toLowerCase().contains('bed')) {
                            icon = Icons.bed;
                          } else {
                            icon = Icons.check_circle;
                          }
                          
                          return Column(
                            children: [
                              Icon(icon, size: 30),
                              SizedBox(height: 7),
                              Text(
                                facility,
                                style: blackTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description Property',
                            style: blackTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            content,
                            textAlign: TextAlign.justify,
                            style: greyTextStyle.copyWith(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: blackTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      kosan.lokasi,
                                      style: greyTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Implement WhatsApp contact functionality
                          },
                          label: Text("Pesan Lewat Whatsapp"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
