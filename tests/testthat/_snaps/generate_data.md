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
      # A tibble: 400 x 8
             x     y    x1    y1    x2    y2 type       i    
         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>
       1    70   280  NA     NA   NA     NA  <NA>       <NA> 
       2    84   245  NA     NA   NA     NA  <NA>       <NA> 
       3   126   217  NA     NA   NA     NA  <NA>       <NA> 
       4   168   217  NA     NA   NA     NA  <NA>       <NA> 
       5    NA    NA  75.7  269.  71.9  254. leaf_stalk <NA> 
       6    NA    NA  82.4  259.  97.3  257. leaf_stalk <NA> 
       7    NA    NA  90.5  250.  90.5  235. leaf_stalk <NA> 
       8    NA    NA  98.8  242. 114.   244. leaf_stalk <NA> 
       9    NA    NA 107.   236. 110.   222. leaf_stalk <NA> 
      10    NA    NA 117.   231. 131.   235. leaf_stalk <NA> 
      # ... with 390 more rows

