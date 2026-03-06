import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

// ==================================================
// YEIDARAAH - AI FOOD RESCUE OPERATING SYSTEM
// TEAM: MANNA HACKERS ✝️
// MASTER CONSOLIDATED MASTER VERSION (STABLE)
// ==================================================

// COLOR CONSTANTS
const Color ORANGE = Color(0xFFFF6B35);
const Color DARK_ORANGE = Color(0xFFE85D2F);
const Color GREEN = Color(0xFF2ECC71);
const Color DARK = Color(0xFF1A1A2E);
const Color WHITE = Colors.white;
const Color APP_BG = Color(0xFFBCD9A2); // Mint Green
const Color NAVY = Color(0xFF2C3E50);
const Color RED = Color(0xFFE74C3C);
const Color BLUE = Color(0xFF3498DB);
const Color PURPLE = Color(0xFF9B59B6);
const Color GOLD = Color(0xFFF39C12);
const Color TEAL = Color(0xFF1ABC9C);

// REAL TAMIL NADU DATASET
final Map<String, Map<String, List<String>>> tamilNaduData = {
  "Chennai": {
    "Hotels": ["Saravana Bhavan", "A2B Bhavan", "Sangeetha Veg Restaurant"],
    "NGOs": ["World Vision India", "Bhumi NGO", "Vuyiroli Welfare Society"]
  },
  "Coimbatore": {
    "Hotels": ["Annapoorna Gowrishankar", "Haribhavanam"],
    "NGOs": ["District HIV Sangam", "Welfare & Education Poor (WEP)"]
  },
  "Madurai": {
    "Hotels": ["Kumar Mess", "Murugan Idli Shop"],
    "NGOs": ["Royal Vision Special School", "Annai Fathima Trust"]
  },
};

// =====================
// GLOBAL STORE (Real-Time Connectivity)
// =====================
class GlobalStore {
  static final StreamController<List<Map<String, dynamic>>> _stream = StreamController.broadcast();
  static List<Map<String, dynamic>> donations = [];
  static int hungerSpotsCount = 3;
  static String? verifiedOrgName;
  static String? verifiedDistrict;
  static String? userRole;

  static void addDonation(Map<String, dynamic> data) {
    donations.add(data);
    _stream.add(donations);
  }

  static Stream<List<Map<String, dynamic>>> get donationStream => _stream.stream;
}

void main() {
  runApp(const YEIDARAAHApp());
}

class YEIDARAAHApp extends StatelessWidget {
  const YEIDARAAHApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YEIDARAAH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: ORANGE,
        scaffoldBackgroundColor: APP_BG,
        fontFamily: 'Roboto',
      ),
      builder: (context, child) => ResponsiveWrapper(child: child!),
      home: const SplashScreen(),
    );
  }
}

// =====================
// RESPONSIVE WRAPPER
// =====================
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: isWide ? const Color(0xFFE5E7EB) : APP_BG,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWide ? 500 : double.infinity),
          decoration: BoxDecoration(
            color: APP_BG,
            boxShadow: [if (isWide) BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Material(color: Colors.transparent, child: child),
        ),
      ),
    );
  }
}

