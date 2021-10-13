# generated bezier leaf dataframe still the same

    Code
      benjamini_leaf()
    Output
      # A tibble: 36 x 3
         i         x     y
         <chr> <dbl> <dbl>
       1 1        20  40  
       2 1        21  34  
       3 1        28  30.5
       4 1        33  31  
       5 2        33  31  
       6 2        38  31.5
       7 2        43  37.2
       8 2        47  38.6
       9 3        47  38.6
      10 3        51  40.0
      # ... with 26 more rows

# generated bezier branch dataframe still the same

    Code
      benjamini_branch()
    Output
      # A tibble: 436 x 4
             x     y i     type       
         <dbl> <dbl> <chr> <chr>      
       1  70    280  <NA>  <NA>       
       2  84    245  <NA>  <NA>       
       3 126    217  <NA>  <NA>       
       4 168    217  <NA>  <NA>       
       5  84.1  265. 1_1   leaf_bezier
       6  85.8  260. 1_1   leaf_bezier
       7  95.5  253. 1_1   leaf_bezier
       8 101.   252. 1_1   leaf_bezier
       9 101.   252. 2_1   leaf_bezier
      10 107.   250. 2_1   leaf_bezier
      # ... with 426 more rows

