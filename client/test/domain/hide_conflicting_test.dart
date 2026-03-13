// Tests for the "Hide Conflicting Classes" filter (isHideConflicting).
//
// Test cases are discovered programmatically from the loaded sample data
// rather than relying on specific class numbers, so the tests remain valid
// if the sample data changes.

import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/persister.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// — helpers ——————————————————————————————————————————————————————————————————

/// True when [c] has at least one real (non-ARR, non-async) meeting time.
bool _hasRealSchedule(Class c) =>
    c.schedule.isNotEmpty && !c.schedule.isARR && !c.schedule.isAsync;

/// Returns the first class in the same term as [target] whose schedule
/// overlaps [target]'s, but is not [target] itself.
Class? _overlapPeer(Class target) {
  for (final other in Class.instances) {
    if (other == target) {
      continue;
    }
    if (other.term != target.term) {
      continue;
    }
    if (!_hasRealSchedule(other)) {
      continue;
    }
    if (target.schedule.overlaps(other.schedule)) {
      return other;
    }
  }
  return null;
}

/// Returns the first class in [target]'s term whose schedule does NOT overlap
/// [target]'s (and is not [target] itself).
Class? _nonOverlapPeer(Class target) {
  for (final other in Class.instances) {
    if (other == target) {
      continue;
    }
    if (other.term != target.term) {
      continue;
    }
    if (!_hasRealSchedule(other)) {
      continue;
    }
    if (!target.schedule.overlaps(other.schedule)) {
      return other;
    }
  }
  return null;
}

/// Returns the first class in a DIFFERENT term whose schedule overlaps
/// [target]'s.
Class? _differentTermOverlapPeer(Class target) {
  for (final other in Class.instances) {
    if (other.term == target.term) {
      continue;
    }
    if (!_hasRealSchedule(other)) {
      continue;
    }
    if (target.schedule.overlaps(other.schedule)) {
      return other;
    }
  }
  return null;
}

/// Returns the first class that has a real schedule AND has at least one
/// overlap peer in the same term (i.e. the "anchor" for conflict tests).
Class _findAnchor() {
  for (final cls in Class.instances) {
    if (!_hasRealSchedule(cls)) {
      continue;
    }
    if (_overlapPeer(cls) != null) {
      return cls;
    }
  }
  throw StateError('No overlapping class pair found in sample data');
}

