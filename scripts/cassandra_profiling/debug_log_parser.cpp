#include <bits/stdc++.h> 
using namespace std; 

int main(int argc, char **argv)
{
    string line;

    ifstream file(argv[1]);
    ofstream outfile;

    unordered_map<int, pair<string, string>> umap; 

    while (getline (file, line)) 
    {
        int compacting = line.find ("Compacting");
        int compacted = line.find("Compacted", 0);
        int usertable = line.find("/var/lib/cassandra/data/ycsb/usertable", 0);

        if(compacting != string::npos && usertable != string::npos)
        {
            stringstream ss(line.substr(line.find("CompactionExecutor:") + 19));
            int task;
            ss >> task; 
            string s;
            string startTime = "";
            ss >> s;
            ss >> s;
            startTime += s + " ";
            ss >> s;
            startTime += s;
            umap[task] = make_pair(startTime, "");
        }
        else if(compacted != string::npos && usertable != string::npos)
        {
            stringstream ss(line.substr(line.find("CompactionExecutor:") + 19));
            int task;
            ss >> task; 
            string s;
            string endTime = "";
            ss >> s;
            ss >> s;
            endTime += s + " ";
            ss >> s;
            endTime += s;
            umap[task].second = endTime;    
            cout << task << ";" << umap[task].first << ";" << umap[task].second << endl;                        
        }
    }
    file.close();
}