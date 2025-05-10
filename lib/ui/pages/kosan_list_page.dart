import 'package:flutter/material.dart';
import 'package:project_house/models/kosan.dart';
import 'package:project_house/services/kosan_service.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/detail_page.dart';

class KosanListPage extends StatefulWidget {
  const KosanListPage({Key? key}) : super(key: key);

  @override
  State<KosanListPage> createState() => _KosanListPageState();
}

class _KosanListPageState extends State<KosanListPage> {
  final KosanService _kosanService = KosanService();
  List<Kosan> _allKosans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKosans();
  }

  void _loadKosans() async {
    _kosanService.getKosans().listen((kosans) {
      setState(() {
        _allKosans = kosans;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Kosan',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildKosanList(),
    );
  }
  
  Widget _buildKosanList() {
    if (_allKosans.isEmpty) {
      return const Center(child: Text('Belum ada kosan tersedia'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: _allKosans.length,
      itemBuilder: (context, index) {
        final kosan = _allKosans[index];
        return _buildKosanCard(kosan);
      },
    );
  }
  
  Widget _buildKosanCard(Kosan kosan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(kosan: kosan),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                kosan.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kosan.deskripsi.split('\n').first,
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: medium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 16,
                        color: greyColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kosan.lokasi,
                          style: greyTextStyle.copyWith(
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${kosan.harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: TextStyle(
                          color: purpleColor,
                          fontSize: 16,
                          fontWeight: medium,
                        ),
                      ),
                      Row(
                        children: [
                          _buildFacilityItem(Icons.king_bed, kosan.bedrooms.toString()),
                          _buildFacilityItem(Icons.bathtub, kosan.bathrooms.toString()),
                          _buildFacilityItem(Icons.kitchen, kosan.kitchens.toString()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFacilityItem(IconData icon, String count) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: greyColor,
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: greyTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}