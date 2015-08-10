# Overview 

Binary classification models are perhaps the most common use-case in predictive analytics. The reason is that many key client actions across a wide range of industries are binary in nature, such as defaulting on a loan, clicking on an ad, or terminating a subscription. 

Prior to building a binary classification model, a common step is to perform variable screening and exploratory data analysis. This is the step where we get to know the data and weed out variables that are either ill-conditioned or simply contain no information that will help us predict the action of interest. Areas of investigation during this step include:

* Identifying variables with a high concentration of missing values
* Assessing the predictive power of missing values
* Ranking variables in terms of "univariate" predictive strength
* Visualizing the correlation between the predictive variables and the binary outcome   

The *weight of evidence* (WOE) and *information value* (IV) provide a great framework for analyzing these questions. This is not a new approach to exploratory data analysis for modeling of binary data; WOE and IV have been used extensively in the credit risk world for several decades, and the underlying theory dates back to the 1950s.  

For details, see the file called information.pdf in the Doc directory.


# The Information Package

The information package is designed to perform exploratory data analysis and variable screening for binary classification models using WOE and IV. Aggregations and done in data.table, and creation of WOE vectors can be distributed across multiple cores. The information package also provides support for exploratory analysis for uplift models.

# Extensions to Exploratory Analysis for Uplift Models
Consider a direct marketing program where a *test group* received an offer of some sort, and the *control group* did not receive anything. The test and control groups are based on a random split. The lift of the campaign is defined as the difference in success rates between the test and control groups. In other words, the program can only be deemed successful if the offer outperforms the "do nothing" (a.k.a baseline) scenario.

The purpose of uplift models is to estimate the difference between the test and control groups, and then using the resulting model to target *persuadables* – i.e., potential or existing clients that are on the fence and need some sort of offer or contract to sign up or buy a product. When preparing to build an uplift model, we cannot only focus on the log odds of *Y*=1 , we need to analyze the *log odds ratio* of *Y*=1 for the test group versus the control group. This can be handled by the *net weight of evidence* (NWOE) and the *net information value* (NIV).
 
# Installation
devtools::install_github("klarsen1/Information", "klarsen1")

