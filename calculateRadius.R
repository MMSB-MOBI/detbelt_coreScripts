get_right_peak=function(y)
    {
        # add azero on the left
        Y_pos_offset=c(0,y[-length(y)])
        # add azero on the right
        Y_neg_offset=c(y[-1],0)
        # detect local maximum
        peaks=which(y>Y_pos_offset & y>Y_neg_offset)
        # get the rightmost peak
        # but ignore peaks that correspond to less than 1% of the data with & y>0.01
        return(max(which(y>Y_pos_offset & y>Y_neg_offset & y>0.01)))
    }

 get_highest_peak=function(y)
    {
        return(which.max(y))
    }   

X=read.table("squared_radii.txt")
colnames(X)="radius"
X$radius=sqrt(X$radius)
hist(X$radius)

# estimate density
D=density(X$radius)
protein_radius=D$x[get_right_peak(D$y)]
plot(D$x,D$y,main=paste("default density"))

# set bandwidth to avoid having very small peaks in the density
D=density(X$radius,bw=2)
protein_radius1=D$x[get_right_peak(D$y)]+1.66
protein_radius2=D$x[get_highest_peak(D$y)]+1.66
plot(D$x,D$y,main=paste("smoothed density, right peak=",format(protein_radius1,digits=2), ", highest peak=", format(protein_radius2,digits=2)))
abline(v=protein_radius1,col="green")
abline(v=protein_radius2,col="purple")


#library(ggplot2)
# Add y=..density.. to scale to density
#ggplot(X,aes(radius))+geom_histogram(aes(y=..density..))+geom_vline(xintercept=protein_radius, col="red")+geom_density()

protein_radius=protein_radius2

Vol=scan("Volume_total.txt",what=double())
H=scan("Thickness.txt",what=double())

belt_radius=sqrt(Vol/(pi*H)+protein_radius^2)

result=data.frame(name=character(),value=numeric())
result=rbind(result,data.frame(name="protein_radius",value=protein_radius))
result=rbind(result,data.frame(name="belt_radius",value=belt_radius))

write.table(result,file="radius.txt",quote=FALSE,row.names=F, col.names=F)
