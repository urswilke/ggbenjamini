library(tidyverse)
library(ggforce)
library(minisvg)
library(zeallot)

points_df <- tibble(
  x = c(10, 30, 40, 45),
  y = c(40, 30, 39, 40)
)
slopes_df <-
  tibble(
    x = c(4, 5, 3, 0),
    y = c(-10, 2, 1,  1)
  )

get_one_bezier <- function(i, points_df, slopes_df) {
  bind_rows(
    points_df %>% slice(i),
    slopes_df %>% slice(i) + points_df %>% slice(i),
    -slopes_df %>% slice(i + 1) + points_df %>% slice(i + 1),
    points_df %>% slice(i + 1)
  )
}
get_bezier_df <- function(points_df, slopes_df) {
  slopes_middle_df <- tibble(
    x = c(-10, -10),
    y = c(-1, 1)
  )

  points_middle_df <- bind_rows(
      points_df %>% slice_tail(),
      points_df %>% slice_head()
    )
  middle_line_df <- get_one_bezier(1, points_middle_df, slopes_middle_df)
  1:3 %>% map_dfr(~get_one_bezier(.x, points_df, slopes_df), .id = "i") %>%
    bind_rows(middle_line_df %>% mutate(i = "4"))
}
points_df_rev <- points_df
points_df_rev$y[-1] <- - points_df_rev$y[-1] + points_df_rev$y[1] + points_df_rev$y[1]

bezier_df <- bind_rows(
  get_bezier_df(points_df, slopes_df),
  get_bezier_df(points_df_rev, slopes_df %>% mutate(y = -y)) %>% mutate(i = paste0(i, "r"))
)



p <- ggplot(bezier_df) +
  ggforce::geom_bezier(aes(x = x, y = y, group = i)) +
  coord_equal()
p

# minisvg -----------------------------------------------------------------


get_svg_bezier_string <- function(bezier_df) {
  bezier_df %>%
    group_by(i) %>%
    slice(-1) %>%
    summarise(cb = paste(x, y, sep = ",", collapse = " ")) %>%
    pull(cb) %>%
    paste("C", ., collapse = " ") %>% paste("Z") %>% paste0("M ", bezier_df$x[1], ",", bezier_df$y[1], " ", .)
}
get_both_bezier_strings <- function(bezier_df) {
  path_str <- bezier_df %>%
    filter(!str_detect(i, "r")) %>%
    get_svg_bezier_string()

  path_str2 <- bezier_df %>%
    filter(str_detect(i, "r")) %>%
    get_svg_bezier_string()
  list(path_str, path_str2)
}




# from here: https://stackoverflow.com/a/15464420
rotate_bezier_df <- function(bezier_df, alpha = 30, xrot = 50, yrot = 50, precision = 2) {

  rotm <- matrix(c(cos(alpha),sin(alpha),-sin(alpha),cos(alpha)),ncol=2)
  #shift, rotate, shift back

  M <- bezier_df %>% select(-i) %>% as.matrix()
  t(rotm %*% (t(M) - c(xrot, yrot)) + c(xrot, yrot)) %>%
    round(precision) %>%
    as_tibble() %>%
    set_names(c("x", "y")) %>%
    mutate(i = bezier_df$i)
}
M2 <- rotate_bezier_df(bezier_df)
# c(path_str, path_str2) %<-% get_both_bezier_strings(bezier_df)
c(path_str, path_str2) %<-% get_both_bezier_strings(M2)


append_leaf <- function(doc, path_str, path_str2) {
  doc$append(
    stag$path(
      d = path_str,
      fill="url(#RadialGradient3)",
      fill_opacity="1"
    ),
    stag$path(
      d = path_str2,
      fill="url(#RadialGradient4)",
      fill_opacity="1"
    )
  )
}
# append_leaf(doc, path_str, path_str2)
g3 <- stag$radialGradient(
  id = "RadialGradient3", cx="0.35", cy="0.63", r="0.7",
  stag$stop(offset = "0%", stop_color = "#00FF00"),
  stag$stop(offset = "100%", stop_color = "#008000")
)
g4 <- stag$radialGradient(
  id = "RadialGradient4", cx="0.5", cy="0.5", r="0.5",
  stag$stop(offset = "0%", stop_color = "#40DD40"),
  stag$stop(offset = "100%", stop_color = "#208020")
)

doc <- SVGDocument$new(width = 640, height = 640)

doc$append(g3, g4)


(seq(0, 360, by = 15) / 90 * pi / 2) %>%
  map(~rotate_bezier_df(bezier_df, alpha = .x, xrot = 100, yrot = 100)) %>%
  map(get_both_bezier_strings) %>%
  walk(~append_leaf(doc, .x[[1]], .x[[2]]))


doc$show()
