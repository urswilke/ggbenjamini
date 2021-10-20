# generated bezier leaf dataframe still the same

    Code
      df_leaf
    Output
      # A tibble: 36 x 5
         element i_part     x     y param_type            
         <chr>    <dbl> <dbl> <dbl> <chr>                 
       1 stalk        0  10    40   bezier start point    
       2 stalk        0  10.0  40.9 bezier control point 1
       3 stalk        0  20.0  39.4 bezier control point 2
       4 stalk        0  20    40   bezier end point      
       5 half 2       1  20    40   bezier start point    
       6 half 2       1  22    36   bezier control point 1
       7 half 2       1  29    35.2 bezier control point 2
       8 half 2       1  34    35   bezier end point      
       9 half 2       2  34    35   bezier start point    
      10 half 2       2  39    34.8 bezier control point 1
      # ... with 26 more rows

# generated bezier branch dataframe still the same

    Code
      df_branch
    Output
      # A tibble: 436 x 8
         b          i_branch element i_part     x     y type        param_type        
         <chr>         <dbl> <chr>    <dbl> <dbl> <dbl> <chr>       <chr>             
       1 1_0_branch        0 branch       1  70    280  branch      bezier start point
       2 1_0_branch        0 branch       1  84    245  branch      bezier control po~
       3 1_0_branch        0 branch       1 126    217  branch      bezier control po~
       4 1_0_branch        0 branch       1 168    217  branch      bezier end point  
       5 0_1_stalk         1 stalk        0  75.7  269. leaf_bezier bezier start point
       6 0_1_stalk         1 stalk        0  75.8  269. leaf_bezier bezier control po~
       7 0_1_stalk         1 stalk        0  82.9  266. leaf_bezier bezier control po~
       8 0_1_stalk         1 stalk        0  83.0  267. leaf_bezier bezier end point  
       9 1_1_half 2        1 half 2       1  83.0  267. leaf_bezier bezier start point
      10 1_1_half 2        1 half 2       1  83.0  264. leaf_bezier bezier control po~
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

