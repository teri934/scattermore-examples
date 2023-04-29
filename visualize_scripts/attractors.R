library(magrittr)
library(scattermore)
library(RColorBrewer)

attractor_clifford <- as.matrix(read.csv('../attractors_generated_data/clifford.csv', sep =",", skipNul=TRUE))
attractor_svensson <- as.matrix(read.csv('../attractors_generated_data/svensson.csv', sep =",", skipNul=TRUE))
attractor_hopalong <- as.matrix(read.csv('../attractors_generated_data/hopalong2.csv', sep =",", skipNul=TRUE))
attractor_symmetric <- as.matrix(read.csv('../attractors_generated_data/symmetric_icon.csv', sep =",", skipNul=TRUE))

# choose here which attractor to plot
attractor <- attractor_clifford
  
par(mar=c(0,0,0,0))
attractor %>% scatter_points_rgbwt(RGBA=c(81,223,90,10)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot



# lorenz attractor from various views (cresting line data from points)
attractor_lorenz <- as.matrix(read.csv("../attractors_generated_data/lorenz.csv"))
dim_lorenz <- 1666666

par(mar=c(0,0,0,0))
cbind(attractor_lorenz[1:dim_lorenz,c(1,2)], attractor_lorenz[2:(dim_lorenz+1), c(1,2)]) %>% 
scatter_lines_histogram(out_size=c(512,512)) %>% log1p %>% 
histogram_to_rgbwt(RGBA=col2rgb(viridisLite::turbo(100), alpha=T)*rbind(1,1,1,pmin(1,seq(0,3,length.out=100)))) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

par(mar=c(0,0,0,0))
cbind(attractor_lorenz[1:dim_lorenz,c(2,3)], attractor_lorenz[2:(dim_lorenz+1), c(2,3)]) %>% 
scatter_lines_histogram(out_size=c(512,512)) %>% log1p %>% 
histogram_to_rgbwt(RGBA=col2rgb(viridisLite::plasma(100), alpha=T)*rbind(1,1,1,pmin(1,seq(0,3,length.out=100)))) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot


par(mar=c(0,0,0,0))
cbind(attractor_lorenz[1:dim_lorenz,c(1,3)], attractor_lorenz[2:(dim_lorenz+1), c(1,3)]) %>% 
scatter_lines_histogram(out_size=c(512,512)) %>% log1p %>% 
histogram_to_rgbwt(RGBA=col2rgb(viridisLite::rocket(100), alpha=T)*rbind(1,1,1,pmin(1,seq(0,3,length.out=100)))) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot
