import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdditionalCommentFormInfo extends StatelessWidget {
  const AdditionalCommentFormInfo({
    super.key,
  });
  String getDate() {
    DateTime dateTime = DateTime.now();
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
            BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                return Text(
                  state.city,
                  style: TextStyle(color: Colors.grey),
                );
              },
            )
          ],
        ),
        Spacer(),
        Text(
          getDate(),
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
