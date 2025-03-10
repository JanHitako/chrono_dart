import 'dart:math' show min;

import '../../results.dart' show ParsingResult;
import '../../types.dart' show Component;
import '../abstract_refiners.dart' show MergingRefiner;

abstract class AbstractMergeDateRangeRefiner extends MergingRefiner {
  @override
  // ignore: avoid_renaming_method_parameters
  ParsingResult mergeResults(textBetween, fromResult, toResult, context) {
    if (!fromResult.start.isOnlyWeekdayComponent() &&
        !toResult.start.isOnlyWeekdayComponent()) {
      toResult.start.getCertainComponents().forEach((key) {
        if (!fromResult.start.isCertain(key)) {
          fromResult.start.imply(key, toResult.start.get(key)!);
        }
      });

      fromResult.start.getCertainComponents().forEach((key) {
        if (!toResult.start.isCertain(key)) {
          toResult.start.imply(key, fromResult.start.get(key)!);
        }
      });
    }

    if (fromResult.start.date().millisecondsSinceEpoch >
        toResult.start.date().millisecondsSinceEpoch) {
      var fromMoment = fromResult.start.dayjs();
      var toMoment = toResult.start.dayjs();
      if (toResult.start.isOnlyWeekdayComponent() &&
          toMoment.add(7, "d")!.isAfter(fromMoment)) {
        toMoment = toMoment.add(7, "d")!;
        toResult.start.imply(Component.day, toMoment.date());
        toResult.start.imply(Component.month, toMoment.month());
        toResult.start.imply(Component.year, toMoment.year());
      } else if (fromResult.start.isOnlyWeekdayComponent() &&
          fromMoment.add(-7, "d")!.isBefore(toMoment)) {
        fromMoment = fromMoment.add(-7, "d")!;
        fromResult.start.imply(Component.day, fromMoment.date());
        fromResult.start.imply(Component.month, fromMoment.month());
        fromResult.start.imply(Component.year, fromMoment.year());
      } else if (toResult.start.isDateWithUnknownYear() &&
          toMoment.add(1, "y")!.isAfter(fromMoment)) {
        toMoment = toMoment.add(1, "y")!;
        toResult.start.imply(Component.year, toMoment.year());
      } else if (fromResult.start.isDateWithUnknownYear() &&
          fromMoment.add(-1, "y")!.isBefore(toMoment)) {
        fromMoment = fromMoment.add(-1, "y")!;
        fromResult.start.imply(Component.year, fromMoment.year());
      } else {
        [toResult, fromResult] = [fromResult, toResult];
      }
    }

    final result = fromResult.clone();
    result.start = fromResult.start;
    result.end = toResult.start;
    result.index = min(fromResult.index, toResult.index);
    if (fromResult.index < toResult.index) {
      result.text = fromResult.text + textBetween + toResult.text;
    } else {
      result.text = toResult.text + textBetween + fromResult.text;
    }

    return result;
  }

  RegExp patternBetween();

  @override
  bool shouldMergeResults(textBetween, currentResult, nextResult, context) {
    return currentResult.end == null &&
        nextResult.end == null &&
        patternBetween().hasMatch(textBetween);
  }
}
