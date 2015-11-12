<!-- README.md is generated from README.Rmd. Please edit that file -->
Release summary
===============

The current version is 0.0.6. Previous version was 0.0.5.

Differences between the two versions:

-   Automatically remove "class==Date" variables from table generation
-   Accepting input data of format tbl and tbl\_df
-   More precise namespace imports to avoid clashes with the upcoming release of ggplot2 2.0.0
-   Check if the treatment parameter is binary.

Test environments
=================

-   Local OS X install, R 3.1.2 and R 3.2.2, using devtools::check()

-   win-builder (devel and release).

R CMD check results
===================

I got the NOTE: "File README.md cannot be checked without ‘pandoc’ being installed." I can't get rid of this unless I add the README.md file to .Rbuildignore, which does not seems like a good strategy. So I am ignorig this for now, hoping that the CRAN servers will have pandoc.
