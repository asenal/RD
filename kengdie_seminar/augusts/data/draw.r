fly_exon_1024_int=as.matrix(read.table('fly/fly_exon_1024_int.txt'))
plot(fly_exon_1024_int[,2],col=1)
lines(fly_exon_1024_int[,3],col=2)		
lines(fly_exon_1024_int[,4],col=2)		

fly_exon_1024_float=as.matrix(read.table('fly/fly_exon_1024_float.txt'))
plot(fly_exon_1024_float[,2],col=1)
lines(fly_exon_1024_float[,3],col=2)		
lines(fly_exon_1024_float[,4],col=2)		
