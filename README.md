<div align="center">

<a href='https://rich-iannone.github.io/intendo/'><img src="man/figures/logo.svg" height="350px"/></a>

</div>

The **intendo** R package provides access to several synthetic yet realistic analytics datasets. Taken together, the interrelated tables help to track the performance of the nonexistent *Super Jetroid* game for mobile devices. 

There are four tables which come in four different sizes (`"small"`, `"medium"`, `"large"`, and `"xlarge"`), representing increasingly larger player bases. 

- `all_revenue`: *all revenue amounts*
- `users_daily`: *records of daily users*
- `user_summary`: *summaries for all users*
- `all_sessions`: *all user sessions*

For each table, regardless of size, there is a special variant table containing errors and data inconsistencies (the `"faulty"` type).

Each table is accessed via its namesake function (e.g., `all_sessions()`) and the object returned can either be a tibble, a data frame, or an in-memory **DuckDB** database table.

These datasets, in all their variations, can be useful for practicing with data of various sizes. They can be used to learn about data quality (since there are faulty versions of the data) and data documentation (since the connected datasets can be envisaged as essential core data for the proper functioning of an analytics department).

## Installation

You can install **intendo** from **CRAN** with:

``` r
install.packages("intendo")
```

You can also install the development version of **intendo** from **GitHub**:

``` r
devtools::install_github("rich-iannone/intendo")
```

## Code of Conduct

Please note that the intendo project is released with a [contributor
code of conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).<br>By participating in this project you agree to abide by its terms.
