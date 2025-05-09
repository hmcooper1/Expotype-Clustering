# ------------------------------------------------------------------------------
# Purpose: This script calculates gap statistic to determine the optimal number
# of clusters for GMM (did not use for final decision)
# ------------------------------------------------------------------------------

# Data and libraries ===========================================================
library(mclust)
library(cluster)
library(factoextra)
library(ggplot2)
ukb_cluster_encoded <- readRDS('/rds/general/project/hda_24-25/live/TDS/Group06/extraction_and_recoding/outputs/ukb_cluster_encoded.rds')
set.seed(123)

# Calculate gap statistic for different cluster numbers ========================
gmm_clustering <- function(x, k) {
  gmm_model <- Mclust(x, G = k)
  return(list(cluster = gmm_model$classification))  # Return in expected format
}

# Compute Gap Statistic
gap_stat <- clusGap(ukb_cluster_encoded, FUN = gmm_clustering,  K.max = 20, B = 50)  

# Print Gap Statistics Table
print(gap_stat, method = "firstmax")

# Plot the Gap Statistic
gap_plot <- fviz_gap_stat(gap_stat)

# Save the plot
ggsave('gap_plot.png', plot = gap_plot, width = 8, height = 6, dpi = 300)

# Find the optimal number of clusters
best_k_gap <- maxSE(gap_stat$Tab[, "gap"], gap_stat$Tab[, "SE.sim"])
print(paste("Best number of clusters based on Gap Statistic:", best_k_gap))
