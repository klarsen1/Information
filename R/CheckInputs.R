#' (helper function) Check user inputs and convert factors to characters. Provide readable reasons if errors are found.
#' 
#' \code{CheckInputs} Checks user inputs and converts factors to characters. Returns the altered dataframes as a list. 
#' Provides readable reasons if errors are found.
#' 
#' @param train training data.
#' @param valid validation dataset (default is NULL)
#' @param trt treatment indicator
#' @param y dependent variable
#'
#' @export CheckInputs

CheckInputs <- function(train, valid, trt, y){
  
  crossval <- TRUE
  if (is.null(valid)==TRUE){
    crossval <- FALSE
  }
  
  if (is.null(train)){
  }
  
  if (nrow(train)==0){
    stop("ERROR: no observations in the training dataset")    
  }
  
  if (length(class(train))>1){
    if (!("data.frame" %in% class(train)))
    stop("ERROR: training dataset has to be of type data.frame, tbl or tbl_df")
  } else if (class(train) != "data.frame"){
    if (class(train)=="")
    stop("ERROR: training dataset has to be of type data.frame, tbl or tbl_df")
  }  
  
  if (crossval==TRUE){
    if (length(names(train)) != length(names(valid))){
      stop("ERROR: validation and training datasets must have the same variables")
    }
    if (any(sort(names(train))==sort(names(valid)))==FALSE){
      stop("ERROR: validation and training datasets must have the same variables")
    }
    if (length(class(valid))>1){
      if (!("data.frame" %in% class(valid)))
        stop("ERROR: validation dataset has to be of type data.frame, tbl or tbl_df")
    } else if (class(valid) != "data.frame"){
      if (class(valid)=="")
        stop("ERROR: training dataset has to be of type data.frame, tbl or tbl_df")
    }  
    if (nrow(valid)==0){
      stop("ERROR: no observations in the validation dataset")    
    }
    if (!(y %in% names(valid))){
      stop(paste0("ERROR: dependent variable ", y, " not found in the input validation data frame"))    
    }
  }
  
  if (!(y %in% names(train))){
    stop(paste0("ERROR: dependent variable ", y, " not found in the input training data frame"))    
  }
  
  if (any(is.na(train[[y]]))){
    stop(paste0("ERROR: dependent variable ", y, " has NAs in the input training data frame"))        
  } 
  
  if (is.null(trt)==FALSE){
    if (!(trt %in% names(train))){
      stop(paste0("ERROR: treatment indicator ", trt, " not found in the input training data frame"))        
    }
    if (crossval==TRUE){
      if (!(trt %in% names(valid))){
        stop(paste0("ERROR: treatment indicator ", trt, " not found in the input validation data frame"))        
      }
    }
  }
  
  if (is.factor(train[[y]])){
    stop(paste0("ERROR: the dependent variable ", y, " is a factor in training dataset -- has to be numeric"))
  }  
  
  if (crossval==TRUE){
    if (is.factor(valid[[y]])){
      stop(paste0("ERROR: the dependent variable ", y, " is a factor in validation dataset -- has to be numeric"))
    }  
    if (is.character(valid[[y]])){
      stop(paste0("ERROR: the dependent variable ", y, " is a character variable in either the validation dataset. It has to be numeric"))
    }  
    if (!is.binary(valid[[y]])){
      stop(paste0("ERROR: the dependent variable has to be binary. Check your training and validation datasets."))
    }
    if (is.null(trt)==FALSE){
      if (!is.binary(valid[[trt]])){
        stop(paste0("ERROR: the treatment variable has to be binary. Check your training and validation datasets."))
      }
    }
    if (any(is.na(valid[[y]]))){
      stop(paste0("ERROR: dependent variable ", y, " has NAs in the input validation data frame"))        
    }
  }
  
  if (is.character(train[[y]])){
    stop(paste0("ERROR: the dependent variable ", y, " is a character variable in either the training dataset. It has to be numeric"))
  }  
  
  if (!is.binary(train[[y]])){
    stop(paste0("ERROR: the dependent variable has to be binary. Check your training and validation datasets."))
  }
  
  if (is.null(trt)==FALSE){
    if (is.factor(train[[trt]])==TRUE){
      stop(paste0("ERROR: the treatment indicator ", trt, " is a factor. It has to be numeric"))
    }
    if (is.character(train[[trt]])==TRUE){
      stop(paste0("ERROR: the treatment indicator ", trt, " is a character variable. It has to be numeric"))
    }
    if (!is.binary(train[[trt]])){
      stop(paste0("ERROR: the treatment indicator has to be binary. Check your training and validation datasets"))
    }
    if (any(is.na(train[[trt]]))){
      stop(paste0("ERROR: the treatment indicator ", trt, " has NAs in the input training data frame"))        
    } 
    if (crossval==TRUE){
      if (any(is.na(valid[[trt]]))){
        stop(paste0("ERROR: the treatment indicator ", trt, " has NAs in the input validation data frame"))        
      }
    }
  }  
  train <- as.data.frame(rapply(train, as.character, classes="factor", how="replace"), stringsAsFactors = FALSE)
  if (crossval==TRUE){
    valid <- as.data.frame(rapply(valid, as.character, classes="factor", how="replace"), stringsAsFactors = FALSE)
  }    
  n <- names(train)
  i <- NULL
  keep <- rep(TRUE, ncol(train))
  for (i in 1:ncol(train)){
    l <- length(unique(train[[i]]))
    c <- class(train[[i]])
    if (c=="Date"){
      print(paste0("Variable ", n[i], " was removed because it is a Date variable"))
      keep[i] <- FALSE
    } else{
      if (is.character(train[[i]])){
        if (l>1000){
          print(paste0("Variable ", n[i], " was removed because it is a non-numeric variable with >1000 categories"))
          keep[i] <- FALSE
        } else if (l==1){
          print(paste0("Variable ", n[i], " was removed because it has only 1 unique value"))
          keep[i] <- FALSE
        }
      } else if (l==1){
        print(paste0("Variable ", n[i], " was removed because it has only 1 unique level"))
        keep[i] <- FALSE
      }
    }
  }
  if (crossval==TRUE){
     return(list(train[,keep], valid))
  } else{
    return(list(train[,keep]))
  }
}
