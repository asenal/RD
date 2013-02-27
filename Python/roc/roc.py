import sys,os
here=os.getcwd()

from pyroc import *
random_sample  = random_mixture_model()  
# Generate a custom set randomly
#Example instance labels (first index) with the decision function , score (second index)

#-- positive class should be +1 and negative 0.
roc = ROCData(random_sample)  #Create the ROC Object
roc.auc() #get the area under the curve
roc.plot(title='ROC Curve') #Crea


x = random_mixture_model()
r1 = ROCData(x)
y = random_mixture_model()
r2 = ROCData(y)
lista = [r1,r2]
plot_multiple_roc(lista,'Multiple ROC Curves',include_baseline=True)
