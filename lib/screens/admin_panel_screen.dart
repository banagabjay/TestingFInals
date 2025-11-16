import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screens/admin_order_screen.dart';
import 'package:ecommerce_app/screens/admin_chat_list_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;
  bool _isSeeding = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isLoading = true;
    });

    try {
      final String imageUrl = _imageUrlController.text.trim();

      await _firestore.collection('products').add({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      messenger.showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully!')),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _imageUrlController.clear();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to upload product: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _seedSampleProducts() async {
    setState(() {
      _isSeeding = true;
    });

    final List<Map<String, dynamic>> sampleProducts = [
      {
        'name': 'VoidStrike RGB Mechanical Keyboard',
        'description':
            'Hot-swappable mechanical keyboard with per-key RGB, pink PBT keycaps, and low-latency wired mode for competitive play.',
        'price': 3490.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Gaming+Keyboard',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'NebulaX UltraLight Gaming Mouse',
        'description':
            '58g ultra-lightweight mouse with 26K DPI sensor, PTFE skates, and customizable pink & black RGB strips.',
        'price': 2590.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Gaming+Mouse',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Nightshade 7.1 Surround Headset',
        'description':
            'Closed-back gaming headset with 7.1 virtual surround, noise-cancelling mic, and soft pink ear cushions.',
        'price': 2990.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Gaming+Headset',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'GalaxyWave XL RGB Mousepad',
        'description':
            'Extended mousepad with stitched edges, soft black surface, and dynamic pink RGB border lighting.',
        'price': 1290.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=RGB+Mousepad',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Lunar Drift Wireless Controller',
        'description':
            'Low-latency wireless controller with hall-effect thumbsticks and neon pink accents for PC and mobile.',
        'price': 2190.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Game+Controller',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Starlight Streaming Microphone',
        'description':
            'USB condenser mic with cardioid pickup, pink shock mount, and reactive RGB stand for streamers.',
        'price': 1890.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Mic',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Phantom Core Gaming Chair',
        'description':
            'Ergonomic gaming chair in black leatherette with pink stitching, 4D armrests, and neck support.',
        'price': 5990.0,
        'imageUrl':
            'https://via.placeholder.com/400x400.png?text=Gaming+Chair',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      for (final product in sampleProducts) {
        await _firestore.collection('products').add(product);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample gaming gear products added!'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add sample products: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSeeding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('Manage All Orders'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminOrderScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('View User Chats'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminChatListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.gamepad_outlined),
                label: _isSeeding
                    ? const Text('Adding Sample Gaming Gear...')
                    : const Text('Add Sample Gaming Gear Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _isSeeding ? null : _seedSampleProducts,
              ),
              const Divider(height: 30, thickness: 1),
              const Text(
                'Add New Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _imageUrlController,
                      decoration:
                          const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http')) {
                          return 'Please enter a valid URL (e.g., http://...)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'Product Name'),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a name'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter a description'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration:
                          const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _uploadProduct,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Upload Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
