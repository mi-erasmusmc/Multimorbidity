# Characterising multimorbidity - Eunomia script

## Load libraries
library(tidyverse)
library(Multimorbidity)
library(Eunomia)
library(FeatureExtraction)
library(ggpol)
library(arules)
library(gt)

## Set connection and study details
user = ""
password = ""
server = ""

cdmDatabaseSchema = "main"
cohortDatabaseSchema = "main"
cohortTableNames = ""
cohortDefinitionSet = ""
cohortTable = "mm_cohorts"
databaseId = "Euno_1"
minCellCount = 5
baseUrl = "" 
frequentItemsetSettings = createAssociationRuleMiningSettings(support = 0.005, confidence = 0.8)
databaseName = "Eunomia"
saveDirectory = "example"
incremental = TRUE
cohortIds = 1428

## Start Analysis
connectionDetails <- Eunomia::getEunomiaConnectionDetails()

analysisDetails <- Multimorbidity::createAnalysisDetails(cdmDatabaseSchema = cdmDatabaseSchema,
                                                         cohortDatabaseSchema = cohortDatabaseSchema,
                                                         cohortTable = cohortTable, 
                                                         databaseId = databaseId, 
                                                         cohortIds = cohortIds,
                                                         minCellCount = minCellCount, 
                                                         baseUrl = baseUrl, 
                                                         frequentItemsetSettings = frequentItemsetSettings, 
                                                         # outputFolder, 
                                                         databaseName = databaseName, 
                                                         saveDirectory = saveDirectory)

Multimorbidity::createEunomiaCohorts(connectionDetails = connectionDetails,
                                     cdmDatabaseSchema = cdmDatabaseSchema, 
                                     cohortDatabaseSchema = cohortDatabaseSchema, 
                                     cohortTable = cohortTable,
                                     incremental = incremental,
                                     saveDirectory = saveDirectory)

## Create directories to dave results
if (!dir.exists(saveDirectory)){
  dir.create(saveDirectory)
  message(paste("Directory", saveDirectory, "has been created."))
}

if (!dir.exists(file.path(saveDirectory, "Results"))){
  dir.create(file.path(saveDirectory, "Results"))
  message(paste("Directory", file.path(saveDirectory, "Results"), "has been created."))
}

if (!dir.exists(file.path(saveDirectory, "Results", "tables"))){
  dir.create(file.path(saveDirectory, "Results", "tables"))
  message(paste("Directory", file.path(saveDirectory, "Results", "tables"), "has been created."))
}

if (!dir.exists(file.path(saveDirectory, "Results", "plots"))){
  dir.create(file.path(saveDirectory, "Results", "plots"))
  message(paste("Directory", file.path(saveDirectory, "Results", "plots"), "has been created."))
}

if (!dir.exists(file.path(saveDirectory, "Results", "descriptive"))){
  dir.create(file.path(saveDirectory, "Results", "descriptive"))
  message(paste("Directory", file.path(saveDirectory, "Results", "descriptive"), "has been created."))
}

extractCovariates(connectionDetails = connectionDetails, analysisDetails = analysisDetails)

covData <- loadCovariateData(file.path(saveDirectory, "Mulitmorbidity_covs"))
mmDf <- createMultimorbidityDataframe(covariateData = covData)

t1 <- Multimorbidity::getBaselineCharacteristics(mmDf)
saveRDS(t1, file = file.path(saveDirectory, "Results", "tables", "t1_data.Rds"))

t2 <- Multimorbidity::getBaselineConditionPrevalence(mmDf)
saveRDS(t2, file = file.path(saveDirectory, "Results", "tables", "t2_data.Rds"))

# Database characterization
## Table 3
t3 <- mmDf$multimorbidityDf %>% 
  group_by(covariateName) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               group_by(covariateName, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "covariateName", names_from = "gender", values_from = "n"), by = "covariateName") %>%
  collect()
saveRDS(t3, file = file.path(saveDirectory, "Results", "tables", "t3_data.Rds"))

