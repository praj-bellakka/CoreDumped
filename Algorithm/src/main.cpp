/**
 * CP2106 Orbital 20/21
 * 
 * To find the optimal path on a fully connected graph.
 *
 * @file: main.cpp
 * @author: Leow Yuan Yang 
 */

#include <iostream>
#include "Graph.cpp"

#define INFINITY 9999

using namespace std;

//struct definitions
typedef struct 
{
    int _index;
    string _address;
} location;

void minSpanTree(Graph mst, Graph map);
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
    map.printList();

    //generate minimum spanning tree mst
    Graph mst(numOfNodes);
    minSpanTree(mst, map);

    map.~Graph();

    return 0;
}

void minSpanTree(Graph mst, Graph map)
{

    //push into min heap
    

    //loop
        //extract min
        //if it doesnt form a cycle
            //addedge

}
