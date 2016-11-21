# #library(summarytools)
# data("tabagisme")
# wgts <- rnorm(300, 2, 1)
# wgts <- wgts - (sum(wgts)-300)/300
# sum(wgts)
# sexe <- tabagisme$sexe
# sexe[c(1,5,6,8,10,42,66,77,88,99,101,200, 230:255)] <- NA
#
#
# (f1 <- freq(tabagisme$sexe, weights = wgts,rescale.weights = FALSE))
# Hmisc::wtd.table(tabagisme$sexe,weights=wgts,type = "table")
# view(freq(tabagisme$sexe, weights = wgts))
# xtabs(wgts~sexe)
#
# (f2 <- freq(sexe, weights = wgts, rescale.weights = TRUE, round.digits = 2, keep.trailing.zeros=TRUE))
# (f3 <- freq(sexe, weights = wgts, rescale.weights = FALSE, keep.trailing.zeros=TRUE, round.digits = 2))
# Hmisc::wtd.table(sexe,weights=wgts,normwt=FALSE)
# view(freq(sexe, weights=wgts, rescale = FALSE))
# colSums(f2)
#

# Hmisc::wtd.table(sexe,weights=wgts,normwt=TRUE)
#
#
#
#
# sum(wgts)
#
#
# pander.option()
# Remove variable labels to prevent potential problems
# if("label" %in% names(attributes(variable))) {
#   attr(output, "var.label") <- rapportools::label(variable)
#   class(variable) <- setdiff(class(variable), "labelled")
#   attr(variable, "label") <- NULL
# }

# # Median: first find the position of the 2 points closest to the center once the weights are applied
# sorted.variable <- variable[order(variable)]
# sorted.weights <- weights[order(variable)]
# weights.cumsum <- cumsum(sorted.weights)/sum(sorted.weights)
# middle.points <- order(abs(0.5-weights.cumsum))[1:2]
#
# # measure the distance between 0.5 and those two points
# distances <- abs(weights.cumsum[middle.points]-0.5)
#
# # Calculate the weights of the 2 points according to this distance
# median.weights <- 1 - distances/sum(distances)
#
# # Multiply by the weights provided in the weights argument
# median.weights <- median.weights * sorted.weights[middle.points]
#
# # Get the final weights for the 2 median values and calculate median
# median.weights <- median.weights/sum(median.weights)
# variable.median <- sum(sorted.variable[middle.points] * median.weights)


# output$stats[i,] <- c(variable.mean,
#               variable.sd,
#               min(variable),
#               max(variable),
#               variable.median,
#               median(abs(variable-variable.median)), # mad
#               variable.mean/variable.sd) # cv

# Todo: voir si poss. d'ajouter IQR, skewness et kurtosis
