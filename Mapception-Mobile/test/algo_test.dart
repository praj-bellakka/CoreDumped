import 'package:test/test.dart';
import '../lib/services/algorithm_ver2.dart';

void main() async {
  test('test case 1: unique inputs, increasing order', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [1, null, null, null, null],
      [2, 3, null, null, null],
      [4, 5, 6, null, null],
      [7, 8, 9, 10, null]
    ];
    var expected = [0, 1, 2, 3, 4];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 2: unique inputs, decreasing order', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [10, null, null, null, null],
      [9, 8, null, null, null],
      [7, 6, 5, null, null],
      [4, 3, 2, 1, null]
    ];
    var expected = [0, 1, 4, 3, 2];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 3: unique inputs, random order', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [4, null, null, null, null],
      [9, 8, null, null, null],
      [1, 5, 3, null, null],
      [7, 6, 2, 10, null]
    ];
    var expected = [0, 1, 4, 2, 3];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 4: same inputs', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [1, null, null, null, null],
      [1, 1, null, null, null],
      [1, 1, 1, null, null],
      [1, 1, 1, 1, null, null],
    ];
    var expected = [0, 1, 2, 3, 4];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 5: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [1, null, null, null, null],
      [2, 1, null, null, null],
      [4, 5, 1, null, null],
      [7, 8, 9, 1, null, null],
    ];
    var expected = [0, 4, 3, 2, 1];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 6: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null, null, null],
      [1, null, null, null, null],
      [2, 1, null, null, null],
      [4, 5, 1, null, null],
      [7, 8, 9, 1, null, null],
    ];
    var expected = [0, 4, 3, 2, 1];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 7: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null],
      [3, null, null],
      [1, 2, null],
    ];
    var expected = [0, 1, 2];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 8: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null],
      [3, null, null],
      [1, 2, null],
    ];
    var expected = [0, 1, 2];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 9: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null, null],
      [3, null, null, null],
      [4, 2, null, null],
      [1, 6, 5, null],
    ];
    var expected = [0, 1, 2, 3];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });
}


//1 unique, increasing order
//2 unique, decreasing order
//3 unique, random order
//4 all non-unique inputs
//5 non-unique inputs, random order 1
//6 non-unique inputs, random order 2
//7 non-unique inputs, random order 3
//8 non-unique inputs, random order 4