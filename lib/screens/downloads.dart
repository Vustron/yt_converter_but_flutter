// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:flutter/material.dart';

// widgets
import 'package:yt_converter/widgets/downloads/components/download_list.dart';
import 'package:yt_converter/widgets/downloads/components/appbar.dart';

// methods
import 'package:yt_converter/widgets/downloads/methods/get_records.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  // init downloads list
  late Future<List<String>> _downloads;

  @override
  void initState() {
    super.initState();
    _downloads = getDownloadRecords();
  }

  Future<void> updateDownloads() async {
    setState(() {
      _downloads = getDownloadRecords();
    });

    // Scan the downloads to make them visible in file manager
    final downloads = await _downloads;
    for (var filePath in downloads) {
      await MediaScanner.loadMedia(path: filePath);
    }
  }

  Future<void> refreshDownloads() async {
    await updateDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: FutureBuilder<List<String>>(
        future: _downloads,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            case ConnectionState.active:
            case ConnectionState.none:
              return const Center(
                child:
                    Text("Loading...", style: TextStyle(color: Colors.black)),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No downloads yet.",
                      style: TextStyle(color: Colors.black)),
                );
              } else {
                return downloadList(
                  snapshot: snapshot,
                  getDownloads: getDownloadRecords,
                  updateDownloads: updateDownloads,
                  refreshDownloads: refreshDownloads,
                );
              }
          }
        },
      ),
    );
  }
}
