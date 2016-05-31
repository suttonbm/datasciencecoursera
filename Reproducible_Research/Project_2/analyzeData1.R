library(dplyr)
library(pander)

topFatalities <- stormData %>%
  group_by(EVTYPE) %>%
  summarize(total_fatalities = sum(FATALITIES, na.rm=TRUE),
            max_fatalities = max(FATALITIES, na.rm=TRUE)) %>%
  filter(total_fatalities>0) %>%
  arrange(desc(total_fatalities), desc(max_fatalities)) %>%
  mutate("Rank"=row_number()) %>%
  top_n(n = 10, wt = total_fatalities) %>%
  rename("Single Event" = max_fatalities, "Total Events" = total_fatalities, "Event Type" = EVTYPE)

topInjuries <- stormData %>%
  group_by(EVTYPE) %>%
  summarize(total_injuries = sum(INJURIES, na.rm=TRUE),
            max_injuries = max(INJURIES, na.rm=TRUE)) %>%
  filter(total_injuries>0) %>%
  arrange(desc(total_injuries), desc(max_injuries)) %>%
  mutate("Rank"=row_number()) %>%
  top_n(n = 10, wt = total_injuries) %>%
  rename("Single Event" = max_injuries, "Total Events" = total_injuries, "Event Type" = EVTYPE)