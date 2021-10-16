# generated bezier leaf dataframe still the same

    Code
      benjamini_leaf()
    Output
      # A tibble: 36 x 3
             x     y i    
         <dbl> <dbl> <chr>
       1  10    40   stalk
       2  10.0  40.9 stalk
       3  20.0  39.4 stalk
       4  20    40   stalk
       5  20    40   1    
       6  22    36   1    
       7  29    35.2 1    
       8  34    35   1    
       9  34    35   2    
      10  39    34.8 2    
      # ... with 26 more rows

# generated bezier branch dataframe still the same

    Code
      benjamini_branch()
    Output
      # A tibble: 436 x 4
             x     y i       type       
         <dbl> <dbl> <chr>   <chr>      
       1  70    280  <NA>    <NA>       
       2  84    245  <NA>    <NA>       
       3 126    217  <NA>    <NA>       
       4 168    217  <NA>    <NA>       
       5  75.7  269. stalk_1 leaf_bezier
       6  75.9  269. stalk_1 leaf_bezier
       7  84.2  266. stalk_1 leaf_bezier
       8  84.4  266. stalk_1 leaf_bezier
       9  84.4  266. 1_1     leaf_bezier
      10  84.8  260. 1_1     leaf_bezier
      # ... with 426 more rows

