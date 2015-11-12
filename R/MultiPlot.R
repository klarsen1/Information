#'  (helper function) Plot mutiple WOE vectors on one page
#' 
#' \code{MultiPlot} creates a multiple WOE or NWOE bar charts on the same page for a specified vector of variables. 
#' 
#' @param variables vector of variables that you want to compare
#' @param information_object object from the information package
#' @param same_scales set to TRUE if all plots should have the same limits on the y-axes (default is FALSE)
#' 
#' @importFrom grid pushViewport viewport grid.newpage grid.layout
#'
#' @export MultiPlot

MultiPlot <- function(information_object, variables, same_scales=FALSE) {
  
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
    plotlist[[i]] <- SinglePlot(information_object, variables[i])
    plotlist[[i]] <- plotlist[[i]] + ylab("") + theme(plot.title = element_text(size=8)) + theme(axis.ticks=element_blank(), axis.text.x=element_blank()) + xlab("")
    if (same_scales==TRUE){
      plotlist[[i]] <- plotlist[[i]] + ylim(min_woe, max_woe)
    }
  }
  
  numPlots = length(plotlist)

  if (length(variables)<=9){
    r <- ceiling(length(variables)/cols)
  } else{
    r <- ceiling(9/cols) 
  } 
  
  layout <- matrix(seq(1, cols * r),
                   ncol = cols, nrow = r)
  
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