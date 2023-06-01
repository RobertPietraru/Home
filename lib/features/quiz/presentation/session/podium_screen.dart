import 'package:flutter/material.dart';
import 'package:testador/core/components/components.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/quiz_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/player_entity.dart';
import 'package:testador/features/quiz/domain/entities/session/session_entity.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_code_widget.dart';

class PodiumScreen extends StatefulWidget {
  final SessionEntity session;
  final QuizEntity quiz;
  const PodiumScreen({
    super.key,
    required this.session,
    required this.quiz,
  });

  @override
  State<PodiumScreen> createState() => _PodiumScreenState();
}

class _PodiumScreenState extends State<PodiumScreen> {
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
        title: SessionCodeWidget(
          sessionId: widget.session.id,
        ),
        trailing: const [],
      ),
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: theme.standardPadding.copyWith(top: 0),
                child: Column(
                  children: [
                    Text(context.translator.podium, style: theme.subtitleTextStyle),
                    Text(context.translator.congrats,
                        style: theme.informationTextStyle),
                  ],
                ),
              )
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
                        leading: Text(
                            '${sortedPlayers[index].correctAnswers}/${widget.quiz.questions.length}'),
                        trailing:
                            Text(sortedPlayers[index].score.toInt().toString()),
                        tileColor: index < 3
                            ? Colors.amber
                            : theme.secondaryColor.withOpacity(0.5),
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
