// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

// methods
import 'package:yt_converter/widgets/downloads/methods/delete_download.dart';
import 'package:yt_converter/widgets/downloads/methods/get_records.dart';
import 'package:yt_converter/widgets/downloads/methods/open_file.dart';
import 'package:yt_converter/widgets/downloads/methods/icons.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Downloads")),
      body: FutureBuilder<List<String>>(
        future: _downloads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No downloads yet."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final filePath = snapshot.data![index];
                return Dismissible(
                  key: Key(filePath),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deleteDownload(filePath, updateDownloads);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: getFileIcon(filePath),
                    title: Text(path.basename(filePath)),
                    onTap: () => openFile(filePath),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
