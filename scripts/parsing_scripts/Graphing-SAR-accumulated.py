#!/usr/bin/env python
# coding: utf-8

# In[8]:


# !pip3 install matplotlib pandas
import matplotlib.pyplot as plt
import pandas as pd
import os
get_ipython().run_line_magic('matplotlib', 'inline')


# In[32]:


# Write
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" in filename and "write" in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[4:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-write")
    plt.savefig("Write-" + i + ".png")
    plt.clf()


# In[33]:


# Read
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" in filename and "read" in filename and "modify" not in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[4:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i)
    plt.savefig("Read-" + i + ".png")
    plt.clf()


# In[34]:


# Update
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" in filename and "update" in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[4:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + "-update")
    plt.savefig("Update-" + i + ".png")
    plt.clf()


# In[35]:


# Read and Modify
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk("/home/shaanzie/Desktop/LSMTProject/results/"):
    for filename in filenames:
        if("sar" in filename and "modify" in filename):
            list_of_files.append(os.sep.join([dirpath, filename]))
            
useful = []
df = pd.read_csv(list_of_files[0])
useful = list(df.columns)[4:-1]

for i in useful:
    for file in list_of_files:
        db = file.split("/")[6]
        df = pd.read_csv(file)
        plt.plot(df[i], label=db)
    plt.legend()
    plt.xlabel(i + '-read_and_modify')
    plt.savefig("Read_and_modify-" + i + ".png")
    plt.clf()


# In[ ]:




