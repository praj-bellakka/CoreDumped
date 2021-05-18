class locationIndex
{
    private:
        int _index;
        string _address;

    public:
        locationIndex(int index, string address);
        string locationName(int index);

        //friend Graph;
};

/**
 * Contructor for class locationIndex
 */
locationIndex::locationIndex(int index, string address)
{
    _index = index;
    _address = name;
}

/**
 * To return the location name
 *
 * @param[in] index The index of the locationl
 */
string locationIndex::locationName(int index)
{
    return _address;
}
