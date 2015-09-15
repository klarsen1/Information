<!-- README.md is generated from README.Rmd. Please edit that file -->
Release summary
===============

The first submitted version was called 0.0.1.9000.

Per suggestion by Kurt Hornik, the title was shortened. The package has been re-uploaded as version 0.0.2.

Test environments
=================

-   Local OS X install, R 3.1.2 using devtools::check()

-   win-builder (devel and release).

R CMD check results
===================

I got NOTE: "File README.md cannot be checked without ‘pandoc’ being installed."

I can't get rid of this unless I add the README.md file to .Rbuildignore, which does not seems like a good strategy.

There were no WARNINGs or ERRORs.
