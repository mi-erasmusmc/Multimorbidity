library(tidyverse)
library(Multimorbidity)
library(Eunomia)
library(FeatureExtraction)
library(ggpol)
library(arules)
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

connectionDetails <- Eunomia::getEunomiaConnectionDetails()

# Not used for now
# analysisDetails <- Multimorbidity::createAnalysisDetails(cdmDatabaseSchema = cdmDatabaseSchema, 
#                                                          cohortDatabaseSchema = cohortDatabaseSchema, 
#                                                          cohortTableNames = cohortTableNames, 
#                                                          cohortDefinitionSet =  cohortDefinitionSet,
#                                                          cohortTable = cohortTable, 
#                                                          databaseId = databaseId,
#                                                          minCellCount = minCellCount,
#                                                          baseUrl = baseUrl, 
#                                                          frequentItemsetSettings = frequentItemsetSettings,
#                                                          databaseName = databaseName, 
#                                                          outputFolder = outputFolder)

# create target cohorts
# Multimorbidity::createCohorts(connectionDetails = connectionDetails,
#                               cdmDatabaseSchema = cdmDatabaseSchema, 
#                               cohortDatabaseSchema = cohortDatabaseSchema, 
#                               cohortTable = cohortTable,
#                               incremental = incremental,
#                               saveDirectory = saveDirectory)


Multimorbidity::createEunomiaCohorts(connectionDetails = connectionDetails,
                                     cdmDatabaseSchema = cdmDatabaseSchema, 
                                     cohortDatabaseSchema = cohortDatabaseSchema, 
                                     cohortTable = cohortTable,
                                     incremental = incremental,
                                     saveDirectory = saveDirectory)

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

extractCovariates(connectionDetails = connectionDetails, analysisDetails = analysisDetails)

# covData <- FeatureExtraction::loadCovariateData("testData/cohortBasedTemporalCovData")
covData <- loadCovariateData("example/Mulitmorbidity_covs")
mmDf <- createMultimorbidityDataframe(covariateData = covData)
# mmDf2 <- createMultimorbidityDataframe2(covariateData = covData)

mmDf$multimorbidityDf
mmDf$multimorbidityDf %>% names()

t1 <- Multimorbidity::getBaselineCharacteristics(mmDf)
t1_gt <- as.data.frame(print(t1, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(name = rownames(.)) %>%
  dplyr::select(name, 1:4) %>%
  dplyr::rename(" " = "name") %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 1: Baseline characteristics.")
t1_gt

t2 <- Multimorbidity::getBaselineConditionPrevalence(mmDf)
t2_gt <- as.data.frame(print(t2, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(name = rownames(.)) %>%
  dplyr::select(name, dplyr::everything()) %>%
  dplyr::rename(" " = "name") %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 2: Condition Prevalence at baseline.")
t2_gt

# Database characterization
# Table 3
mmDf$multimorbidityDf %>% 
  group_by(covariateName) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               group_by(covariateName, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "covariateName", names_from = "gender", values_from = "n"), by = "covariateName")

# Table 4
mmDf$multimorbidityDf %>%
  group_by(NoConditions) %>%
  count() %>%
  ungroup() %>%
  rename("N" = "n") %>%
  inner_join(mmDf$multimorbidityDf %>% 
               group_by(NoConditions, gender) %>%
               count() %>%
               ungroup() %>%
               tidyr::pivot_wider(id_cols = "NoConditions", names_from = "gender", values_from = "n"), by = "NoConditions") %>%
  arrange(NoConditions)

# Table 5
mmDf$multimorbidityDf %>%
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
               tidyr::pivot_wider(id_cols = "multimorbid", names_from = "gender", values_from = "n"), by = "multimorbid") 

# Table 6
mmDf$multimorbidityDf %>%
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
               tidyr::pivot_wider(id_cols = "covariateName", names_from = "gender", values_from = "n"), by = "covariateName") 


# Age at onset of multimorbidity
newPlotDf7 <- mmDf$multimorbidityDf %>%
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
    .default = as.character(NoConditions)
  ), 
  # ageGroup = fct_relevel(ageGroup, "100+", after = Inf)
  ) %>%
  select(rowId, gender, ageGroup, groupedConditions) %>%
  group_by(gender, ageGroup, groupedConditions) %>%
  summarize(N = n()) %>%
  group_by(gender, ageGroup) %>%
  summarise(N = sum(N))

multimorbidPatients <- mmDf$multimorbidityDf %>% filter(multimorbid == "Yes") %>% distinct(rowId) %>% count() %>% pull()

