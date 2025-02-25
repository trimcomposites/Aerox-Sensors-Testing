import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalCommentFormInfo extends StatelessWidget {
  const AdditionalCommentFormInfo({
    super.key,
  });

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
          '02.01.24',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
