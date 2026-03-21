#' @export
# createMultimorbidityDataframe <- function(covariateData){
#   
#   ageDf <- covariateData$covariates %>%
#     dplyr::filter(covariateId  == 1002) %>%
#     # arrow::to_duckdb() %>%
#     dplyr::mutate(covariateId = as.character(covariateId)) %>%
#     tidyr::pivot_wider(id_cols = rowId, names_from = covariateId, values_from = covariateValue) %>%
#     dplyr::rename(age = `1002.0`) %>%
#     # arrow::to_arrow() %>%
#     dplyr::collect()
#   
#   genderDf <- covariateData$covariates %>%
#     dplyr::filter(covariateId %in% c(8507001, 8532001)) %>%
#     # arrow::to_duckdb() %>%
#     dplyr::mutate(gender = case_when(
#       covariateId == 8507001 ~ "Male", 
#       covariateId == 8532001 ~ "Female"
#     )) %>%
#     dplyr::select(rowId, gender) %>%
#     # arrow::to_arrow() %>%
#     dplyr::collect()
#   
#   if (FeatureExtraction::isTemporalCovariateData(covariateData)){
#     conditionsDf <- covariateData$covariates %>%
#       dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>%
#       # arrow::to_duckdb() %>%
#       dplyr::group_by(rowId, covariateId) %>%
#       dplyr::slice_max(timeId, with_ties = FALSE) %>%
#       dplyr::ungroup() %>%
#       dplyr::collect()
#   } else {
#     conditionsDf <- covariateData$covariates %>%
#       dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>%
#       dplyr::collect() 
#   }
#   
#   
#   multimorbidityDf <- ageDf %>%  
#     dplyr::inner_join(genderDf, by = "rowId") %>%
#     dplyr::full_join(conditionsDf, by = "rowId", multiple = "all") %>%
#     # arrow::to_duckdb() %>%
#     dplyr::mutate(covariateValue = dplyr::case_when(
#       is.na(covariateId) ~ "", 
#       .default = as.character(covariateValue)
#     )) %>%
#     # arrow::to_arrow() %>%
#     dplyr::full_join(covariateData$covariateRef %>% dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>% dplyr::collect(), by = "covariateId") %>%
#     dplyr::arrange(rowId) %>% dplyr::collect()
#   
#   return(multimorbidityDf)
# }
# createMultimorbidityDataframe <- function(covariateData){
#   
#   newAndromeda <- Andromeda::andromeda()
#   newAndromeda$covariateRef <- covariateData$covariateRef
#   newAndromeda$ageDf <- covariateData$covariates %>%
#     dplyr::filter(covariateId  == 1002) %>%
#     # arrow::to_duckdb() %>%
#     dplyr::mutate(covariateId = as.character(covariateId)) %>%
#     tidyr::pivot_wider(id_cols = rowId, names_from = covariateId, values_from = covariateValue) %>%
#     dplyr::rename(age = `1002.0`) 
#   
#   newAndromeda$genderDf <- covariateData$covariates %>%
#     dplyr::filter(covariateId %in% c(8507001, 8532001)) %>%
#     # arrow::to_duckdb() %>%
#     dplyr::mutate(gender = case_when(
#       covariateId == 8507001 ~ "Male", 
#       covariateId == 8532001 ~ "Female"
#     )) %>%
#     dplyr::select(rowId, gender) 
#   
#   if (FeatureExtraction::isTemporalCovariateData(covariateData)){
#     newAndromeda$conditionsDf <- covariateData$covariates %>%
#       dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>%
#       # arrow::to_duckdb() %>%
#       dplyr::group_by(rowId, covariateId) %>%
#       dplyr::slice_max(timeId, with_ties = FALSE) %>%
#       dplyr::ungroup() 
#   } else {
#     newAndromeda$conditionsDf <- covariateData$covariates %>%
#       dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) 
#   }
#   
#   newAndromeda$multimorbidityDf <- newAndromeda$ageDf %>%  
#     dplyr::inner_join(newAndromeda$genderDf, by = "rowId") %>%
#     dplyr::full_join(newAndromeda$conditionsDf, by = "rowId", multiple = "all") %>%
#     # dplyr::mutate(covariateValue = dplyr::case_when(
#     #   is.na(covariateId) ~ "", 
#     #   .default = as.character(covariateValue)
#     # )) %>%
#     dplyr::group_by(rowId) %>%
#     dplyr::mutate(NoConditions = dplyr::case_when(
#       is.na(covariateId) ~ 0, 
#       .default = dplyr::n()
#     ))%>%
#     dplyr::ungroup() %>% 
#     dplyr::mutate(conditionAge = dplyr::case_when(
#       !is.na(covariateId) ~ age + round(-timeId/365), 
#       .default = NA),
#       multimorbid = case_when(
#       NoConditions < 2 ~ "No", 
#       NoConditions >=2 ~ "Yes"
#     )) %>%
#     dplyr::arrange(rowId, conditionAge)
#   
#   newAndromeda$multimorbidityDf <- newAndromeda$multimorbidityDf %>%
#     dplyr::full_join(newAndromeda$covariateRef %>% dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001)))%>% dplyr::select(-c(analysisId, conceptId, valueAsConceptId, collisions)), by = "covariateId") 
#   
#   return(newAndromeda)
# }
createMultimorbidityDataframe <- function(studyPopulation, 
                                          MMcovariateData){
  # startDate <- studyPopulation$covariates
  
  newAndromeda <- Andromeda::andromeda()
  newAndromeda$covariateRef <- studyPopulation$covariateRef %>% 
    dplyr::collect() %>% 
    dplyr::bind_rows(MMcovariateData$covariateRef %>% dplyr::collect())
  
  # Getting the age of each patient in the study population
  newAndromeda$ageDf <- studyPopulation$covariates %>%
    dplyr::filter(covariateId  == 1002) %>%
    dplyr::mutate(covariateId = as.character(covariateId)) %>%
    tidyr::pivot_wider(id_cols = rowId, names_from = covariateId, values_from = covariateValue) %>%
    dplyr::rename(age = `1002.0`) 
  
  # Labelling the gender for each patient
  newAndromeda$genderDf <- studyPopulation$covariates %>%
    dplyr::filter(covariateId %in% c(8507001, 8532001)) %>%
    dplyr::mutate(gender = case_when(
      covariateId == 8507001 ~ "Male", 
      covariateId == 8532001 ~ "Female"
    )) %>%
    dplyr::select(rowId, gender) 
  
  studyPopulationRowIds <- studyPopulation$covariates %>% dplyr::distinct(rowId) %>% dplyr::pull()
  
  # studyPopulation$covariates %>%
  #   collect()
  #   dplyr::bind_rows(MMcovariateData$covariates %>% collect())
  
  if (FeatureExtraction::isTemporalCovariateData(MMcovariateData)){
    newAndromeda$conditionsDf <- MMcovariateData$covariates %>%  
      dplyr::filter(rowId %in% studyPopulationRowIds) %>%
      dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>%
      dplyr::group_by(rowId, covariateId) %>%
      dplyr::slice_max(timeId, with_ties = FALSE) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(studyTimeId = dplyr::case_when(
        timeId >= 0 ~ 0, 
        .default = timeId
      )) %>%
      dplyr::arrange(rowId, dplyr::desc(studyTimeId))
  } else {
    newAndromeda$conditionsDf <- MMcovariateData$covariates %>%
      dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) 
  }
  
  multimorbidWide <- newAndromeda$conditionsDf %>% 
    dplyr::group_by(rowId) %>%
    dplyr::mutate(conditionsTime = dplyr::case_when(
      studyTimeId < 0 ~ "conditionsDuringStudy", 
      studyTimeId == 0 ~ "conditionsAtBaseline"
    )) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(rowId, conditionsTime) %>%
    dplyr::summarise(conditionCount = dplyr::n(), .groups = "drop") %>%
    # dplyr::ungroup() %>%
    tidyr::pivot_wider(id_cols = "rowId", names_from = conditionsTime, values_from = conditionCount, values_fill = 0) %>%
    dplyr::mutate(multimorbidAtBaseline = dplyr::case_when(
      conditionsAtBaseline >= 2 ~ "Yes",
      .default = "No"
    )) 
  
  newAndromeda$multimorbidityDf <- newAndromeda$ageDf %>%  
    dplyr::inner_join(newAndromeda$genderDf, by = "rowId") %>%
    dplyr::inner_join(multimorbidWide, by = "rowId") %>%
    dplyr::full_join(newAndromeda$conditionsDf, by = "rowId", multiple = "all") %>%
    dplyr::group_by(rowId) %>%
    dplyr::mutate(NoConditions = dplyr::case_when(
      is.na(covariateId) ~ 0, 
      .default = dplyr::n()), 
    multimorbidDuringStudy = dplyr::case_when(
      NoConditions >= 2 && multimorbidAtBaseline == "No" ~ "Yes", 
      .default = "No"
    ))%>%
    dplyr::ungroup() %>%
    dplyr::mutate(conditionAge = dplyr::case_when(
      !is.na(covariateId) && timeId < 0 ~ age + round(-timeId/365), 
      !is.na(covariateId) && timeId >= 0 ~ age - round(timeId/365),
      .default = NA)) %>%
    dplyr::arrange(rowId, conditionAge)
  
  newAndromeda$multimorbidityDf <- newAndromeda$multimorbidityDf %>%
    dplyr::full_join(newAndromeda$covariateRef %>% 
                       dplyr::filter(!(covariateId %in% c(1002, 8507001, 8532001))) %>% 
                       dplyr::select(-c(analysisId, conceptId, valueAsConceptId, collisions)), 
                     by = "covariateId") 
  
  return(newAndromeda)
}


