<div align="center">

<a href='http://rich-iannone.github.io/intendo/'><img src="man/figures/logo.svg" height="350px"/></a>

</div>

The **intendo** R package provides access to several synthetic yet realistic analytics datasets:

- `all_sessions`
- `all_revenue`
- `users_daily`
- `user_summary`

These four tables track the performance of the nonexistent *Super Jetroid* mobile game. The tables are interrelated and there is internal consistency between them (they were created from a much larger table containing all analytics events). There are four sizes for each of these (`"small"`, `"medium"`, `"large"`, and `"xlarge"`) which represent increasingly larger player bases. Regardless of size, each table has a variant containing errors and data inconsistencies (the `"faulty"` type). Each table is accessed via its namesake function (e.g., `all_sessions()`) and the object returned can either be a tibble, a data frame, or an in-memory database table (DuckDB).

These datasets, in all their variations, can be useful for practicing with data of various sizes. We could also use them to learn about data quality (since there are faulty versions of the data) and data documentation (since the connected datasets can be envisaged as essential core data for the proper functioning of an organization).

## Installation

You can install the development version of **intendo** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rich-iannone/intendo")
```
