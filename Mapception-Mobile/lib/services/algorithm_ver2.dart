// @dart=2.10
import 'package:graph_collection/graph.dart';

void main() {
  // var numOfNodes = 5;
  // var inputs = <int>[101, 21, 31, 41, 51, 61, 71, 81, 91, 101];

  // List<List<double>> inputs2 = [
  //   [null, 101.0, 21.0, 31, 41],
  //   [null, null, 51, 61, 71],
  //   [null, null, null, 81, 91],
  //   [null, null, null, null, 101],
  //   [null, null, null, null, null]
  // ];
  // RouteOptimizeAlgo(inputs2);
  // print("/////break///\n\n\n\n");
  // //create undirected weight graph
  // var FullGraph = UndirectedValueGraph();
  // for (var i = 0; i < numOfNodes; i++) {
  //   for (var j = 0; j < i; j++) {
  //     var w = inputs.first;
  //     FullGraph.setBy<int>(i, j, w);
  //     inputs.removeAt(0);
  //   }
  // }
  // //debugger: get the weight of the edges end check the links
  // print('edges weight:');
  // for (var i = 0; i < numOfNodes; i++) {
  //   for (var j = 0; j < i; j++) {
  //     print(FullGraph.getBy<int>(i, j).val);
  //   }
  // }
  // print('\n\nfull graph:');
  // printGraph(FullGraph, numOfNodes);
  // print('\n\n');

  // //create MST
  // var mstGraph = UndirectedValueGraph();
  // mstGraph = kruskalsAlgo(FullGraph, numOfNodes);
  // //debugger: check the MST
  // print('MST:');
  // printGraph(mstGraph, numOfNodes);

  // //find odd nodes
  // print('\n\nodd nodes: '); //debugger
  // var oddNodes = [];
  // for (var i = 0; i < numOfNodes; i++) {
  //   if (mstGraph.links(i).length % 2 != 0) {
  //     oddNodes.add(i);
  //     print(i); //debugger: print odd nodes
  //   }
  // }

  // //form a full graph with the odd edges
  // var oddGraph = UndirectedValueGraph();
  // for (var i = 0; i < oddNodes.length; i++) {
  //   oddGraph.add(oddNodes[i]);
  //   for (var j = i - 1; j > -1; j--) {
  //     int a = oddNodes[i];
  //     int b = oddNodes[j];
  //     int w = FullGraph.getBy<int>(a, b).val;
  //     oddGraph.setBy<int>(a, b, w);
  //   }
  // }
  // //debugger: check for odd graph
  // print('\n\nodd Graph:');
  // print(oddGraph.items);
  // for (var i = 0; i < numOfNodes; i++) {
  //   print(oddGraph.links(i));
  // }

  // //sort the edges
  // var edgeList = [];
  // for (var i = 0; i < numOfNodes; i++) {
  //   for (var j = 0; j < i; j++) {
  //     int weight = oddGraph.getBy<int>(i, j).val;
  //     //check if the edge exist (when weight != null)
  //     if (weight != null) {
  //       var newEdge = Edge(from: i, to: j, weight: weight);
  //       edgeList.add(newEdge);
  //     }
  //   }
  // }
  // edgeList.sort((curr, next) => curr.weight.compareTo(next.weight));
  // //debugger: check sorted edges
  // print('\n\nsorted edges');
  // for (var i = 0; i < 6; i++) {
  //   print(edgeList[i].weight);
  // }

  // //construct a graph w min edge
  // var checked = <bool>[];
  // for (var i = 0; i < numOfNodes; i++) {
  //   var tmp = false;
  //   checked.add(tmp);
  // }
  // var finalGraph = UndirectedValueGraph();
  // for (var i = 0; i < numOfNodes; i++) {
  //   finalGraph.add(i);
  // }
  // for (var i = 0; i < edgeList.length; i++) {
  //   int a = edgeList[i].toNode();
  //   int b = edgeList[i].fromNode();
  //   if (checked[a] == false && checked[b] == false) {
  //     int w = FullGraph.getBy<int>(a, b).val;
  //     finalGraph.setBy<int>(a, b, w);
  //     checked[a] = true;
  //     checked[b] = true;
  //   }
  // }

  // print('\n\nfinal graph:');
  // printGraph(finalGraph, numOfNodes);

  // //union the mst w the graph
  // for (var i = 0; i < numOfNodes; i++) {
  //   for (var j = i; j > -1; j--) {
  //     var a = mstGraph.hasEdgeBy<int>(i, j);
  //     var b = finalGraph.hasEdgeBy<int>(i, j);
  //     //print(a);
  //     if (a && !b) /*exist in mst but not exist in final graph*/
  //     {
  //       var w = FullGraph.getBy<int>(i, j);
  //       finalGraph.setBy<int>(i, j, w);
  //     }
  //   }
  // }

  // print('\n\nunion graph:');
  // printGraph(finalGraph, numOfNodes);

  // //calculate euler tour
  // var Euler = EulerTour(finalGraph);
  // print('\n\nEuler Tour:');
  // var eulerTour = Euler.getEuler();
  // print(eulerTour);

  // //remove duplicate edges
  // var finalList = removeDuplicates(eulerTour, numOfNodes);
  // print('\n\n1.5-approximate output:');
  // print(finalList);

  // //two approx
  // var twoApproximate = twoApprox(mstGraph, numOfNodes);
  // print('\n\n2-approximate output:');
  // print(twoApproximate);
}

