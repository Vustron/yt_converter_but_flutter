// utils
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_filex/open_filex.dart';

Future<void> openFile(String filePath) async {
  try {
    await OpenFilex.open(filePath);
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Could not open the file: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }
}
