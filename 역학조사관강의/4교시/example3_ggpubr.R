## histogram
data <- read.csv("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/example_g1e.csv")

data3 <- data2[,HTN:=as.factor(ifelse(Q_PHX_DX_HTN==1,"Yes","NO"))]

plot1 <- gghistogram(data=data3, x="WGHT",
                     color="HTN", fill = "HTN", add="mean",
                     main="Weight distrubution by HTN history",
                     xlab="Weight(kg)",
                     legend.title="HTN Dx history")

print(plot1)

## box plot
plot2 <- ggboxplot(data=data3, x="HTN", y="WGHT", color="HTN",
               main="Weight distrubution by HTN history",
               ylab="Weight(kg)",
               xlab="HTN Dx history",
               legend="none") +
  stat_compare_means(method = "t.test", label.x.npc = "middle")

print(plot2)

#세그룹
my_comparisons <- list(c("1", "2"), c("2", "3"), c("1", "3"))
plot3 <- ggboxplot(data=data3, x="Q_SMK_YN", y="WGHT", color="Q_SMK_YN",
               main="Weight distrubution by smoking",
               ylab="Weight(kg)",
               xlab="Smoking",
               legend="none") +
  stat_compare_means(comparisons = my_comparisons) +
  stat_compare_means(label.y = 150) +
  scale_x_discrete(labels=c("Never", "Ex-smoker", "Current"))

print(plot3)

## scatter plot
plot4 <- ggscatter(data=data3, x="HGHT", y="WGHT", 
               add = "reg.line", conf.int = TRUE,
               add.params = list(color = "navy", fill = "lightgray"),
               ylab="Weight(kg)",
               xlab="Height(cm)") +
  stat_cor(method = "pearson")

print(plot4)

plot5 <- ggscatter(data=data3, x="HGHT", y="WGHT", color="HTN", alpha=0.5,
               add = "reg.line", conf.int = TRUE,
               ylab="Weight(kg)",
               xlab="Height(cm)") +
  stat_cor(aes(color = HTN))

print(plot5)

## ggarange
ggarrange(plot2, plot3,
          labels = c("A", "B"),
          ncol = 2, nrow = 1)

# Save plots
library(rvg); library(officer)

plot_file <- read_pptx() %>%
  add_slide() %>% ph_with(dml(ggobj = plot1), location=ph_location_type(type="body")) %>%
  add_slide() %>% ph_with(dml(ggobj = plot4), location=ph_location_type(type="body")) %>%
  add_slide() %>% ph_with(dml(ggobj = plot5), location=ph_location_type(type="body"))


print(plot_file, target = "plot_file.pptx")
