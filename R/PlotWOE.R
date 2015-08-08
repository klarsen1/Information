#' Plot a WOE vector
#' 
#' \code{PlotWOE} creates a bar chart of the WOE pattern for a specified variable 
#' 
#' @param tables list object from the information package
#' @param variable variable for which we want to see the WOE pattern
#' 
#' @import ggplot2
#'
#' @export PlotWOE
#' @examples  
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' PlotWOE(IV, "N_OPEN_REV_ACTS")

PlotWOE <- function(object, variable){
  df <- object[["Tables"]][[variable]]
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
  ggplot(data=df, aes(x=xvar, y=yvar)) + geom_bar(stat="identity", position = "identity") + xlab(variable) + ylab(type)
}