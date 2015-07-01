#' @title WOE/NWOE Analysis
#'
#' @details  
#' Given a data.frame with a set of predictive variables and 
#' a binary response variable, Information::CreateTables() will cycle through all variables and create
#' NWOE or WOE tables. It will also rank all variables by their respective NIV/IV values. 
#' 
#' For NWOE analysis, you must have a "treatment" and a conrol group, identified by a binary treatment indicator.
#' For regular WOE analysis, all you need is a binary response variable (dependent variable).
#' 
#' You can cross validate your IV or NIV values by supplying a validation data.frame. CreateTables() cross
#' validated by calculating the penalized IV/NIV values. 
#'
#' @author Kim Larsen (kblarsen4 _at_ gmail.com)
#' @keywords WOE, NWOE, NIV, logistc regression
#' @docType package
#' @description 
#' Information creates WOE/NWOE tables, and ranks variables by IV/NIV
#'
#' @name Information
#' @examples 
#' The only function you will need to call is CreateTables(). 
#' CreateTables() creates WOE/NWOE tables (accessed by
#' Tables$<variable name>) and outputs a data.frame that 
#' contains IV or NIV for all variables.
#' IV and NIV values are found in the Summary data.frame. 
#'
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y=PURCHASE)
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

NULL