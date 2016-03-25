#' Create WOE tables from aggregated data (helper function)
#' 
#' \code{WOE} returns WOE tables from data frames prepared by Aggregate()
#' 
#' @param t table prepared by the Aggregate function
#' @param x variable
#' 
#' @importFrom stats ave
#' 
#' @export WOE


WOE <- function(t, x){
  sum_y_1 <- sum(t$y_1)
  sum_y_0 <- sum(t$y_0)  
  t$WOE <- ifelse(t$y_1>0 & t$y_0>0, log((t$y_1*sum_y_0)/(t$y_0*sum_y_1)), 0)  
  t$IV_weight <- t$y_1/sum_y_1 - t$y_0/sum_y_0
  t$IV_row <- t$WOE * t$IV_weight 
  t$IV <- ave(t$IV_row, FUN=cumsum)
  t <- t[,c(x, "N", "Percent", "WOE", "IV", "IV_weight", "key")]
  return(t)
}
