
a_40=simHMM(hmm,40)
f_40=forward(hmm,a_40$observation)
b_40=backward(hmm,a_40$obvervation)
b_40=backward(hmm,a_40$observation)
lala_40=baumWelch(hmm,a_40$observation)
				
a_400=simHMM(hmm,400)
f_400=forward(hmm,a_400$observation)
b_400=backward(hmm,a_400$obvervation)
b_400=backward(hmm,a_400$observation)
lala_400=baumWelch(hmm,a_400$observation)

par(mfg=c(2,2))

plot(f_40[1,],col=1,cex=0.2,main="40 samples",xlab="steps",ylab="log prob",pch="")
lines(f_40[1,],col=1)				
lines(f_40[2,],col=2)				
lines(b_40[1,],col=3)				
lines(b_40[2,],col=4)				
legend("top",c("f_40-1","f_40-2","b_40-1","b_40-2"),col=c(1:4),lty=rep(1,4),pt.cex=0.2)				

plot(f_400[1,],col=1,cex=0.2,main="400 samples",xlab="steps",ylab="log prob",pch="")
lines(f_400[1,],col=1)				
lines(f_400[2,],col=2)				
lines(b_400[1,],col=3)				
lines(b_400[2,],col=4)				
legend("top",c("f_400-1","f_400-2","b_400-1","b_400-2"),col=c(1:4),lty=rep(1,4),pt.cex=0.2)				
				
plot(f_400[1,][181:220],col=1,cex=0.2,main="40 out of 400 samples",xlab="steps",ylab="log prob",pch="",axis(1,c(1:40),c(181:220)))
lines(f_400[1,][181:220],col=1)				
lines(f_400[2,][181:220],col=2)				
lines(b_400[1,][181:220],col=3)				
lines(b_400[2,][181:220],col=4)				
legend("top",c("f_400-1","f_400-2","b_400-1","b_400-2"),col=c(1:4),lty=rep(1,4),pt.cex=0.2)				

lines(f_40[1,],col=1,cex=0.2)
lines(f_40[2,],col=2)				

