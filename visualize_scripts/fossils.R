library(magrittr)
library(scattermore)
library(RColorBrewer)

# you have to download the files and place them into the folder
# https://3d.si.edu
trex <- as.matrix(read.table('../fossils_data/trex_points.tsv')[,2:3])

# without blur
par(mar=c(0,0,0,0))
trex %>% scatter_histogram %>% sqrt %>% 
histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(11, 'Spectral'), alpha=1)) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

# blurred one
par(mar=c(0,0,0,0))
trex %>% scatter_histogram %>% sqrt %>% apply_kernel_histogram %>% 
histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(11, 'Spectral'), alpha=1)) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot



mammoth <- as.matrix(read.table('../fossils_data/mammoth_points.tsv')[,2:3])

# without blur
par(mar=c(0,0,0,0))
mammoth %>% scatter_histogram %>% sqrt %>% 
histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(11, 'PiYG'), alpha=1)) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

# blurred one
par(mar=c(0,0,0,0))
mammoth %>% scatter_histogram %>% sqrt %>% apply_kernel_histogram %>% 
histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(11, 'PiYG'), alpha=1)) %>% 
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot
