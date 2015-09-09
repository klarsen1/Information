#' Plot a WOE vector
#' 
#' \code{PlotWOE} creates a bar chart of the WOE pattern for a specified variable 
#' 
#' @param information_object object from the information package
#' @param variable variable for which we want to see the WOE pattern
#' @param show_values do you want to show values on the bar chart? Default is FALSE
#' 
#' @import ggplot2
#'
#' @export PlotWOE
#' @examples  
#' ##------------------------------------------------------------
#' ## WOE plot, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' PlotWOE(IV, "N_OPEN_REV_ACTS")

PlotWOE <- function(information_object, variable, show_values=FALSE){
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