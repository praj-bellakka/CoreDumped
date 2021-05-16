#include <iostream>
#include <string>

#define INFINITY 9999

using namespace std;

class Graph;

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

string nodeLocation::locationName(int index)
{
    return _locationName;
}

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

Graph::~Graph()
{

}

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


void Graph::addEdge(int row, int col, int w)
{
    matrix[row][col] = w;
}


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

    map.printMatrix();

    //find MST
    //push vertices with odd degree into list
    return 0;
}
