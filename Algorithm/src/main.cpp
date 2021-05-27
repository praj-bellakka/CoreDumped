/**
 * CP2106 Orbital 20/21
 * 
 * To find the optimal path on a fully connected graph.
 *
 * @file: main.cpp
 * @author: Leow Yuan Yang 
 */
#include <iostream>
#include <list>
#include <queue>

#define INFINITY 9999

using namespace std;

class unionFind
{
    private:
        int _size;
        int *_parent;
        int *_rank;

    public:
        unionFind(int size);
        ~unionFind();
        int size() { return _size; };
        bool isSameSet(int index1, int index2);
        int findSet(int index);
        void unionSet(int index1, int index2);
};

unionFind::unionFind(int size)
{
    _size = size;
    _parent = new int [_size];
    _rank = new int [_size];
    for (int i = 0; i < _size; i++)
    {
        _parent[i] = i;
        _rank[i] = 0;
    }
}

void unionFind::unionSet(int index1, int index2)
{
    if (isSameSet(index1, index2))
        return;

    if (_rank[index1] > _rank[index2])
    {
        swap(index1, index2);
    }
    _parent[index1] = index2;
    if (_rank[index1] == _rank[index2])
        _rank[index2]++;
}

int unionFind::findSet(int index)
{
    return _parent[index];
}

bool unionFind::isSameSet(int index1, int index2)
{
    return findSet(index1) == findSet(index2);
}

unionFind::~unionFind()
{

}


class edge 
{
    private:
        int _from;
        int _to;
        int _weight;

    public:
        edge(int f, int t, int w) { _from = f; _to = t; _weight = w; };
        edge(const edge& eln) { _from = eln._from; _to = eln._to; _weight = eln._weight; };
        int fromNode() { return _from; };
        int toNode() { return _to; };
        int weight() { return _weight; };
};

class adListNode {
    private:
        int _index;
        int _weight;

    public:
        adListNode(int n, int w) { _index = n; _weight = w; };
        adListNode(const adListNode& nwp) { _index = nwp._index; _weight = nwp._weight; };
        int nodeIndex() { return _index; };
        int weight() { return _weight; };
        //bool operator > (adListNode nwp) { return _weight > nwp._weight;};
        //bool operator < (adListNode nwp) { return _weight > nwp._weight;};
        //bool operator == (const adListNode& nwp) { return _index == nwp._index; };
};
bool operator<(const edge nwp1, const edge nwp2)
{
    int w1 = nwp1.weight();
    int w2 = nwp2.weight();

    return w1 > w2;
}

class Graph
{
    private:
        int **_matrix;
        list<adListNode> *_adList;                           
        list<edge> _edgeList;
        int _nv; // number of nodes
        int *_order;

    public: 
        int size() {return _nv;};
        Graph(int n);
        void addEdge(int s, int d, int w);
        void printMatrix();
        void printAdList();
        void printEdgeList();
        void minSpanTree(Graph mst);
        void dfs(int index, int visitedCount, bool *visited);
        void printOrder();
        ~Graph();
};

int main()
{
    //read in number of nodes
    int numOfNodes;
    cin >> numOfNodes;

    //create graph
    Graph map(numOfNodes);

    for (int i = 0; i < numOfNodes; i++)
    {
        for (int j = 0; j < i; j++)
        {
            cout << i << " " << j << ":";
            int w;
            cin >> w;
            map.addEdge(i, j, w);
        }
        map.addEdge(i, i, INFINITY);
    }

    map.printMatrix();

    //generate minimum spanning tree mst
    Graph mst(numOfNodes);
    map.minSpanTree(mst);

    bool *visited = new bool [numOfNodes];
    mst.dfs(0, 0, visited);

    cout << "MST: ";
    mst.printAdList();
    mst.printOrder();

    return 0;
}

