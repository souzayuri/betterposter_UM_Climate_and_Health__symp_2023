
if(!require(tidyverse)) install.packages("tidyverse", dependencies = TRUE)
if(!require(iNEXT)) install.packages("iNEXT", dependencies = TRUE)


termites_spp <- read_csv("00_data/termites_Brazil.csv") %>% 
  group_by(Site, Identification) %>% 
  mutate(Code_frequency = n()) %>% 
  ungroup() %>% 
  distinct() %>% 
  pivot_wider(names_from = Site, values_from = Code_frequency) %>% 
  replace(is.na(.), 0) %>% 
  write_csv("00_data/termites_sp_effort_Brazil.csv")


termites_spp_se <- read_csv("00_data/termites_sp_effort_Brazil_sum.csv") %>% 
  column_to_rownames("Identification") %>% 
  as.matrix()

res_rarefacao_amostras <- iNEXT(termites_spp_se, q = 0, 
                                datatype = "incidence_freq") 

ggiNEXT(res_rarefacao_amostras , type = 1, color.var = "Assemblage") + 
  #geom_vline(xintercept = 16, lty = 2) +
  scale_colour_manual(values = c("darkorange", "darkorchid", "cyan4", "red")) +
  scale_fill_manual(values = c("darkorange", "darkorchid", "cyan4", "red")) +
  scale_linetype_discrete(name = "Método", labels = c("Observed", "Extrapolated")) +
  labs(x = "Sample Size", y = "Species richness") +
  theme_minimal() +
  theme(legend.direction = "vertical",
        legend.position = c(0.2,0.8),
        axis.title = element_text(size = 28),
        axis.text.x = element_text(size = 24),
        axis.text.y = element_text(size = 24),
        legend.title = element_text(size = 22),
        legend.text = element_text(size = 22))

ggsave("02_figures/rarefaction_curve.png", width = 25, height = 25, units = "cm", dpi = 500)













