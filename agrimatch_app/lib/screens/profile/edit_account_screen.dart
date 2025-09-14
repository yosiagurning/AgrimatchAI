import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      await auth.updateProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
      Navigator.pop(context); // balik ke ProfileScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update profil: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    // refresh isi form kalau ada data terbaru dari provider
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Akun"),
        backgroundColor: const Color(0xFF81C784),
      ),
      body: auth.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // preview profil user di atas form
                    if (user != null) ...[
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${user.email}"),
                            if (user.phone != null && user.phone!.isNotEmpty)
                              Text("No. Telp: ${user.phone}"),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],

                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: "Nama Lengkap"),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Nama wajib diisi"
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Email wajib diisi"
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: "No. Telepon"),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF81C784),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Simpan Perubahan"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
