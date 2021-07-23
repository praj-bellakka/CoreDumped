/* Kruskal's algorithm to find the MST */
// @dart=2.10
import 'package:graph_collection/graph.dart';

void main() {
  var numOfNodes = 5;
  // var inputs = <int>[101, 21, 31, 41, 51, 61, 71, 81, 91, 101];
  // var inputs = <int>[1,2,3,4,5,6,7,8,9,10];
  // var inputs = <int>[10,9,8,7,6,5,4,3,2,1];
  var inputs = <int>[4, 6, 3, 7, 2, 8, 5, 9, 10, 1];

  //create directed weight graph
  var FullGraph = UndirectedValueGraph();

  //add the nodes and edges
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      var w = inputs.first;
      FullGraph.setBy<int>(i, j, w);
      inputs.removeAt(0);

      //debugger: get the weight of the edge
      var t = FullGraph.getBy<int>(i, j);
      print(t.val);
    }
  }
  //debugger: check if the nodes are linked
  print('\n');
  print('links between nodes');
  for (var i = 0; i < numOfNodes; i++) {
    print(FullGraph.links(i));
  }
  print('\n');
  kruskalsAlgo(FullGraph, numOfNodes);
  //kruskal's algo
  // var testGraph = Graph();
  // testGraph.link(1, 2);

  //for all edges
  //extract min edge
  //check for cycle
  //add into mst
  //kruskalsAlgo(FullGraph);
  //from mst
  //run dfs
}

Future<List<int>> RouteOptimizeAlgo1(
    List<List<double>> arrayOfDurations) async {
  //Get input
  var listOfInputs = new List.empty(growable: true);
  for (int i = 0; i < arrayOfDurations.length; i++) {
    for (int j = 0; j < arrayOfDurations.length; j++) {
      if (arrayOfDurations[i][j] != null) {
        listOfInputs.add(arrayOfDurations[i][j].toInt());
      }
    }
  }
  print(listOfInputs);
  print('\n');
  var FullGraph = UndirectedValueGraph();
  int numOfNodes = arrayOfDurations.length;
  // add the nodes and edges
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      var w = listOfInputs.first;
      FullGraph.setBy<int>(i, j, w);
      listOfInputs.removeAt(0);

      //debugger: get the weight of the edge
      var t = FullGraph.getBy<int>(i, j);
      print(t.val);
    }
  }

  var returnedVal = kruskalsAlgo(FullGraph, numOfNodes);
  print(returnedVal);
  return returnedVal;
}

class Edge {
  int from;
  int to;
  var weight;

  Edge({this.from, this.to, this.weight});
}

List<int> kruskalsAlgo(UndirectedValueGraph completeGraph, int numOfNodes) {
  //List to hold edge objects
  var edgeList = [];

  //Access each edge of the graph, and copy it into the edgeList list
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      int _weight = completeGraph.getBy<int>(i, j).val;
      //check if the edge exist (when weight != null)
      if (_weight != null) {
        var newEdge = Edge(from: i, to: j, weight: _weight);
        edgeList.add(newEdge);
      }
    }
  }
  //Sort edgeList by weight in an ascending order
  edgeList.sort((curr, next) => curr.weight.compareTo(next.weight));
  //print(edgeList.first.weight);

  var cycleChecker = UnionFind(numOfNodes);
  var MSTGraph = UndirectedValueGraph();
  var i = 1;
  while (i < numOfNodes) {
    var tempNode = edgeList.removeAt(0);
    int sourceNode = tempNode.from;
    int destNode = tempNode.to;
    int weight = tempNode.weight;

    //check if the node belongs to the same set
    if (!cycleChecker.isSameSet(sourceNode, destNode)) {
      //if it doesnt belong to the same set, union the two edges
      cycleChecker.unionSet(sourceNode, destNode);
      MSTGraph.setBy(sourceNode, destNode, weight);
      i++;
    }
  }

  //printGraph(MSTGraph, numOfNodes);
  var returnedVal = traverse(MSTGraph, 0);
  print(returnedVal.visits);
  return returnedVal.visits;
}

void printGraph(UndirectedValueGraph mstGraph, int n) {
  for (var i = 0; i < n; i++) {
    print(mstGraph.links(i));
  }
}

class UnionFind {
  var _parent;
  var _rank;
  var _setSize;
  var _numSets = 0;

  //constructor
  UnionFind(int n) {
    _parent = new List<int>(n);
    _rank = new List<int>(n);
    _setSize = new List<int>(n);

    for (var i = 0; i < n; i++) {
      _parent[i] = i;
      _setSize[i] = 1;
      _rank[i] = 0;
      _numSets = n;
    }
  }

  int findSet(int i) {
    return (_parent[i] == i) ? i : _parent[i] = findSet(_parent[i]);
  }

  bool isSameSet(int i, int j) {
    return findSet(i) == findSet(j);
  }

  int numDisjointSets() {
    return _numSets;
  }

  int sizeOfSet(int i) {
    return _setSize[findSet(i)];
  }

  void unionSet(int i, int j) {
    if (isSameSet(i, j)) {
      return;
    }

    //x and y represents parent of i and j
    var x = findSet(i);
    var y = findSet(j);
    //make sure the set of x is smaller than set of y
    if (_rank[x] > _rank[y]) {
      var temp = x;
      x = y;
      y = temp;
    }
    //make x part of set y
    _parent[x] = y;
    //update rank
    if (_rank[x] == _rank[y]) {
      _rank[y]++;
    }
    //update other stuff
    _setSize[y] += _setSize[x];
    --_numSets;
  }
}

//ADT for Traversal
class Traversal {
  final Set<int> _visitedVertices;
  final List<int> _visits;

  //vertices visited
  List<int> get visits => _visits;

  //Constructor
  Traversal()
      : _visitedVertices = <int>{},
        _visits = <int>[];

  //Check if the node has been visited
  bool hasVisited(int vertex) {
    return _visitedVertices.contains(vertex);
  }

  //Add the node to the list of visited nodes
  void addVisited(int vertex) {
    _visitedVertices.add(vertex);
  }

  //Add a new visit to the traversed list
  void addVisit(int vertex) {
    _visits.add(vertex);
  }

  @override
  String toString() => _visitedVertices.toString();
}

Traversal traverse(UndirectedValueGraph graph, int vertex) {
  var traversal = Traversal();

  _doDFS(graph, vertex, traversal);

  return traversal;
}

void _doDFS(UndirectedValueGraph graph, int vertex, Traversal traversal) {
  traversal.addVisited(vertex);
  traversal.addVisit(vertex);
  for (var connectedVertex in graph.links(vertex)) {
    if (!traversal.hasVisited(connectedVertex)) {
      _doDFS(graph, connectedVertex, traversal);
    }
  }
}
