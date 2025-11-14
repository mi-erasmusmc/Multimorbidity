# Format Results
saveDirectory = "example"

# Table 1
t1 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t1_data.Rds"))
t1_gt <- as.data.frame(print(t1, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(name = rownames(.)) %>%
  dplyr::select(name, 1:4) %>%
  dplyr::rename(" " = "name") %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 1: Baseline characteristics.")
t1_gt

gt::gtsave(t1_gt, filename = "Table1.docx", path = file.path(saveDirectory, "Results", "tables"))

#Table 2
t2 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t2_data.Rds"))
t2_gt <- as.data.frame(print(t2, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(name = rownames(.)) %>%
  dplyr::select(name, dplyr::everything()) %>%
  dplyr::rename(" " = "name") %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 2: Condition Prevalence at baseline.")
t2_gt
gt::gtsave(t2_gt, filename = "Table2.docx", path = file.path(saveDirectory, "Results", "tables"))

# Table 3
t3 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t3_data.Rds"))
t3_gt <- as.data.frame(print(t3, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(covariateName = stringr::str_remove(string = covariateName, pattern = "cohort: "), 
                covariateName = stringr::str_replace_all(string = covariateName, pattern = "_", replacement = " ")) %>%
  dplyr::rename("Condition" = "covariateName") %>%
  dplyr::arrange(Condition) %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 3: Prevalence of each condition.")
t3_gt
gt::gtsave(t3_gt, filename = "Table3.docx", path = file.path(saveDirectory, "Results", "tables"))

# Table 4
t4 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t4_data.Rds"))
#### Alternative table
# tableone::CreateTableOne(data = mmDf$multimorbidityDf |> collect() |> mutate(NoConditions = as.factor(NoConditions)), vars = c("NoConditions"), addOverall = TRUE, strata = c("gender"), includeNA = TRUE)
t4_gt <- as.data.frame(print(t4, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::select(NoConditions, N, Female, Male) %>%
  # dplyr::rename(" " = "name") %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 4: Number of conditions per gender.")
t4_gt
gt::gtsave(t4_gt, filename = "Table4.docx", path = file.path(saveDirectory, "Results", "tables"))

# Table 5
t5 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t5_data.Rds"))
t5_gt <- as.data.frame(print(t5, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::select(multimorbid, N, Female, Male) %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 5: Multimorbid patients.")
t5_gt
gt::gtsave(t5_gt, filename = "Table5.docx", path = file.path(saveDirectory, "Results", "tables"))

# Table 6
t6 <- readRDS(file = file.path(saveDirectory, "Results", "tables", "t6_data.Rds"))
t6_gt <- as.data.frame(print(t6, quote = FALSE, noSpaces = TRUE, printToggle = FALSE, formatOptions = list(big.mark = ","))) %>%
  dplyr::mutate(covariateName = stringr::str_remove(string = covariateName, pattern = "cohort: "), 
                covariateName = stringr::str_replace_all(string = covariateName, pattern = "_", replacement = " ")) %>%
  dplyr::rename("Condition" = "covariateName") %>%
  dplyr::arrange(Condition)  %>%
  gt::gt() %>%
  gt::tab_caption(caption = "Table 6: Prevalence of conditions within the multimorbid population.")
t6_gt
gt::gtsave(t6_gt, filename = "Table6.docx", path = file.path(saveDirectory, "Results", "tables"))

# Plots
## Plot 1
ageAtOncet <- readRDS(file = file.path(saveDirectory, "Results", "descriptive", "ageAtOncet.Rds"))
multimorbidPatients <- readRDS(file = file.path(saveDirectory, "Results", "descriptive", "multimorbidPatients.Rds"))

p1 <- ggplot(data = ageAtOncet,  aes(x = ageGroup, y = N, fill = gender))+
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(name = "", values = c(Male = "#3E606F", Female = "#8C3F4D"))+
  labs(subtitle = paste0("N = ", multimorbidPatients),
       caption = "Figure 1: Multimorbid patients per age group.", fill = "No of Conditions")+ 
  scale_color_manual(name = "", values = c(Male = "#3E606F", Female = "#8C3F4D"))+
  theme_classic() +
  theme(text = element_text(color = "#3A3F4A"),
        panel.grid.major.y = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(linetype = "dotted", size = 0.1, color = "#3A3F4A"),
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 10), hjust = 0.030),
        plot.subtitle = element_text(size = 12, hjust = 0.030),
        plot.caption = element_text(size = 8, color = "#5D646F", hjust = 0.0),
        axis.text.x = element_text(size = 12, color = "#5D646F", angle = 45,  hjust=1),
        plot.background = element_rect(fill = "#EFF2F4"),
        legend.position = "bottom",
        legend.spacing = unit(0.1, "lines"),
        legend.text  = element_text(size = 8),
        legend.direction = "horizontal"
  ) +
  guides(fill = guide_legend(nrow = 1))
p1
ggplot2::ggsave(plot = p1, filename = "Plot1", path = file.path(saveDirectory, "Results", "plots"), device = "jpeg" )

## Plot 2
ageCrossSectional <- readRDS(file = file.path(saveDirectory, "Results", "descriptive", "ageCrossSectional.Rds"))

### Figure 2: Multimorbid patients per age group stratified by gender 
p2 <- ggplot()+
  geom_bar(data = ageCrossSectional[ageCrossSectional$gender=="Male",], aes(x = ageGroup, y = N, fill = groupedConditions), stat = "identity",  alpha = 0.8, position = position_stack(reverse = TRUE))+
  geom_bar(data = ageCrossSectional[ageCrossSectional$gender=="Female",], aes(x = ageGroup, y = -N, fill = groupedConditions), stat = "identity", alpha = 0.8, position = position_stack(reverse = TRUE)) +
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
ggplot2::ggsave(plot = p2, filename = "Plot2", path = file.path(saveDirectory, "Results", "plots"), device = "jpeg" )

## Plot 3
mmConditionPrevalence <- readRDS(file = file.path(saveDirectory, "Results", "descriptive", "mmConditionPrevalence.Rds"))

p3 <- mmConditionPrevalence %>%
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
ggplot2::ggsave(plot = p3, filename = "Plot3", path = file.path(saveDirectory, "Results", "plots"), device = "jpeg" )
