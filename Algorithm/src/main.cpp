/**
 * CP2106 Orbital 20/21
 * 
 * To find the optimal path on a fully connected graph.
 *
 * @file: main.cpp
 * @author: Leow Yuan Yang & Prajwal Bellaka
 *
 */

#include <iostream>
#include <string>

#define INFINITY 9999

using namespace std;

//class definitions
class nodeLocation
{
    private:
        int _nodeIndex;
        string _locationName;

    public:
        nodeLocation(int index, string name);
        string locationName(int index);

        friend Graph;
};

class Graph
{
    private:
        int **matrix;
        int _nv; // number of nodes

    public: 
        Graph(int n);
        void addEdge(int s, int d, int w);
        void printMatrix();
        ~Graph();
        //void printGraph();
};


//function definitions
Graph::Graph(int n);
Graph::~Graph();
void Graph::addEdge(int row, int col, int w);
void Graph::printMatrix();

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
    }



    map.~Graph();

    return 0;
}


/**
 * Contructor of the class Graph
 * 
 * @param[in] n The number of nodes in the graph.
 * @post _nv will be updated.
 * @post matrix will be initialize to a lower triangular matrix.
 * @post matrix[i][i] for all i < n will be initialized to INFINITY.
 */
Graph::Graph(int n)
{
    _nv = n;
    //construct lower triangular matrix
    matrix = new int* [n];

    for (int i = 0; i < n; i++)
    {
        matrix[i] = new int [i + 1];
    }

    //initialise all i=j nodes to infinity
    for (int i = 0; i < n; i++)
    {
        addEdge(i, i, INFINITY);
    }
}

/**
 * Deconstructor for class Graph
 */
Graph::~Graph()
{

}

/**
 * To print out the adjacency matrix to the terminal.
 */
void Graph::printMatrix()
{
    for (int i = 0; i < _nv; i++)
    {
        for (int j = 0; j < i + 1; j++)
        {
            cout << matrix[i][j] << " ";
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
 * @post matrix[row][col] will be updated with the weight of the edge.
 */
void Graph::addEdge(int row, int col, int w)
{
    matrix[row][col] = w;
}

/**
 * To return the location name
 *
 * @param[in] index The index of the locationl
 */
string nodeLocation::locationName(int index)
{
    return _locationName;
}


