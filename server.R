library(shiny)
library(gtools)
library(Rsolnp)
library(shinythemes)

shinyServer(
function(input, output) {

NPK<-read.table("Sources.txt", sep=",", head=FALSE)
colnames(NPK)<-c("NPK", "N", "P", "K", "S")
comb<-combinations(10,2,as.matrix(NPK[,1]))
comb<-as.data.frame(comb)
colnames(comb)<-c("Fert1", "Fert2")

observe<-observeEvent(input$generate,{
	MSE <- function(x){
		((input$N-(NPK[index1,"N"]*x[1]+NPK[index2,"N"]*x[2]))^2+
		(input$P-(NPK[index1,"P"]*x[1]+NPK[index2,"P"]*x[2]))^2+
		(input$K-(NPK[index1,"K"]*x[1]+NPK[index2,"K"]*x[2]))^2
		)/3
	}

	constr <- function(x){x[1]+x[2]}

	i=0
	for(i in i:nrow(comb)){
		i=i+1
		if(i==nrow(comb)+1){break}
		index1<-NPK$NPK %in% comb$Fert1[i]
		index2<-NPK$NPK %in% comb$Fert2[i]
		solve<-solnp(pars=c(0.5,0.5), fun=MSE, eqfun=constr, eqB=1, LB=c(0,0), UB=c(1,1))
		comb[i, "perc1"]=solve$pars[1]
		comb[i, "perc2"]=solve$pars[2]
		comb[i, "MSE"]=solve$values[3]
	}

	i=0
	df1<-data.frame(one="", two="", three="", stringsAsFactors = FALSE)
	colnames(df1)<-c("Fertilizer", "NPKS formula", "mt")
	df2<-data.frame(N="", P="", K="", S="", stringsAsFactors = FALSE)
	for(i in i:2){
		if(i==3){break}
		emin<-with(comb, which(MSE==-sort(-MSE, partial=length(MSE)-i)[length(MSE)-i]))
		df1[i*2+1,]<-rbind(c("Fertilizer 1"), c(paste(comb[emin,"Fert1"])), c(round(comb[emin,"perc1"]*input$vol, digits=3)))
		df1[i*2+2,]<-rbind(c("Fertilizer 2"), c(paste(comb[emin,"Fert2"])), c(round(comb[emin,"perc2"]*input$vol, digits=3)))
		df2[i+1,]<-rbind(
		round(NPK$N[NPK$NPK %in% comb[emin, "Fert1"]]*comb[emin, "perc1"] + NPK$N[NPK$NPK %in% comb[emin, "Fert2"]]*comb[emin, "perc2"], digits=1), 
		round(NPK$P[NPK$NPK %in% comb[emin, "Fert1"]]*comb[emin, "perc1"] + NPK$P[NPK$NPK %in% comb[emin, "Fert2"]]*comb[emin, "perc2"], digits=1),
		round(NPK$K[NPK$NPK %in% comb[emin, "Fert1"]]*comb[emin, "perc1"] + NPK$K[NPK$NPK %in% comb[emin, "Fert2"]]*comb[emin, "perc2"], digits=1),
		round(NPK$S[NPK$NPK %in% comb[emin, "Fert1"]]*comb[emin, "perc1"] + NPK$S[NPK$NPK %in% comb[emin, "Fert2"]]*comb[emin, "perc2"], digits=1)
		)
		i=i+1
	}
	
output$table_1.1 <- renderTable({df1[1:2,]})
output$table_1.2 <- renderTable({df2[1,]})
output$table_2.1 <- renderTable({df1[3:4,]})
output$table_2.2 <- renderTable({df2[2,]})
output$table_3.1 <- renderTable({df1[5:6,]})
output$table_3.2 <- renderTable({df2[3,]})

})
}

)
