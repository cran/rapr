EVAL <- as.logical(Sys.getenv("R_RAPR_EXTENDED_EXAMPLES", unset=FALSE))
litedown::reactor(
  eval = EVAL,
  collapse = TRUE,
  fig.width = 6,
  fig.align = 'center'
)

library(rapr)    # access RAP products
library(terra)   # spatial data handling

p <- buffer(terra::vect(
  data.frame(x = -105.97133, y = 32.73437),
  geom = c("x", "y"),
  crs = "OGC:CRS84"
), width = 1000)

terra::plet(p, tiles = c("Esri.WorldImagery", "OpenTopoMap"))

rap <- get_rap(
  p,
  product = "vegetation-biomass",
  years = 1986:2024,
  verbose = FALSE
)

plot(rap[[1]], main = names(rap)[1])

makeplot <- function() {
  lapply(grep("annual_forb_and_grass", names(rap)), function(i) {
    terra::plot(
      rap[[i]],
      main = names(rap)[i],
      type = "continuous",
      range = c(0, 500),
      cex.main = TRUE
    )
    terra::plot(
      terra::as.lines(p),
      col = "white",
      add = TRUE
    )
  })
}

try({
  
library(gifski) 
gifski::save_gif(makeplot(), 
                 gif_file = "annual_forb_and_grass_biomass.gif", 
                 delay = 0.5)

})

if (file.exists("annual_forb_and_grass_biomass.gif")) {
  cat("![](annual_forb_and_grass_biomass.gif)")
}

