import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_house/shared/theme.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project_house/models/kosan.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final Kosan? kosan; // Make it optional for now to maintain backward compatibility
  
  const DetailPage({super.key, this.kosan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Function to launch WhatsApp with the given phone number
  Future<void> _launchWhatsApp(int phoneNumber) async {
    // Format the phone number (remove any leading zeros and add country code if needed)
    String formattedNumber = phoneNumber.toString();
    if (formattedNumber.startsWith('0')) {
      formattedNumber = '62${formattedNumber.substring(1)}';
    } else if (!formattedNumber.startsWith('62')) {
      formattedNumber = '62$formattedNumber';
    }
    
    // Create the WhatsApp URL
    final Uri whatsappUrl = Uri.parse('https://wa.me/$formattedNumber');
    
    // Launch the URL
    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }
  String content =
      "Imagine waking up each morning in a home that truly feels like your own. Our rental house provides the space, comfort, and amenities you crave, allowing you to live life to the fullest. Whether you're a growing family, young professional, or empty-nester, this house offers the perfect blend of functionality and style to elevate your lifestyle.";
  final List<String> category = [
    'All',
    'Living Room',
    'Bed Room',
    'Dining Room',
    'Kitchen',
  ];
  @override
  Widget build(BuildContext context) {
    // Use the kosan data if available, otherwise use default values
    final kosan = widget.kosan;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Property Details'),
        actions: [
          FaIcon(FontAwesomeIcons.heart),
          const SizedBox(width: 20),
          FaIcon(FontAwesomeIcons.share),
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
                  child: kosan?.imageUrl != null && kosan!.imageUrl.isNotEmpty
                    ? Image.network(
                        kosan.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/carsoul_images1.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/carsoul_images1.jpg',
                        fit: BoxFit.cover,
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
                          Text(
                            kosan?.deskripsi.split('\n').first ?? 'Model Apartement in New York',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp. ${kosan?.harga.toString() ?? '50000'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              // Display availability status
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kosan?.isAvailable ?? true ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  kosan?.isAvailable ?? true ? 'Tersedia' : 'Tidak Tersedia',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              FaIcon(FontAwesomeIcons.bed, size: 30),
                              SizedBox(height: 7),
                              Text(
                                '${kosan?.bedrooms ?? 2} Bed',
                                style: blackTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FaIcon(FontAwesomeIcons.kitchenSet, size: 30),
                              SizedBox(height: 7),
                              Text(
                                '${kosan?.kitchens ?? 1} Kitchen',
                                style: blackTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FaIcon(FontAwesomeIcons.shower, size: 30),
                              SizedBox(height: 7),
                              Text(
                                '${kosan?.bathrooms ?? 2} Shower',
                                style: blackTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                          ReadMoreText(
                            kosan?.deskripsi ?? content,
                            trimLines: 3,
                            textAlign: TextAlign.justify,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: "....Show More",
                            trimExpandedText: "....Show Less",
                            lessStyle: TextStyle(
                              fontWeight: bold,
                              color: Colors.green,
                            ),
                            moreStyle: TextStyle(
                              fontWeight: bold,
                              color: Colors.green,
                            ),
                            style: greyTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    kosan?.lokasi.split(',').first ?? 'Jln. Ahmad Yani No.1',
                                    style: greyTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: regular,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    kosan?.lokasi.contains(',') == true 
                                        ? kosan!.lokasi.split(',').skip(1).join(',').trim() 
                                        : 'Jakarta, Indonesia',
                                    style: greyTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: regular,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: FlutterMap(
                              options: MapOptions(
                                center: LatLng(kosan?.latitude ?? -6.200000, kosan?.longitude ?? 106.816666),
                                zoom: 15.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName:
                                      'com.example.project_house',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            'Feature',
                            style: blackTextStyle.copyWith(fontSize: 15),
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              if (kosan?.fasilitas != null && kosan!.fasilitas.isNotEmpty)
                                ...kosan.fasilitas.map((facility) {
                                  IconData icon;
                                  String facilityStr = facility.toString();
                                  
                                  if (facilityStr.toLowerCase().contains('living') || 
                                      facilityStr.toLowerCase().contains('ruang tamu')) {
                                    icon = Icons.weekend;
                                  } else if (facilityStr.toLowerCase().contains('bed') || 
                                           facilityStr.toLowerCase().contains('kamar')) {
                                    icon = Icons.bed;
                                  } else if (facilityStr.toLowerCase().contains('dining') || 
                                           facilityStr.toLowerCase().contains('makan')) {
                                    icon = Icons.restaurant;
                                  } else if (facilityStr.toLowerCase().contains('kitchen') || 
                                           facilityStr.toLowerCase().contains('dapur')) {
                                    icon = Icons.kitchen;
                                  } else if (facilityStr.toLowerCase().contains('bath') || 
                                           facilityStr.toLowerCase().contains('mandi')) {
                                    icon = Icons.shower;
                                  } else if (facilityStr.toLowerCase().contains('wifi') || 
                                           facilityStr.toLowerCase().contains('internet')) {
                                    icon = Icons.wifi;
                                  } else if (facilityStr.toLowerCase().contains('ac') || 
                                           facilityStr.toLowerCase().contains('air')) {
                                    icon = Icons.ac_unit;
                                  } else {
                                    icon = Icons.home;
                                  }
                                  
                                  return Chip(
                                    avatar: Icon(icon, size: 20),
                                    label: Text(facilityStr),
                                  );
                                }).toList()
                              else
                                ...List.generate(category.length, (index) {
                                  IconData icon;
                                  switch (category[index]) {
                                    case 'Living Room':
                                      icon = Icons.weekend;
                                      break;
                                    case 'Bed Room':
                                      icon = Icons.bed;
                                      break;
                                    case 'Dining Room':
                                      icon = Icons.restaurant;
                                      break;
                                    case 'Kitchen':
                                      icon = Icons.kitchen;
                                      break;
                                    default:
                                      icon = Icons.home;
                                  }
                                  return Chip(
                                    avatar: Icon(icon, size: 20),
                                    label: Text(category[index]),
                                  );
                                }),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GFButton(
                          onPressed: () {
                            // Get the WhatsApp number from the kosan model
                            if (kosan != null && kosan.noWa > 0) {
                              _launchWhatsApp(kosan.noWa);
                            } else {
                              // Show a snackbar if no WhatsApp number is available
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Nomor WhatsApp tidak tersedia'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          text: "Pesan Lewat Whatsapp",
                          icon: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                          color: Colors.green,
                          size: GFSize.LARGE,
                          fullWidthButton: false,
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
