#' (helper function )Aggregate data for WOE/NWOE calculations
#' 
#' \code{Aggregate} returns aggregated data for the WOE and NWOE functions
#' 
#' @param data input data frame 
#' @param x variable to be aggregated
#' @param y dependent variable
#' @param breaks breaks for binning
#' @param trt binary treatment variable (for net lift only)
#' 
#' @import data.table
#' 
#' @export Aggregate

Aggregate <- function(data, x, y, breaks, trt){  
  
  var <- Group <- n <- y_1 <- y_0 <- t_1 <- t_0 <- y_1_t <- y_0_t <- y_1_c <- y_0_c <- NULL

  data$y_1 <- data[[y]]
  data$y_0 <- ifelse(data$y_1==1, 0, 1)  
  data$n <- 1
  if (is.null(trt)==FALSE){
    data$t_1 <- ifelse(data[,trt]==1, 1, 0)
    data$t_0 <- ifelse(data[,trt]==0, 1, 0)    
    data$y_1_t <- ifelse(data[,y]==1 & data[,trt]==1, 1, 0) 
    data$y_0_t <- ifelse(data[,y]==0 & data[,trt]==1, 1, 0)
    data$y_1_c <- ifelse(data[,y]==1 & data[,trt]==0, 1, 0)
    data$y_0_c <- ifelse(data[,y]==0 & data[,trt]==0, 1, 0)      
  }
  if (is.character(data[[x]])==FALSE & is.factor(data[[x]])==FALSE){    
    if (length(breaks)==1){
      if (breaks==max(data[[x]], na.rm=TRUE)){
         data$Group <- findInterval(data[[x]], breaks, rightmost.closed=FALSE)
      } else{
        data$Group <- findInterval(data[[x]], breaks, rightmost.closed=TRUE)
      }
    } else{
      data$Group <- findInterval(data[[x]], breaks)
    }
    data <- data.table(data)
    setkey(data, Group)    
  } else{
    data$Group <- data[[x]]
    data <- data.table(data)
    setkey(data, Group)    
  }
  
  if (is.null(trt)==TRUE){
    if (is.character(data[[x]])==FALSE & is.factor(data[[x]])==FALSE){
      t <- as.data.frame(data[,list(sum(n), sum(y_1), sum(y_0), min(var), max(var)), by=Group])
      names(t) <- c("Group", "N", "y_1", "y_0", "Min", "Max")   
      t <- t[,c("Group", "N", "y_1", "y_0", "Min", "Max")]
    } else{
      t <- as.data.frame(data[,list(sum(n), sum(y_1), sum(y_0)), by=Group])
      names(t) <- c("Group", "N", "y_1", "y_0")      
    }  
  } else{
    if (is.character(data[[x]])==FALSE & is.factor(data[[x]])==FALSE){
      t <- as.data.frame(data[,list(sum(n), sum(t_1), sum(t_0),  
                                    sum(y_1_t), sum(y_0_t), 
                                    sum(y_1_c), sum(y_0_c), 
                                    min(var), max(var)),
                              by=Group])
      names(t) <- c("Group", "N", "Treatment", "Control", "y_1_t", "y_0_t", "y_1_c", "y_0_c", "Min", "Max")     
      t <- t[,c("Group", "N", "Treatment", "Control", "y_1_t", "y_0_t", "y_1_c", "y_0_c", "Min", "Max")]
    } else{
      t <- as.data.frame(data[,list(sum(n), sum(t_1), sum(t_0),  
                                    sum(y_1_t), sum(y_0_t), 
                                    sum(y_1_c), sum(y_0_c)), by=Group])
      names(t) <- c("Group", "N", "Treatment", "Control", "y_1_t", "y_0_t", "y_1_c", "y_0_c")      
    }      
  }
  
  ## create the bin labels and a match key
  if (is.character(data[[x]]) | is.factor(data[[x]])){
    t[,x] <- t$Group
    t[,"key"] <- t$Group
    t$key <- ifelse(t$key=="", "_BLANK_", t$key)
  } else{
    anyna <- 0
    for (i in 1:nrow(t)){
      if (is.na(t[i,1])){
        anyna <- 1
        t[i,x] <- "NA"
        t[i,"key"] <- "NA"
      } else{
        t[i,x] <- paste0("[",round(t[i,"Min"],2),",",round(t[i,"Max"],2),"]")
        t[i,"key"] <- as.character(t[i,"Group"])
      }
    }
  }  
  t$Group <- NULL
  t$Percent <- t$N/sum(t$N)
  return(t)
}