# Table 4
t4 <- mmDf$multimorbidityDf %>%
  group_by(NoConditions) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               group_by(NoConditions, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "NoConditions", names_from = "gender", values_from = "n"), by = "NoConditions") %>%
  arrange(NoConditions) %>%
  collect()
saveRDS(t4, file = file.path(saveDirectory, "Results", "tables", "t4_data.Rds"))

## Table 5
t5 <- mmDf$multimorbidityDf %>%
  distinct(rowId, .keep_all = TRUE) %>%
  group_by(multimorbid) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               distinct(rowId, .keep_all = TRUE) %>%
               group_by(multimorbid, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "multimorbid", names_from = "gender", values_from = "n"), by = "multimorbid") %>%
  collect()
saveRDS(t5, file = file.path(saveDirectory, "Results", "tables", "t5_data.Rds"))

## Table 6
t6 <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  group_by(covariateName) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               filter(multimorbid == "Yes") %>%
               group_by(covariateName, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "covariateName", names_from = "gender", values_from = "n"), by = "covariateName") %>%
  collect()
saveRDS(t6, file = file.path(saveDirectory, "Results", "tables", "t6_data.Rds"))

# Age at onset of multimorbidity
## Create a dataframe indicating and group patients according to their age when the second condition was diagnosed
ageAtOncet <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  collect() %>%
  group_by(rowId) %>%
  mutate(multimorbidAge = conditionAge[2]) %>%
  slice(1L) %>%
  ungroup() %>%
  mutate(ageGroup = case_when(
    multimorbidAge < 25 ~ "18-24", 
    multimorbidAge >= 25 & multimorbidAge < 30 ~ "25-29", 
    multimorbidAge >= 30 & multimorbidAge < 35 ~ "30-34", 
    multimorbidAge >= 35 & multimorbidAge < 40 ~ "35-39", 
    multimorbidAge >= 40 & multimorbidAge < 45 ~ "40-44",  
    multimorbidAge >= 45 & multimorbidAge < 50 ~ "45-49", 
    multimorbidAge >= 50 & multimorbidAge < 55 ~ "50-54", 
    multimorbidAge >= 55 & multimorbidAge < 60 ~ "55-59", 
    multimorbidAge >= 60 & multimorbidAge < 65 ~ "60-64",
    multimorbidAge >= 65 & multimorbidAge < 70 ~ "65-69", 
    multimorbidAge >= 70 & multimorbidAge < 75 ~ "70-74",
    multimorbidAge >= 75 & multimorbidAge < 80 ~ "75-79", 
    multimorbidAge >= 80 & multimorbidAge < 85 ~ "80-84",
    multimorbidAge >= 85 & multimorbidAge < 90 ~ "85-89", 
    multimorbidAge >= 90 & multimorbidAge < 95 ~ "90-94",
    multimorbidAge >= 95 & multimorbidAge < 100 ~ "95-99", 
    multimorbidAge >= 100 ~ "100+"  
  ), 
  groupedConditions = case_when(
    NoConditions >= 8 ~ "8+", 
    .default = as.character(NoConditions))) %>%
  select(rowId, gender, ageGroup, groupedConditions) %>%
  group_by(gender, ageGroup, groupedConditions) %>%
  summarize(N = n()) %>%
  group_by(gender, ageGroup) %>%
  summarise(N = sum(N))
saveRDS(ageAtOncet, file = file.path(saveDirectory, "Results", "descriptive", "ageAtOncet.Rds"))

multimorbidPatients <- mmDf$multimorbidityDf %>% filter(multimorbid == "Yes") %>% distinct(rowId) %>% count() %>% pull()
saveRDS(multimorbidPatients, file = file.path(saveDirectory, "Results", "descriptive", "multimorbidPatients.Rds"))

