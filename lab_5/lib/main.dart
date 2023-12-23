import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab_3/service/location_service.dart';
import 'package:lab_3/service/notification_service.dart';
import 'package:lab_3/widgets/CalendarWidget.dart';
import 'package:lab_3/widgets/NewMidterm.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/Midterm.dart';
import 'controller/notification_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AwesomeNotifications().initialize(
    null, [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "basic_notif",
        channelDescription: "basic notification channel",
      )
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "basic_group")
    ]
  );
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainListScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
    );
  }
}


class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  _MainListScreenState createState() => _MainListScreenState();
}

class _MainListScreenState extends State<MainListScreen> {
  final List<Midterm> midterms = [
    Midterm(subject: 'MIS', date: DateTime(2023, 12, 30)),
    Midterm(subject: 'VNP', date: DateTime(2023, 12, 31)),
    Midterm(subject: 'DB', date: DateTime(2023, 12, 24)),
    Midterm(subject: "MIS", date: DateTime(2023, 12, 25))
  ];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceiveMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceiveMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreateMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayed
    );
    NotificationService().scheduleNotificationsForExistingMidterms(midterms);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midterm List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _openCalendar,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => FirebaseAuth.instance.currentUser != null
                ? _addMidtermFunction(context)
                : _navigateToSignInPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _signOut,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: midterms.length,
        itemBuilder: (context, index) {
          final subject = midterms[index].subject;
          final date = midterms[index].date;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    date.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarWidget(midterms: midterms),
      ),
    );
  }

  Future<void> _addMidtermFunction(BuildContext context) async {
    TextEditingController subjectController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewMidterm(addMidterm: _addMidterm,),
            behavior: HitTestBehavior.opaque,
          );
        }
    );
  }

  void _addMidterm(Midterm midterm) {
    setState(() {
      midterms.add(midterm);
      NotificationService().scheduleNotification(midterm);
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> _authAction() async {
    try {
      if (widget.isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog("Login Successful", "You have successfully logged in!");
        _navigateToHome();
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        _showSuccessDialog("Registration Successful", "You have successfully registered!");
        _navigateToLogin();
      }
    } catch (e) {
      _showErrorDialog("Authentication Error", "Error during authentication: $e");
    }
  }

  void _showSuccessDialog(String title, String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _navigateToLogin() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _navigateToRegister() {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isLogin ? const Text("Login") : const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authAction,
              child: Text(widget.isLogin ? "Sign In" : "Register"),
            ),
            if (!widget.isLogin)
              ElevatedButton(
                onPressed: _navigateToLogin,
                child: const Text('Already have an account? Login'),
              ),
            if (widget.isLogin)
              ElevatedButton(
                onPressed: _navigateToRegister,
                child: const Text('Create an account'),
              ),
            TextButton(
              onPressed: _navigateToHome,
              child: const Text('Back to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
