# generated bezier leaf dataframe still the same

    Code
      df_leaf
    Output
      # A tibble: 36 x 5
             x     y param_type             i_part element
         <dbl> <dbl> <chr>                   <dbl> <chr>  
       1  10    40   bezier start point          0 stalk  
       2  10.0  40.9 bezier control point 1      0 stalk  
       3  20.0  39.4 bezier control point 2      0 stalk  
       4  20    40   bezier end point            0 stalk  
       5  20    40   bezier start point          1 half 2 
       6  22    36   bezier control point 1      1 half 2 
       7  29    35.2 bezier control point 2      1 half 2 
       8  34    35   bezier end point            1 half 2 
       9  34    35   bezier start point          2 half 2 
      10  39    34.8 bezier control point 1      2 half 2 
      # ... with 26 more rows

# generated bezier branch dataframe still the same

    Code
      df_branch
    Output
      # A tibble: 436 x 8
             x     y b          i_part i_branch type        element param_type        
         <dbl> <dbl> <chr>       <dbl>    <dbl> <chr>       <chr>   <chr>             
       1  70    280  1_0_branch      1        0 branch      branch  bezier start point
       2  84    245  1_0_branch      1        0 branch      branch  bezier control po~
       3 126    217  1_0_branch      1        0 branch      branch  bezier control po~
       4 168    217  1_0_branch      1        0 branch      branch  bezier end point  
       5  75.7  269. 0_1_stalk       0        1 leaf_bezier stalk   bezier start point
       6  75.9  269. 0_1_stalk       0        1 leaf_bezier stalk   bezier control po~
       7  84.2  266. 0_1_stalk       0        1 leaf_bezier stalk   bezier control po~
       8  84.4  266. 0_1_stalk       0        1 leaf_bezier stalk   bezier end point  
       9  84.4  266. 1_1_half 2      1        1 leaf_bezier half 2  bezier start point
      10  84.8  260. 1_1_half 2      1        1 leaf_bezier half 2  bezier control po~
      # ... with 426 more rows

# bezier elements to polygons transformations work

    Code
      df_polygon
    Output
      # A tibble: 900 x 5
         b       i_part element     x     y
         <chr>    <dbl> <chr>   <dbl> <dbl>
       1 0_stalk      0 stalk    10    40  
       2 0_stalk      0 stalk    10.0  40.0
       3 0_stalk      0 stalk    10.0  40.1
       4 0_stalk      0 stalk    10.0  40.1
       5 0_stalk      0 stalk    10.1  40.1
       6 0_stalk      0 stalk    10.1  40.1
       7 0_stalk      0 stalk    10.1  40.1
       8 0_stalk      0 stalk    10.2  40.2
       9 0_stalk      0 stalk    10.2  40.2
      10 0_stalk      0 stalk    10.2  40.2
      # ... with 890 more rows

