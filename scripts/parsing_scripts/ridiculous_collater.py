import pandas as pd
import os

all_df = pd.DataFrame()

for root, dirs, files in os.walk("/home/shaanzie/forest-results/"):
    for filename in files:
        if("latency" in filename):
            df = pd.read_csv("/home/shaanzie/forest-results/" + filename)
            indices = filename.split("-")
            df["Benchmark"] = indices[0]
            df["Workload"] = indices[1]
            df["NumLSM"] = indices[2]
            df["Fallbacks"] = indices[3]
            df["Parallel"] = indices[4]
            df["KVSep"] = indices[5]
            df["UpdateCon"] = indices[6]
            all_df = all_df.append(df)
            print("Done processing " + filename)
all_df.to_csv("CollatedLatency.csv")