
#' (helper function) Calculate cross validation penalty
#' 
#' \code{is.binary} returns TRUE if a variable is binary, and FALSE otherwise
#' 
#' @param x a numeric vector
#' 
#' @export is.binary

is.binary <- function(x){
  unique = unique(x)
  if (!is.numeric(x) | any(is.na(x))){ 
    return(FALSE)
  } else {
    return(!(any(as.integer(unique) != unique) || length(unique) > 2 || min(x) != 0 || max(x) != 1))
  }
}
