#' @title WOE/NWOE Analysis
#'
#' @details  
#' Given a data.frame with a set of predictive variables and 
#' a binary response variable, Information::CreateTables() will cycle through all variables and create
#' NWOE or WOE tables. It will also rank all variables by their respective NIV/IV values. 
#' 
#' Calculations will be distributed across multiple cores.
#' 
#' NWOE analysis is only for uplift models. Thus, for NWOE analysis, you must have a "treatment" and a conrol group identified by a binary treatment indicator.
#' For regular WOE analysis, all you need is a binary response variable (dependent variable).
#' 
#' You can cross validate your IV or NIV values by supplying a validation data.frame. This will produce penalized IV/NIV values.
#'
#' @author Kim Larsen (kblarsen4 at gmail.com)
#' @keywords WOE, NWOE, NIV, logistc regression, information theory, weight of evidence, weight-of-evidence, uplift modeling
#' @docType package
#' @description 
#' The information package is designed to perform exploratory data analysis and variable screening for binary 
#' classification models using WOE and IV. The package also supports exploratory analysis and variable screening
#' for uplift models (NWOE and NIV).
#'
#' @name Information
#' @examples 
#' The only functions you will need to call are CreateTables(), PlotWOE() and MultiPlotWOE() 
#' CreateTables() creates WOE/NWOE tables (accessed by
#' Tables$<variable name>) and outputs a data.frame that 
#' contains IV or NIV for all variables.
#' IV and NIV values are found in the Summary data.frame. 
#' 
#' PlotWOE() plots the WOE vector for a sigle variable
#' 
#' MultiPlotWOE() plots WOE vectors for multiple variables on a single page. Multiple pages will be created
#' if needed (9 plots per page). 
#'
#' ##------------------------------------------------------------
#' ## WOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' print(head(IV$Summary), row.names=FALSE)
#' print(IV$Tables$N_OPEN_REV_ACTS, row.names=FALSE)
#' 
#' ##------------------------------------------------------------
#' ## WOE plots
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' train <- subset(train, TREATMENT==1)
#' IV <- CreateTables(data=train, y="PURCHASE")
#' MultiPlotWOE(IV, IV$Summary$Variable[1:18])
#' PlotWOE(IV, "N_OPEN_REV_ACTS")
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, no validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' NIV <- CreateTables(data=train, trt=TREATMENT, y="PURCHASE")
#' print(head(NIV$Summary), row.names=FALSE)
#' print(NIV$Tables$N_OPEN_REV_ACTS, row.names=FALSE)
#' 
#' ##------------------------------------------------------------
#' ## NWOE analysis, validation
#' ##------------------------------------------------------------
#' data(train, package="Information")
#' data(valid, package="Information")
#' NIV <- CreateTables(data=train, valid=valid, trt=TREATMENT, y="PURCHASE")
#' print(head(NIV$Summary), row.names=FALSE)
#' print(NIV$Tables$N_OPEN_REV_ACTS, row.names=FALSE)

NULL