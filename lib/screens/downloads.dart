// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

// services
import 'package:yt_converter/services/download.dart';
import 'package:yt_converter/widgets/downloads/components/appbar.dart';

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
  }

  Future<void> _refreshDownloads() async {
    await updateDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: FutureBuilder<List<String>>(
        future: _downloads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No downloads yet.",
                    style: TextStyle(color: Colors.black)));
          } else {
            return RefreshIndicator(
              color: Colors.black,
              onRefresh: _refreshDownloads,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // get file data
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
                    child: Consumer(
                      builder: (context, ref, child) {
                        final progress =
                            ref.watch(downloadProgressProvider(filePath));
                        return ListTile(
                          leading: getFileIcon(filePath),
                          title: Text(
                            path.basename(filePath),
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: progress != null
                              ? LinearProgressIndicator(value: progress)
                              : const Text(
                                  'Completed',
                                  style: TextStyle(fontSize: 12),
                                ),
                          onTap: () => openFile(filePath),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
