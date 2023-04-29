library(magrittr)
library(scattermore)
library(RColorBrewer)

water_points <- as.matrix(read.table('../maps_data/czech_waterways_points')[,2:3])
ways_points <- as.matrix(read.table('../maps_data/czech_highways_points')[,2:3])

water_lines <- cbind(water_points[1:2599331,c(1,2)], water_points[2:2599332, c(1,2)])
ways_lines <- cbind(ways_points[1:10180390,c(1,2)], ways_points[2:10180391, c(1,2)])

water_lines_original <- as.matrix(read.table('../maps_data/czech_waterways_lines.tsv'))
ways_lines_original <- as.matrix(read.table('../maps_data/czech_highways_lines.tsv'))



# plot using points
par(mar=c(0,0,0,0))
water_points %>% scatter_histogram(out_size=c(768,512)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'Blues'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

par(mar=c(0,0,0,0))
ways_points %>% scatter_histogram(out_size=c(768,512)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'BrBG'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot



# plot from created line data
par(mar=c(0,0,0,0))
water_lines %>% scatter_lines_histogram(out_size=c(768,512)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'Blues'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

par(mar=c(0,0,0,0))
water_lines %>% scatter_lines_histogram(out_size=c(768,512)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'BrBG'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot



# plot using lines
par(mar=c(0,0,0,0))
ways_lines_original %>%scatter_lines_histogram(out_size=c(512,768)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'BrBG'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot

par(mar=c(0,0,0,0))
water_lines_original %>%scatter_lines_histogram(out_size=c(512,768)) %>%
log1p %>% histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'Blues'), alpha=1)) %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot



# plot histogram of highways data with contours
histogram <- apply_kernel_histogram(log1p(scatter_lines_histogram(ways_lines_original, out_size=c(512,768))), radius=10, filter="gauss")
image(histogram)
rasterImage(xleft=0, xright=1, ybottom=1, ytop=0, rgba_int_to_raster(rgbwt_to_rgba_int(histogram_to_rgbwt(histogram, RGBA=col2rgb(brewer.pal(9, 'BrBG'), alpha=1)))))
contour(z=t(histogram), add=T, nlevels=5)
