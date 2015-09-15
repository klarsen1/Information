#' Training dataset
#'
#' The data is from a historical marketing campaign.
#' It contains 68 predictive variables and 4,972 records. In addition, it contains a
#' treatment indicator and a purchase indicator. 
#'
#' @format A data frame with 10000 rows and 70 variables:
#' \itemize{
#'   \item TREATMENT: equals 1 if the person received the marketing offer, and 0 if the person was in the control group
#'   \item PURCHASE: equals 1 if the person accepted the offer, and 0 otherwise
#'   \item UNIQUE_ID: unique identifier
#'   \item AGE: age of the person
#'   \item D_REGION_X: 1 if the person lives in region X, 0 otherwise (3 regions: A, B, C)
#'   \item Other variables are from credit bureau data (e.g., N_OPEN_REV_ACTS = number of open revolving accounts)
#' }
"train"

#' Validation dataset
#'
#' The data is from a historical marketing campaign.
#' It contains 68 predictive variables and 5,060 records. In addition, it contains a
#' treatment indicator and a purchase indicator. 
#'
#' @format A data frame with 10000 rows and 70 variables:
#' \itemize{
#'   \item TREATMENT: equals 1 if the person received the marketing offer, and 0 if the person was in the control group
#'   \item PURCHASE: equals 1 if the person accepted the offer, and 0 otherwise
#'   \item UNIQUE_ID: unique identifier
#'   \item AGE: age of the person
#'   \item D_REGION_X: 1 if the person lives in region X, 0 otherwise (3 regions: A, B, C)
#'   \item Other variables are from credit bureau data (e.g., N_OPEN_REV_ACTS = number of open revolving accounts)
#' }
"valid"