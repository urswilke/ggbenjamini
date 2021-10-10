library(tidyverse)
library(ggforce)
library(minisvg)

points_df <- tibble(
  x = c(10, 30, 40, 43),
  y = c(40, 30, 38, 40)
)
slopes_df <-
  tibble(
    x = c(2, 10, 3, 0),
    y = c(-10, 2, 0,  1)
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


# minisvg -----------------------------------------------------------------
doc <- SVGDocument$new(width = 64, height = 100)

path_str <- bezier_df %>%
  filter(!str_detect(i, "r")) %>%
  group_by(i) %>%
  slice(-1) %>%
  summarise(cb = paste(x, y, sep = ",", collapse = " ")) %>%
  pull(cb) %>%
  paste("C", ., collapse = " ") %>% paste("Z") %>% paste0("M ", bezier_df$x[1], ",", bezier_df$y[1], " ", .)

path_str2 <- bezier_df %>%
  filter(str_detect(i, "r")) %>%
  group_by(i) %>%
  slice(-1) %>%
  summarise(cb = paste(x, y, sep = ",", collapse = " ")) %>%
  pull(cb) %>%
  paste("C", ., collapse = " ") %>% paste("Z") %>% paste0("M ", bezier_df$x[1], ",", bezier_df$y[1], " ", .)

doc$append(
  stag$path(
    d = path_str,
    fill="green",
    fill_opacity="1"
  ),
  stag$path(
    d = path_str2,
    fill="darkgreen",
    fill_opacity="1"
  )
)
doc$show()
