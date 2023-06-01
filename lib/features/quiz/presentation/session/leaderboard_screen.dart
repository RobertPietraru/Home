import 'package:flutter/material.dart';
import 'package:testador/core/components/components.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/session/player_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_code_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final SessionEntity session;
  const LeaderboardScreen({super.key, this.onContinue, required this.session});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ScrollController controller = ScrollController();
  int total = 0;
  late final List<PlayerEntity> sortedPlayers;

  @override
  void initState() {
    sortedPlayers = widget.session.students.toList();
    sortedPlayers.sort((a, b) => b.score.compareTo(a.score));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
          title: SessionCodeWidget(sessionId: widget.session.id),
          trailing: [
            if (widget.onContinue != null)
              AppBarButton(
                  text: context.translator.continueText,
                  onPressed: widget.onContinue!)
          ]),
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                  padding: theme.standardPadding.copyWith(top: 0),
                  child: Center(
                    child: Text(
                      context.translator.leaderboard,
                      style: theme.subtitleTextStyle,
                    ),
                  ))
            ]))
          ];
        },
        body: widget.session.students.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: theme.spacing.small),
                itemCount: sortedPlayers.length,
                itemBuilder: (context, index) => Padding(
                      padding:
                          theme.standardPadding.copyWith(top: 0, bottom: 0),
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        trailing:
                            Text(sortedPlayers[index].score.toInt().toString()),
                        tileColor: theme.secondaryColor.withOpacity(0.5),
                        title: Text(sortedPlayers[index].name),
                      ),
                    ))
            : Expanded(
                child: Center(
                    child: Text(
                context.translator.theresNobodyElse,
                style: theme.titleTextStyle,
              ))),
      ),
    );
  }
}
