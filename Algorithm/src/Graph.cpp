#include "Graph.h"
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
    _list = new list<nodeWeightPair> [n];

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
        for (list<nodeWeightPair>::iterator it = _list[i].begin(); it != _list[i].end(); it++)
        {
            cout << "(" << (*it).nodeIndex() << ", " <<(*it).weight() << ")" << "\t";
        }
        cout << endl;
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
    nodeWeightPair newNode(col, w);
   _list[row].push_back(newNode);
}
