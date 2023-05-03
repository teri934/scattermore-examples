library(scattermore)
library(RColorBrewer)

makedata <- function(
    n = 10240, k = 30, d = 40,
    rnw = 3, rpw = 1, nw = 5,
    rnwf = function(sp) rnw, rpwf = function(sp) rpw, nwf = function(sp) nw,
    iters = 250L, alpha = 0.02, accel = 1, threads = 0L,
    n_pheno = 20, pheno_positive_probability = 0.2,
    spectra_sdev = 0.2, spectra_intensity = 4,
    negative_population_intensity = 2,
    positive_population_intensity = 3,
    population_intensity_sdev = 0.1,
    emission_rate = 0.999, emission_quantum = 10,
    crosstalk_sdev = 0.0005,
    asinh_cofactor = 100,
    plotf = plot) {
  # generate and normalize a random set of spectra
  spectra <- matrix(exp(spectra_intensity * runif(k * d)), k, d) *
    exp(rnorm(k, sd = spectra_sdev))
  spectra <- spectra / sqrt(rowSums(spectra^2))

  # generate a few cell phenotypes, then generate base expressions of cells of
  # a random phenotype, with a bit of standard deviation in the expression
  # (this roughly corresponds to marker amount on cells)
  pheno <- matrix(
    sample(c(0, 1),
      prob = c(1 - pheno_positive_probability, pheno_positive_probability),
      replace = T, n_pheno * k
    ),
    n_pheno, k
  )
  exprs <- 10^(negative_population_intensity + (positive_population_intensity-negative_population_intensity) *
    (pheno[sample(n_pheno, n, replace = T), ] +
      rnorm(k * n, sd = population_intensity_sdev)))

  # this is the amount of light that could be theoretically emitted, but some
  # photons get lost (the ratio lost is guided by beta distribution)
  emissible <- exprs %*% spectra
  emissible_quanta <- emissible / emission_quantum
  emitted <- emissible *
    matrix(
      rbeta(
        length(emissible),
        emission_rate * emissible_quanta,
        (1 - emission_rate) * emissible_quanta
      ),
      n, d
    )

  # add static noise from the receiver dependent on the total signal
  received <- emitted +
    rnorm(length(emitted),
      sd = crosstalk_sdev * sqrt(rowSums(emitted^2))
    )

  # unmix using OLS
  olsres <- t(lm(t(received) ~ t(spectra) + 0)$coefficients)

  # transformation function
  trans <- function(x) asinh(x / asinh_cofactor)

  return(list(ground.truth = trans(exprs[,1:2]), simulated=trans(olsres[,1:2])))
}


set.seed(127)
d <- makedata(n=102400, k=20, d=20, positive_population_intensity=4, negative_population_intensity=1, population_intensity_sdev=0.1)
points_rgbwt <- scatter_points_rgbwt(d$simulated, RGBA=c(0,0,255,50))
lines <- cbind(d$ground.truth, d$simulated)
lines_rgbwt <- scatter_lines_rgbwt(lines, RGBA = c(255,0,0,10))
lines_histogram <- scatter_lines_histogram(lines)


# plot generated points and lines
par(mar=c(0,0,0,0))
plot(rgba_int_to_raster(rgbwt_to_rgba_int(points_rgbwt)))
par(new=TRUE)
plot(rgba_int_to_raster(rgbwt_to_rgba_int(lines_rgbwt)))


# plot histogram of lines together with points
par(mar=c(0,0,0,0))
lines_histogram %>% log1p %>% apply_kernel_histogram(filter="gauss", radius=10) %>% 
histogram_to_rgbwt(RGBA=col2rgb(brewer.pal(9, 'Oranges'), alpha=1)) %>% {. ->> lines_histogram_rgbwt}

comb <- merge_rgbwt(points_rgbwt, lines_histogram_rgbwt)
plot(rgba_int_to_raster(rgbwt_to_rgba_int(comb)))