p1 <- ggplot(data = newPlotDf7,  aes(x = ageGroup, y = N, fill = gender))+
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(name = "", values = c(Male = "#3E606F", Female = "#8C3F4D"))+
  # geom_bar(data = newPlotDf4[newPlotDf4$gender=="Male",], aes(x = ageGroup, y = N), stat = "identity",  alpha = 0.8, position = position_stack(reverse = TRUE), fill =  "#3E606F")+
  # geom_bar(data = newPlotDf4[newPlotDf4$gender=="Female",], aes(x = ageGroup, y = N), stat = "identity", alpha = 0.8, position = position_stack(reverse = TRUE), fill = "#8C3F4D") +
  # facet_share(~gender, dir = "h",reverse_num = TRUE, scales = "free", switch = "both", strip.position = "top") + coord_flip()+
  labs(subtitle = paste0("N = ", multimorbidPatients),
       caption = "Figure 1: Multimorbid patients per age group.", fill = "No of Conditions")+ 
  scale_color_manual(name = "", values = c(Male = "#3E606F", Female = "#8C3F4D"))+
  theme_classic() +
  theme(text = element_text(color = "#3A3F4A"),
        panel.grid.major.y = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        # axis.title = element_blank(),
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 10), hjust = 0.030),
        plot.subtitle = element_text(size = 12, hjust = 0.030),
        plot.caption = element_text(size = 8, color = "#5D646F", hjust = 0.0),
        axis.text.x = element_text(size = 12, color = "#5D646F", angle = 45,  hjust=1),
        # axis.text.y = element_blank(),
        # strip.text = element_text(color = "#5D646F", size = 18, face = "bold", hjust = 0.030),
        plot.background = element_rect(fill = "#EFF2F4"),
        # plot.margin = unit(c(1, 1, 1, 1), "cm"),
        legend.position = "bottom",
        legend.spacing = unit(0.1, "lines"),
        legend.text  = element_text(size = 8),
        legend.direction = "horizontal"
  ) +
  guides(fill = guide_legend(nrow = 1))
p1

newPlotDf6 <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  collect() %>%
  group_by(rowId) %>%
  mutate(multimorbidAge = conditionAge[2]) %>%
  # slice(1L) %>%
  # ungroup() %>%
  # group_by(rowId) %>%
  mutate(lastConditionAge = last(conditionAge)) %>%
  # ungroup() %>%
  # group_by(rowId) %>%
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
  # mutate(N = case_when(
  #   gender == "Male" ~ -1*N, 
  #   .default = N))
  # %>%
  select(rowId, gender, ageGroup, groupedConditions) %>%
  group_by(gender, ageGroup, groupedConditions) %>%
  summarize(N = n())
# Figure 2: Multimorbid patients per age group stratified by gender 
p2 <- ggplot()+
  geom_bar(data = newPlotDf6[newPlotDf6$gender=="Male",], aes(x = ageGroup, y = N, fill = groupedConditions), stat = "identity",  alpha = 0.8, position = position_stack(reverse = TRUE))+
  geom_bar(data = newPlotDf6[newPlotDf6$gender=="Female",], aes(x = ageGroup, y = -N, fill = groupedConditions), stat = "identity", alpha = 0.8, position = position_stack(reverse = TRUE)) +
  facet_share(~gender, dir = "h",reverse_num = TRUE, scales = "free", switch = "both", strip.position = "top") + coord_flip()+
  labs(subtitle = paste0("N = ", multimorbidPatients),
       caption = "NOTE: \n Patient's age at the last recorded condition was used to stratify patients in each age group.\n
   Figure 2: Multimorbid patients per age group stratified by gender.", 
       fill = "No of Conditions")+ 
  scale_color_manual(name = "", values = c(Male = "#3E606F", Female = "#8C3F4D"),
                     # labels = c("Females", "Males")
  )+
  theme_classic() +
  theme(text = element_text(color = "#3A3F4A"),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(linetype = "dotted", size = 0.2, color = "#3A3F4A"),
        # axis.title = element_blank(),
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 10), hjust = 0.030),
        plot.subtitle = element_text(size = 12, hjust = 0.030),
        plot.caption = element_text(size = 8, color = "#5D646F", hjust = 0.0),
        axis.text.x = element_text(size = 12, color = "#5D646F"),
        # axis.text.y = element_blank(),
        # strip.text = element_text(color = "#5D646F", size = 18, face = "bold", hjust = 0.030),
        plot.background = element_rect(fill = "#EFF2F4"),
        # plot.margin = unit(c(1, 1, 1, 1), "cm"),
        legend.position = "bottom",
        legend.spacing = unit(0.1, "lines"),
        legend.text  = element_text(size = 8),
        legend.text.align = 0, 
        legend.direction = "horizontal"
  ) +
  guides(fill = guide_legend(nrow = 1))
p2

mm_df5 <- mmDf$multimorbidityDf %>%
  filter(multimorbid == "Yes") %>%
  group_by(covariateName) %>%
  summarise(N = n()) 

