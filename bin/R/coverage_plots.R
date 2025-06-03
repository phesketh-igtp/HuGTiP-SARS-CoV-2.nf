#!/bin/bash/R

# Library
library(dplyr)
library(ggplot2)
library(plotly)
library(htmlwidgets)

# import the df
depth <- read.delim("depths.csv", header = FALSE)
colnames(depth) <- c("chr", "pos", "depth")

scheme <- read.delim("scheme.bed", header=FALSE)
colnames(scheme) <- c("chr", "start", "stop", "primer", "pool", "dir", "nt")

delta <- 5  # vertical offset from center

amplicons <- scheme %>%
  mutate(
    primer_id = str_extract(primer, "nCoV-2019_\\d+"),
    end = ifelse(grepl("LEFT", primer), "LEFT", "RIGHT")
  ) %>%
  select(primer_id, end, start, stop) %>%
  pivot_wider(names_from = end, values_from = c(start, stop)) %>%
  drop_na() %>%
  mutate(
    region_start = pmin(start_LEFT, start_RIGHT, na.rm = TRUE),
    region_stop = pmax(stop_LEFT, stop_RIGHT, na.rm = TRUE),
    y = rep(c(delta, -delta), length.out = n())  # alternate up/down
  )


# Create a group ID that increases whenever there's a gap > 1
depth_segmented <- depth %>%
  arrange(pos) %>%
  mutate(
    gap = c(0, diff(pos)),
    group = cumsum(gap > 1)
  )



p <- ggplot(depth_segmented, aes(x = pos, y = depth, group = group)) +
  geom_area(fill = "steelblue", alpha = 0.6) +
  
  # Primer horizontal bars
  geom_segment(data = amplicons,
               aes(x = region_start, xend = region_stop, y = y, yend = y, text = primer_id),
               inherit.aes = FALSE,
               color = "firebrick", size = 0.7) +
  
  # End caps
  geom_linerange(data = amplicons,
                 aes(x = region_start, ymin = y - 1, ymax = y + 1, text = primer_id),
                 inherit.aes = FALSE,
                 color = "firebrick", size = 0.7) +
  geom_linerange(data = amplicons,
                 aes(x = region_stop, ymin = y - 1, ymax = y + 1, text = primer_id),
                 inherit.aes = FALSE,
                 color = "firebrick", size = 0.7) +
  labs(x = "Genomic position", y = "Read depth") +
  theme_minimal()

# Convert to interactive plot with hover
p_plotly <- ggplotly(p, tooltip = "text")

# Save as standalone HTML
saveWidget(p_plotly, "sequencing_depth_plot.html", selfcontained = TRUE)