Future<List<int>> RouteOptimizeAlgo(List<List<double>> arrayOfDurations) async {
  //Get input
  var inputs = new List.empty(growable: true);
  for (int i = 0; i < arrayOfDurations.length; i++) {
    for (int j = 0; j < arrayOfDurations.length; j++) {
      if (arrayOfDurations[i][j] != null) {
        inputs.add(arrayOfDurations[i][j].toInt());
      }
    }
  }
  print(inputs);
  print('\n');
  int numOfNodes = arrayOfDurations.length;
  var FullGraph = UndirectedValueGraph();
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      var w = inputs.first;
      FullGraph.setBy<int>(i, j, w);
      inputs.removeAt(0);
    }
  }
  //debugger: get the weight of the edges end check the links
  print('edges weight:');
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      print(FullGraph.getBy<int>(i, j).val);
    }
  }
  print('\n\nfull graph:');
  printGraph(FullGraph, numOfNodes);
  print('\n\n');

  //create MST
  var mstGraph = UndirectedValueGraph();
  mstGraph = kruskalsAlgo(FullGraph, numOfNodes);
  //debugger: check the MST
  print('MST:');
  printGraph(mstGraph, numOfNodes);

  //find odd nodes
  print('\n\nodd nodes: '); //debugger
  var oddNodes = [];
  for (var i = 0; i < numOfNodes; i++) {
    if (mstGraph.links(i).length % 2 != 0) {
      oddNodes.add(i);
      print(i); //debugger: print odd nodes
    }
  }

  //form a full graph with the odd edges
  var oddGraph = UndirectedValueGraph();
  for (var i = 0; i < oddNodes.length; i++) {
    oddGraph.add(oddNodes[i]);
    for (var j = i - 1; j > -1; j--) {
      int a = oddNodes[i];
      int b = oddNodes[j];
      int w = FullGraph.getBy<int>(a, b).val;
      oddGraph.setBy<int>(a, b, w);
    }
  }
  //debugger: check for odd graph
  print('\n\nodd Graph:');
  print(oddGraph.items);
  for (var i = 0; i < numOfNodes; i++) {
    print(oddGraph.links(i));
  }

  //sort the edges
  var edgeList = [];
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = 0; j < i; j++) {
      int weight = oddGraph.getBy<int>(i, j).val;
      //check if the edge exist (when weight != null)
      if (weight != null) {
        var newEdge = Edge(from: i, to: j, weight: weight);
        edgeList.add(newEdge);
      }
    }
  }
  edgeList.sort((curr, next) => curr.weight.compareTo(next.weight));
  //debugger: check sorted edges
  print('\n\nsorted edges');
  // for (var i = 0; i < 6; i++) {
  //   print(edgeList[i].weight);
  // }

  //construct a graph w min edge
  var checked = <bool>[];
  for (var i = 0; i < numOfNodes; i++) {
    var tmp = false;
    checked.add(tmp);
  }
  var finalGraph = UndirectedValueGraph();
  for (var i = 0; i < numOfNodes; i++) {
    finalGraph.add(i);
  }
  for (var i = 0; i < edgeList.length; i++) {
    int a = edgeList[i].toNode();
    int b = edgeList[i].fromNode();
    if (checked[a] == false && checked[b] == false) {
      int w = FullGraph.getBy<int>(a, b).val;
      finalGraph.setBy<int>(a, b, w);
      checked[a] = true;
      checked[b] = true;
    }
  }

  print('\n\nfinal graph:');
  printGraph(finalGraph, numOfNodes);

  //union the mst w the graph
  for (var i = 0; i < numOfNodes; i++) {
    for (var j = i; j > -1; j--) {
      var a = mstGraph.hasEdgeBy<int>(i, j);
      var b = finalGraph.hasEdgeBy<int>(i, j);
      //print(a);
      if (a && !b) /*exist in mst but not exist in final graph*/
      {
        var w = FullGraph.getBy<int>(i, j);
        finalGraph.setBy<int>(i, j, w);
      }
    }
  }

  print('\n\nunion graph:');
  printGraph(finalGraph, numOfNodes);

  //calculate euler tour
  var Euler = EulerTour(finalGraph);
  print('\n\nEuler Tour:');
  var eulerTour = Euler.getEuler();
  print(eulerTour);

  //remove duplicate edges
  List<int> finalList = removeDuplicates(eulerTour, numOfNodes).toList();
  print('\n\n1.5-approximate output:');
  print(finalList);
  return finalList;
  //two approx
  // var twoApproximate = twoApprox(mstGraph, numOfNodes);
  // print('\n\n2-approximate output:');
  // print(twoApproximate);
}

