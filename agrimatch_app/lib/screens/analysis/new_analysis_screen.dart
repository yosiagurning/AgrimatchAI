import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/soil_provider.dart';

class NewAnalysisScreen extends StatefulWidget {
  const NewAnalysisScreen({super.key});
  @override
  State<NewAnalysisScreen> createState() => _NewAnalysisScreenState();
}

class _NewAnalysisScreenState extends State<NewAnalysisScreen> {
  final _landName = TextEditingController();
  File? _img;
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 85);
    if (x != null) setState(() => _img = File(x.path));
  }

  @override
  Widget build(BuildContext context) {
    final soil = context.watch<SoilProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6EAF71), // Light green
              Color(0xFF6EAF71), // Medium green
              Color(0xFF5A9B5E), // Slightly darker green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF5A9B5E), // Updated to darker shade of #6EAF71
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Analisis Tanah Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight -
                                48, // Account for padding
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Informasi Lahan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Color(0xFF6EAF71), // Updated to #6EAF71
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: TextField(
                                    controller: _landName,
                                    decoration: const InputDecoration(
                                      labelText: 'Nama Lahan',
                                      prefixIcon: Icon(Icons.landscape,
                                          color: Color(
                                              0xFF6EAF71)), // Updated to #6EAF71
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16),
                                      labelStyle:
                                          TextStyle(color: Color(0xFF666666)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Foto Tanah',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Color(0xFF6EAF71), // Updated to #6EAF71
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    minHeight: 150,
                                    maxHeight: 250,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 2,
                                        style: BorderStyle.solid),
                                  ),
                                  child: _img == null
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              size: 48,
                                              color: Color(0xFF999999),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Belum ada foto tanah',
                                              style: TextStyle(
                                                color: Color(0xFF999999),
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.file(
                                            _img!,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF6EAF71),
                                              Color(0xFF5A9B5E)
                                            ], // Updated gradient colors to use #6EAF71
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6EAF71)
                                                  .withOpacity(
                                                      0.3), // Updated shadow color
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              _pick(ImageSource.camera),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          icon: const Icon(Icons.camera_alt,
                                              color: Colors.white),
                                          label: const Text(
                                            'Kamera',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF6EAF71),
                                              width: 2), // Updated border color
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              _pick(ImageSource.gallery),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(
                                                0xFF6EAF71), // Updated foreground color
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          icon: const Icon(Icons.photo),
                                          label: const Text(
                                            'Galeri',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 40),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6EAF71),
                                          Color(0xFF5A9B5E)
                                        ], // Updated gradient colors to use #6EAF71
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6EAF71)
                                              .withOpacity(
                                                  0.4), // Updated shadow color
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: soil.loading || _img == null
                                          ? null
                                          : () async {
                                              try {
                                                await soil.analyze(_img!, {
                                                  'land_name': _landName.text,
                                                  'location': 'unknown',
                                                  'altitude': '0',
                                                  'water_availability': 'cukup',
                                                  'climate_type': 'tropis',
                                                  'drainage': 'baik',
                                                });
                                                if (mounted)
                                                  Navigator.pushNamed(context,
                                                      '/analysis/result');
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Gagal: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        disabledBackgroundColor:
                                            Colors.grey[300],
                                      ),
                                      child: soil.loading
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Menganalisis...',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              'Mulai Analisis Tanah',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 20
                                        : 0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
