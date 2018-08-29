#factoextra::Extract and Visualize the Results of Multivariate Data Analyses
#http://www.sthda.com/english/rpkgs/factoextra/
#-----------------------------------------------------------
install.packages("FactoMineR")
library("FactoMineR")
install.packages("factoextra")
library("factoextra")
#-------------------------------
#Principal component analysis
library("factoextra")
data("decathlon2")
df <- decathlon2[1:23, 1:10]
#Principal component analysis
library("FactoMineR")
res.pca <- PCA(df,  graph = FALSE)
#Extract and visualize eigenvalues/variances
# Extract eigenvalues/variances
get_eig(res.pca)
# Visualize eigenvalues/variances
fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 50))
#.Extract and visualize results for variables:
# Extract the results for variables
var <- get_pca_var(res.pca)
var
# Coordinates of variables
head(var$coord)
# Contribution of variables
head(var$contrib)
# Graph of variables: default plot
fviz_pca_var(res.pca, col.var = "black")
#It's possible to control variable colors using their contributions ("contrib") to the principal axes:
# Control variable colors using their contributions
fviz_pca_var(res.pca, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)
#Variable contributions to the principal axes:
# Contributions of variables to PC1
fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)

# Contributions of variables to PC2
fviz_contrib(res.pca, choice = "var", axes = 2, top = 10)
#-------Extract and visualize results for individuals:
# Extract the results for individuals
ind <- get_pca_ind(res.pca)
ind
# Coordinates of individuals
head(ind$coord)
# Graph of individuals
# 1. Use repel = TRUE to avoid overplotting
# 2. Control automatically the color of individuals using the cos2
# cos2 = the quality of the individuals on the factor map
# Use points only
# 3. Use gradient color
fviz_pca_ind(res.pca, col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping (slow if many points)
)
# Biplot of individuals and variables
fviz_pca_biplot(res.pca, repel = TRUE)
#-----Color individuals by groups:
# Compute PCA on the iris data set
# The variable Species (index = 5) is removed
# before PCA analysis
iris.pca <- PCA(iris[,-5], graph = FALSE)

# Visualize
# Use habillage to specify groups for coloring
fviz_pca_ind(iris.pca,
             label = "none", # hide individual labels
             habillage = iris$Species, # color by groups
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE # Concentration ellipses
)
             