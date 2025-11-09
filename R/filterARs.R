#' @export
filterARs <- function(rules, transactions, ...){
  
  input_list <- list(...)
  
  nonredundant <- rules[!is.redundant(rules)]
  
  quality(nonredundant) <- quality(nonredundant) %>%
    mutate(hyperConfidence = interestMeasure(nonredundant, measure = "hyperConfidence", transactions = input$transactions), 
           stdLift = interestMeasure(nonredundant, "stdLift", transactions = input$transactions), 
           chisq = interestMeasure(nonredundant, "chiSquared", transactions = input$transactions, significance = TRUE), 
           adjusted_chisq = p.adjust(chisq, "fdr"),
           relativeRisk = interestMeasure(nonredundant, measure = "relativeRisk", transactions = input$transactions),
           size = size(nonredundant))
  
  if ((all(names(input_list) %in% c("support", "confidence", "lift", "hyperConfidence", "stdLift", "chisq", "adjusted_chisq", "relativeRisk", "size"))== TRUE) == FALSE){
    stop("Not all arguments to filter are supported. See documentation for which measures are allowed to filter from.")
  } else {
    
    for (variable in names(input_list)){
      result <- subset(nonredundant, subset = base::eval(base::parse(text = base::paste(quote(variable), input_list[[variable]]))))
    }
  }
  
  return(result)
}
