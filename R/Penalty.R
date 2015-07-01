#' Calculate cross validation penalty
#' 
#' \code{penalty} returns the weighted cross validation penalty.
#' 
#' @param t training data (data.frame)
#' @param v valdation data (data.frame)
#' @param d_net_lift is it a net lift model? (1/0)
#' 
#' @export penalty

penalty <- function(t, v, d_net_lift){
  if (nrow(t) != nrow(v)){
    t$PENALTY <- 0
  } else if (d_net_lift==0){
    t$PENALTY <- ave(abs(t$IV_weight)*abs(t$WOE-v$WOE), FUN=cumsum)
  } else{
    t$PENALTY <- ave(abs(t$NIV_weight)*abs(t$NWOE-v$NWOE), FUN=cumsum)
  }
  return(t)  
}
