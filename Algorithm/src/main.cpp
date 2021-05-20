/**
 * CP2106 Orbital 20/21
 * 
 * To find the optimal path on a fully connected graph.
 *
 * @file: main.cpp
 * @author: Leow Yuan Yang & Prajwal Bellaka
 */

#include <iostream>
#include <string>
#include <list>

#define INFINITY 9999

using namespace std;

//class definitions
class Graph
{
    private:
        int **_matrix;
        list<int> *_list;
        int _nv; // number of nodes

    public: 
        Graph(int n);
        void addEdge(int s, int d, int w);
        void printMatrix();
        void printList();
        ~Graph();
        //void printGraph();
};

/*
   class nodeWeightPair {
   private:
   int _index;
   int _weight;

   public:
   nodeWeightPair(int n, int w) { _node = n; _weight = w; };
   nodeWeightPair(const nodeWeightPair& nwp) { _node = nwp._node; _weight = nwp._weight; };
   int nodeIndex() { return _index; };
   int weight() { return _weight; };
//bool operator>(const nodeWeightPair& nwp) { return _weight > nwp._weight;};
//bool operator == (const nodeWeightPair& nwp) { return _node == nwp._node; };
};

*/

int main()
{
    //read in number of nodes
    int numOfNodes;
    cin >> numOfNodes;

    //create graph
    Graph map(numOfNodes);

    for (int i = 1; i < numOfNodes; i++)
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
    map.printList();


    map.~Graph();

    return 0;
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
    _list = new list<int> [n];

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
void Graph::printList()
{
    cout << endl;
    cout << "Adjacency List: " << endl;
    for (int i = 0; i < _nv; i++)
    {
        cout << i << ":\t";
        //print each linked list
        for (list<int>::iterator it = _list[i].begin(); it != _list[i].end(); it++)
        {
            cout << *it << "\t";
        }
        cout << endl;
    }
    for (int i = 0; i < _nv; i++)
        cout << "\t" << i;
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
    _list[row].push_back(w);
}
