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

class edgeListNode 
{
    private:
        int _from;
        int _to;
        int _weight;

    public:
        edgeListNode(int f, int t, int w) { _from = f; _to = t; _weight = w; };
        edgeListNode(const edgeListNode& eln) { _from = eln._from; _to = eln._to; _weight = eln._weight; };
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
bool operator<(const edgeListNode nwp1, const edgeListNode nwp2)
{
    int w1 = nwp1.weight();
    int w2 = nwp2.weight();

    return w1 > w2;
}

class Graph
{
    private:
        int **_matrix;
        list<adListNode> *_adList;                               //1
        list<edgeListNode> _edgeList;
        int _nv; // number of nodes

    public: 
        int size() {return _nv;};
        Graph(int n);
        void addEdge(int s, int d, int w);
        void printMatrix();
        void printAdList();
        void printEdgeList();
        void minSpanTree(Graph mst);
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
    map.printAdList();
    map.printEdgeList();

    //generate minimum spanning tree mst
    Graph mst(numOfNodes);
    map.minSpanTree(mst);


    return 0;
}

void Graph::minSpanTree(Graph mst)
{
    //constructing pq
    priority_queue<edgeListNode> pq;
    for (list<edgeListNode>::iterator it = _edgeList.begin(); it != _edgeList.end(); it++)
    {
        pq.push(*it);
    }
    
    cout << endl;
    
    while (!pq.empty())
    {
        cout << "(" << (pq.top()).fromNode() << ", " << (pq.top()).toNode() << ", " << (pq.top()).weight() << ")" << endl;
        pq.pop();
    }
    

    //loop
        //extract min
        //if it doesnt form a cycle
            //addedge

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

void Graph::printEdgeList()
{
    cout << endl;
    cout << "Edge List: " << endl;

    for (list<edgeListNode>::iterator it = _edgeList.begin(); it != _edgeList.end(); it++)
    {
        cout << "(" << (*it).fromNode() << ", " << (*it).toNode() << ", " << (*it).weight() << ")" << endl;
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
   edgeListNode newNode1(row, col, w);
   _edgeList.push_back(newNode1);
}
