# Part 2
# Блок визуализации
# http://www.sthda.com/english/wiki/ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page-r-software-and-data-visualization

plot(oil.xts)
plot(oil.xts.shift1)
plot(oil.xts.shift2)
plot(oil.xts.shift5)


# Попробуем изучить, когда у нас были не точные показания, 
# что какие были вероятности для каждого значения
# df_y_test - содержит информацию о по результатам моделирования

str(df_y_test)
# 'data.frame':	732 obs. of  4 variables:
#   $ predict: num  1 0 0 0 1 0 0 0 0 0 ...
# $ p0     : num  0.258 0.567 0.606 0.551 0.408 ...
# $ p1     : num  0.742 0.433 0.394 0.449 0.592 ...
# $ actual : Factor w/ 2 levels "0","1": 2 2 1 2 1 1 1 1 1 2 ...

library(tidyr)
library("gridExtra")
library("cowplot")
df_y_test %>%
  filter(actual != predict, actual== 1) %>%
  gather("isRaise", "Prob", 1:2) %>%  
  ggplot(aes(isRaise, Prob)) + geom_boxplot() -> gFailsFalse

df_y_test %>%
  filter(actual != predict, actual == 0) %>%
  gather("isRaise", "Prob", 1:2) %>%  
  ggplot(aes(isRaise, Prob)) + geom_boxplot() -> gFailsTrue

df_y_test %>%
  filter(actual == predict, actual == 1) %>%
  gather("isRaise", "Prob", 1:2) %>%  
  ggplot(aes(isRaise, Prob)) + geom_boxplot() -> gAccurateTrue 

df_y_test %>%
  filter(actual == predict, actual == 0) %>%
  gather("isRaise", "Prob", 1:2) %>%  
  ggplot(aes(isRaise, Prob)) + geom_boxplot() -> gAccurateFalse

ggdraw() +
  draw_plot(gFailsFalse, 0, .5, 0.5, .5) +
  draw_plot(gFailsTrue, 0.5, .5, 0.5, .5) +
  draw_plot(gAccurateFalse, 0, 0, .5, .5) +
  draw_plot(gAccurateTrue, .5, 0, .5, .5) +
  draw_plot_label(c("Fails", "Good"), 
                  c(0.4, 0.4),
                  c(1, 0.5), size = 15)
