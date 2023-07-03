#' @export
extractAssociationRules <- function(analysisDetails){
  
  associationRuleSettings <- analysisDetails$associationRuleSettings
  
  params <- list(support = associationRuleSettings$support, 
                 confidence = associationRuleSettings$confidence, 
                 maxlen = associationRuleSettings$maxLen, 
                 maxtime = )
  
  apres <- apriori(trans_sets, 
                   parameter = list(support = associationRuleSettings$support, maxlen = 20, maxtime = 0),
                   control = list(verbose = TRUE))
  
  arules::write(apres, 
                file = "rulesTest_dedupl.csv",
                sep = ",", 
                quote = TRUE, 
                row.names = FALSE)
  
  return(invisible())
  
}
