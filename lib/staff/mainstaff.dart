import 'package:flutter/material.dart';
import 'package:parkditto/api/api_service.dart';
import 'package:parkditto/login.dart';
import 'package:parkditto/staff/booking_status.dart';

class MainStaffPage extends StatelessWidget {
  const MainStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // REMOVED PADDING FROM HERE TO REMOVE SIDE MARGINS
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - ADDED PADDING TO HEADER INSTEAD
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    const Column(
                      children: [
                        Text(
                          "Parking Management",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B060A),
                          ),
                        ),
                        Text(
                          "Staff",
                          style: TextStyle(
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
              ),

              const SizedBox(height: 5),

              // Floor tabs - ADDED PADDING TO THIS ROW
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab("Ground", true),
                    _buildTab("First", false),
                    _buildTab("Second", false),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Parking slot layout - ADDED PADDING TO THIS CONTAINER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildParkingSlots(),
              ),
              const SizedBox(height: 20),

              // Vehicle type selector - ADDED PADDING TO THIS SECTION
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        spacing: 3,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildVehicleType("Car", true),
                          _buildVehicleType("Mini Truck", false),
                          _buildVehicleType("Motorcycle", false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Reservation Details Container - NO MARGIN/PADDING ON SIDES
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFDF7D8).withOpacity(.53),
                  border: Border.all(
                    color: const Color(0xFF3B060A).withOpacity(0.3),
                    width: 1,
                  ),
                  // ADDED BORDER RADIUS TO TOP LEFT AND TOP RIGHT ONLY
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slot number and View Detail button
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Slot 5",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B060A),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingStatusPage(
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B060A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                            ),
                            child: const Text(
                              "View Detail",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Remaining time
                    const Center(
                      child: Text(
                        "15 days 06:45:32 remaining",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02542D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Date range
                    const Center(
                      child: Text(
                        "Jan 01 2025 - Jan 01 2026",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Days remaining
                    const Center(
                      child: Text(
                        "365 days total",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.only(right: 30,left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBF0000),
                                foregroundColor: Color(0xFFFDF7D8),
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19),
                                ),
                              ),
                              child: const Text("End"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await ApiService.logout();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                      (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF02542D),
                                foregroundColor: Color(0xFFFDF7D8),
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19),
                                ),
                              ),
                              child: const Text("logout"),
                            ),
                          ),

                        ],
                      ),
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

  Widget _buildTab(String title, bool active) {
    return Container(
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
    );
  }

  Widget _buildVehicleType(String type, bool selected) {
    return Container(
      width: 105,
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
    );
  }

  Widget _buildParkingSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParkingSlot(1, true),
              _buildParkingSlot(2, false),
            ],
          ),
          // Row 2
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParkingSlot(3, false),
              _buildParkingSlot(4, true),
            ],
          ),
          // Row 3
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParkingSlot(5, false),
              _buildParkingSlot(6, false),
            ],
          ),
          // Row 4
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildParkingSlot(7, true),
              _buildParkingSlot(8, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSlot(int slotNum, bool occupied) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: _getBorderForSlot(slotNum),
      ),
      child: occupied
          ? Center(
        child: Image.asset(
          "assets/carz.png",
          width: 84,
          height: 84,
          fit: BoxFit.contain,
        ),
      )
          : Center(
        child: Text(
          "Slot $slotNum",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF3B060A),
          ),
        ),
      ),
    );
  }

  Border _getBorderForSlot(int slotNum) {
    bool isTopRow = slotNum <= 2;
    bool isBottomRow = slotNum >= 7;
    bool isLeftColumn = slotNum % 2 == 1;

    if (isLeftColumn) {
      return Border(
        top: BorderSide(color: Colors.black, width: isTopRow ? 2.0 : 1.0),
        bottom: BorderSide(color: Colors.black, width: isBottomRow ? 2.0 : 1.0),
        right: BorderSide(color: Colors.black, width: 1),
      );
    } else {
      return Border(
        top: BorderSide(color: Colors.black, width: isTopRow ? 2.0 : 1.0),
        bottom: BorderSide(color: Colors.black, width: isBottomRow ? 2.0 : 1.0),
        left: BorderSide(color: Colors.black, width: 1),
      );
    }
  }
}