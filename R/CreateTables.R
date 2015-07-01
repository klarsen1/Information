#' Create WOE/NWOE tables and rank variables by IV/NIV
#' 
#' \code{CreateTables} returns WOE or NWOE tables (as data.frames), and a data.frame with IV or NIV values for all
#' predictive variables. 
#' 
#' @param data input dataset for analysis (this is typically your training dataset)
#' @param valid validation dataset (default is NULL)
#' @param y dependent variable
#' @param bins number of bins (default is 10)
#' @param trt binary treatment variable (for net lift modeling). Default is NULL
#' @export CreateTables
#' @examples  
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=, y=PURCHASE)
#' View(IV$Summary)
#' IV$Tables$N_OPEN_REV_ACTS
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' NIV <- CreateTables(data=train, trt=TREATMENT, y=PURCHASE)
#' View(NIV$Summary)
#' NIV$Tables$N_OPEN_REV_ACTS
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' data(validation, package="Information")
#' NIV <- CreateTables(data=train, valid=validation, trt=TREATMENT, y=PURCHASE)
#' View(NIV$Summary)
#' NIV$Tables$N_OPEN_REV_ACTS

CreateTables <- function(data, valid=NULL, y, bins=10, trt=NULL){

  ### If no validation dataset, no cross validation
  crossval <- TRUE
  if (is.null(valid)){
    crossval <- FALSE
  }

  ### Check inputs
  CheckInputs(data, valid, trt, y, crossval)
      
  ### Set up output containers  
  variables <- names(data)[!(names(data) %in% c(trt, y))]
  d_netlift <- 0 # net lift indicator. This triggers different metrics
  if (is.null(trt)==FALSE){
    d_netlift <- 1
  }  
  tables <- list(length=length(variables)) # List to hold WOE/NWOE tables
  if (crossval==TRUE){
    c <- 4
  } else{
    c <- 2
  }
  stats <- data.frame(matrix(nrow=length(variables), ncol=c)) # data.frame to hold summary stats
  if (crossval==TRUE){
    if (d_netlift==0){
      names(stats) <- c("Variable", "IV", "PENALTY", "AdjIV")
    } else{
      names(stats) <- c("Variable", "NIV", "PENALTY", "AdjNIV")    
    }
  } else{
    if (d_netlift==0){
      names(stats) <- c("Variable", "IV")
    } else{
      names(stats) <- c("Variable", "NIV")    
    }
  }
  
  ### Loop through variables
  for (i in 1:length(variables)){
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
      tables[[i]] <- woe_train
      stats[i,"Variable"] <- variables[i]
      stats[i,"IV"] <- woe_train[nrow(woe_train),"IV"]
      if (crossval==TRUE){
        stats[i,"PENALTY"] <- woe_train[nrow(woe_train),"PENALTY"]
        stats[i,"AdjIV"] <- stats[i,"IV"] - stats[i,"PENALTY"]
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
      tables[[i]] <- nwoe_train
      stats[i,"Variable"] <- variables[i]
      stats[i,"NIV"] <- nwoe_train[nrow(nwoe_train),"NIV"]
      if (crossval==TRUE){
        stats[i,"PENALTY"] <- nwoe_train[nrow(nwoe_train),"PENALTY"]
        stats[i,"AdjNIV"] <- stats[i,"NIV"] - stats[i,"PENALTY"]
      }
    }    
  }
  
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
  names(tables) <- variables
  object <- list(Tables=tables, Summary=stats)
  class(object) <- "Information"
  return (object)

}