List twoApprox(UndirectedValueGraph graph, int n) {
  var dfs = DepthFirstSearch(graph, n);
  var finalList = dfs.getDFSorder(0);
  return finalList;
}

class EulerTour {
  UndirectedValueGraph _graph;
  UndirectedValueGraph _tmpGraph;
  var finalList = [];
  var deletedEdge = [];
  int _n;
  var adList = [];

  EulerTour(UndirectedValueGraph graph) {
    _graph = graph;
    _tmpGraph = graph;
    _n = graph.length;
    for (var i = 0; i < _n; i++) {
      var tmp = _graph.links(i);
      adList.add(tmp);
    }
  }

  List getEuler() {
    var u = 0;
    for (var i = 0; i < _n; i++) {
      if (adList[i].length % 2 == 1) {
        u = i;
        break;
      }
    }
    print('start from $u');
    finalList.add(u);
    _doEuler(u);
    return finalList;
  }

  void _deleteEdge(int a, int b) {
    if (a > b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    var tmp = Edge(from: a, to: b);
    deletedEdge.add(tmp);
    _tmpGraph.unLink(a, b);
  }

  bool _isEdgeDeleted(int a, int b) {
    if (a > b) {
      var tmp = a;
      a = b;
      b = tmp;
    }
    for (var i = 0; i < deletedEdge.length; i++) {
      if (deletedEdge[i].from == a && deletedEdge[i].to == b) {
        return true;
      }
    }
    return false;
  }

  bool _isValidNextEdge(int a, int b) {
    if (_isEdgeDeleted(a, b) == true) {
      return false;
    }

    if (_tmpGraph.links(a).length == 1) {
      return true;
    }

    var dfs = DepthFirstSearch(_tmpGraph, _n);
    var count1 = dfs.getDFScount(a);
    dfs.removeEdge(a, b);
    var count2 = dfs.getDFScount(a);

    return count1 <= count2;
  }

  void _doEuler(int vertex) {
    var lst = adList[vertex].toList();
    var l = lst.length;
    for (var i = 0; i < l; i++) {
      var from = vertex;
      var to = lst[i];
      if (_isValidNextEdge(from, to)) {
        finalList.add(to);
        _deleteEdge(from, to);
        _doEuler(to);
      }
    }
  }
}

class DepthFirstSearch {
  var _count = 0;
  var _n;
  var visited = [];
  var finalList = [];
  UndirectedValueGraph _graph;
  DepthFirstSearch(UndirectedValueGraph graph, int n) {
    _graph = graph;
    _n = n;
    for (var i = 0; i < n; i++) {
      var tmp = false;
      visited.add(tmp);
    }
  }

  void _doDFS(int vertex) {
    for (var i = 0; i < _n; i++) {
      visited[i] = false;
    }
    _count = 0;
    finalList.clear();
    _dfs(vertex);
  }

  void removeEdge(int a, int b) {
    _graph.unLink(a, b);
    finalList.clear();
  }

  int getDFScount(int vertex) {
    _doDFS(vertex);
    return _count;
  }

  List getDFSorder(int vertex) {
    _doDFS(vertex);
    return finalList;
  }

  void _dfs(int vertex) {
    _count++;
    visited[vertex] = true;
    finalList.add(vertex);
    var lst = _graph.links(vertex).toList();
    for (var i = 0; i < lst.length; i++) {
      var a = lst[i];
      if (!visited[a]) {
        _dfs(a);
      }
    }
  }
}

class Edge {
  int from;
  int to;
  var weight;

  Edge({this.from, this.to, this.weight});

  int fromNode() {
    return from;
  }

  int toNode() {
    return to;
  }
}

UndirectedValueGraph kruskalsAlgo(
    UndirectedValueGraph completeGraph, int numOfNodes) {
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
      MSTGraph.setBy<int>(sourceNode, destNode, weight);
      i++;
    }
  }

  //var returnedVal = traverse(MSTGraph, 0);
  //print(returnedVal);
  return MSTGraph;
}

void printGraph(UndirectedValueGraph graph, int n) {
  print(graph.items);
  for (var i = 0; i < n; i++) {
    print(graph.links(i));
  }
}

List<int> removeDuplicates(List lst, int n) {
  List<int> finalList = [];
  var checked = [];
  for (var i = 0; i < n; i++) {
    var tmp = false;
    checked.add(tmp);
  }
  for (var i = 0; i < lst.length; i++) {
    var a = lst[i];
    if (!checked[a]) {
      finalList.add(a);
      checked[a] = true;
    }
  }
  return finalList;
}

class UnionFind {
  var _parent;
  var _rank;
  var _setSize;
  var _numSets = 0;

  //constructor
  UnionFind(int n) {
    _parent = List<int>(n);
    _rank = List<int>(n);
    _setSize = List<int>(n);

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
