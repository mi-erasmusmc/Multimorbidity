#' @export
extractAssociationRules <- function(analysisDetails,
                                    transactions, 
                                    getPatientId = FALSE){
  
  
  saveDirectory <- analysisDetails$outputFolder
  associationRuleSettings <- analysisDetails$associationRuleSettings$frequentItemsetSettings
  
  controls <- list(verbose = associationRuleSettings$verbose)
  params <- list(support = associationRuleSettings$support, 
                 confidence = associationRuleSettings$confidence, 
                 maxlen = associationRuleSettings$maxLen, 
                 maxtime = 0)
  
  apres <- apriori(transactions, 
                   parameter = params,
                   control = controls)
  
  saveRDS(apres, file.path(saveDirectory, "ExtractedRules", "aprioriRules.Rds"))
  
  if (getPatientId){
    patientIds <- arules::supportingTransactions(x = apres, transactions = transactions)
  saveRDS(patientIds, file.path(saveDirectory, 'ExtractedRules', "patientIds.Rds"))
    }
  
  
  return(invisible())
  
}
