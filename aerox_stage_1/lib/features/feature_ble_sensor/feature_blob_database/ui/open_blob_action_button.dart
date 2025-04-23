import 'dart:io';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class OpenBlobActionButton extends StatelessWidget {
  const OpenBlobActionButton({
    super.key,
    required this.blob,
  });

  final ParsedBlob blob;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.open_in_new, color: Colors.blueAccent),
        onPressed: () async {
                   
          final dir = await getApplicationDocumentsDirectory();
          final fullPath = '${dir.path}/${blob.path}';
          final file = File(fullPath);
                   
          final exists = await file.exists();
          print('¿El archivo existe?: $exists');
                   
          if (exists) {
            await OpenFilex.open(fullPath);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Archivo no encontrado. $fullPath')),
            );
          }
     
        },
      );
  }
}
