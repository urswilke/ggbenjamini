# generated bezier leaf dataframe still the same

    Code
      benjamini_leaf()
    Output
      # A tibble: 36 x 3
         i         x     y
         <chr> <dbl> <dbl>
       1 1        20  40  
       2 1        22  36  
       3 1        29  35.2
       4 1        34  35  
       5 2        34  35  
       6 2        39  34.8
       7 2        43  37.3
       8 2        45  38.8
       9 3        45  38.8
      10 3        47  40.2
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
       5  84.4  266. 1_1   leaf_bezier
       6  84.8  260. 1_1   leaf_bezier
       7  96.7  258. 1_1   leaf_bezier
       8 101.   257. 1_1   leaf_bezier
       9 101.   257. 2_1   leaf_bezier
      10 104.   256. 2_1   leaf_bezier
      # ... with 426 more rows

