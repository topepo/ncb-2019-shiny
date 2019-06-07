Materials for the _R shiny tutorial with nonclinical applications_ at the 2019 Nonclinical Biostatistics conference

Materials can be found at [`https://github.com/topepo/ncb-2019-shiny`](https://github.com/topepo/ncb-2019-shiny). If you've never used GitHub, just choose the green _"Clone or download"_ button on the right-hand side and download the ZIP file. 

The main notes require a few R packages. You can install them using:

```r
install.packages(c("shiny", "ggplot2", "readr", "plotly", "ggiraph"), 
                 repos = "http://cran.r-project.org")

# to test:
library(shiny)
library(ggplot2)
library(readr)
library(plotly)
library(ggiraph)
```

(warnings are fine, errors are not)

**Optionally** some of the extended examples use these packages too:

```r
install.packages(c("flexdashboard", "recipes", "heatmaply", "shinyBS", "yardstick"), 
                 repos = "http://cran.r-project.org")
```

Email `max@rstudio.com` for questions. 

If you can't (or don't want to) install these packages, we have the GitHub repo mirrored on [RStudio.cloud](https://rstudio.cloud/spaces/18814/join?access_code=lAd0GV2qZWLVW9g2Z4fpXqBt9XD2%2F2mGkQDIKL%2B0) and you can run the analyses there. See the directions below. 


# RStudio.cloud instructions

You can create an account for Rstudio.cloud or just log in with a gmail or GitHub account. 

 - You may have to setup an account name. 

It will ask if you want to join the space (yes).

If you clink on the _Projects_ tab at the top, the you should see an entry for _"R shiny tutorial with nonclinical applications"_. 

A note that says _Deploying Project_ will come up. Be patient, if is currently a free service (in beta) so it might take a few minutes. 

When it is done, there is the usual RStudio IDE in your browser. 

