import 'package:flutter/material.dart';
import 'package:parkditto/pages/reserve.dart';

class FindParkingPage extends StatefulWidget {
  const FindParkingPage({super.key});

  @override
  State<FindParkingPage> createState() => _FindParkingPageState();
}

class _FindParkingPageState extends State<FindParkingPage> {
  int? selectedSlot;

  // example: Slot 1 & 4 occupied
  final List<int> occupiedSlots = [1, 4, 6];

  final List<String> vehicleTypes = ["Car", "Mini Truck", "Motorcycle"];
  String selectedVehicle = "Car";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ bottom nav bar (prototype)


      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Arrow icon with function
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size:28, color: Color(0xFF5D2C2C)),
                    onPressed: () {
                      Navigator.pop(context); // Babalik sa previous page
                    },
                  ),

                  const Text(
                    "Reserve slot",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B060A),
                    ),
                  ),

                  // Notification icon (pwede ring lagyan ng function)
                  IconButton(
                    icon: const Icon(Icons.notifications, size:28,color: Color(0xFF5D2C2C)),
                    onPressed: () {
                      // Pwede kang magdagdag ng function dito para sa notifications
                      // Halimbawa: Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTab("Ground", true),
                  _buildTab("2nd Floor", false),
                  _buildTab("3rd Floor", false),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Parking slot layout (prototype)
              _buildParkingSlots(),

              const SizedBox(height: 20),

              // ✅ Vehicle type selector
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
                      width: 105, // Fixed width for all chips
                      child: InkWell(
                        onTap: () {
                          setState(() => selectedVehicle = type);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF3B060A) : Color(0xFF3B060A2E).withOpacity(0.18),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: selected ? const Color(0xFF3B060A) : Color(0xFF3B060A2E).withOpacity(0.18),
                              width: 2,
                            ),
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
              const SizedBox(height: 60),

              // ✅ Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF02542D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("Reserve"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B060A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Book now"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ✅ reusable tab
  Widget _buildTab(String title, bool active) {
    return Container(
      width: 105, // Fixed width for all tabs
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

  // ✅ Parking slot layout (simplified grid)
  Widget _buildParkingSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (col) {
              int slotNum = row * 2 + col + 1;
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
                  height: 60,
                  decoration: BoxDecoration(
                    color : (selected ? Colors.green[100] : Colors.white),
                    border: _getBorderForSlot(row, col),
                  ),
                  child: occupied
                      ? Center(
                    child: Image.asset(
                      "lib/assets/carz.png",
                      width: 84, // Adjust size as needed
                      height: 84, // Adjust size as needed
                      fit: BoxFit.contain,
                    ),
                  )
                      : Center(
                    child: Text(
                      "Slot $slotNum",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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

  Border _getBorderForSlot(int row, int col) {
    // For left column
    if (col == 0) {
      if(row==0){
      return Border(
        top: BorderSide(color: Colors.black, width: 2.0),
        bottom: BorderSide(color: Colors.black, width: 1.0),
        right: BorderSide(color: Colors.black, width: 1),
      );
    }
      if(row==3){
        return Border(
          top: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          right: BorderSide(color: Colors.black, width: 1),
        );
      }
      return Border(
        top: BorderSide(color: Colors.black, width: 1.0),
        bottom: BorderSide(color: Colors.black, width: 1.0),
        right: BorderSide(color: Colors.black, width: 1),

      );

    }
    // For right column
    else {
      if(row==0){
        return Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 1.0),
          left: BorderSide(color: Colors.black, width: 1),
        );
      }
      if(row==3){
        return Border(
          top: BorderSide(color: Colors.black, width: 1.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 1),
        );
      }
      return Border(
        top: BorderSide(color: Colors.black, width: 1.0),
        bottom: BorderSide(color: Colors.black, width: 1.0),
        left: BorderSide(color: Colors.black, width: 1),
      );
    }
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
        ),
        Text(text),
      ],
    );
  }
}
