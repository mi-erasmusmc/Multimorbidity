#' @export
getBaselineCharacteristics <- function(covariateData){

  subjects <- covariateData$ageDf %>% dplyr::distinct(rowId) %>% dplyr::count() %>% dplyr::pull()
  
  multimorbidAtBaselineDf <- covariateData$multimorbidityDf %>% 
    dplyr::filter(timeId == 0) %>%
    dplyr::group_by(rowId) %>%
    dplyr::mutate(NoOfConditionsAtBaseline = dplyr::n(), 
                  multimorbidAtBaseline = dplyr::case_when(
                    NoOfConditionsAtBaseline  >= 2 ~ "Yes", 
                    .default = "No"
    )) %>%
    dplyr::ungroup() %>%
    dplyr::select(rowId, age, gender, multimorbidAtBaseline) %>%
    dplyr::distinct() 
  
  baselineDf <- covariateData$multimorbidityDf %>%
    dplyr::select(rowId, age, gender) %>%
    dplyr::distinct() %>%
    dplyr::left_join(multimorbidAtBaselineDf) %>%
    dplyr::mutate(multimorbid = dplyr::case_when(
      is.na(multimorbidAtBaseline) ~ "No", 
      .default = multimorbidAtBaseline
    )) %>%
    dplyr::collect()
  
  # t1 <- tibble::tibble(Characteristic = c("N", "age (mean (SD))", "multimorbid = Yes (%)"), 
  #                      Overall = c(subjects, ))
  t1 <- tableone::CreateTableOne(data = baselineDf, vars = c("age", "multimorbid"), factorVars = c("multimorbid"), addOverall = TRUE, strata = "gender")
  
  return(t1)
}

#' @export
getBaselineConditionPrevalence <- function(covariateData){
  
  subjects <- covariateData$ageDf %>% dplyr::distinct(rowId) %>% dplyr::count() %>% dplyr::pull()
  
  overallDf <- covariateData$multimorbidityDf %>% 
    dplyr::filter(timeId == 0 && !is.na(covariateId)) %>%
    dplyr::select(rowId, age, gender, covariateName) %>%
    dplyr::group_by(covariateName) %>%
    dplyr::mutate(N = dplyr::n()) %>%
    dplyr::ungroup() 
  
  baselineDf <- covariateData$multimorbidityDf %>%
    dplyr::select(rowId, age, gender) %>%
    dplyr::distinct() %>%
    dplyr::left_join(overallDf, by = join_by(rowId, age, gender)) %>%
    dplyr::mutate(covariateName = dplyr::case_when(
      stringr::str_detect(covariateName, "Anaemia") ~ "Cohort: Anaemia", 
      .default = covariateName
    )) %>%
    dplyr::collect()
  
  result <- tableone::CreateTableOne(data = baselineDf, vars = c("covariateName"), addOverall = TRUE, strata = c("gender"), includeNA = TRUE
                                     )
  
  return(result)
  
}

