import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'screens/gender_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/library_screen.dart';
import 'screens/write_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/reading_screen.dart';
import 'widgets/theme_selector.dart';
import 'services/auth_service.dart';
import 'services/diary_service.dart';
import 'models/diary_entry.dart';
import 'utils/app_constants.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.database;
  runApp(const SecretSpaceApp());
}

class SecretSpaceApp extends StatelessWidget {
  const SecretSpaceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Serif'),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainFlow()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.defaultBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SecretSpace",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5E3C),
              ),
            ),
            Image.asset('assets/images/secretspace_logo.png', width: 200),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppConstants.defaultPrimary),
          ],
        ),
      ),
    );
  }
}

class MainFlow extends StatefulWidget {
  const MainFlow({super.key});
  @override
  State<MainFlow> createState() => _MainFlowState();
}

class _MainFlowState extends State<MainFlow> {
  final PageController _pageController = PageController();
  final diaryTitleCtrl = TextEditingController();
  final diaryContentCtrl = TextEditingController();

  Color customPrimary = AppConstants.defaultPrimary;
  Color customBg = AppConstants.defaultBg;
  Color customText = AppConstants.defaultText;
  Color? selPrimary, selBg, selText;

  bool isMale = false;
  bool isLoggedIn = false;
  String username = "Kimidora";
  String userEmail = "";
  List<DiaryEntry> entries = [];
  DiaryEntry? selectedEntry;

