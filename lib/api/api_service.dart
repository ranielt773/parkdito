import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.68.65/parkditto_api"; // Use 10.0.2.2 for Android emulator
  // For physical device testing: Use your computer's IP address instead of localhost

  static Future<Map<String, dynamic>> login(String username,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10)); // Add timeout

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in login: $e');
      throw Exception('Network error: $e');
    }
  }

  // api_service.dart - Update the register method
  static Future<Map<String, dynamic>> register(String username, String email,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Register Response status: ${response.statusCode}');
      print('Register Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Try to parse error message
        try {
          final errorResponse = jsonDecode(response.body);
          throw Exception(errorResponse['message'] ?? 'Failed to register');
        } catch (e) {
          throw Exception(
              'Failed to register. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error in register: $e');
      throw Exception('Network error: $e');
    }
  }

  // Save user data to shared preferences
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));
    await prefs.setBool('isLoggedIn', true);
  }

  // Get user data from shared preferences
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<List<Map<String, dynamic>>> getParkingSpots() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_parking_spots.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('Parking spots response: ${response.statusCode}');
      print('Parking spots body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          return List<Map<String, dynamic>>.from(result['data']);
        } else {
          throw Exception('Failed to get parking spots');
        }
      } else {
        throw Exception(
            'Failed to get parking spots. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting parking spots: $e');
      throw Exception('Network error: $e');
    }
  }

  // Create transaction
  static Future<Map<String, dynamic>> createTransaction(int parkingSpaceId,
      int userId,
      String lotNumber,
      String transactionType,
      String arrivalTime,
      double amount,
      String paymentMethod,
      {String? departureTime}) async {
    try {
      final Map<String, dynamic> requestBody = {
        'parking_space_id': parkingSpaceId,
        'user_id': userId,
        'lot_number': lotNumber,
        'transaction_type': transactionType,
        'arrival_time': arrivalTime,
        'amount': amount,
        'payment_method': paymentMethod,
      };

      if (departureTime != null) {
        requestBody['departure_time'] = departureTime;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create_transaction.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 10));

      print('Create transaction response: ${response.statusCode}');
      print('Create transaction body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create transaction. Status code: ${response
            .statusCode}');
      }
    } catch (e) {
      print('Error creating transaction: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get user transactions
  static Future<List<Map<String, dynamic>>> getUserTransactions(
      int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_transactions.php?user_id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('Transactions response: ${response.statusCode}');
      print('Transactions body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          return List<Map<String, dynamic>>.from(result['data']);
        } else {
          throw Exception('Failed to get transactions');
        }
      } else {
        throw Exception(
            'Failed to get transactions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting transactions: $e');
      throw Exception('Network error: $e');
    }
  }

// api_service.dart - Add these methods

// Create booking transaction
  static Future<Map<String, dynamic>> createBooking(int parkingSpaceId,
      int userId,
      String lotNumber,
      String transactionType,
      DateTime arrivalTime,
      double amount,
      String paymentMethod,
      String vehicleType, // Add this parameter
      String floor, // Add this parameter
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_transaction.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'parking_space_id': parkingSpaceId,
          'user_id': userId,
          'lot_number': lotNumber,
          'transaction_type': transactionType,
          'arrival_time': arrivalTime.toIso8601String(),
          'amount': amount,
          'payment_method': paymentMethod,
          'vehicle_type': vehicleType, // Add this
          'floor': floor, // Add this
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

// Update parking space availability
  static Future<Map<String, dynamic>> updateParkingAvailability(
      int parkingSpaceId,
      String vehicleType,
      String floor,
      int slotNumber,
      bool isOccupied,) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_parking_availability.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'parking_space_id': parkingSpaceId,
          'vehicle_type': vehicleType,
          'floor': floor,
          'slot_number': slotNumber,
          'is_occupied': isOccupied,
        }),
      ).timeout(const Duration(seconds: 10));

      print('Update parking response: ${response.statusCode}');
      print('Update parking body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to update parking. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating parking: $e');
      throw Exception('Network error: $e');
    }
  }

  // Add these methods to your ApiService class


  static Future<List<Map<String, dynamic>>> getActiveReservations(
      int parkingSpaceId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/get_active_reservations.php?parking_space_id=$parkingSpaceId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to get active reservations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> checkExpiredReservations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/check_expired_reservations.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('Check expired response: ${response.statusCode}');
      print('Check expired body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to check expired reservations. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      print('Error checking expired reservations: $e');
      throw Exception('Network error: $e');
    }
  }

// Get bookings with status filter
  static Future<List<Map<String, dynamic>>> getBookingsByStatus(int userId,
      String status) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/get_bookings_by_status.php?user_id=$userId&status=$status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('Bookings by status response: ${response.statusCode}');
      print('Bookings by status body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          return List<Map<String, dynamic>>.from(result['data']);
        } else {
          throw Exception('Failed to get bookings by status');
        }
      } else {
        throw Exception(
            'Failed to get bookings by status. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      print('Error getting bookings by status: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserBookings(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings.php?user_id=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('User bookings response: ${response.statusCode}');
      print('User bookings body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if response body is empty
        if (response.body.isEmpty) {
          print('Empty response body from server');
          return [];
        }

        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('error')) {
            print('API Error: ${decoded['error']}');
            return [];
          }
        }

        return [];
      } else {
        print('Failed to get user bookings. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting user bookings: $e');
      return [];
    }
  }
  static Future<Map<String, dynamic>> createBookingWithDuration(
      int parkingSpaceId,
      int userId,
      String lotNumber,
      String transactionType,
      String arrivalTime, // This can be empty for bookings
      double amount,
      String paymentMethod,
      String durationType,
      int durationValue, {
        String? vehicleType,
        String? floor,
      }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_transaction.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'parking_space_id': parkingSpaceId,
        'user_id': userId,
        'lot_number': lotNumber,
        'transaction_type': transactionType,
        'arrival_time': arrivalTime, // This will be empty for bookings
        'amount': amount,
        'payment_method': paymentMethod,
        'duration_type': durationType,
        'duration_value': durationValue,
        'vehicle_type': vehicleType,
        'floor': floor,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create booking');
    }
  }
  // Add these methods to your ApiService class

  static Future<Map<String, dynamic>> uploadImage(File imageFile, int userId, String type) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload.php'),
      );

      request.fields['user_id'] = userId.toString();
      request.fields['type'] = type;

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseData);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Image upload error: $e');
    }
  }

  static Future<Map<String, dynamic>> updateProfileWithImages(
      int userId,
      String firstName,
      String lastName,
      {String? displayPhotoPath,
        String? idPicturePath}
      ) async {
    try {
      final Map<String, dynamic> requestBody = {
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
      };

      if (displayPhotoPath != null) {
        requestBody['display_photo'] = displayPhotoPath;
      }

      if (idPicturePath != null) {
        requestBody['id_picture'] = idPicturePath;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/update_profile.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }
}