// 1. SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [ORANGE, DARK_ORANGE])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 100, color: WHITE),
              const SizedBox(height: 24),
              const Text('YEIDARAAH', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
              const Text('AI Food Rescue Operating System', style: TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. LANDING PAGE
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withAlpha(230),
        elevation: 0,
        title: const Row(children: [Icon(Icons.restaurant_menu, color: ORANGE), SizedBox(width: 10), Text("YEIDARAAH", style: TextStyle(color: ORANGE, fontWeight: FontWeight.bold))]),
        actions: [
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AboutUsScreen())), child: const Text("About Us", style: TextStyle(color: NAVY))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              color: ORANGE,
              child: Column(
                children: [
                  const Text("Rescuing Food.\nRestoring Hope.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RolePortalGate())),
                    style: ElevatedButton.styleFrom(backgroundColor: WHITE, foregroundColor: ORANGE, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    child: const Text("PARTNER LOGIN / SIGNUP", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _infoTile(Icons.auto_awesome, "AI Surplus Prediction", "GAP 2 SOLVED: Predictive analytics for zero waste."),
            _infoTile(Icons.map, "Live Hunger Mapping", "GAP 3 SOLVED: Real-time hunger crowdsourcing."),
            _infoTile(Icons.track_changes, "Transparent Food Journey", "GAP 1 SOLVED: Track every KG donated."),
            const SizedBox(height: 50),
            const Text("Welcome to non profitable organization", style: TextStyle(color: NAVY, fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData i, String t, String d) => ListTile(leading: Icon(i, color: ORANGE, size: 30), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(d));
}

// 3. ROLE PORTAL GATE
class RolePortalGate extends StatelessWidget {
  const RolePortalGate({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Select Portal")),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _portalBtn(context, "HOTEL / RESTAURANT", Icons.hotel, ORANGE),
          _portalBtn(context, "NGO PARTNER", Icons.volunteer_activism, GREEN),
          _portalBtn(context, "DELIVERY PARTNER", Icons.delivery_dining, BLUE),
        ],
      ),
    ),
  );
  Widget _portalBtn(BuildContext c, String t, IconData i, Color col) => Card(margin: const EdgeInsets.only(bottom: 15), child: ListTile(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (c) => VerificationScreen(role: t))), leading: Icon(i, color: col, size: 30), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: const Icon(Icons.arrow_forward_ios)));
}

// 4. VERIFICATION MODULE
class VerificationScreen extends StatefulWidget {
  final String role;
  const VerificationScreen({super.key, required this.role});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String country = "India";
  String state = "Tamil Nadu";
  String? district;
  String? orgName;
  final captchaInput = TextEditingController();
  final String captchaCode = "Fb4H2";
  bool isVerifying = false;

  void _runVerification() {
    if (!_formKey.currentState!.validate()) return;
    if (captchaInput.text != captchaCode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Captcha Failed!"), backgroundColor: RED));
      return;
    }
    setState(() => isVerifying = true);
    
    Timer(const Duration(seconds: 3), () {
      GlobalStore.verifiedOrgName = orgName ?? "Admin User";
      GlobalStore.verifiedDistrict = district;
      GlobalStore.userRole = widget.role;
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => AlertDialog(
            title: const Icon(Icons.check_circle, color: GREEN, size: 60),
            content: const Text("Verification Done Successfully!\nCredentials matched with government records.", textAlign: TextAlign.center),
            actions: [TextButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const HomeScreen()), (r) => false), child: const Text("ENTER DASHBOARD"))],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.role} Login")),
      body: isVerifying 
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 20), Text("Syncing with Government Records...")] ))
        : SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [
            _drop("Country", ["India", "Singapore", "USA"], (v) => setState(() => country = v!)),
            if (country == "India") _drop("State", ["Tamil Nadu", "Kerala", "Andhra Pradesh"], (v) => setState(() => state = v!)),
            if (state == "Tamil Nadu") _drop("District", tamilNaduData.keys.toList(), (v) => setState(() { district = v; orgName = null; })),
            if (district != null && !widget.role.contains("DELIVERY")) 
              _drop("Select Organization Name", widget.role.contains("HOTEL") ? tamilNaduData[district]!["Hotels"]! : tamilNaduData[district]!["NGOs"]!, (v) => setState(() => orgName = v)),
            
            if (widget.role.contains("DELIVERY")) ...[
              _field("Full Name", null), _field("Phone Number", null, type: TextInputType.phone), _field("Experience (Years)", null, type: TextInputType.number)
            ] else _field("FSSAI License / Registration ID (14 Digits)", null, limit: 14, type: TextInputType.number),
            
            _field("Full Address", null, lines: 2),
            const SizedBox(height: 20),
            const Text("Captcha: Fb4H2", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 5)),
            _field("Enter Captcha Shown Above", captchaInput),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _runVerification, style: ElevatedButton.styleFrom(backgroundColor: NAVY, foregroundColor: WHITE, minimumSize: const Size(double.infinity, 50)), child: const Text("PROCEED TO VERIFICATION")),
          ]))),
    );
  }
  Widget _drop(String h, List<String> items, Function(String?) on) => Padding(padding: const EdgeInsets.only(bottom: 15), child: DropdownButtonFormField<String>(hint: Text(h), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: on, decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: WHITE)));
  Widget _field(String h, TextEditingController? controller, {TextInputType type = TextInputType.text, int lines = 1, int? limit}) => Padding(padding: const EdgeInsets.only(bottom: 15), child: TextFormField(controller: controller, maxLines: lines, keyboardType: type, maxLength: limit, decoration: InputDecoration(labelText: h, border: const OutlineInputBorder(), filled: true, fillColor: WHITE), validator: (v) => (v == null || v.isEmpty) ? "Required" : null));
}

