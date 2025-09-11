import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:parkditto/api/api_service.dart';

class PersonalDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const PersonalDetailsPage({super.key, this.userData});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Camera related variables
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _showCamera = false;
  bool _isEditing = false;
  File? _selectedDisplayPhoto;
  File? _selectedIdPicture;
  String? _displayPhotoUrl;
  String? _idPictureUrl;
  bool _isUploading = false;
  bool _hasIdPicture = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with user data
    if (widget.userData != null) {
      _firstNameController.text = widget.userData!['first_name'] ?? '';
      _lastNameController.text = widget.userData!['last_name'] ?? '';
      _emailController.text = widget.userData!['email'] ?? '';
      _displayPhotoUrl = widget.userData!['display_photo'];
      _idPictureUrl = widget.userData!['id_picture'];
      _hasIdPicture = _idPictureUrl != null && _idPictureUrl!.isNotEmpty;
    }
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startCamera() async {
    if (_cameras == null || _cameras!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No cameras available')),
      );
      return;
    }

    setState(() {
      _showCamera = true;
    });

    // Use the first camera (back camera by default)
    _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile picture = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = picture;
        _selectedIdPicture = File(picture.path);
        _hasIdPicture = true;
        _showCamera = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID scanned successfully')),
      );
    } catch (e) {
      debugPrint('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
      _selectedIdPicture = null;
      _hasIdPicture = _idPictureUrl != null && _idPictureUrl!.isNotEmpty;
      _showCamera = true;
      _startCamera();
    });
  }

  void _removeIdPicture() {
    setState(() {
      _selectedIdPicture = null;
      _hasIdPicture = false;
      _idPictureUrl = null;
    });
  }

  void _closeCamera() {
    setState(() {
      _showCamera = false;
      _cameraController?.dispose();
      _cameraController = null;
    });
  }

  // Add this method to pick display photo
  Future<void> _pickDisplayPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedDisplayPhoto = File(image.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final userData = await ApiService.getUserData();
      final userId = userData!['id'];

      String? displayPhotoPath;
      String? idPicturePath;

      // Upload display photo if selected
      if (_selectedDisplayPhoto != null) {
        final displayPhotoResponse = await ApiService.uploadImage(
            _selectedDisplayPhoto!,
            userId,
            'display_photo'
        );
        displayPhotoPath = displayPhotoResponse['file_path'];
      }

      // Upload ID picture if captured/selected
      if (_selectedIdPicture != null) {
        final idPictureResponse = await ApiService.uploadImage(
            _selectedIdPicture!,
            userId,
            'id_picture'
        );
        idPicturePath = idPictureResponse['file_path'];
      }

      // Update profile with the new data
      final response = await ApiService.updateProfileWithImages(
        userId,
        _firstNameController.text,
        _lastNameController.text,
        displayPhotoPath: displayPhotoPath,
        idPicturePath: idPicturePath,
      );

      if (response['success']) {
        // Update local user data
        final updatedUserData = {
          ...userData,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'display_photo': displayPhotoPath ?? _displayPhotoUrl,
          'id_picture': idPicturePath ?? _idPictureUrl,
        };

        await ApiService.saveUserData(updatedUserData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _isEditing = false;
          _displayPhotoUrl = displayPhotoPath ?? _displayPhotoUrl;
          _idPictureUrl = idPicturePath ?? _idPictureUrl;
          _hasIdPicture = _idPictureUrl != null && _idPictureUrl!.isNotEmpty;
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Camera view (keep this part the same)
    if (_showCamera) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // Camera preview
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_cameraController != null &&
                        _cameraController!.value.isInitialized) {
                      return CameraPreview(_cameraController!);
                    } else {
                      return const Center(child: Text('Camera not available'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),

              // Close button
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4C0B0B),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    onPressed: _closeCamera,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),

              // Capture button
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _takePicture,
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Frame overlay for ID scanning
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Position ID within this frame",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Regular personal details page
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          "assets/back.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const Text(
                        "Personal Details",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                      const SizedBox(width: 40), // For balance
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile picture
            Stack(
              alignment: Alignment.center,
              children: [
                // 🔵 Main circular container with image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF3B060A).withOpacity(0.3),
                      width: 2,
                    ),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: _selectedDisplayPhoto != null
                        ? Image.file(
                      _selectedDisplayPhoto!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                        : (_displayPhotoUrl != null && _displayPhotoUrl!.isNotEmpty
                        ? Image.network(
                      'http://192.168.68.77/parkditto_api/$_displayPhotoUrl',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/display.png",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        );
                      },
                    )
                        : Image.asset(
                      "assets/display.png",
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )),
                  ),
                ),

                // 📷 Camera icon positioned at the lower-left border
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isEditing ? _pickDisplayPhoto : null,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF3B060A),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Form fields in a scrollable container
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(top: 25, bottom: 50),
                decoration: BoxDecoration(
                    color: const Color(0xFFFDF7D8).withOpacity(0.53),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // First Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "First Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C0B0B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _firstNameController,
                            enabled: _isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF3B060A).withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B060A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Last Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C0B0B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _lastNameController,
                            enabled: _isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF3B060A).withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B060A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C0B0B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            enabled: false, // Email should not be editable
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF3B060A).withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B060A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // ID Picture Section - Always visible
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ID Picture",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C0B0B),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Show ID picture if available
                          if (_hasIdPicture)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green, width: 2),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "ID Verified",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: _selectedIdPicture != null
                                        ? Image.file(
                                      _selectedIdPicture!,
                                      fit: BoxFit.contain,
                                    )
                                        : (_idPictureUrl != null && _idPictureUrl!.isNotEmpty
                                        ? Image.network(
                                      'http://192.168.68.77/parkditto_api/$_idPictureUrl',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.error, color: Colors.red);
                                      },
                                    )
                                        : const Icon(Icons.credit_card, size: 50)),
                                  ),
                                  const SizedBox(height: 10),
                                  if (_isEditing)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _startCamera,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text("Rescan ID"),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: _removeIdPicture,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text("Remove ID"),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.credit_card, size: 50, color: Colors.grey),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "No ID picture uploaded",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  if (_isEditing)
                                    ElevatedButton(
                                      onPressed: _startCamera,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4C0B0B),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Scan ID"),
                                    ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 10),
                          const Text(
                            "Note: Please provide a valid Senior/PWD ID for verification to avail of your community perks.",
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Edit/Save Profile Button
                      _isUploading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C0B0B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 60,
                          ),
                        ),
                        onPressed: _updateProfile,
                        child: Text(
                          _isEditing ? "Save Changes" : "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}