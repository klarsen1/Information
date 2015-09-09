#' Create WOE/NWOE tables and rank variables by IV/NIV
#' 
#' \code{CreateTables} returns WOE or NWOE tables (as data.frames), and a data.frame with IV or NIV values for all
#' predictive variables. 
#' 
#' @param data input dataset for analysis (this is typically your training dataset)
#' @param valid validation dataset (default is NULL)
#' @param y dependent variable
#' @param bins number of bins (default is 10)
#' @param trt binary treatment variable (for net lift modeling -- i.e., NWOE and NIV). Default is NULL (for standard WOE and IV)
#' @param ncore number of cores used. Default is to use detectcores-1.
#' 
#' @import foreach
#' @import parallel
#' @import doParallel
#'
#' @export CreateTables
#' @examples  
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' IV$Summary
#' IV$Tables$N_OPEN_REV_ACTS
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' NIV <- CreateTables(data=train, trt=TREATMENT, y="PURCHASE")
#' NIV$Summary
#' NIV$Tables$N_OPEN_REV_ACTS
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' data(validation, package="Information")
#' NIV <- CreateTables(data=train, valid=validation, trt=TREATMENT, y="PURCHASE")
#' NIV$Summary
#' NIV$Tables$N_OPEN_REV_ACTS


CreateTables <- function(data, valid=NULL, y, bins=10, trt=NULL, ncore=NULL){

  comb <- function(x, ...) {
    lapply(seq_along(x),
           function(i) c(x[[i]], lapply(list(...), function(y) y[[i]])))
  }
  
  ### If no validation dataset, no cross validation
  crossval <- TRUE
  if (is.null(valid)){
    crossval <- FALSE
  }

  ### Check inputs
  c <- CheckInputs(data, valid, trt, y)
  data <- c[[1]]
  if (crossval==TRUE){
    valid <- c[[2]]
  }
      
  ### Set up output containers  
  variables <- names(data)[!(names(data) %in% c(trt, y))]
  d_netlift <- 0 # net lift indicator. This triggers different metrics
  if (is.null(trt)==FALSE){
    d_netlift <- 1
  }
  
  if (is.null(ncore)){
     ncore <- parallel::detectCores()-1
  } 
  
  if (ncore<1) ncore <- 1
  
  registerDoParallel(ncore)
  
  ### Loop through variables
  loopResult <- foreach(i=1:length(variables), .combine='comb', .multicombine=TRUE,
                       .init=list(list(), list())) %dopar% {
    
    data$var <- data[[variables[i]]]
    cuts <- NULL
    if (crossval==TRUE){
      valid$var <- valid[[variables[i]]]
      if (is.character(data[[variables[i]]]) != is.character(valid[[variables[i]]])){
        stop(paste0("ERROR: Variable type mismatch for ", variables[i], " (one is a character and the other is not.)"))
      }
      if (is.factor(data[[variables[i]]]) != is.factor(valid[[variables[i]]])){
        stop(paste0("ERROR: Variable type mismatch for ", variables[i], " (one is a factor and the other is not.)"))
      }
      if (is.character(data[[variables[i]]])==FALSE & is.factor(data[[variables[i]]])==FALSE){
        cuts <- unique(quantile(data[[variables[i]]], probs=c(1:(bins-1)/bins), na.rm=TRUE, type=3))  
      }
    }
    if (is.character(data[[variables[i]]])==FALSE){
      cuts <- unique(quantile(data[[variables[i]]], probs=c(1:(bins-1)/bins), na.rm=TRUE, type=3))  
    }
    summary_train <- Aggregate(data, variables[i], y, cuts, trt)
    if (crossval==TRUE){
       summary_valid <- Aggregate(valid, variables[i], y, cuts, trt)
    }
    if (d_netlift==0){
      woe_train <- WOE(summary_train, variables[i])
      if (crossval==TRUE){
        woe_valid <- WOE(summary_valid, variables[i])
      }
      if (crossval==TRUE){
        woe_train <- penalty(woe_train, woe_valid, 0)
      }
      woe_train[,c("IV_weight")] <- NULL
      strength <- data.frame(variables[i], woe_train[nrow(woe_train),"IV"])
      names(strength) <- c("Variable", "IV")
      if (crossval==TRUE){
        strength$PENALTY <- woe_train[nrow(woe_train),"PENALTY"]
        strength$AdjIV <- strength$IV - strength$PENALTY
      }
    } else{
      nwoe_train <- NWOE(summary_train, variables[i])      
      if (crossval==TRUE){
        nwoe_valid <- NWOE(summary_valid, variables[i])   
      }
      if (crossval==TRUE){
        nwoe_train <- penalty(nwoe_train, nwoe_valid, 1)
      }
      nwoe_train[,c("NIV_weight")] <- NULL
      strength <- data.frame(variables[i], nwoe_train[nrow(nwoe_train),"NIV"])
      names(strength) <- c("Variable", "NIV")
      if (crossval==TRUE){
        strength$PENALTY <- nwoe_train[nrow(nwoe_train),"PENALTY"]
        strength$AdjNIV <- strength$NIV - strength$PENALTY
      }
    }    
    if (d_netlift==1){
      list(nwoe_train, strength)
    } else{
      list(woe_train, strength)
    }
  }
  
  tables <- loopResult[[1]]
  stats <- data.frame(rbindlist(loopResult[[2]]))
  
  ### Sort by adjusted IV/NIV, or raw IV/NIV
  if (crossval==TRUE){
     if (d_netlift==0){
       stats <- stats[order(-stats$AdjIV),]
     } else{
       stats <- stats[order(-stats$AdjNIV),]    
     }
  } else{
    if (d_netlift==0){
      stats <- stats[order(-stats$IV),]
    } else{
      stats <- stats[order(-stats$NIV),]    
    }
  }
  
  ### Return the results
  stats$Variable <- as.character(stats$Variable)
  names(tables) <- variables
  object <- list(Tables=tables, Summary=stats)
  class(object) <- "Information"
  return (object)

}
