#include <bits/stdc++.h> 
using namespace std; 

int main(int argc, char **argv)
{
    string line;

    ifstream file(argv[1]);

    cout << "time;stopping_duration;stopping_time\n";

    while (getline (file, line)) 
    {
        int stopping = line.find ("Total time for which application threads were stopped:");

        if(stopping != string::npos)
        {
            stringstream ss(line);
            string time;
            ss >> time;

            string stopping_duration = "";
            string time_taken_to_stop = "";

            stringstream ss1(line.substr(line.find("stopped: ") + 9));
            ss1 >> stopping_duration;

            stringstream ss2(line.substr(line.find("Stopping threads took: ") + 23));
            ss2 >> time_taken_to_stop;

            cout << time << ";" << stopping_duration << ";" << time_taken_to_stop << "\n";

        }
    }
    file.close();
}