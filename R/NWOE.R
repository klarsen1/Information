#' Create WOE table (helper function)
#' 
#' \code{WOE} returns NWOE tables from a data.frame prepared by Information::Aggregate(). This is only for net lift models.
#' 
#' @param t table prepared by the Aggregate function
#' @param x variable
#' 
#' @importFrom stats ave
#'
#' @export NWOE

NWOE <- function(t, x){
  sum_y_1_t <- sum(t$y_1_t)
  sum_y_0_t <- sum(t$y_0_t)
  sum_y_1_c <- sum(t$y_1_c)
  sum_y_0_c <- sum(t$y_0_c)  
  t$WOE_t <- ifelse(t$y_1_t>0 & t$y_0_t>0, log((t$y_1_t*sum_y_0_t)/(t$y_0_t*sum_y_1_t)), 0)  
  t$WOE_c <- ifelse(t$y_1_c>0 & t$y_0_c>0, log((t$y_1_c*sum_y_0_c)/(t$y_0_c*sum_y_1_c)), 0) 
  t$NWOE <- t$WOE_t - t$WOE_c
  #t$NWOE <- t$NWOE - mean(t$NWOE)
  t$NIV_weight <- (t$y_1_t/sum_y_1_t)*(t$y_0_c/sum_y_0_c) - (t$y_0_t/sum_y_0_t)*(t$y_1_c/sum_y_1_c)
  C <- 10
  t$NIV_weight <- t$NIV_weight * C
  t$NIV_row <- t$NWOE * t$NIV_weight 
  t$NIV <- ave(t$NIV_row, FUN=cumsum)
  t <- t[,c(x, "Percent", "Treatment", "Control", "NWOE", "WOE_t", "WOE_c", "NIV", "NIV_weight", "key")]
  return(t)
}
