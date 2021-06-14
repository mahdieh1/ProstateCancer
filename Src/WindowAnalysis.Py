import pandas as pd
import numpy as np   
from tqdm import tqdm
from poibin import PoiBin
#------------hg19-----------------------
chromosome_length = {'chr1' : 249250621,
'chr2':  243199373,
'chr3':  198022430,
'chr4':  191154276, 
'chr5':  180915260,
'chr6':  171115067,
'chr7':  159138663,
'chr8' : 146364022,
'chr9' : 141213431,
'chr10' : 135534747,
'chr11' : 135006516,
'chr12' : 133851895,
'chr13' : 115169878,
'chr14' : 107349540,
'chr15' : 102531392,
'chr16' : 90354753,
'chr17' : 81195210,
'chr18' : 78077248,
'chr20' : 63025520,
'chr19' : 59128983,
'chr22' : 51304566,
'chr21' : 48129895,
'chrY'  :59373566,
'chrX'  :155270560}
len(chromosome_length)

final_df1 = pd.DataFrame() 
final_df2 = pd.DataFrame()

#-------Read files------------
CHUNKSIZE = 10**3
df_iter = pd.read_csv('SomaticMutation.txt', sep='delimiter',delimiter = "\t" ,chunksize= CHUNKSIZE,skiprows=2 ,header = None)#,header = None)#, skiprows=1)
df_list = []
for df in tqdm(df_iter):
    df_list += [df.copy()]
    
df= pd.concat(df_list) 
print(len(df))
df.head()

#-----window analysis-----
final_df1 = pd.DataFrame()
final_df2 = pd.DataFrame() 
removed_length = {}
length_window=9;
for i in range(1,23):
    df2 = df[df[0] == str(i)]
    removed_length[i] = df2.pivot_table(index=[5], aggfunc='size')
    df3 = df2.drop_duplicates(subset=3, keep="first")
    print(len(df3))
    df3[6] = (df3[1]/length_window).apply(np.ceil)
    for i, row in df3.pivot_table(index=[6], aggfunc='size').iteritems():
        df4 = df3[(df3[6] == i[1])]
        df4[7] = df3.pivot_table(index=[6], aggfunc='size')[i]
        final_df1 = pd.concat([final_df1, df4])

A = ['X','Y']
for i in A: 
    df2 = df[df[0] == i]
    removed_length[i] = df2.pivot_table(index=[5], aggfunc='size')
    df3 = df2.drop_duplicates(subset=3, keep="first")
    print(len(df3))
    df3[6] = (df3[1]/length_window).apply(np.ceil)
    for i, row in df3.pivot_table(index=[6], aggfunc='size').iteritems():
        df4 = df3[(df3[6] == i[1])]
        df4[7] = df3.pivot_table(index=[6], aggfunc='size')[i]
        final_df1 = pd.concat([final_df1, df4])

#------calculate number---------
for i in range(1,23): 
    df2 = final_df1[final_df1[0] == str(i)]
    for i, row in df2.pivot_table(index=[6], aggfunc='size').iteritems():
        df3 = df2[(df2[6] == i)]
        df3[8] = df2.pivot_table(index=[6], aggfunc='size')[i]
        final_df2 = pd.concat([final_df2, df3])
for i in A: 
    df2 = final_df1[final_df1[0] == str(i)]
    for i, row in df2.pivot_table(index=[6], aggfunc='size').iteritems():
        df3 = df2[(df2[6] == i)]
        df3[8] = df2.pivot_table(index=[6], aggfunc='size')[i]
        final_df2 = pd.concat([final_df2, df3])
#-----save in one file----
final_df2.to_csv('final_results.csv')
#-----save separately----
for i in range(1,23): 
    df = final_df2[final_df2[5] == str(i)]
    df.to_csv('Window'+str(i)+ '.csv')
for i in A: 
    df = final_df2[final_df2[5] == str(i)]
    df.to_csv('Window'+i+ '.csv') 
#-----calculate p-value----
for i in range(1,23): 
    df = final_df2[final_df2[1] == str(i)]
    pb = PoiBin(df[7]/sum(df[7]))
    df[9] = pb.pval(df[7])    
    final_df3 = pd.concat([final_df3, df]) 
for i in A: 
    df = final_df2[final_df2[1] == str(i)]
    pb = PoiBin(df[7]/sum(df[7]))
    df[9] = pb.pval(df[7])
    final_df3 = pd.concat([final_df3, df])
for i in range(1,23): 
    df = final_df3[final_df3[1] == str(i)]
    df.to_csv('final_result'+str(i)+ '.csv')  
for i in A: 
    df = final_df3[final_df3[1] == str(i)]
    df.to_csv('final_result'+i+ '.csv')    