void Graph::dfs(int index, int visitedCount, bool *visited)
{
    _order[visitedCount] = index;
    visited[index] = true;

    for (list<adListNode>::iterator it = _adList[index].begin(); it != _adList[index].end(); it++)
    {
        int next = (*it).nodeIndex();
        if (!visited[next])
        {
            visitedCount++;
            dfs(next, visitedCount, visited);
        }
    }
}

void Graph::printOrder()
{
    cout << endl << "Order: ";
    for (int i = 0; i < _nv; i++)
    {
        cout << _order[i] << " ";
    }
}


/**
 * To generate a minimun spanning tree.
 *
 * @param[in, out] mst The graph containing the minimum spanning tree.
 * @pre mst must will initialise with the same number of nodes as original graph.
 */
void Graph::minSpanTree(Graph mst)
{

    //construct unfs to check for cycle
    unionFind cycleChecker(_nv);
    //constructing pq
    priority_queue<edge> pq;
    for (list<edge>::iterator it = _edgeList.begin(); it != _edgeList.end(); it++)
    {
        pq.push(*it);
    }
    
    cout << endl;
    
    int i = 1;

    while (i < _nv)
    {
        edge temp = pq.top();
        int src = temp.fromNode();
        int dst = temp.toNode();
        int wt = temp.weight();



        if (!cycleChecker.isSameSet(src, dst))
        {
            cycleChecker.unionSet(src, dst);
            mst.addEdge(dst, src, wt);
            i++;
        }
        pq.pop();
    }
}


/**
 * Contructor of the class Graph
 * 
 * @param[in] n The number of nodes in the graph.
 * @post _nv will be updated.
 * @post _matrix will be initialize to a lower triangular matrix.
 * @post _matrix[i][i] for all i < n will be initialized to INFINITY.
 */
Graph::Graph(int n)
{
    _nv = n;
    //construct adjacency matrix
    _matrix = new int* [n];
    for (int i = 0; i < n; i++)
    {
        _matrix[i] = new int [i + 1];
    }
    //construct adjacency list
    _adList = new list<adListNode> [n];

    _order = new int [n];


}

/**
 * Deconstructor for class Graph
 */
Graph::~Graph()
{

}

/**
 * To print out the adjacency matrix to stdout.
 */
void Graph::printMatrix()
{
    cout << endl;
    cout << "Adjacency Matrix: " << endl;
    for (int i = 0; i < _nv; i++)
    {
        cout << i << ":\t";
        for (int j = 0; j < i + 1; j++)
        {
            cout << _matrix[i][j] << "\t";
        }
        cout << endl;
    }
    for (int i = 0; i < _nv; i++)
        cout << "\t" << i;
}

/**
 * To print out the adjacency list to stdout.
 */
void Graph::printAdList()
{
    cout << endl;
    cout << "Adjacency List: " << endl;
    for (int i = 0; i < _nv; i++)
    {
        cout << i << ":\t";
        //print each linked list
        for (list<adListNode>::iterator it = _adList[i].begin(); it != _adList[i].end(); it++)
        {
            cout << "(" << (*it).nodeIndex() << ", " <<(*it).weight() << ")" << "\t";
        }
        cout << endl;
    }
}

/**
 * To print out the edge list to stdout.
 */
void Graph::printEdgeList()
{
    cout << endl;
    cout << "Edge List: " << endl;

    int i = 1;
    for (list<edge>::iterator it = _edgeList.begin(); it != _edgeList.end(); it++)
    {
        cout << i << " ";
        cout << "(" << (*it).fromNode() << ", " << (*it).toNode() << ", " << (*it).weight() << ")" << endl;
        i++;
    }
}

/**
 * To add an edge between 2 nodes.
 *
 * @param[in] row Index of the first node.
 * @param[in] col Index of the second node.
 * @param[in] w Weight between the two nodes.
 * @pre row < col
 * @post _matrix[row][col] will be updated with the weight of the edge.
 */
void Graph::addEdge(int row, int col, int w)
{
    _matrix[row][col] = w;
    adListNode newNode(col, w);
   _adList[row].push_back(newNode);
   edge newNode1(row, col, w);
   _edgeList.push_back(newNode1);
}
