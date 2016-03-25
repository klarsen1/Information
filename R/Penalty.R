#' (helper function) Calculate cross validation penalty
#' 
#' \code{penalty} returns the weighted cross validation penalty.
#' 
#' @param t training data (data.frame)
#' @param v valdation data (data.frame)
#' @param d_net_lift is it a net lift model? (1=yes, 0=no)
#' 
#' @importFrom  plyr join
#' @importFrom plyr numcolwise
#' @export penalty

penalty <- function(t, v, d_net_lift){
  n <- names(t)[1]
  v$inside_valid <- 1
  t$inside_train <- 1
  equal_rows <- (nrow(t)==nrow(v))
  same_rows <- FALSE
  if (equal_rows){
     same_rows <- (!(any(t[["key"]]==v[["key"]])==FALSE))     
  }
  if (same_rows==FALSE){
    # make v look like t
    v <- join(t[,c("inside_train", "key")], v, by="key", type="left")
    v[,sapply(v, is.numeric)] <- numcolwise(function(x) replace(x, is.na(x), 0))(v)
    # tag record that have validation buckets
    t <- join(t, v[,c("inside_valid", "key")], by="key", type="left")
    if (nrow(v)==0 | nrow(t)==0){
      t$PENALTY <- 0
    } else{
       if (d_net_lift==0){
          t$PENALTY <- stats::ave(abs(t$IV_weight)*abs(t$WOE-v$WOE)*t$inside_valid, FUN=cumsum)
       } else{
         t$PENALTY <- stats::ave(abs(t$NIV_weight)*abs(t$NWOE-v$NWOE)*t$inside_valid, FUN=cumsum)
       }
      t$inside_valid <- NULL
    }
  } else if (d_net_lift==0){
    t$PENALTY <- stats::ave(abs(t$IV_weight)*abs(t$WOE-v$WOE), FUN=cumsum)
  } else{
    t$PENALTY <- stats::ave(abs(t$NIV_weight)*abs(t$NWOE-v$NWOE), FUN=cumsum)
  }
  t$inside_train <- NULL
  return(t)  
}