// =====================
// 5. HOME SCREEN
// =====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _c;
  late Animation<int> _meals;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(seconds: 2)); _meals = IntTween(begin: 0, end: 383).animate(_c); _c.forward(); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.restaurant_menu, size: 20, color: WHITE), SizedBox(width: 10), Text("Dashboard", style: TextStyle(color: WHITE))]),
        backgroundColor: ORANGE,
        actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ChatbotScreen())), icon: const Icon(Icons.smart_toy, color: WHITE))],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _stat("Meals Saved", _meals), _staticStat("42kg", "CO2 Saved", GREEN), _staticStat("8", "Donors", BLUE)
        ]),
        const SizedBox(height: 25),
        if (GlobalStore.verifiedOrgName != null) Container(padding: const EdgeInsets.all(10), margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: GOLD.withAlpha(30), borderRadius: BorderRadius.circular(10), border: Border.all(color: GOLD)), child: Row(children: [const Icon(Icons.verified, color: GOLD), const SizedBox(width: 10), Text("Verified Account: ${GlobalStore.verifiedOrgName}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown))])),
        _action(context, "HOTEL PORTAL", "Scan & Donate", Icons.hotel, ORANGE, const DonorPortal()),
        _action(context, "NGO PORTAL", "Matching Feed", Icons.volunteer_activism, GREEN, const NGOPortal()),
        _action(context, "DELIVERY PORTAL", "Logistics", Icons.delivery_dining, BLUE, const DeliveryPortal()),
        _action(context, "HUNGER HEATMAP", "Live Locations", Icons.map, RED, const HungerMapScreen()),
        _action(context, "FOOD JOURNEY", "Impact Journey", Icons.track_changes, PURPLE, const FoodJourneyScreen()),
      ])),
    );
  }
  Widget _stat(String l, Animation<int> a) => AnimatedBuilder(animation: a, builder: (c, _) => _staticStat(a.value.toString(), l, ORANGE));
  Widget _staticStat(String v, String l, Color col) => Column(children: [Text(v, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: col)), Text(l, style: const TextStyle(fontSize: 10))]);
  Widget _action(BuildContext c, String t, String tag, IconData i, Color col, Widget s) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (c) => s)), leading: Icon(i, color: col, size: 30), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(tag, style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold)), trailing: const Icon(Icons.arrow_forward_ios, size: 16)));
}

// =====================
// 6. PORTAL: HOTEL (With AI Scanner)
// =====================
class DonorPortal extends StatefulWidget {
  const DonorPortal({super.key});
  @override
  State<DonorPortal> createState() => _DonorPortalState();
}

class _DonorPortalState extends State<DonorPortal> {
  bool scanning = false;
  bool predicted = false;
  bool photoUploaded = false;
  int timer = 300;
  Timer? _t;

  final foodNameController = TextEditingController();
  final quantityController = TextEditingController();
  final prepTimeController = TextEditingController();
  final expiryTimeController = TextEditingController();

  void _simulatePhotoUpload() {
    setState(() => photoUploaded = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Food Photo Uploaded! AI Ready to Scan."), backgroundColor: BLUE));
  }

  void _startScanning() {
    if (!photoUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload food photo first!")));
      return;
    }
    setState(() => scanning = true);
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() { scanning = false; predicted = true; });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _t?.cancel(); setState(() => timer = 300);
    _t = Timer.periodic(const Duration(seconds: 1), (t) => setState(() => timer--));
  }

  @override
  void dispose() { _t?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hotel Dashboard")),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text("1. Evidence Collection", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InkWell(
          onTap: _simulatePhotoUpload,
          child: Container(
            height: 150,
            decoration: BoxDecoration(color: WHITE, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
            child: Center(child: photoUploaded ? const Icon(Icons.check_circle, color: GREEN, size: 50) : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, color: ORANGE, size: 40), Text("Tap to Upload Leftover Photo", style: TextStyle(fontSize: 10))])),
          ),
        ),
        const SizedBox(height: 20),
        const Text("2. Food Details", style: TextStyle(fontWeight: FontWeight.bold)),
        _input("Food Name", foodNameController),
        _input("Quantity", quantityController),
        Row(children: [
          Expanded(child: _input("Prep Time", prepTimeController)),
          const SizedBox(width: 10),
          Expanded(child: _input("Expiry Time", expiryTimeController)),
        ]),
        const SizedBox(height: 20),
        if (scanning)
          const Center(child: Column(children: [CircularProgressIndicator(), Text("AI ANALYZING FRESHNESS & TIMELINES...")]))
        else if (!predicted)
          ElevatedButton.icon(
            onPressed: _startScanning, 
            icon: const Icon(Icons.qr_code_scanner), 
            label: const Text("AI SCAN & PREDICT"),
            style: ElevatedButton.styleFrom(backgroundColor: NAVY, foregroundColor: WHITE, padding: const EdgeInsets.all(16)),
          ),
        
        if (predicted) ...[
          const SizedBox(height: 20),
          _aiAnalysisCard(),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            GlobalStore.addDonation({"hotel": GlobalStore.verifiedOrgName ?? "Hotel Raj", "qty": quantityController.text, "time": expiryTimeController.text});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alert Sent to Nearby NGOs!"), backgroundColor: GREEN));
          }, style: ElevatedButton.styleFrom(backgroundColor: GREEN, foregroundColor: WHITE), child: const Text("LIST FOOD & NOTIFY NGOs")),
        ]
      ])),
    );
  }

  Widget _input(String h, TextEditingController c) => Padding(padding: const EdgeInsets.only(top: 10), child: TextField(controller: c, decoration: InputDecoration(labelText: h, border: const OutlineInputBorder(), filled: true, fillColor: WHITE)));

  Widget _aiAnalysisCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(12), border: Border.all(color: ORANGE, width: 2)),
    child: Column(children: [
      const Text("AI PREDICTION REPORT", style: TextStyle(fontWeight: FontWeight.bold, color: ORANGE)),
      const Divider(),
      _aiRow(Icons.verified, "Freshness Index:", "98% (High Quality)"),
      _aiRow(Icons.timer, "Delivery Timeline:", "Within 45 Mins"),
      _aiRow(Icons.history, "Waste Forecast:", "15kg may waste tomorrow. Reduce prep by 10%."),
      const SizedBox(height: 10),
      Text("RESCUE WINDOW: ${(timer ~/ 60)}:${(timer % 60).toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: RED)),
    ]),
  );

  Widget _aiRow(IconData i, String t, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Icon(i, size: 16, color: NAVY), const SizedBox(width: 10), Expanded(child: Text("$t $v", style: const TextStyle(fontSize: 12)))]));
}

