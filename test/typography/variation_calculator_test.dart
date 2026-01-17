import 'package:test/test.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/variation_calculator.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/item_variation_store.dart';
import 'package:dart_graphics/src/typography/openfont/tables/variations/tuple_variation.dart';

void main() {
  group('VariationCoordinates', () {
    test('stores and retrieves coordinates', () {
      final coords = VariationCoordinates();
      coords.set('wght', 0.5);
      coords.set('wdth', -0.3);

      expect(coords.get('wght'), equals(0.5));
      expect(coords.get('wdth'), equals(-0.3));
    });

    test('returns 0.0 for unset tags', () {
      final coords = VariationCoordinates();
      expect(coords.get('wght'), equals(0.0));
    });

    test('clamps values to -1.0 to 1.0', () {
      final coords = VariationCoordinates();
      coords.set('wght', 2.0);
      coords.set('wdth', -3.0);

      expect(coords.get('wght'), equals(1.0));
      expect(coords.get('wdth'), equals(-1.0));
    });

    test('hasVariations is true when any value is non-zero', () {
      final coords1 = VariationCoordinates();
      expect(coords1.hasVariations, isFalse);

      final coords2 = VariationCoordinates();
      coords2.set('wght', 0.5);
      expect(coords2.hasVariations, isTrue);
    });

    test('toOrderedList returns values in correct order', () {
      final coords = VariationCoordinates();
      coords.set('wdth', 0.3);
      coords.set('wght', 0.7);
      coords.set('slnt', -0.2);

      final list = coords.toOrderedList(['wght', 'wdth', 'slnt', 'opsz']);
      expect(list, equals([0.7, 0.3, -0.2, 0.0]));
    });

    test('creates from map', () {
      final coords = VariationCoordinates.from({
        'wght': 0.5,
        'wdth': -0.25,
      });

      expect(coords.get('wght'), equals(0.5));
      expect(coords.get('wdth'), equals(-0.25));
    });
  });

  group('VariationCalculator.calculateAxisScalar', () {
    test('returns 1.0 at peak', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        0.5, // coord at peak
        0.0, // start
        0.5, // peak
        1.0, // end
      );
      expect(scalar, equals(1.0));
    });

    test('returns 0.0 at start boundary', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        0.0, // coord at start
        0.0, // start
        0.5, // peak
        1.0, // end
      );
      expect(scalar, equals(0.0));
    });

    test('returns 0.0 at end boundary', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        1.0, // coord at end
        0.0, // start
        0.5, // peak
        1.0, // end
      );
      expect(scalar, equals(0.0));
    });

    test('returns 0.0 outside region', () {
      final scalar1 = VariationCalculator.calculateAxisScalar(
        -0.5, // coord before start
        0.0,
        0.5,
        1.0,
      );
      expect(scalar1, equals(0.0));

      final scalar2 = VariationCalculator.calculateAxisScalar(
        1.5, // coord after end
        0.0,
        0.5,
        1.0,
      );
      expect(scalar2, equals(0.0));
    });

    test('returns correct interpolation between start and peak', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        0.25, // coord halfway between start and peak
        0.0, // start
        0.5, // peak
        1.0, // end
      );
      expect(scalar, closeTo(0.5, 0.001));
    });

    test('returns correct interpolation between peak and end', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        0.75, // coord halfway between peak and end
        0.0, // start
        0.5, // peak
        1.0, // end
      );
      expect(scalar, closeTo(0.5, 0.001));
    });

    test('returns 1.0 when peak is 0', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        0.5,
        -1.0,
        0.0, // peak is 0
        1.0,
      );
      expect(scalar, equals(1.0));
    });

    test('handles negative peak correctly', () {
      final scalar = VariationCalculator.calculateAxisScalar(
        -0.5, // coord at peak
        -1.0, // start
        -0.5, // peak
        0.0, // end
      );
      expect(scalar, equals(1.0));
    });
  });

  group('VariationCalculator.calculateRegionScalar', () {
    test('returns product of axis scalars', () {
      final region = VariationRegion();
      region.regionAxes = [
        VariationAxis()
          ..startCoord = 0.0
          ..peakCoord = 1.0
          ..endCoord = 1.0,
        VariationAxis()
          ..startCoord = 0.0
          ..peakCoord = 1.0
          ..endCoord = 1.0,
      ];

      // Both axes at peak -> 1.0 * 1.0 = 1.0
      expect(
        VariationCalculator.calculateRegionScalar([1.0, 1.0], region),
        equals(1.0),
      );

      // Both axes at 0.5 interpolation -> 0.5 * 0.5 = 0.25
      expect(
        VariationCalculator.calculateRegionScalar([0.5, 0.5], region),
        closeTo(0.25, 0.001),
      );
    });

    test('returns 0.0 if any axis is outside region', () {
      final region = VariationRegion();
      region.regionAxes = [
        VariationAxis()
          ..startCoord = 0.0
          ..peakCoord = 1.0
          ..endCoord = 1.0,
        VariationAxis()
          ..startCoord = 0.0
          ..peakCoord = 1.0
          ..endCoord = 1.0,
      ];

      // First axis at peak, second axis outside
      expect(
        VariationCalculator.calculateRegionScalar([1.0, -1.0], region),
        equals(0.0),
      );
    });
  });

  group('VariationCalculator.calculateTupleScalar', () {
    test('calculates scalar from embedded peak tuple', () {
      final header = TupleVariationHeader();
      header.tupleIndex = TupleIndexFormat.EMBEDDED_PEAK_TUPLE;
      header.peakTuple = TupleRecord(2)..coords = [1.0, 0.5];

      // At peak coords -> scalar = 1.0
      final scalar1 = VariationCalculator.calculateTupleScalar(
        header,
        [1.0, 0.5],
        null,
      );
      expect(scalar1, equals(1.0));

      // Halfway to peak on first axis -> scalar = 0.5 * 1.0 = 0.5
      final scalar2 = VariationCalculator.calculateTupleScalar(
        header,
        [0.5, 0.5],
        null,
      );
      expect(scalar2, closeTo(0.5, 0.001));
    });

    test('uses shared tuple when no embedded peak', () {
      final sharedTuples = [
        TupleRecord(1)..coords = [0.5],
        TupleRecord(1)..coords = [1.0],
      ];

      final header = TupleVariationHeader();
      header.tupleIndex = 1; // Index to shared tuple 1

      final scalar = VariationCalculator.calculateTupleScalar(
        header,
        [1.0], // At peak
        sharedTuples,
      );
      expect(scalar, equals(1.0));
    });

    test('uses intermediate region when present', () {
      final header = TupleVariationHeader();
      header.tupleIndex = TupleIndexFormat.EMBEDDED_PEAK_TUPLE | TupleIndexFormat.INTERMEDIATE_REGION;
      header.peakTuple = TupleRecord(1)..coords = [0.75];
      header.intermediateStartTuple = TupleRecord(1)..coords = [0.5];
      header.intermediateEndTuple = TupleRecord(1)..coords = [1.0];

      // At peak
      final scalar1 = VariationCalculator.calculateTupleScalar(
        header,
        [0.75],
        null,
      );
      expect(scalar1, equals(1.0));

      // At start
      final scalar2 = VariationCalculator.calculateTupleScalar(
        header,
        [0.5],
        null,
      );
      expect(scalar2, equals(0.0));

      // Outside region (before start)
      final scalar3 = VariationCalculator.calculateTupleScalar(
        header,
        [0.25],
        null,
      );
      expect(scalar3, equals(0.0));
    });
  });

  group('AxisNormalizer', () {
    test('normalize returns 0.0 at default value', () {
      final normalized = AxisNormalizer.normalize(
        400, // value
        100, // min
        400, // default
        900, // max
      );
      expect(normalized, equals(0.0));
    });

    test('normalize returns 1.0 at max value', () {
      final normalized = AxisNormalizer.normalize(
        900, // value at max
        100, // min
        400, // default
        900, // max
      );
      expect(normalized, equals(1.0));
    });

    test('normalize returns -1.0 at min value', () {
      final normalized = AxisNormalizer.normalize(
        100, // value at min
        100, // min
        400, // default
        900, // max
      );
      expect(normalized, equals(-1.0));
    });

    test('normalize handles values outside range', () {
      final normalized1 = AxisNormalizer.normalize(
        1000, // value above max
        100,
        400,
        900,
      );
      expect(normalized1, equals(1.0));

      final normalized2 = AxisNormalizer.normalize(
        0, // value below min
        100,
        400,
        900,
      );
      expect(normalized2, equals(-1.0));
    });

    test('normalize returns correct intermediate values', () {
      // Halfway between default and max
      final normalized1 = AxisNormalizer.normalize(
        650, // (400 + 900) / 2
        100,
        400,
        900,
      );
      expect(normalized1, closeTo(0.5, 0.001));

      // Halfway between min and default
      final normalized2 = AxisNormalizer.normalize(
        250, // (100 + 400) / 2
        100,
        400,
        900,
      );
      expect(normalized2, closeTo(-0.5, 0.001));
    });

    test('denormalize returns default at 0.0', () {
      final value = AxisNormalizer.denormalize(
        0.0,
        100,
        400,
        900,
      );
      expect(value, equals(400));
    });

    test('denormalize returns max at 1.0', () {
      final value = AxisNormalizer.denormalize(
        1.0,
        100,
        400,
        900,
      );
      expect(value, equals(900));
    });

    test('denormalize returns min at -1.0', () {
      final value = AxisNormalizer.denormalize(
        -1.0,
        100,
        400,
        900,
      );
      expect(value, equals(100));
    });

    test('round-trip normalize/denormalize', () {
      const minVal = 100.0;
      const defaultVal = 400.0;
      const maxVal = 900.0;

      for (final testValue in [100.0, 250.0, 400.0, 650.0, 900.0]) {
        final normalized = AxisNormalizer.normalize(
          testValue,
          minVal,
          defaultVal,
          maxVal,
        );
        final denormalized = AxisNormalizer.denormalize(
          normalized,
          minVal,
          defaultVal,
          maxVal,
        );
        expect(denormalized, closeTo(testValue, 0.001));
      }
    });
  });
}
