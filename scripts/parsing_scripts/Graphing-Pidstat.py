#!/usr/bin/env python
# coding: utf-8

# In[2]:


# !pip3 install matplotlib pandas
import matplotlib.pyplot as plt
import pandas as pd
import sys


# In[4]:


df = pd.read_csv(sys.argv[1])


# In[20]:


useless = ["CPU", "Workload"]
workload = df["Workload"][0]
for i in df.columns:
    if(i not in useless):
        plt.plot(df[i], label=i)
        plt.legend()
        plt.savefig(workload + "-pidstat-" + i.replace("/", "-") + ".png")
        plt.clf()


# In[ ]:




