#' Training dataset
#'
#' The data is from an historical marketing campaign.
#' It contains 68 predictive variables and 4,972 records. In addition, it contains a
#' treatment indicator and a purchase indicator. 
#'
#' @format A data frame with 4972 rows and 70 variables:
#' \itemize{
#'   \item TREATMENT: equals 1 if the person received the marketing offer, and 0 if the person was in the control group
#'   \item PURCHASE: equals 1 if the person accepted the offer, and 0 otherwise
#'   \item UNIQUE_ID: unique identifier
#' }
"train"

#' Validation dataset
#'
#' The data is from an historical marketing campaign.
#' It contains 68 predictive variables and 5,060 records. In addition, it contains a
#' treatment indicator and a purchase indicator. 
#'
#' @format A data frame with 5060 rows and 70 variables:
#' \itemize{
#'   \item TREATMENT: equals 1 if the person received the marketing offer, and 0 if the person was in the control group
#'   \item PURCHASE: equals 1 if the person accepted the offer, and 0 otherwise
#'   \item UNIQUE_ID: unique identifier
#' }
"valid"