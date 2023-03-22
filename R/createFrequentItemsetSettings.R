#' @export
createAssociationRuleMiningSettings <- function(support, 
                                                confidence,
                                                minlen = 1, 
                                                maxlen = 10, 
                                                ext = TRUE,
                                                tidLists = TRUE, 
                                                verbose = TRUE,
                                                sparse = 7,
                                                sort = 2,
                                                
                                                ...){
  # params <- list(support = support, 
  #                confidence = confidence, 
  #                minlen = minlen, 
  #                maxlen = maxlen, 
  #                ext = ext,
  #                tidLists = tidLists)
  # 
  # control <- list(sparse = 10, 
  #                 sort = 2, 
  #                 sparse = 7)
  
  settings <- list(support = support, 
                   confidence = confidence, 
                   minlen = minlen, 
                   maxlen = maxlen, 
                   ext = ext,
                   tidLists = tidLists,
                   verbose = verbose,
                   sort = sort, 
                   sparse = sparse)
  
  return(settings)
}