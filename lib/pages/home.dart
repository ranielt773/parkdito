import 'package:flutter/material.dart';
import 'package:parkditto/mainpage.dart';
import 'package:parkditto/pages/reserve/findparking.dart';
import 'reserve.dart'; // Add this import

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Map of parking images
  final Map<int, String> parkingImages = const {
    1: "assets/market.png",
    2: "assets/calauan.png",
    3: "assets/bay.png",
    4: "assets/victoria.png",
    5: "assets/parking5.jpg",
    6: "assets/parking6.jpg",
    7: "assets/parking7.jpg",
    8: "assets/parking8.jpg",
    9: "assets/parking9.jpg",
    10: "assets/parking10.jpg",
    11: "assets/parking11.jpg",
    12: "assets/parking12.jpg",
  };

  // Default image if specific image is not available
  final String defaultParkingImage = "assets/parkingbg.png";

  // ✅ Sample parking data with the same structure as ReservePage
  final List<Map<String, dynamic>> parkingSpots = const [
    {
      "id": 1,
      "name": "Calauan Public Market Parking",
      "address": "Public Market, Calauan, Laguna",
      "totalSpaces": 50,
      "availableSpaces": 10,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 8},
        "Motorcycle": {"total": 20, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 2,
      "name": "Calauan Municipal Hall Parking",
      "address": "Municipal Hall Compound, Calauan, Laguna",
      "totalSpaces": 80,
      "availableSpaces": 15,
      "vehicleTypes": {
        "Car": {"total": 50, "available": 10},
        "Mini Truck": {"total": 20, "available": 5},
        "Motorcycle": {"total": 10, "available": 0},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15]
        },
        "Motorcycle": {
          "Ground": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        }
      }
    },
    {
      "id": 3,
      "name": "Bay Town Center Parking",
      "address": "Bay Town Center, Bay, Laguna",
      "totalSpaces": 40,
      "availableSpaces": 8,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 5},
        "Motorcycle": {"total": 10, "available": 3},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 2, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8, 10],
          "3rd Floor": [1, 3, 5]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        }
      }
    },
    {
      "id": 4,
      "name": "Victoria Plaza Parking",
      "address": "Victoria Plaza, Victoria, Laguna",
      "totalSpaces": 60,
      "availableSpaces": 12,
      "vehicleTypes": {
        "Car": {"total": 40, "available": 8},
        "Mini Truck": {"total": 10, "available": 2},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 5,
      "name": "Nagcarlan Town Square Parking",
      "address": "Town Square, Nagcarlan, Laguna",
      "totalSpaces": 35,
      "availableSpaces": 7,
      "vehicleTypes": {
        "Car": {"total": 25, "available": 5},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7]
        }
      }
    },
    {
      "id": 6,
      "name": "Rizal Municipal Parking",
      "address": "Municipal Building, Rizal, Laguna",
      "totalSpaces": 45,
      "availableSpaces": 9,
      "vehicleTypes": {
        "Car": {"total": 30, "available": 6},
        "Mini Truck": {"total": 5, "available": 1},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13],
          "2nd Floor": [2, 4, 6, 8, 10]
        },
        "Mini Truck": {
          "Ground": [1, 3],
          "2nd Floor": [2]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
    {
      "id": 7,
      "name": "Luisiana Public Market Parking",
      "address": "Public Market, Luisiana, Laguna",
      "totalSpaces": 30,
      "availableSpaces": 6,
      "vehicleTypes": {
        "Car": {"total": 20, "available": 4},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7]
        }
      }
    },
    {
      "id": 8,
      "name": "Pagsanjan Town Plaza Parking",
      "address": "Town Plaza, Pagsanjan, Laguna",
      "totalSpaces": 75,
      "availableSpaces": 15,
      "vehicleTypes": {
        "Car": {"total": 50, "available": 10},
        "Mini Truck": {"total": 15, "available": 3},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16],
          "3rd Floor": [1, 3, 5, 7, 9]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5],
          "2nd Floor": [2, 4],
          "3rd Floor": [1]
        }
      }
    },
    {
      "id": 9,
      "name": "Cabuyao City Mall Parking",
      "address": "City Mall, Cabuyao, Laguna",
      "totalSpaces": 125,
      "availableSpaces": 25,
      "vehicleTypes": {
        "Car": {"total": 80, "available": 15},
        "Mini Truck": {"total": 25, "available": 5},
        "Motorcycle": {"total": 20, "available": 5},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor", "4th Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
          "3rd Floor": [1, 3, 5, 7, 9, 11, 13, 15],
          "4th Floor": [2, 4, 6, 8, 10, 12]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8],
          "3rd Floor": [1, 3, 5],
          "4th Floor": [2, 4]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8],
          "3rd Floor": [1, 3, 5],
          "4th Floor": [2, 4]
        }
      }
    },
    {
      "id": 10,
      "name": "San Pablo City Parking Complex",
      "address": "City Complex, San Pablo City, Laguna",
      "totalSpaces": 150,
      "availableSpaces": 30,
      "vehicleTypes": {
        "Car": {"total": 100, "available": 20},
        "Mini Truck": {"total": 30, "available": 6},
        "Motorcycle": {"total": 20, "available": 4},
      },
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],
          "3rd Floor": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11],
          "2nd Floor": [2, 4, 6, 8, 10, 12],
          "3rd Floor": [1, 3, 5]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9],
          "2nd Floor": [2, 4, 6, 8, 10],
          "3rd Floor": [1, 3]
        }
      }
    },
    {
      "id": 11,
      "name": "Alaminos Town Center Parking",
      "address": "Town Center, Alaminos, Laguna",
      "totalSpaces": 55,
      "availableSpaces": 11,
      "vehicleTypes": {
        "Car": {"total": 40, "available": 8},
        "Motorcycle": {"total": 15, "available": 3},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7, 9, 11],
          "2nd Floor": [2, 4, 6]
        }
      }
    },
    {
      "id": 12,
      "name": "Sta. Cruz Municipal Parking",
      "address": "Municipal Building, Sta. Cruz, Laguna",
      "totalSpaces": 90,
      "availableSpaces": 18,
      "vehicleTypes": {
        "Car": {"total": 60, "available": 12},
        "Mini Truck": {"total": 20, "available": 4},
        "Motorcycle": {"total": 10, "available": 2},
      },
      "floors": ["Ground", "2nd Floor"],
      "occupiedSlots": {
        "Car": {
          "Ground": [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29],
          "2nd Floor": [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24]
        },
        "Mini Truck": {
          "Ground": [1, 3, 5, 7, 9, 11, 13],
          "2nd Floor": [2, 4, 6, 8]
        },
        "Motorcycle": {
          "Ground": [1, 3, 5, 7],
          "2nd Floor": [2, 4]
        }
      }
    },
  ];

  // Helper function to get image for a parking spot
  String _getParkingImage(int parkingId) {
    return parkingImages[parkingId] ?? defaultParkingImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/search.png",
                      width: 40,
                      height: 40,
                    ),
                    const Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    Image.asset(
                      "assets/notif.png",
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),

              // ✅ Parking Nearby Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Parking nearby",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    // GestureDetector for navigation
                    GestureDetector(
                      onTap: () {
                        MainPage.of(context)?.onItemTapped(1); // ✅ punta sa ReservePage (index 1)
                      },
                      child: const Text(
                        "View Map",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Horizontal list of nearby parking
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final spot = parkingSpots[index];
                    final imagePath = _getParkingImage(spot["id"]);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                        );
                      },
                      child: Container(
                        width: 266,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF3B060A), width: 2),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5)),
                                  child: Image.asset(
                                    imagePath,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to default image if specific image is not found
                                      return Image.asset(
                                        defaultParkingImage,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  bottom: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFDF7D8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${spot["availableSpaces"]} free spaces",
                                      style: const TextStyle(
                                        color: Color(0xFF3B060A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spot["name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3B060A),
                                        fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    spot["address"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ✅ Promo Banner
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFDF7D8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign,
                        color: Color(0xFF3B060A), size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Save up to 25% – Get Monthly or yearly plan!",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Favorite Place
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Favorite Parking Spots",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    // GestureDetector for navigation
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReservePage()),
                        );
                      },
                      child: const Text(
                        "View Map",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ List of favorite spots
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6, // Show 6 favorite spots
                itemBuilder: (context, index) {
                  final spot = parkingSpots[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindParkingPage(parkingData: spot)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9).withOpacity(0.3),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            _getParkingImage(spot["id"]),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                defaultParkingImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          spot["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B060A)),
                        ),
                        subtitle: Text(
                          spot["address"],
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFDF7D8),
                          ),
                          child: Text(
                            "${spot["availableSpaces"]} free spaces",
                            style: const TextStyle(
                              color: Color(0xFF3B060A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}