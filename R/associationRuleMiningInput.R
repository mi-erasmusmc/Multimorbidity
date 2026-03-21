#' @export
createTransactions <- function(multimorbidityDataframe){
  
    input <- multimorbidityDataframe$multimorbidityDf %>%
      dplyr::filter(multimorbidDuringStudy == "Yes") %>%
      dplyr::arrange(rowId, dplyr::desc(timeId)) %>% 
      dplyr::collect() %>%
      dplyr::mutate(eventId = dplyr::dense_rank(dplyr::desc(timeId)),
                    covariateLabel = dplyr::case_when(
        is.na(covariateName) ~ "", 
        .default = stringr::str_replace(covariateName, ".*: ", "")))
  
  trans_sets <- input %>% 
    dplyr::select(rowId, covariateLabel) %>%
    as.data.frame() %>%
    arules::transactions(format = "long")
  
  result <- list(
    inputDataframe = input, 
    transactions = trans_sets
  )
  
  return(result)
}
