library(scattermore)
library(magrittr)
library(RColorBrewer)

pts <- read.csv("../tibib/data_2d.csv")
pts <- data.matrix(pts, rownames.force = NA)

idxs <- read.csv("../tibib/v.csv")[,1]
n <- length(idxs)
starts <- read.csv("../tibib/starts.csv")[,1]

lns <- cbind(pts[idxs[1:(n-1)],1:2],pts[idxs[2:n],])
lns <- lns[-(starts-1),]


# plot density of the data
par(mar=c(0,0,0,0))
{
log(1 + 10 * (pts %>% scatter_points_histogram %>%  
apply_kernel_histogram(radius=5))) %>% histogram_to_rgbwt(RGBA=col2rgb(colorRampPalette(brewer.pal(9, "BuPu"))(50), alpha=1))%>% 
{. ->> pts_rgbwt} %>% rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot
}


# plot line data
par(mar=c(0,0,0,0))
lns %>% scatter_lines_rgbwt(RGBA=c(255,255,140,10)) %>% {. ->> lns_rgbwt} %>%
rgbwt_to_rgba_int %>% rgba_int_to_raster %>% plot


# blend the together so the lines are above the points
par(mar=c(0,0,0,0))
comb <- blend_rgba_float(list(rgbwt_to_rgba_float(lns_rgbwt), rgbwt_to_rgba_float(pts_rgbwt)))
comb %>% rgba_float_to_rgba_int %>% rgba_int_to_raster %>% plot

