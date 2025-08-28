import 'package:flutter/material.dart';
import 'package:parkditto/pages/booking_contents/plan.dart';
import 'package:parkditto/pages/booking_contents/reservePlan.dart';

class FindParkingPage extends StatefulWidget {
  final Map<String, dynamic> parkingData;

  const FindParkingPage({super.key, required this.parkingData});

  @override
  State<FindParkingPage> createState() => _FindParkingPageState();
}

class _FindParkingPageState extends State<FindParkingPage> {
  int? selectedSlot;
  String selectedFloor = "Ground";
  String selectedVehicle = "Car";

  @override
  void initState() {
    super.initState();
    // Set default vehicle type to the first available one
    if (widget.parkingData["vehicleTypes"].isNotEmpty) {
      selectedVehicle = widget.parkingData["vehicleTypes"].keys.first;
    }
    // Set default floor to the first available one
    if (widget.parkingData["floors"].isNotEmpty) {
      selectedFloor = widget.parkingData["floors"][0];
    }
  }

  // Get vehicle configuration based on selected vehicle type
  Map<String, dynamic> getVehicleConfig(String vehicleType) {
    // Default configuration
    Map<String, dynamic> defaultConfig = {
      "floors": ["Ground"],
      "slotsPerFloor": 8,
      "slotHeight": 60.0,
      "rows": 4,
      "cols": 2,
    };

    // Get available floors for this vehicle type from parking data
    List<String> availableFloors = [];
    if (widget.parkingData["floors"] != null) {
      availableFloors = List<String>.from(widget.parkingData["floors"]);
    }

    // Get occupied slots from parking data
    Map<String, List<int>> occupiedSlots = {};
    if (widget.parkingData["occupiedSlots"] != null &&
        widget.parkingData["occupiedSlots"][vehicleType] != null) {
      occupiedSlots = Map<String, List<int>>.from(
          widget.parkingData["occupiedSlots"][vehicleType]);
    }

    // Adjust configuration based on vehicle type
    switch (vehicleType) {
      case "Car":
        return {
          ...defaultConfig,
          "floors": availableFloors,
          "slotsPerFloor": 8,
          "occupiedSlots": occupiedSlots,
          "image": "assets/carz.png",
          "slotHeight": 60.0,
          "rows": 4,
          "cols": 2,
        };
      case "Mini Truck":
        return {
          ...defaultConfig,
          "floors": ["Ground"], // Only ground floor for mini trucks
          "slotsPerFloor": 4,
          "occupiedSlots": occupiedSlots,
          "image": "assets/minitruck.png",
          "slotHeight": 70.0,
          "rows": 2,
          "cols": 2,
        };
      case "Motorcycle":
        return {
          ...defaultConfig,
          "floors": availableFloors,
          "slotsPerFloor": 10,
          "occupiedSlots": occupiedSlots,
          "image": "assets/motor.png",
          "slotHeight": 42.0,
          "rows": 5,
          "cols": 2,
        };
      default:
        return defaultConfig;
    }
  }

  // Get available vehicle types from parking data
  List<String> getAvailableVehicleTypes() {
    if (widget.parkingData["vehicleTypes"] != null) {
      return widget.parkingData["vehicleTypes"].keys.toList();
    }
    return ["Car", "Mini Truck", "Motorcycle"];
  }

  @override
  Widget build(BuildContext context) {
    final config = getVehicleConfig(selectedVehicle);
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
                      "assets/back.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Reserve slot",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                      Text(
                        widget.parkingData["name"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      "assets/notif.png",
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Parking info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem("Total Spaces", widget.parkingData["totalSpaces"].toString()),
                    _buildInfoItem("Available", widget.parkingData["availableSpaces"].toString()),
                    _buildInfoItem("Distance", "2.5 km"),
                  ],
                ),
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
                  children: getAvailableVehicleTypes().map((type) {
                    bool selected = selectedVehicle == type;
                    return Container(
                      width: 105,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedVehicle = type;
                            selectedSlot = null;
                            // Reset to first available floor for this vehicle type
                            selectedFloor = getVehicleConfig(type)["floors"][0];
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
                      onPressed: selectedSlot != null ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservePlanPage()),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSlot != null ? Color(0xFF02542D) : Colors.grey,
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
                      onPressed: selectedSlot != null ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlanPage()),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSlot != null ? Color(0xFF3B060A) : Colors.grey,
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

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B060A),
          ),
        ),
      ],
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

  void _showReservationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Reservation"),
          content: Text("Do you want to reserve slot $selectedSlot on the $selectedFloor floor for your $selectedVehicle?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B060A),
              ),
              child: const Text("Confirm", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reservation Successful"),
          content: Text("Your reservation for slot $selectedSlot on the $selectedFloor floor has been confirmed."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B060A),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}