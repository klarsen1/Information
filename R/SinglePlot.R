#' (helper function) Plot a WOE or NWOE vector
#' 
#' \code{SinglePlot} creates a bar chart of the WOE or NWOE pattern for a specified variable 
#' 
#' @param information_object object from the information package
#' @param variable variable for which we want to see the WOE pattern
#' @param show_values if set to TRUE, values will be displayed on the bar chart (default is FALSE)
#' 
#' @importFrom ggplot2 geom_bar aes xlab ylab ggtitle geom_text ggplot theme element_text element_blank ylim
#'
#' @export SinglePlot

SinglePlot <- function(information_object, variable, show_values=FALSE){
  
  xvar <- yvar <- NULL
  
  df <- information_object[["Tables"]][[variable]]
  orderlist <- df[[variable]]
  df$xvar <- df[[variable]]
  type <- "WOE"
  if ("NWOE" %in% names(df)){
    df$yvar <- df$NWOE
    type <- "NWOE"
  } else{
    df$yvar <- df$WOE
  }
  df <- transform(df, xvar=factor(xvar, levels=orderlist))
  if (show_values==FALSE){
     ggplot(data=df, aes(x=xvar, y=yvar)) + geom_bar(stat="identity", position = "identity") + xlab("") + ylab(type) + ggtitle(variable)
  } else{
    ggplot(data=df, aes(x=xvar, y=yvar)) + geom_bar(stat="identity", position = "identity", fill="gray70") + xlab("") + ylab(type) + ggtitle(variable) + geom_text(aes(label = round(yvar, 2)), size=4)
  }
}