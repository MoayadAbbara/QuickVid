import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quick_vid/businessLayer/Video/video_service.dart';

class SummarizedTranskript extends StatefulWidget {
  final String videoId;
  const SummarizedTranskript({super.key, required this.videoId});

  @override
  State<SummarizedTranskript> createState() => _SummarizedTranskriptState();
}

class _SummarizedTranskriptState extends State<SummarizedTranskript> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoService videoService = VideoService();

  // State variables to hold the summarized text
  String? geminiSummary;
  String? gptSummary;
  Map<String, dynamic>? scores;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch summaries and store them in state variables
    fetchSummaries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to fetch summaries
  void fetchSummaries() async {
    try {
      String gemini = await videoService.summarizeVideoText(widget.videoId);
      String gpt = await videoService.summarizeWithGpt(widget.videoId);
      scores = await videoService.evaluateSummariesWithGpt(videoId: widget.videoId, summaryGemini: gemini, summaryGpt: gpt);

      setState(() {
        geminiSummary = gemini;
        gptSummary = gpt;
      });
    } catch (e) {
      print(e);
      setState(() {
        geminiSummary = 'Error fetching Gemini summary';
        gptSummary = 'Error fetching GPT summary';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 73, 14, 10),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Gemini',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'ChatGPT',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Scores',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Gemini Tab
          buildSummaryTab(geminiSummary, 'Gemini'),
          // ChatGPT Tab
          buildSummaryTab(gptSummary, 'ChatGPT'),
          // Center(
          //   child: scores == null ? Text('Loading') : Text(scores!['Total'].toString()),
          // )
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: scores == null
                ? const Text('Loading')
                : ListView(
                    children: scores!.entries.map((entry) {
                      String key = entry.key;
                      List<dynamic> values = entry.value;

                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label for each metric
                            Text(
                              key,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: values.asMap().entries.map((entry) {
                                int index = entry.key;
                                int value = entry.value;

                                Color progressColor = index == 0 ? Color.fromRGBO(37, 150, 190, 1) : Color.fromRGBO(15, 163, 127, 1);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: buildCircleWithImageAndPercentage(value, progressColor, index),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          )
        ],
      ),
    );
  }

  // Widget to display a summary tab
  Widget buildSummaryTab(String? summary, String title) {
    if (summary == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 73, 14, 10),
        ),
      );
    } else if (summary.startsWith('Error')) {
      return Center(
        child: Text(
          summary,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '$title Summary',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 73, 14, 10),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: SelectableText(
                    summary,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildCircleWithImageAndPercentage(int value, Color progressColor, int index) {
    // Choose the correct logo based on the index
    String imagePath = index == 0 ? 'assets/images/Gemini.png' : 'assets/images/Gpt.png';
    double imageWidth = index == 0 ? 40.0 : 35.0;
    String centerText = "$value%";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 10.0,
          percent: value / 100,
          animation: true,
          animationDuration: 1500,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: imageWidth,
              ),
              Text(
                centerText,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          progressColor: progressColor,
          backgroundColor: Colors.grey[300]!,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8.0), // space between circles
      ],
    );
  }
}