p3 <- mm_df5 %>%
  arrange(desc(N)) %>%
  # slice_head(n = 30) %>%
  mutate(condition = str_replace_all(covariateName, " / ", "/"), 
         condition = str_replace_all(condition, "cohort: ", ""), 
         condition = str_remove_all(condition, "_\\s*\\([^\\)]+\\)")) %>%
  ggplot(aes(x = reorder(condition, -N), y = N)) +
  geom_bar(stat = "identity", width = 0.9, fill ="#56B4E9") +
  labs(x = "Condition",
       subtitle = "",
       caption = "Figure 3: Top Multimorbid conditions.", 
       fill = "")+ 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 20)) +
  theme_classic() +
  theme(text = element_text(color = "#3A3F4A"),
        panel.grid.major.y = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        # axis.title = element_blank(),
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 10), hjust = 0.030),
        plot.subtitle = element_text(size = 12, hjust = 0.030),
        plot.caption = element_text(size = 8, color = "#5D646F", hjust = 0.0),
        axis.text.x = element_text(size = 10, color = "#5D646F", angle = 70,  hjust=1),
        # axis.text.y = element_blank(),
        # strip.text = element_text(color = "#5D646F", size = 18, face = "bold", hjust = 0.030),
        plot.background = element_rect(fill = "#EFF2F4"),
        # plot.margin = unit(c(1, 1, 1, 1), "cm"),
        legend.position = "bottom",
        legend.spacing = unit(0.1, "lines"),
        legend.text  = element_text(size = 8),
        legend.text.align = 0, 
        legend.direction = "horizontal"
  ) +
  guides(fill = guide_legend(nrow = 1)) 
p3

# identify ARs
# df_inputTemp <- as.data.frame(dplyr::select(mmDf$multimorbidityDf, c(rowId, covariateName, timeId)))
# 
#  mmDf2 <- df_inputTemp %>%
#   group_by(rowId) %>%
#   mutate(size = n()) %>%
#   filter(size!= 1) %>%
#   # arrange(desc(timeId)) %>%
#   # arrange(rowId, eventId) %>%
#   mutate(eventId = dense_rank(desc(timeId))) %>%
#   ungroup() %>%
#   dplyr::rename("condition" = "covariateName") %>%
#   as.data.frame(.)

# mmDf2 <- mmDf$multimorbidityDf %>% dplyr::collect() %>% as.data.frame()
# length(unique(mmDf2$rowId))
input <- Multimorbidity::createTransactions(mmDf)

# ARM
aprioriInput <- as(split(mmDf2[,"condition"], mmDf2[,"rowId"]), "transactions")
transactions <- createTransactions(mmDf)
summary(transactions$transactions)
as(mmDf2 %>% select(rowId, eventId, condition), "transactions")

minSup = 10/multimorbidPatients
# res1 <- apriori(aprioriInput, parameter = list(support = minSup, confidence = 0, minlen= 2, maxlen = 5, maxtime = 0), control = list(verbose = TRUE))
# res1.1 <-  apriori(trans_sets, parameter = list(support = minSup, confidence = 0, minlen= 2, maxlen = 5, maxtime = 0), control = list(verbose = TRUE))
res1.2 <- apriori(input$transactions, parameter = list(support = minSup, confidence = 0, minlen= 2, maxlen = 5, maxtime = 0), control = list(verbose = TRUE))
# res1
# res1.1
res1.2
# res2 <- res1[!is.redundant(res1)]
res1.2 <- res1.2[!is.redundant(res1.2)]
# res2
# resdf1 <- res1 %>% as("data.frame") %>% tibble()
# resdf2 <- res2 %>% as("data.frame") %>% tibble()

# Estimating extra measures

# quality(res1.2) <- quality(res1.2) %>%
#   mutate(hyperConfidence = interestMeasure(res1.2, measure = "hyperConfidence", transactions = input$transactions), 
#          stdLift = interestMeasure(res1.2, "stdLift", transactions = input$transactions), 
#          chisq = interestMeasure(res1.2, "chiSquared", transactions = input$transactions, significance = TRUE), 
#          adjusted_chisq = p.adjust(chisq, "fdr"),
#          relativeRisk = interestMeasure(res1.2, measure = "relativeRisk", transactions = input$transactions),
#          size = size(res1.2))
# 
# tibble(quality(res1.2))
# test <- filterARs(res1.2)
# tibble(quality(test))
newRes <- filterARs(rules = res1.2, transactions = input$transactions, stdLift = "> 0.2")
# debugonce(filterARs)


lhs_items <- labels(lhs(newRes))
rhs_items <- labels(rhs(newRes))

# Create clean rules dataframe
rules_clean <- data.frame(
  LHS = gsub("\\{|\\}", "", lhs_items),
  RHS = gsub("\\{|\\}", "", rhs_items),
  support = newRes@quality$support,
  confidence = newRes@quality$confidence,
  lift = newRes@quality$lift
)

library(igraph)
library(arulesViz)

g <- associations2igraph(res1.2, associationsAsNodes = FALSE)
plot(g, layout = layout_in_circle)
plot(g)
layout <- layout_with_kk(g)
plot(g, layout = layout, main = "Social network with the Kamada-Kawai layout algorithm")
plot(
  g,
  layout = layout_with_fr,
  main = "Social network with the Fruchterman-Reingold layout algorithm"
)
