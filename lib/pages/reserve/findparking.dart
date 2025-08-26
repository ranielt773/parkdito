import 'package:flutter/material.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage({super.key});

  @override
  State<FindParkingPage> createState() => _FindParkingPageState();
}

class _FindParkingPageState extends State<FindParkingPage> {
  int? selectedSlot;
  String selectedFloor = "Ground";

  final List<String> vehicleTypes = ["Car", "Mini Truck", "Motorcycle"];
  String selectedVehicle = "Car";

  // Different configurations for each vehicle type
  final Map<String, Map<String, dynamic>> vehicleConfigs = {
    "Car": {
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "slotsPerFloor": 8,
      "occupiedSlots": {
        "Ground": [1, 4, 6],
        "2nd Floor": [2, 5, 7],
        "3rd Floor": [3, 8],
      },
      "image": "lib/assets/carz.png",
      "slotHeight": 60.0,
      "rows": 4,
      "cols": 2,
    },
    "Mini Truck": {
      "floors": ["Ground"], // Only ground floor for mini trucks
      "slotsPerFloor": 4,
      "occupiedSlots": {
        "Ground": [2],
      },
      "image": "lib/assets/minitruck.png",
      "slotHeight": 70.0, // Slightly taller for trucks
      "rows": 2,
      "cols": 2,
    },
    "Motorcycle": {
      "floors": ["Ground", "2nd Floor", "3rd Floor"],
      "slotsPerFloor": 10,
      "occupiedSlots": {
        "Ground": [3, 7],
        "2nd Floor": [2, 5, 9],
        "3rd Floor": [1, 4, 8],
      },
      "image": "lib/assets/motor.png",
      "slotHeight": 42.0, // 70% of car height (60 * 0.7 = 42)
      "rows": 5,
      "cols": 2,
    },
  };

  @override
  Widget build(BuildContext context) {
    final config = vehicleConfigs[selectedVehicle]!;
    final currentFloors = List<String>.from(config["floors"] as List);
    final currentOccupiedSlots = (config["occupiedSlots"] as Map<String, List<int>>)[selectedFloor] ?? [];
    final slotHeight = config["slotHeight"] as double;
    final rows = config["rows"] as int;
    final cols = config["cols"] as int;
    final vehicleImage = config["image"] as String;

    // If selected floor is not available for current vehicle, switch to first available floor
    if (!currentFloors.contains(selectedFloor)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedFloor = currentFloors.first;
          selectedSlot = null;
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      "lib/assets/back.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const Text(
                    "Reserve slot",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B060A),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "lib/assets/notif.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tabs - Show only available floors for current vehicle
              if (currentFloors.length > 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: currentFloors.map((floor) {
                    return _buildTab(floor, selectedFloor == floor);
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Parking slot layout
              _buildParkingSlots(currentOccupiedSlots, slotHeight, rows, cols, vehicleImage),

              const SizedBox(height: 20),

              // Vehicle type selector
              const Text(
                "Vehicle type",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B060A)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 3,
                  alignment: WrapAlignment.center,
                  children: vehicleTypes.map((type) {
                    bool selected = selectedVehicle == type;
                    return Container(
                      width: 105,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedVehicle = type;
                            selectedSlot = null;
                            // Reset to first available floor for this vehicle type
                            selectedFloor = vehicleConfigs[type]!["floors"][0];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF3B060A) : Color(0xFF3B060A2E).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Color(0xFFFDF7D8) : Color(0xFF3B060A).withOpacity(0.41),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 70),

              // Action buttons
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF02542D),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Reserve",
                        style: TextStyle(color: Color(0xFFFDF7D8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B060A),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Book now",
                        style: TextStyle(color: Color(0xFFFDF7D8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Reusable tab
  Widget _buildTab(String title, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFloor = title;
          selectedSlot = null;
        });
      },
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF3B060A) : Color(0xFF3B060A2E).withOpacity(0.18),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Color(0xFFFDF7D8) : Color(0xFF3B060A).withOpacity(0.41),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Parking slot layout with dynamic parameters
  Widget _buildParkingSlots(List<int> occupiedSlots, double slotHeight, int rows, int cols, String vehicleImage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cols, (col) {
              int slotNum = row * cols + col + 1;
              bool occupied = occupiedSlots.contains(slotNum);
              bool selected = selectedSlot == slotNum;

              return GestureDetector(
                onTap: () {
                  if (occupied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Parking space not available"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    setState(() {
                      selectedSlot = slotNum;
                    });
                  }
                },
                child: Container(
                  width: 120,
                  height: slotHeight,
                  decoration: BoxDecoration(
                    color: (selected ? Colors.green[100] : Colors.white),
                    border: _getBorderForSlot(row, col, rows),
                  ),
                  child: occupied
                      ? Center(
                    child: Image.asset(
                      vehicleImage,
                      width: slotHeight * 1.4, // Scale image proportionally
                      height: slotHeight * 1.4,
                      fit: BoxFit.contain,
                    ),
                  )
                      : Center(
                    child: Text(
                      "Slot $slotNum",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: slotHeight * 0.3, // Scale font size
                        color: selected ? Colors.green : const Color(0xFF3B060A),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Border _getBorderForSlot(int row, int col, int totalRows) {
    bool isFirstRow = row == 0;
    bool isLastRow = row == totalRows - 1;

    // For left column
    if (col == 0) {
      return Border(
        top: BorderSide(color: Colors.black, width: isFirstRow ? 2.0 : 1.0),
        bottom: BorderSide(color: Colors.black, width: isLastRow ? 2.0 : 1.0),
        right: BorderSide(color: Colors.black, width: 1),
      );
    }
    // For right column
    else {
      return Border(
        top: BorderSide(color: Colors.black, width: isFirstRow ? 2.0 : 1.0),
        bottom: BorderSide(color: Colors.black, width: isLastRow ? 2.0 : 1.0),
        left: BorderSide(color: Colors.black, width: 1),
      );
    }
  }
}