// — tests ————————————————————————————————————————————————————————————————————

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final filters = Filters();

  setUp(() async {
    Term.defaultTermIndex = 1;
    AbstractPersister.instance = MockPersister();
    await DataHandler.fetchData(test: true);
    await filters.reset();
    for (final c in Class.instances) {
      c.saved = false;
    }
  });

  tearDown(() {
    for (final c in Class.instances) {
      c.saved = false;
    }
  });

  // ---------------------------------------------------------------------------
  // Unit tests: Class.includesNoConflict
  // ---------------------------------------------------------------------------
  group('includesNoConflict', () {
    test('returns true when filter is disabled', () {
      final cls = Class.instances.first;
      expect(cls.includesNoConflict(false), isTrue);
    });

    test('saved class always passes when filter is enabled', () {
      final cls = Class.instances.first;
      cls.saved = true;
      expect(cls.includesNoConflict(true), isTrue);
    });

    test('returns true when no other classes are saved for the same term', () {
      // setUp guarantees no saved flags are set
      final cls = Class.instances.first;
      expect(cls.includesNoConflict(true), isTrue);
    });

    test(
      'returns false when a saved peer has an overlapping schedule in the same term',
      () {
        final anchor = _findAnchor();
        final peer = _overlapPeer(anchor)!;

        expect(
          anchor.schedule.overlaps(peer.schedule),
          isTrue,
          reason: 'anchor and peer schedules must overlap',
        );
        expect(
          anchor.term,
          equals(peer.term),
          reason: 'anchor and peer must share a term',
        );

        anchor.saved = true;
        expect(peer.includesNoConflict(true), isFalse);
      },
    );

    test('returns true when the saved peer does not overlap in time', () {
      final anchor = _findAnchor();
      final noConflict = _nonOverlapPeer(anchor);
      if (noConflict == null) {
        return; // skip if sample has no non-overlapping peer
      }

      expect(
        anchor.schedule.overlaps(noConflict.schedule),
        isFalse,
        reason: 'anchor and noConflict schedules must not overlap',
      );
      expect(anchor.term, equals(noConflict.term), reason: 'must share a term');

      anchor.saved = true;
      expect(noConflict.includesNoConflict(true), isTrue);
    });

    test('returns true when the only saved class is in a different term', () {
      final anchor = _findAnchor();
      final diffTerm = _differentTermOverlapPeer(anchor);
      if (diffTerm == null) {
        return; // skip if sample has only one term
      }

      expect(
        anchor.schedule.overlaps(diffTerm.schedule),
        isTrue,
        reason: 'schedules must overlap to be a meaningful cross-term test',
      );
      expect(
        anchor.term,
        isNot(equals(diffTerm.term)),
        reason: 'must be different terms',
      );

      anchor.saved = true;
      // diffTerm is in a different term — must not be excluded
      expect(diffTerm.includesNoConflict(true), isTrue);
    });

    test('cross-term save does not affect the other direction', () {
      final anchor = _findAnchor();
      final diffTerm = _differentTermOverlapPeer(anchor);
      if (diffTerm == null) {
        return;
      }

      diffTerm.saved = true;
      expect(anchor.includesNoConflict(true), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration tests: Query + Filters.isHideConflicting
  // ---------------------------------------------------------------------------
  group('Query integration: isHideConflicting filter', () {
    test('result count is unchanged when no classes are saved', () async {
      final countBefore = Query().results().length;
      await filters.setIsHideConflicting(true);
      expect(filters.classes.length, equals(countBefore));
    });

    test(
      'saved class always appears in results when filter is enabled',
      () async {
        final anchor = _findAnchor();
        anchor.saved = true;
        await filters.setTerm(anchor.term);
        await filters.setIsHideConflicting(true);
        expect(filters.classes.contains(anchor), isTrue);
      },
    );

    test('unsaved class with conflicting schedule is excluded', () async {
      final anchor = _findAnchor();
      final peer = _overlapPeer(anchor)!;
      anchor.saved = true;
      await filters.setTerm(anchor.term);
      await filters.setIsHideConflicting(true);
      expect(filters.classes.contains(anchor), isTrue);
      expect(filters.classes.contains(peer), isFalse);
    });

    test(
      'unsaved class with non-conflicting schedule remains in results',
      () async {
        final anchor = _findAnchor();
        final noConflict = _nonOverlapPeer(anchor);
        if (noConflict == null) {
          return;
        }

        anchor.saved = true;
        await filters.setTerm(anchor.term);
        await filters.setIsHideConflicting(true);
        expect(filters.classes.contains(noConflict), isTrue);
      },
    );

    test(
      'result count decreases when a saved class has conflicting peers',
      () async {
        final anchor = _findAnchor();
        await filters.setTerm(anchor.term);
        final countBefore = filters.classes.length;
        anchor.saved = true;
        await filters.setIsHideConflicting(true);
        expect(filters.classes.length, lessThan(countBefore));
      },
    );

    test(
      'no unsaved result in the same term conflicts with any saved class',
      () async {
        final anchor = _findAnchor();
        anchor.saved = true;
        await filters.setTerm(anchor.term);
        await filters.setIsHideConflicting(true);

        for (final cls in filters.classes) {
          if (!cls.saved && cls.term == anchor.term) {
            expect(
              cls.schedule.overlaps(anchor.schedule),
              isFalse,
              reason:
                  'Class ${cls.classNumber} conflicts with the saved class but appeared in results',
            );
          }
        }
      },
    );

    test(
      'disabling the filter restores previously hidden conflicting class',
      () async {
        final anchor = _findAnchor();
        final peer = _overlapPeer(anchor)!;
        anchor.saved = true;
        await filters.setTerm(anchor.term);

        await filters.setIsHideConflicting(true);
        expect(filters.classes.contains(peer), isFalse);

        await filters.setIsHideConflicting(false);
        expect(filters.classes.contains(peer), isTrue);
      },
    );

    test('isHideConflicting resets to false via filters.reset()', () async {
      await filters.setIsHideConflicting(true);
      expect(filters.isHideConflicting, isTrue);
      await filters.reset();
      expect(filters.isHideConflicting, isFalse);
    });

    test('isHideConflicting increments activeFilterCount', () async {
      final countBefore = filters.activeFilterCount;
      await filters.setIsHideConflicting(true);
      expect(filters.activeFilterCount, equals(countBefore + 1));
    });
  });
}
