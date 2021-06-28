CNVRsSelection  <- function(df,cnv,NO)
{
  
  for(k in (1:22))
  {
    
    row<-data.frame();
    col<-data.frame();
    f<-data.frame();
    final2<-data.frame();
    subtract<-data.frame();
    
    df1=df[df[,1]==k,]
    cnv1=cnv[cnv[,2]==k,]
    No1=No[No[,1]==k,]
    
    for (j in (1:nrow(cnv1)))
    {
      col[j,1]<-cnv1[j,3];
      row[1,j]<-cnv1[j,3];
    }
    
    for(i in 1:nrow(col))
    {
      f[i,i]<-No1[i,2];
      final2[i,i]<-100;
      subtract[i,i]<-0;
    }
    
    for(i in(1:nrow(col)))
    {
      for(j in (1:ncol(row)))
      {
        if(i!=j)
        {
          c<-df1[df1$V2==col[i,1],];
          d<-df1[df1$V2==row[1,j],];
          total <- rbind(c,d);
          f[i,j]<-sum(duplicated(total$V8));
          subtract[i,j]<-abs(f[i,i]-f[i,j]);
        }
      }
    }
    
    print('writing file')
    write.table(subtract, file=paste(k, "gain-subtract.txt", sep=""), sep="\t", col.names = F, row.names = F)
    
    #----clustering----
    df<-data.frame();
    row<-data.frame();
    col<-data.frame();
    win_sel <- win[win[,2]==k,];
    col2 <- win_sel[,3];
    row<-as.data.frame(t(col2));
    col<-as.data.frame(win_sel[,4]);
    
    for(i in 1:nrow(col))
    {
      for(j in 1:ncol(row))
      {
        df[i,j]<- abs(col[i,1]-row[1,j])
      }
    }
    ID<-win_sel[,1]
    df<-cbind(df, ID)
    subtract<-cbind(subtract, ID)
    df1<-merge(df,subtract,by="ID")
    df1$ID <- NULL;
    
    df_matrix <- as.matrix(df1)
    kNNdistplot(df_matrix, k=5)
    abline(h=4e7, col="red")
    db = dbscan(df_matrix, 4e7, 5)
    c<-db$cluster 
    c<-data.frame(df1,c) 
    write.table(c, file=paste(k, "DBSCAN-gain.txt", sep=""), sep="\t", col.names = F, row.names = F)
    #----clustering
    df1_new<-data.frame();
    newdf<-data.frame();
    c<-cbind(a=win_sel$Win.ID,c)
    c<-cbind(b=win_sel$Win_chr,c)
    c<-cbind(c=win_sel$Win_start,c)
    c<-cbind(d = c$c, c)
    
    df1_new<-as.data.frame(t(c$c))
    df1_new<-cbind(df1_new[,1:ncol(df1_new)],df1_new)
    newdf <- rbind(df1_new, c)
    
    #---uniuque part---
    a<-nrow(newdf)+4;
    b<-ncol(newdf);
    df1<-data.frame();
    df1<-newdf[,c(1,2,3,4,a:b)];
    #---distance part---
    df2<-data.frame();
    df2<-newdf[,c(1:a-1)];
    
    for(i in 2:nrow(df2)){
      df2[i,i+3] <- 0;
    }
    
    No_clus<-unique(df1$V4);
    score<-data.frame();
    all_cluster<-data.frame();
    for(m in 1:(length(No_clus)-1))
    {
      final<-data.frame();
      uniqness<-data.frame();
      score<-data.frame();
      c1<-data.frame();
      c2<-data.frame();
      c1<-df1[1,];
      c2 <- df1[df1[,4]==m,];
      
      
      uniqness<-rbind(c1,c2);
      uniq_total<-data.frame();
      for (i in 1:nrow(c2)) {
        for (j in 5:ncol(uniqness)) {
          if(uniqness[1,j]==c2[i,3])
          {
            b2<-uniqness[,j];
            uniq_total<-rbind(uniq_total,b2);
          }
        }
      }
      correlation<-data.frame();
      correlation<-uniq_total[,c(1)];
      
      correlation1<-as.data.frame(correlation)
      correaltion2<-data.frame();
      uniq_total[,1]<-NULL;
      res<-data.frame();
      for (l in 1:nrow(uniq_total)) 
      {
        sum<-0;
        for (n in 1:nrow(uniq_total))
        {
          if(n!=l)
          {
            f1<-uniq_total[l,1:nrow(uniq_total)];
            f2<-uniq_total[n,1:nrow(uniq_total)];
            f3<-as.numeric(as.factor(f1));
            f4<-as.numeric(as.factor(f2));
            res <- cor.test(f3, f4,method = "kendall");
            sum<-sum+res$estimate;
            correlation1[l,2] <- sum; 
          }
        }
        
      }
      for (k in 1:nrow(uniq_total)) 
      {
        
        score[k,1]<-(sum(uniq_total[k,])-(correlation1[k,2]));
        
      }
      final<-c2[,c(1,2,3,4)]; 
      final$V5 <- score$V1;
      all_cluster<-rbind(all_cluster,final);
      
    }
    
    #draw
    temp <- all_cluster;
    score$V2<-(-1)*(score$V1);
    all_cluster$V5<-(-1)*all_cluster$V5
    No_clus<-unique(all_cluster$V4)
    all_cluster$V6<-0;
    for(m in 1:(length(No_clus)))
    {
      c<-data.frame();
      s<-data.frame();
      selective<-data.frame();
      c<-all_cluster[all_cluster[,4]==m,];
      s<-c[order(-c$V5) , ];
      fraction <- 0.6*nrow(c);
      selective<-s[1:fraction,]
      
      for (i in 1:nrow(all_cluster)) {
        
        for (j in 1:nrow(selective)) {
          
          
          if(all_cluster[i,3]==selective[j,3])
          {
            all_cluster[i,6]<-1;
          }
          
          
        }
      }
      
      
    }
    write.table(all_cluster, file=paste(chr, "Selected-cnv-gain.txt", sep=""), sep="\t", col.names = F, row.names = F)
  }
  
}