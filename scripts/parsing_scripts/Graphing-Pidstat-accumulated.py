#!/usr/bin/env python
# coding: utf-8

# In[21]:


# !pip3 install matplotlib pandas
import matplotlib.pyplot as plt
import pandas as pd
import os
get_ipython().run_line_magic('matplotlib', 'inline')


# In[22]:


# Write
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" not in filename and "write" in filename and "csv" in filename and "pid-" not in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-write")
    plt.savefig("Write-" + i.replace("/", "-") + ".png")
    plt.clf()


# In[23]:


# Read
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" not in filename and "read" in filename and "csv" in filename and "pid-" not in filename and "modify" not in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-read")
    plt.savefig("Read-" + i.replace("/", "-") + ".png")
    plt.clf()


# In[24]:


# Read and modify
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" not in filename and "read" in filename and "csv" in filename and "pid-" not in filename and ("modify" in filename or 'Modify' in filename)):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[:-1]

# list_of_files

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-read_and_modify")
    plt.savefig("Read_and_modify-" + i.replace("/", "-") + ".png")
    plt.clf()


# In[25]:


# Update
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" not in filename and "update" in filename and "csv" in filename and "pid-" not in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[:-1]

# list_of_files

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-Update")
    plt.savefig("Update-" + i.replace("/", "-") + ".png")
    plt.clf()


# In[ ]:




