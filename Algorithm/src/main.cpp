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
        //~Graph();
        //void printGraph();
};

Graph::Graph(int n)
{
    //construct lower triangular matrix

    //initialise all i=j nodes to infinity
    for (int i = 0; i < n; i++)
    {
        addEdge(i, i, INFINITY);
    }
}


void Graph::addEdge(int s, int d, int w)
{
    //ensure s smaller than d
    if (s > d)
    {
        int temp;
        temp = s;
        s = d;
        d = temp;
    }

    matrix[s][d] = w;
}


int main()
{
    int numOfNodes;
    cin >> numOfNodes;

    //create graph
    Graph map(numOfNodes);
    for (int i = 0; i < numOfNodes - 1; i++)
    {
        for (int j = 0; j < i - 1; j++)
        {
            int w;
            cin >> w;
            addEdge(i, j, w);
        }
    }

    //find MST
    //push vertices with odd degree into list
    return 0;
}
