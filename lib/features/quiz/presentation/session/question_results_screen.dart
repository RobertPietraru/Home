import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testador/core/components/components.dart';
import 'package:testador/core/utils/translator.dart';
import 'package:testador/features/quiz/domain/entities/question_entity.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_code_widget.dart';
import 'package:testador/features/quiz/presentation/session/admin/widgets/session_option_widget.dart';
import '../../domain/entities/session/session_entity.dart';

class QuestionResultsScreen extends StatefulWidget {
  final VoidCallback? onContinue;
  final SessionEntity session;
  final QuestionEntity currentQuestion;
  final int currentQuestionIndex;

  const QuestionResultsScreen({
    super.key,
    this.onContinue,
    required this.session,
    required this.currentQuestion,
    required this.currentQuestionIndex,
  });

  @override
  State<QuestionResultsScreen> createState() => _QuestionResultsScreenState();
}

class _QuestionResultsScreenState extends State<QuestionResultsScreen> {
  final ScrollController controller = ScrollController();
  int total = 0;

  Map<int, int> getAnsweresPerOptionIndex() {
    Map<int, int> answerCount = {};

    // pentru fiecare answer entity
    // vezi ce raspunsuri sunt selectate
    // si incrementeaza pt fiecare raspuns
    for (var answerEntity in widget.session.answers) {
      for (var selectedOption in answerEntity.optionIndexes ?? <int>[]) {
        answerCount[selectedOption] = answerCount[selectedOption] == null
            ? 1
            : answerCount[selectedOption]! + 1;
      }
    }
    return answerCount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    Map<int, int> answerCount = getAnsweresPerOptionIndex();
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
                  padding: theme.standardPadding.copyWith(top: 0, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(widget.currentQuestionIndex + 1).toString()}. ${widget.currentQuestion.text ?? context.translator.someoneForgotTo}",
                        style: theme.subtitleTextStyle,
                      ),
                      _ResultsChart(
                        options: widget.currentQuestion.options,
                        answerCount: answerCount,
                      ),
                    ],
                  ))
            ]))
          ];
        },
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: widget.currentQuestion.options.length,
            itemBuilder: (context, index) => SessionOptionWidget(
                  index: index,
                  option: widget.currentQuestion.options[index],
                  isSelected: false,
                  onPressed: null,
                )),
      ),
    );
  }
}

class _ResultsChart extends StatelessWidget {
  final Map<int, int> answerCount;

  final List<MultipleChoiceOptionEntity> options;
  const _ResultsChart({required this.answerCount, required this.options});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(theme),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(AppThemeData theme) {
    if (answerCount.isEmpty) {
      return List.generate(options.length, (i) {
        final isCorrect = options[i].isCorrect;
        final fontSize = isCorrect ? 25.0 : 16.0;
        final radius = isCorrect ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        return PieChartSectionData(
          color: theme.getColor(i),
          badgeWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('0', style: theme.subtitleTextStyle),
              if (isCorrect) const SizedBox(width: 3),
              if (isCorrect) const Icon(Icons.done),
            ],
          ),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: shadows,
          ),
        );
      });
    }
    return List.generate(options.length, (i) {
      final isCorrect = options[i].isCorrect;
      final fontSize = isCorrect ? 25.0 : 16.0;
      final radius = isCorrect ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      int count = answerCount[i] ?? 0;
      return PieChartSectionData(
        color: theme.getColor(i),
        badgeWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count.toString(), style: theme.subtitleTextStyle),
            if (isCorrect) const SizedBox(width: 3),
            if (isCorrect) const Icon(Icons.done),
          ],
        ),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}
