library(ggplot2)
library(dplyr)
library(reshape2)

topEconEvents <- stormData %>%
  group_by(EVTYPE) %>%
  summarize(total_cost = sum(TOTALDMG, na.rm=TRUE),
            max_cost = max(TOTALDMG, na.rm=TRUE)) %>%
  filter(total_cost>0) %>%
  top_n(n = 10, wt = total_cost) %>%
  rename("Total Cost" = total_cost, "Max Cost" = max_cost)

topEconEvents.long <- melt(topEconEvents, id.vars="EVTYPE")
topEconEvents.long$EVTYPE <- factor(topEconEvents.long$EVTYPE)
topEconEvents.long$variable <- factor(topEconEvents.long$variable)

plt <- ggplot(topEconEvents.long, aes(x=EVTYPE, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") +
  scale_color_discrete("Metric") +
  xlab("Event Type") +
  ylab("Cost ($)") +
  ggtitle("Economic Impact of Weather Events") +
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))