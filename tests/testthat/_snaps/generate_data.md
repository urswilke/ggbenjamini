# generated bezier leaf dataframe still the same

    Code
      benjamini_leaf()
    Output
      # A tibble: 32 x 3
         i         x     y
         <chr> <dbl> <dbl>
       1 1        10  40  
       2 1        12  35  
       3 1        18  30.8
       4 1        24  31  
       5 2        24  31  
       6 2        30  31.2
       7 2        34  37.3
       8 2        36  38.4
       9 3        36  38.4
      10 3        38  39.4
      # ... with 22 more rows

# generated bezier branch dataframe still the same

    Code
      benjamini_branch()
    Output
      # A tibble: 202 x 8
             x     y    x1    y1    x2    y2 type       i    
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>
       1    70   280  NA     NA   NA     NA  <NA>       <NA> 
       2    84   245  NA     NA   NA     NA  <NA>       <NA> 
       3   126   217  NA     NA   NA     NA  <NA>       <NA> 
       4   168   217  NA     NA   NA     NA  <NA>       <NA> 
       5    NA    NA  78.9  264.  76.1  249. leaf_stalk <NA> 
       6    NA    NA  89.7  251. 105.   250. leaf_stalk <NA> 
       7    NA    NA 103.   239. 105.   224. leaf_stalk <NA> 
       8    NA    NA 118.   230. 132.   234. leaf_stalk <NA> 
       9    NA    NA 134.   223. 141.   209. leaf_stalk <NA> 
      10    NA    NA 168    217  179.   228. leaf_stalk <NA> 
      # ... with 192 more rows