# age cross sectionally
ageCrossSectional <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  collect() %>%
  group_by(rowId) %>%
  mutate(multimorbidAge = conditionAge[2]) %>%
  mutate(lastConditionAge = last(conditionAge)) %>%
  mutate(maxConditionAge = max(conditionAge)) %>%
  ungroup() %>%
  group_by(rowId) %>%
  slice(1L) %>%
  ungroup() %>%
  mutate(ageGroup = case_when(
    maxConditionAge < 25 ~ "18-24", 
    maxConditionAge >= 25 & maxConditionAge < 30 ~ "25-29", 
    maxConditionAge >= 30 & maxConditionAge < 35 ~ "30-34", 
    maxConditionAge >= 35 & maxConditionAge < 40 ~ "35-39", 
    maxConditionAge >= 40 & maxConditionAge < 45 ~ "40-44",  
    maxConditionAge >= 45 & maxConditionAge < 50 ~ "45-49", 
    maxConditionAge >= 50 & maxConditionAge < 55 ~ "50-54", 
    maxConditionAge >= 55 & maxConditionAge < 60 ~ "55-59", 
    maxConditionAge >= 60 & maxConditionAge < 65 ~ "60-64",
    maxConditionAge >= 65 & maxConditionAge < 70 ~ "65-69", 
    maxConditionAge >= 70 & maxConditionAge < 75 ~ "70-74",
    maxConditionAge >= 75 & maxConditionAge < 80 ~ "75-79", 
    maxConditionAge >= 80 & maxConditionAge < 85 ~ "80-84",
    maxConditionAge >= 85 & maxConditionAge < 90 ~ "85-89", 
    maxConditionAge >= 90 & maxConditionAge < 95 ~ "90-94",
    maxConditionAge >= 95 & maxConditionAge < 100 ~ "95-99", 
    maxConditionAge >= 100 ~ "100+"  
  ), 
  groupedConditions = case_when(
    NoConditions >= 8 ~ "8+", 
    .default = as.character(NoConditions)
  ), 
  ageGroup = fct_relevel(ageGroup, "100+", after = Inf)) %>%
  select(rowId, gender, ageGroup, groupedConditions) %>%
  group_by(gender, ageGroup, groupedConditions) %>%
  summarize(N = n())
saveRDS(ageCrossSectional, file = file.path(saveDirectory, "Results", "descriptive", "ageCrossSectional.Rds"))
# Prevalence of multimorbid conditions
mmConditionPrevalence <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  group_by(covariateName) %>%
  summarise(N = n()) %>%
  collect()
saveRDS(mmConditionPrevalence, file = file.path(saveDirectory, "Results", "descriptive", "mmConditionPrevalence.Rds"))

# ARM
## create Transactions
input <- Multimorbidity::createTransactions(mmDf)

## Define minimum support
minSup = 10/multimorbidPatients

rules <- apriori(input$transactions, parameter = list(support = minSup, confidence = 0, minlen= 2, maxtime = 0), control = list(verbose = TRUE))
rules

rules <- rules[!is.redundant(rules)]

## Estimating extra measures
newRules <- Multimorbidity::filterARs(rules = rules, transactions = input$transactions, stdLift = "> 0.2")
newRules
lhs_items <- labels(lhs(newRules))
rhs_items <- labels(rhs(newRules))

# Create clean rules dataframe
# rules_clean <- data.frame(
#   LHS = gsub("\\{|\\}", "", lhs_items),
#   RHS = gsub("\\{|\\}", "", rhs_items),
#   support = newRes@quality$support,
#   confidence = newRes@quality$confidence,
#   lift = newRes@quality$lift
# )
# 
# library(igraph)
# library(arulesViz)
# 
# g <- associations2igraph(res1.2, associationsAsNodes = FALSE)
# plot(g, layout = layout_in_circle)
# plot(g)
# layout <- layout_with_kk(g)
# plot(g, layout = layout, main = "Social network with the Kamada-Kawai layout algorithm")
# plot(
#   g,
#   layout = layout_with_fr,
#   main = "Social network with the Fruchterman-Reingold layout algorithm"
# )
