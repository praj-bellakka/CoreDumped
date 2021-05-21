/**
 * CP2016 Orbital 20/21 
 * 
 * Class definitions for Graph
 *
 * @file: Graph.h
 * @author: Leow Yuan Yang
 */

#pragma once
#include <list>

class nodeWeightPair {
    private:
        int _index;
        int _weight;

    public:
        nodeWeightPair(int n, int w) { _index = n; _weight = w; };
        nodeWeightPair(const nodeWeightPair& nwp) { _index = nwp._index; _weight = nwp._weight; };
        int nodeIndex() { return _index; };
        int weight() { return _weight; };
        //bool operator>(const nodeWeightPair& nwp) { return _weight > nwp._weight;};
        //bool operator == (const nodeWeightPair& nwp) { return _index == nwp._index; };
};

class Graph
{
    private:
        int **_matrix;
        list<nodeWeightPair> *_list;                               //1
        int _nv; // number of nodes

    public: 
        Graph(int n);
        void addEdge(int s, int d, int w);
        void printMatrix();
        void printList();
        ~Graph();
        //void printGraph();
};

