#' @title Data exploration with information theory (weight-of-evidence and information value)
#'
#' @details  
#' Given a data.frame with a set of predictive variables and 
#' a binary response variable, Information::create_infotables() will cycle through all variables and create
#' NWOE or WOE tables. It will also rank all variables by their respective NIV/IV values. 
#' 
#' Calculations will be distributed across multiple cores.
#' 
#' NWOE analysis is only for uplift models. Thus, for NWOE analysis, you must have a "treatment" and a conrol group identified by a binary treatment indicator.
#' For regular WOE analysis, all you need is a binary response variable (dependent variable).
#' 
#' You can cross validate your IV or NIV values by supplying a validation dataset. This will produce penalized IV/NIV values.
#'
#'#' To learn more about Information, start with the vignette:
#' \code{browseVignettes(package = "Information")}
#' 
#' @author Kim Larsen (kblarsen4 at gmail.com)
#' @keywords WOE, NWOE, NIV, IV, classification, weight-of-evidence, uplift
#' @docType package
#' @description 
#' The information package is designed to perform exploratory data analysis and variable screening for binary 
#' classification models using WOE and IV. The package also supports exploratory analysis and variable screening
#' for uplift models (NWOE and NIV).
#' 
#' Note that the only functions you will need to call are create_infotables() and plot_infotables():
#'  
#'   - create_infotables() creates WOE or NWOE tables and outputs a variable-strength summary data.frame (IV or NIV)
#' 
#'   - plot_infotables() creates WOE or NWOE bar charts for one or more variables

#'
#' @name Information
#' @examples 
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' library(Information)
#' 
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)[1:1000,]
#' IV <- Information::create_infotables(data=train, y="PURCHASE", parallel=FALSE)
#' 
#' print(head(IV$Summary), row.names=FALSE)
#' print(IV$Tables$N_OPEN_REV_ACTS, row.names=FALSE)
#' 
#' # Plotting a single variable
#' Information::plot_infotables(IV, "N_OPEN_REV_ACTS")
#' 
#' # Plotting multiple variables
#' Information::plot_infotables(IV, IV$Summary$Variable[1:4], same_scale=TRUE)
#' 
#' closeAllConnections()

NULL