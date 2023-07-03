#' @export
prepareInputDataset <- function(analysisDetails){
  
  inputFile <- analysisDetails$inputDataFileName
  inputData <- AssociationRuleMining::getInputFileForAssociationRules(covariateDataObject = covs, fileToSave = inputFile)
  
  df <- inputData %>% 
    dplyr::group_by(rowId) %>%
    dplyr::arrange(rowId)
  df_input <- as.data.frame(dplyr::select(df, c(rowId, covariateLabel)))
  
  trans_sets <- as(split(df_input[,"covariateLabel"], df_input[,"rowId"]), "transactions")
  arules::write(x = trans_sets, file = paste0(inputFile, "_basket"))

  return(trans_sets)
}