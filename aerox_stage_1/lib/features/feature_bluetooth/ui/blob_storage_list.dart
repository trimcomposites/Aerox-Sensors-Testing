import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobStorageList extends StatelessWidget {
  const BlobStorageList({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final selectedEntityPageBloc =
        BlocProvider.of<SelectedEntityPageBloc>(context);
    return BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
      builder: (context, state) {
        return Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: state.blobs.length,
            itemBuilder: (BuildContext context, int index) {
              final blob = state.blobs[index];
              // final parsed = blob.parseHs1kHzBlob();
              return Row(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          child: Text(
                        "blob ${blob.createdAt}",
                        maxLines: 10,
                      ))),
                  IconButton(
                      onPressed: () {
                        selectedEntityPageBloc.add(OnParseBlob(blob: blob));
                      },
                      icon: Icon(Icons.arrow_circle_up))
                ],
              );
            },
          ),
        );
      },
    );
  }
}
