#' @title Data exploration with information theory (weight-of-evidence and information value)
#'
#' @details  
#' Given a data.frame with a set of predictive variables and a binary response variable,
#' create_infotables() will cycle through all variables and create NWOE or WOE tables.
#' It will also rank all variables by their respective IV or NIV values and return the results in a data.frame. 
#' 
#' The package needs minimal inputs. You do not have to explicitly specify which variables to evaluate or provide bins: 
#' create_infotables() will process all variables in the dataset and generate appropriate bins for WOE/NWOE analysis.
#' 
#' If requested, calculations can be distributed across multiple cores for better performance.
#' 
#' Note that NWOE analysis is only for uplift models. Thus, for NWOE analysis, you must have a "treatment" and a "control" group in your dataset. 
#' The treatment and control groups should identified by a binary indicator variable (1/0).
#' 
#' For regular WOE analysis, on the other hand, all you need is a binary response variable (dependent variable).
#' 
#' You can cross validate your IV or NIV values by supplying a validation dataset. This will produce penalized IV/NIV values.
#'
#'#' To learn more about the Information package, start with the vignette:
#' \code{browseVignettes(package = "Information")}
#' 
#' @author Kim Larsen (kblarsen4 at gmail.com)
#' @keywords WOE, NWOE, NIV, IV, classification, weight-of-evidence, uplift
#' @docType package
#' @description 
#' The information package performs exploratory data analysis and variable screening for binary 
#' classification models using information theory (WOE and IV). 
#' 
#' The package also supports exploratory analysis and variable screening for uplift models (NWOE and NIV).
#' 
#' Note that the only functions you will need to use are create_infotables() and plot_infotables():
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
#' train <- subset(train, TREATMENT==1)
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
#' # If the goal is to plot multiple variables individually, as opposed to a comparison-grid, we can
#' # loop through the variable names and create individual plots
#' \dontrun{
#' names <- names(IV$Tables)
#' plots <- list()
#' for (i in 1:length(names)){
#'   plots[[i]] <- plot_infotables(IV, names[i])
#' }
#' # Showing the top 18 variables
#' plots[1:18]
#' }
#' 
#' # We can speed up create_infotables() by setting parallel=TRUE (default setting)
#' # If we leave ncore as the default, ncore is set to available clusters - 1
#' \dontrun{
#' train <- subset(train, TREATMENT==1)
#' IV <- Information::create_infotables(data=train, y="PURCHASE")
#' }
#' closeAllConnections()

NULL