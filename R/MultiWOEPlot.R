#' Plot mutiple WOE vectors on one page
#' 
#' \code{MultiPlotWOE} creates a multiple WOE bar charts on the same page for a specified vector of variables. 
#' Multiple pages will be created if needed (9 plots per page). 
#' 
#' @param variables vector of variables that you want to compare
#' @param information_object object from the information package
#' @param same_scale should all plots have the same limits on the y-axes (default is FALSE)
#' 
#' @import grid
#'
#' @export MultiPlotWOE
#' @examples  
#' ##------------------------------------------------------------
#' ## WOE plots
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' # Plotting two variables
#' MultiPlotWOE(IV, c("N_OPEN_REV_ACTS", "AGE"))
#' # Plotting all variables with IV>0.1
#' MultiPlotWOE(IV, subset(IV$Summary, IV>0.1)$Variable)

MultiPlotWOE <- function(information_object, variables, same_scale=FALSE) {
  
  cols <- ceiling(length(variables)/3)
  if (cols>3) {cols <- 3}
  
  woe_tables <- information_object$Tables[variables]

  min_woe <- 0
  max_woe <- 0
  
  metric <- "WOE"
  if ("NWOE" %in% names(woe_tables[[1]])){
    metric <- "NWOE"
  }
  
  for (i in 1:length(variables)){
    if (min(woe_tables[[i]][[metric]]) < min_woe){min_woe <- min(woe_tables[[i]][[metric]])}
    if (max(woe_tables[[i]][[metric]]) > max_woe){max_woe <- max(woe_tables[[i]][[metric]])}
  }
  
  plotlist <- list()
  for (i in 1:length(variables)){
    iv <- 
    plotlist[[i]] <- PlotWOE(information_object, variables[i])
    plotlist[[i]] <- plotlist[[i]] + ylab("") + theme(plot.title = element_text(size=8)) + theme(axis.ticks=element_blank(), axis.text.x=element_blank()) + xlab("")
    if (same_scale==TRUE){
      plotlist[[i]] <- plotlist[[i]] + ylim(min_woe, max_woe)
    }
  }
  
  numPlots = length(plotlist)
  
  layout <- matrix(seq(1, cols * ceiling(9/cols)),
                   ncol = cols, nrow = ceiling(9/cols))
  
  if (numPlots==1) {
    print(plotlist[[1]])
  } else {
    
    pages <- ceiling(numPlots/9)
    
    k <- 0
    for (j in 1:pages){
       grid.newpage()
       pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
       if (j==pages){
         subplots <- numPlots - k
       } else{
         subplots <- 9
       }
       for (i in 1:subplots) {
         matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
         k <- k + 1
         print(plotlist[[k]], vp = viewport(layout.pos.row = matchidx$row,
                                         layout.pos.col = matchidx$col))
      }
    }
  }
}