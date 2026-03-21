#' @export
filterARs <- function(rules, transactions, ...){
  
  input_list <- list(...)
  
  nonredundant <- rules[!arules::is.redundant(rules)]
  
  quality(nonredundant) <- arules::quality(nonredundant) %>%
    dplyr::mutate(hyperConfidence = arules::interestMeasure(nonredundant, measure = "hyperConfidence", transactions = transactions), 
           stdLift = arules::interestMeasure(nonredundant, "stdLift", transactions = transactions), 
           chisq = arules::interestMeasure(nonredundant, "chiSquared", transactions = transactions, significance = TRUE), 
           adjusted_chisq = p.adjust(chisq, "fdr"),
           relativeRisk = arules::interestMeasure(nonredundant, measure = "relativeRisk", transactions = transactions),
           size = arules::size(nonredundant))
  
  if ((all(names(input_list) %in% c("support", "confidence", "lift", "hyperConfidence", "stdLift", "chisq", "adjusted_chisq", "relativeRisk", "size"))== TRUE) == FALSE){
    stop("Not all arguments to filter are supported. See documentation for which measures are allowed to filter from.")
  } else {
    # initialising result value
    result = nonredundant
    for (variable in names(input_list)){
      # result <- arules::subset(nonredundant, subset = base::eval(base::parse(text = base::paste(quote(variable), input_list[[variable]]))))
      result <- arules::subset(result, subset = base::eval(base::parse(text = base::paste(noquote(variable), input_list[[variable]]))))
    }
  }
  
  return(result)
}
