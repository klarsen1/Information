# Overview 

Binary classification models are perhaps the most common use-case in predictive analytics. The reason is that many key client actions across a wide range of industries are binary in nature, such as defaulting on a loan, clicking on an ad, or terminating a subscription. 

Prior to building a binary classification model, a common step is to perform variable screening and exploratory data analysis. This is the step where we get to know the data and weed out variables that are either ill-conditioned or simply contain no information that will help us predict the action of interest. Note that the purpose of this step should not to be confused with that of multiple-variable selection techniques, such as stepwise regression and lasso, where the final variables that go into the model are selected. Rather, this is a precursory step designed to ensure that the approaches deployed during the final modeling phases are set up for success.

The *weight of evidence* (WOE) and *information value* (IV) provide a great framework for for exploratory analysis and variable screening for binary classifiers. WOE and IV have been used extensively in the credit risk world for several decades, and the underlying theory dates back to the 1950s. However, it is still not widely used outside the credit risk world, and it is a fairly underserved area in R.

WOE and IV enable one to:

* Consider each variable’s independent contribution to the outcome.
* Detect linear and non-linear relationships.
* Rank variables in terms of "univariate" predictive strength.
* Visualize the correlations between the predictive variables and the binary outcome.   
* Seamlessly compare the strength of continuous and categorical variables without dummy-coding.
* Identify variables with too many missing values.
* Assess the predictive power of missing values.

For details, see the file called information.pdf in the Doc directory.

# About the Package

The information package is designed to perform exploratory data analysis and variable screening for binary classification models using WOE and IV. Aggregations are done in data.table, and creation of WOE vectors can be distributed across multiple cores. Thus the package is fairly fast.

The package can be downloaded from https://github.com/klarsen1/Information.

There are a number of great R packages available that support WOE and IV (see a partial list below), but they are either primarily designed to build WOE-based models – e.g., naive Bayes classifiers – or they do not support the uplift use-case. Hence, despite some redundancy, we saw the need to create the `Information` package.

### Date Used in Examples
The data is from an historical marketing campaign from the insurance industry and is automatically downloaded when you install the `Information` package. The data is stored in two `.RDA` files, one for the training dataset and one for the validation dataset. Each file has 68 predictive variables and 10k records.

The datasets contain two key indicators: 

* `PURCHASE` This variable equals 1 if the client accepted the offer, and 0 otherwise
* `TREATMENT` This variable equals 1 if the client was in the test group (received the offer), and 0 otherwise.
  
### Key Functions

* `CreateTables()` creates WOE tables and IVs for all variables in the input dataframe.
* `PlotWOE()` plots the WOE vector for one variable.
* `MultiPlotWOE()` plots more than one WOE vector on one page for comparisons.

# Extensions to Exploratory Analysis for Uplift Models
Consider a direct marketing program where a *test group* received an offer of some sort, and the *control group* did not receive anything. The test and control groups are based on a random split. The lift of the campaign is defined as the difference in success rates between the test and control groups. In other words, the program can only be deemed successful if the offer outperforms the "do nothing" (a.k.a baseline) scenario.

The purpose of uplift models is to estimate the difference between the test and control groups, and then using the resulting model to target *persuadables* – i.e., potential or existing clients that are on the fence and need some sort of offer or contract to sign up or buy a product. Thus, when preparing to build an uplift model, we cannot only focus on the log odds of *Y*=1 , we need to analyze the *log odds ratio* of *Y*=1 for the test group versus the control group. This can be handled by the *net weight of evidence* (NWOE) and the *net information value* (NIV).

For details, see the file called information.pdf in the Doc directory.
 
# Installation
devtools::install_github("klarsen1/Information", "klarsen1")

# References

[1] Hastie, Trevor , Tibshirani, Robert and Friedman, Jerome. (1986), Elements of Statistical Learning, Second Edition, Springer, 2009.

[2] Kullback S., Information Theory and Statistics, John Wiley & Sons, 1959.

# Other Packages that support WOE/IV

woe package, https://cran.r-project.org/web/packages/woe/woe.pdf.

riv package (not to be confused with the riv packake in CRAN), http://www.r-bloggers.com/r-credit-scoring-woe-information-value-in-woe-package/.

klaR package, https://cran.r-project.org/web/packages/klaR/klaR.pdf.


