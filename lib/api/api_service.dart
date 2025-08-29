import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.68.74/parkditto_api"; // Use 10.0.2.2 for Android emulator
  // For physical device testing: Use your computer's IP address instead of localhost

  static Future<Map<String, dynamic>> login(String username, String password) async {
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
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
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
          throw Exception('Failed to register. Status code: ${response.statusCode}');
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
        throw Exception('Failed to get parking spots. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting parking spots: $e');
      throw Exception('Network error: $e');
    }
  }

  // Create transaction
  static Future<Map<String, dynamic>> createTransaction(
      int parkingSpaceId,
      int userId,
      String lotNumber,
      String transactionType,
      String arrivalTime,
      double amount,
      String paymentMethod,
      {String? departureTime}
      ) async {
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
        throw Exception('Failed to create transaction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating transaction: $e');
      throw Exception('Network error: $e');
    }
  }

  // Get user transactions
  static Future<List<Map<String, dynamic>>> getUserTransactions(int userId) async {
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
        throw Exception('Failed to get transactions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting transactions: $e');
      throw Exception('Network error: $e');
    }
  }
// api_service.dart - Add these methods

// Create booking transaction
  static Future<Map<String, dynamic>> createBooking(
      int parkingSpaceId,
      int userId,
      String lotNumber,
      String transactionType,
      DateTime arrivalTime,
      double amount,
      String paymentMethod, {
        DateTime? departureTime,
      }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'parking_space_id': parkingSpaceId,
        'user_id': userId,
        'lot_number': lotNumber,
        'transaction_type': transactionType,
        'arrival_time': arrivalTime.toIso8601String(),
        'amount': amount,
        'payment_method': paymentMethod,
      };

      if (departureTime != null) {
        requestBody['departure_time'] = departureTime.toIso8601String();
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
        throw Exception('Failed to create transaction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating transaction: $e');
      throw Exception('Network error: $e');
    }
  }

// Update parking space availability
  static Future<Map<String, dynamic>> updateParkingAvailability(
      int parkingSpaceId,
      String vehicleType,
      String floor,
      int slotNumber,
      bool isOccupied,
      ) async {
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
        throw Exception('Failed to update parking. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating parking: $e');
      throw Exception('Network error: $e');
    }
  }
}