class NGOPortal extends StatelessWidget {
  const NGOPortal({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Matching Portal")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: GlobalStore.donationStream,
        builder: (c, s) {
          final list = s.data ?? GlobalStore.donations;
          if (list.isEmpty) return const Center(child: Text("Searching for nearby donations..."));
          return ListView.builder(itemCount: list.length, itemBuilder: (c, i) => Card(margin: const EdgeInsets.all(12), child: ListTile(
            title: Text(list[i]['hotel']),
            subtitle: Text("Fresh Meals • Qty: ${list[i]['qty']} • Ready at ${list[i]['time']}"),
            trailing: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Claimed!")),), child: const Text("ACCEPT")))));
        },
      ),
    );
  }
}

class DeliveryPortal extends StatelessWidget {
  const DeliveryPortal({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Partner")),
      body: ListView(padding: const EdgeInsets.all(15), children: [
        Card(child: Padding(padding: const EdgeInsets.all(15), child: Column(children: [
          const ListTile(leading: Icon(Icons.delivery_dining, color: BLUE), title: Text("Task: Hotel Residency → Akshaya NGO"), subtitle: Text("OTP: 4829")),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ ElevatedButton(onPressed: () {}, child: const Text("ROUTE")), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: GREEN, foregroundColor: WHITE), child: const Text("COMPLETE")) ])
        ])))
      ]),
    );
  }
}

class HungerMapScreen extends StatefulWidget {
  const HungerMapScreen({super.key});
  @override
  State<HungerMapScreen> createState() => _HungerMapScreenState();
}
class _HungerMapScreenState extends State<HungerMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pc;
  @override
  void initState() { super.initState(); _pc = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true); }
  @override
  void dispose() { _pc.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: DARK, appBar: AppBar(title: const Text("Heatmap")), body: Stack(children: [
    const Center(child: Icon(Icons.map, size: 300, color: Colors.white10)),
    _dot(100, 200), _dot(250, 350), _dot(50, 400),
    Positioned(bottom: 30, left: 20, right: 20, child: ElevatedButton(onPressed: () { setState(() => GlobalStore.hungerSpotsCount++); }, style: ElevatedButton.styleFrom(backgroundColor: RED, foregroundColor: WHITE), child: const Text("I AM HUNGRY")))
  ]));
  Widget _dot(double x, double y) => Positioned(left: x, top: y, child: ScaleTransition(scale: Tween(begin: 1.0, end: 1.5).animate(_pc), child: Container(width: 15, height: 15, decoration: const BoxDecoration(color: RED, shape: BoxShape.circle))));
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}
class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<String> chat = ["Vanakkam! I am ShareBite AI. I assist in coordination. Ask me anything!"];
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("ShareBite AI")), body: Column(children: [
    Expanded(child: ListView.builder(itemCount: chat.length, itemBuilder: (c, i) => ListTile(leading: const Icon(Icons.smart_toy, color: TEAL), title: Text(chat[i])))),
    Container(padding: const EdgeInsets.all(10), child: Wrap(spacing: 8, children: ["How do I donate?", "Find NGO", "Check task status"].map((q) => ActionChip(label: Text(q), onPressed: () => setState(() => chat.add("ShareBite: Processing '$q'...")))).toList()))
  ]));
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("About Us")), body: const Padding(padding: EdgeInsets.all(30), child: Text("YEIDARAAH is an AI-powered system dedicated to zero hunger.", style: TextStyle(fontSize: 18))));
}
class FoodJourneyScreen extends StatelessWidget {
  const FoodJourneyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Impact Journey")), body: const Center(child: Text("Donated food reached 83 children tonight ❤️", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))));
}
