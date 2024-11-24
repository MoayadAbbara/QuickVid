import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_vid/consts/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController linkInputController;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.red,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    linkInputController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    linkInputController.dispose();
    super.dispose();
  }

  Widget _buildActionCard({required IconData icon, required String title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: 10.0), // Add padding for height adjustment
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: const Color.fromARGB(255, 73, 14, 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          Expanded(
            // Wrap Text to handle overflow
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'BebasNeue',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Color.fromARGB(255, 73, 14, 10),
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/HomeScreen2.png',
                        fit: BoxFit.cover,
                        width: 350,
                        height: 250,
                      ),
                      const Text(
                        'QuickVid',
                        style: TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontFamily: 'Lobster'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActionCard(
                        icon: Icons.link,
                        title: 'Drop a Video Link',
                      ),
                      const SizedBox(height: 15),
                      _buildActionCard(
                        icon: Icons.flash_on,
                        title: 'Get a Speedy Summary',
                      ),
                      const SizedBox(height: 15),
                      _buildActionCard(
                        icon: Icons.chat,
                        title: 'Explore The Content Through Chat!',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextField(
                    controller: linkInputController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.link_rounded,
                        color: Color.fromARGB(255, 73, 14, 10),
                      ),
                      hintText: 'youtube.com/watch?v=example',
                      border: OutlineInputBorder(),
                      focusColor: Color.fromARGB(255, 73, 14, 10),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      String url = linkInputController.text;
                      Navigator.pushNamed(context, videoDetails, arguments: {
                        'VideoUrl': url,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 73, 14, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'AntonSC'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
