import 'package:test/test.dart';
import '../lib/services/algorithm_ver2.dart';

void main() async {
  test('test case 1: unique inputs, increasing order', () async {
    List<List<double>> input = [
      [null, 10, 9, 8, 7],
      [null, null, 6, 5, 4],
      [null, null, null, 3, 2],
      [null, null, null, null, 1],
      [null, null, null, null, null]
    ];
    var expected = [0, 1, 4, 3, 2, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 2: unique inputs, decreasing order', () async {
    List<List<double>> input = [
      [null, 1, 2, 3, 4],
      [null, null, 5, 6, 7],
      [null, null, null, 8, 9],
      [null, null, null, null, 10],
      [null, null, null, null, null]
    ];
    var expected = [0, 1, 2, 3, 4, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 3: unique inputs, random order', () async {
    List<List<double>> input = [
      [null, 1, 2, 8, 4],
      [null, null, 7, 1, 9],
      [null, null, null, 3, 5],
      [null, null, null, null, 10],
      [null, null, null, null, null]
    ];
    var expected = [0, 1, 4, 3, 2, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 4: same inputs', () async {
    List<List<double>> input = [
      [null, 1, 1, 1, 1],
      [null, null, 1, 1, 1],
      [null, null, null, 1, 1],
      [null, null, null, null, 1],
      [null, null, null, null, null],
    ];
    var expected = [0, 1, 2, 3, 4, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 5: non unique inputs', () async {
    List<List<double>> input = [
      [null, 1, 1, 3, 1],
      [null, null, 1, 5, 1],
      [null, null, null, 1, 6],
      [null, null, null, null, 9],
      [null, null, null, null, null]
    ];
    var expected = [0, 1, 3, 2, 4, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 6: non unique inputs', () async {
    List<List<double>> input = [
      [null, 1, 5, 5, 1],
      [null, null, 1, 9, 9],
      [null, null, null, 4, 1],
      [null, null, null, null, 9],
      [null, null, null, null, null]
    ];
    var expected = [0, 1, 4, 2, 3, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

  test('test case 7: non unique inputs', () async {
    List<List<double>> input = [
      [null, 1, 5, 5, 1],
      [null, null, 1, 9, 9],
      [null, null, null, 4, 1],
      [null, null, null, null, 9],
      [null, null, null, null, null],
    ];
    var expected = [0, 1, 4, 2, 3, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });

/*
  test('test case 8: non unique inputs', () async {
    List<List<double>> input = [
      [null, null, null],
      [3, null, null],
      [1, 2, null],
    ];
    var expected = [0, 1, 2, 0];
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
    var expected = [0, 1, 2, 3, 0];
    var output = await RouteOptimizeAlgo(input, true);
    expect(output, equals(expected));
  });
  */
}


//1 unique, increasing order
//2 unique, decreasing order
//3 unique, random order
//4 all non-unique inputs
//5 non-unique inputs, random order 1
//6 non-unique inputs, random order 2
//7 non-unique inputs, random order 3
//8 non-unique inputs, random order 4