  int h = 0, s = 0, anx = 0, ang = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      customPrimary = Color(prefs.getInt('customPrimary') ?? 0xFF8B5E3C);
      customBg = Color(prefs.getInt('customBg') ?? 0xFFFEFEE2);
      customText = Color(prefs.getInt('customText') ?? 0xFF795548);
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        final genderKey = isMale ? "boy" : "girl";
        username =
            prefs.getString('user_${userEmail}_${genderKey}_name') ??
            prefs.getString('username') ??
            "";
        userEmail = prefs.getString('email') ?? "";
      }
    });
    if (isLoggedIn) {
      entries = await DiaryService.loadEntries(userEmail, isMale);
      _pageController.jumpToPage(2);
    }
  }

  void goTo(int p) => _pageController.animateToPage(
    p,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  void _handleAuth(String u, String e, String p, bool isLogin) async {
    if (e.isEmpty || p.isEmpty) return;

    if (isLogin) {
      if (await AuthService.login(e, p, isMale)) {
        _init();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials or wrong gender.")),
        );
      }
    } else {
      final message = await AuthService.register(u, e, p, isMale);
      if (message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } else {
        await AuthService.login(e, p, isMale);
        _init();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBg,
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GenderScreen(
            bgColor: customBg,
            onPick: (m) {
              setState(() => isMale = m);
              goTo(1);
            },
          ),
          AuthScreen(
            isMale: isMale,
            bgColor: customBg,
            primaryColor: customPrimary,
            onBack: () => goTo(0),
            onAuth: _handleAuth,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: customPrimary,
                onPressed: () => goTo(1),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 120,
                      color: customPrimary,
                    ),
                    onPressed: () => goTo(3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Start creating your fun!",
                    style: TextStyle(
                      color: customPrimary,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          EditorScreen(
            isMale: isMale,
            primaryColor: customPrimary,
            bgColor: customBg,
            onDiary: () => goTo(4),
            onMoods: () => goTo(6),
            onBack: () => goTo(2),
          ),
          LibraryScreen(
            entries: entries,
            primaryColor: customPrimary,
            onAdd: () => goTo(5),
            onDelete: (i) async {
              setState(() => entries.removeAt(i));
              await DiaryService.saveEntries(entries, userEmail, isMale);
            },
            onOpen: (i) {
              setState(() => selectedEntry = entries[i]);
              goTo(8);
            },
            onBack: () => goTo(3),
          ),
          WriteScreen(
            titleCtrl: diaryTitleCtrl,
            contentCtrl: diaryContentCtrl,
            primaryColor: customPrimary,
            bgColor: customBg,
            onBack: () => goTo(4),
            onMood: () => goTo(6),
            onSave: _saveEntry,
          ),
          MoodScreen(
            h: h,
            s: s,
            anx: anx,
            ang: ang,
            onUpdate: (h1, s1, ax1, ag1) => setState(() {
              h = h1;
              s = s1;
              anx = ax1;
              ang = ag1;
            }),
            onDone: () => goTo(5),
            onSummary: () => goTo(7),
          ),
          _buildWeeklySummary(),
          ReadingScreen(
            entry: selectedEntry,
            bgColor: customBg,
            onBack: () => goTo(4),
          ),
        ],
      ),
    );
  }

  void _saveEntry() async {
    final now = DateTime.now();
    final entry = DiaryEntry(
      title: diaryTitleCtrl.text.isEmpty
          ? "Entry ${now.day}"
          : diaryTitleCtrl.text,
      content: diaryContentCtrl.text,
      date: "${now.year}/${now.month}/${now.day}",
      happy: h,
      sad: s,
      anxious: anx,
      angry: ang,
      displayIndex: entries.length,
    );
    setState(() {
      entries.add(entry);
      h = 0;
      s = 0;
      anx = 0;
      ang = 0;
      diaryTitleCtrl.clear();
      diaryContentCtrl.clear();
    });
    await DiaryService.saveEntries(entries, userEmail, isMale);
    goTo(4);
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!isLoggedIn) return null;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          GestureDetector(
            onTap: _showProfile,
            child: Icon(Icons.account_circle, color: customPrimary, size: 28),
          ),
          const SizedBox(width: 8),
          Text(
            username,
            style: TextStyle(
              color: customPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          onPressed: _showTheme,
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthService.logout();
            setState(() => isLoggedIn = false);
            goTo(0);
          },
        ),
      ],
    );
  }

  void _showProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final genderKey = isMale ? "boy" : "girl";
    String joined =
        prefs.getString('user_${userEmail}_${genderKey}_joined') ??
        "Not Available";

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: customBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "User Profile",
          style: TextStyle(color: customPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileField("Username", username),
            _profileField("Email", userEmail),
            _profileField("Gender", isMale ? "Boy" : "Girl"),
            _profileField("Member Since", joined),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: customPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.brown[900],
            fontSize: 15,
            fontFamily: 'Serif',
          ),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showTheme() => showModalBottomSheet(
    context: context,
    builder: (_) => ThemeSelector(
      currentBg: customBg,
      selPrimary: selPrimary,
      selBg: selBg,
      selText: selText,
      onSelectPrimary: (c) => setState(() => selPrimary = c),
      onSelectBg: (c) => setState(() => selBg = c),
      onSelectText: (c) => setState(() => selText = c),
      onSave: () async {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          if (selPrimary != null) customPrimary = selPrimary!;
          if (selBg != null) customBg = selBg!;
          if (selText != null) customText = selText!;
        });
        await prefs.setInt('customPrimary', customPrimary.toARGB32());
        await prefs.setInt('customBg', customBg.toARGB32());
        await prefs.setInt('customText', customText.toARGB32());
        if (!mounted) return;
        Navigator.pop(context);
      },
      onReset: () => setState(() {
        customPrimary = AppConstants.defaultPrimary;
        customBg = AppConstants.defaultBg;
        Navigator.pop(context);
      }),
    ),
  );

  Widget _buildWeeklySummary() {
    return Scaffold(
      backgroundColor: customBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: customPrimary),
          onPressed: () => goTo(6),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          const Text(
            "Weekly Summary",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _bar("Happy", Colors.yellow),
          _bar("Sad", Colors.blue),
          _bar("Anxious", Colors.orange),
          _bar("Angry", Colors.red),
        ],
      ),
    );
  }

  Widget _bar(String l, Color c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l),
      LinearProgressIndicator(
        value: 0.5,
        color: c,
        backgroundColor: Colors.white,
      ),
      const SizedBox(height: 10),
    ],
  );
}
