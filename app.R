# Install the required packages if they are not already installed
if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny")
if (!requireNamespace("shinydashboard", quietly = TRUE)) install.packages("shinydashboard")
if (!requireNamespace("DT", quietly = TRUE)) install.packages("DT")
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("factoextra", quietly = TRUE)) install.packages("factoextra")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("openxlsx", quietly = TRUE)) install.packages("openxlsx")
if (!requireNamespace("shinycssloaders", quietly = TRUE)) install.packages("shinycssloaders")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("mFilter", quietly = TRUE)) install.packages("mFilter")
if (!requireNamespace("ConvergenceClubs", quietly = TRUE)) install.packages("ConvergenceClubs")
if (!requireNamespace("shinyjqui", quietly = TRUE)) install.packages("shinyjqui")
if (!requireNamespace("caret", quietly = TRUE)) install.packages("caret")
if (!requireNamespace("xgboost", quietly = TRUE)) install.packages("xgboost")
if (!requireNamespace("cluster", quietly = TRUE)) install.packages("cluster")

# Load the necessary libraries   
library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(factoextra)
library(ggplot2)
library(openxlsx)
library(shinycssloaders)
library(dplyr)
library(mFilter)
library(ConvergenceClubs)
library(shinyjqui)
library(caret)
library(xgboost)
library(cluster)




# UI
ui <- dashboardPage(
  dashboardHeader(title = "Kluster it!"),
  dashboardSidebar(
    fluidRow(
      column(12,
             fileInput("file1", "", accept = c(".csv", ".xlsx"), width = "80%"),
             actionButton("change_sep", label = "", icon = icon("circle-info"), style = "margin-top: -75px; margin-left: 180px;")
      ),
      tags$div(style = "height: 90px;")
    ),
    sidebarMenu(
      id = "tabs",
      menuItem("General Information", tabName = "Information", icon = icon("magnifying-glass", style = "margin-right: 10.5px;"),
               menuSubItem("Instructions", tabName = "general_instructions"),
               menuSubItem("Check the Data Uploaded!", tabName = "general_check"),
               menuSubItem("References", tabName = "general_references")
      ),
      menuItem("KMeans", tabName = "kmeans", icon = icon("shapes", style = "margin-right: 10px;"),
               menuSubItem("Methodology", tabName = "kmeans_methodology"),
               menuSubItem("Instructions", tabName = "kmeans_instructions"),
               menuSubItem("Preparation and Optimum K", tabName = "optimumk"),
               menuSubItem("Analysis", tabName = "analysis")
      ),
      menuItem("Club Convergence", tabName = "clubconvergence", icon = icon("think-peaks", style = "margin-right: 9px;"),
               menuSubItem("Methodology", tabName = "cc_methodology"),
               menuSubItem("Instructions", tabName = "cc_instructions"),
               menuSubItem("Data Preparation", tabName = "cc_data_prep"),
               menuSubItem("Analysis", tabName = "cc_analysis")
      ),
      menuItem("Index Klub", tabName = "indexklub", icon = icon("jedi", style = "margin-right: 9.5px;"),
               menuSubItem("Methodology & Instructions", tabName = "ik_methodology"),
               menuSubItem("Preparation", tabName = "ik_preparation"),
               menuSubItem("Index Coefficients", tabName = "ik_indexcoefficients"),
               menuSubItem("Index Club", tabName = "ik_indexclub")
      ),
      div(style = "position: absolute; bottom: 10px; width: 100%; text-align: left; left: 10px;",
          tags$a(href = "https://github.com/bbanyuls/KlubKluster", target = "_blank",
                 tags$i(class = "fa fa-github", style = "font-size: 24px; color: white;"))
      )
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "general_instructions",
              p("Welcome to ", strong("Kluster it!"), ". This app is designed to provide users with a suite of tools and methodologies for performing clustering analysis on their data."),
              p("The app implements several clustering algorithms, each tailored to different types of data and research questions. Here’s a brief overview of the main features and functionalities of the app:"),
              h3("Components"),
              HTML('
                <ol>
                  <li><strong>KMeans:</strong> This section covers the KMeans clustering algorithm, explaining how it partitions data into k clusters based on the sum of squared Euclidean distances from the cluster centroids.</li>
                  <li><strong>Club Convergence:</strong> This section delves into the methodology developed by Phillips and Sul (2007, 2009) for analyzing convergence clubs, which helps to identify groups of entities that converge over time.</li>
                  <li><strong>Index Klub:</strong> This section provides tools and explanations for using the Index Klub methodology to analyze and interpret clustered data.</li>
                </ol>
              '),
              br(),
              p("To get started, follow these steps:"),
              h3("1. Upload Your Data"),
              p("The first step is to upload the data you want to analyze. This can be done by using the file input widget in the sidebar. The app supports CSV and Excel files."),
              h3("2. Check and Prepare Your Data"),
              p("Once the data is uploaded, navigate to the 'Check the Data Uploaded!' tab to ensure your data is correctly loaded and to make any necessary adjustments. Here you can view your data, check the variable types, and modify them if needed."),
              h3("3. Read Methodologies and Instructions"),
              p("Before performing any analysis, it's recommended to read the methodologies and instructions provided in each section. This will help you understand the theoretical background and how to effectively use the tools available in the app."),
              h3("4. Perform Clustering Analysis"),
              p("Each clustering method has its own tab where you can perform the analysis. Follow the instructions provided in each tab to carry out the analysis."),
              h3("5. Interpret Results"),
              p("After running the analysis, you can view and interpret the results. The app provides various visualizations and tables to help you understand the clustering outcomes."),
              br(),
              p("The detailed explanations, mathematical formulations, and practical examples provided in each section will guide you through the process of clustering analysis, ensuring you can apply these methodologies to your data effectively.")
      ),
      tabItem(tabName = "general_check",
              fluidRow(
                column(width = 6, 
                       box(title = "Preview Data", status = "primary", solidHeader = TRUE, collapsible = TRUE, width = NULL,
                           DTOutput("check_data"), style = "margin-left: 20px;")),
                column(width = 6, 
                       box(title = "Variable Types", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                           DTOutput("dataTypes"), dynamicHeight = TRUE),
                       box(title = "Modify Data Types", status = "warning", solidHeader = TRUE, collapsible = TRUE,
                           uiOutput("modify_types_ui"), dynamicHeight = TRUE)
                )
              )
      ),
      tabItem(tabName = "general_references",
              h2("References:"),
              HTML('
            <ol>
              <li>Wickham, H. (2021). Mastering Shiny. O\'Reilly Media, Inc. <a href="https://mastering-shiny.org/" target="_blank">https://mastering-shiny.org/</a></li>
              <li>MacQueen, J.B. (1967) Some Methods for Classification and Analysis of Multivariate Observations. In: Proceedings of the 5th Berkeley Symposium on Mathematical Statistics and Probability, Volume 1: Statistics, University of California Press, Berkeley, 281-297. <a href="http://projecteuclid.org/euclid.bsmsp/1200512992" target="_blank">http://projecteuclid.org/euclid.bsmsp/1200512992</a></li>
              <li>Phillips, P. C. B., and Sul, D. (2007). Transition Modeling and Econometric Convergence Tests. Econometrica, 75(6), 1771–1855. <a href="http://www.jstor.org/stable/4502048" target="_blank">http://www.jstor.org/stable/4502048</a></li>
              <li>Du, K. (2017). Econometric Convergence Test and Club Clustering Using Stata. The Stata Journal, 17(4), 882–900. <a href="https://doi.org/10.1177/1536867X1801700407" target="_blank">https://doi.org/10.1177/1536867X1801700407</a></li>
              <li><a href="https://cran.r-project.org/web/packages/ConvergenceClubs/index.html" target="_blank">https://cran.r-project.org/web/packages/ConvergenceClubs/index.html</a></li>
            </ol>
        ')
      ),
      tabItem(tabName = "kmeans_methodology",
              p("There are several algorithms for clustering, but the standard one is the Hartigan-Wong algorithm in which the total variance of the individuals within a cluster is defined as the sum of the squared Euclidean distances between the elements and the corresponding centroid. The centroid of each group is the center of the group that corresponds to the mean value of each individual in that cluster (Hartigan and Wong, 1979)."),
              withMathJax(helpText('$$W(C_k) = \\sum_{x_i \\in C_k} (x_i - \\mu_k)^2$$ (1)')),
              p("In this equation (1), \\(x_i\\) indicates the data point \\(i\\) belonging to cluster \\(C_k\\) and \\(\\mu_k\\) is the average value of the points in cluster \\(C_k\\)."),
              p("The total variation of individuals within a cluster is defined as follows in equation (2):"),
              withMathJax(helpText('$$\\sum_{k=1}^{k} W(C_k) = \\sum_{k=1}^{k} \\sum_{x_i \\in C_k} (x_i - \\mu_k)^2$$ (2)')),
              p("Each observation \\(x_i\\) is assigned to a given cluster such that the distance of the sum of squares of the observation to its centroid \\(\\mu_k\\) is minimum. The clustering algorithm follows the following processes:"),
              HTML('
          <ol>
            <li>Manually define the number of clusters to use throughout the algorithm, although there are several ways to check which number \\(k\\) of clusters is the most optimal.</li>
            <li>The algorithm randomly places \\(k\\) centroids in the data as initial centroids. And then, each individual \\(x_i\\) is assigned to the nearest centroid using the Euclidean distance.</li>
            <li>The next step is to calculate the average value of each cluster that becomes the new centroid and the individuals \\(x_i\\) are reassigned to the new centroids \\(\\mu_k\\).</li>
            <li>The previous step is repeated until the centroids do not change, even if the same step is repeated again, thus achieving that the total variation of individuals within a cluster is the minimum possible. There are several ways to analyze the optimal number of centroids or clusters, such as the elbow method and the silhouette method.</li>
          </ol>
        '),
        p("The elbow method uses the mean distance of the observations to their respective centroid, i.e., the total variance of the individuals within a cluster. The higher the number of clusters, the lower the variance since the maximum number of clusters is equal to the number of observations, so the number \\(k\\) of clusters will be the one that an increase in the number does not substantially improve the variance within a cluster."),
        withMathJax(helpText('$$WCSS = \\sum_{x_i \\in C_1} \\text{distance}(x_i, \\mu_{k=1})^2 + \\sum_{x_i \\in C_2} \\text{distance}(x_i, \\mu_{k=2})^2 + \\sum_{x_i \\in C_3} \\text{distance}(x_i, \\mu_{k=3})^2$$ (3)')),
        p("This equation (3) is used to calculate the WCSS (Within-Cluster Sum-of-Squares) variable, which measures the variance in each cluster. The more clusters there are, the better this variable will be, to the point that it will be equal to zero when the number of clusters is equal to the number of observations."),
        p("Silhouette analysis is used to analyze the quality of clustering. It measures the separation distance between different clusters. It tells us how close each observation of a cluster is to the observations of other clusters. The range of this method whose purpose is to analyze how many clusters range from -1 to 1, and the closer the value is to 1, it means that the observation is far away from the neighboring clusters. If the coefficient is 0 it means that it is very near or on the border between the two clusters. A negative value would indicate that it is in the wrong cluster."),
        p("The silhouette method calculates the mean of the silhouette coefficients of all the observations for different values of \\(k\\). The optimal number of clusters \\(k\\) is the one that maximizes the mean of the silhouette coefficients for a range of values of \\(k\\)."),
        withMathJax(helpText('$$S = \\frac{b - a}{\\max(a, b)}$$ (4)')),
        p("In which \\(a\\) is the mean distance within a cluster, and \\(b\\) is the mean distance to the observations of the nearest cluster.")
      ),
      tabItem(tabName = "kmeans_instructions",
              h3("Step 1: Upload Your Data"),
              p("First, upload your dataset using the file input widget in the sidebar. You can upload CSV or Excel files."),
              h3("Step 2: Prepare Your Data"),
              p("Navigate to the 'Check the Data Uploaded!' tab to review your data. Ensure that the variables are correctly identified and modify their types if necessary."),
              p("It is important to check that the type of our variables of interest is numeric as the algorithm only works with that type of data."),
              h3("Step 3: Select Variables for Analysis"),
              p("Go to the 'Preparation and Optimum K' tab. Select the variables you want to include in the clustering analysis. You can choose to scale the data if needed."),
              h3("Step 4: Determine the Optimal Number of Clusters"),
              p("Use the Silhouette method and Elbow method plots provided in the 'Preparation and Optimum K' tab to determine the optimal number of clusters for your dataset."),
              p("This section is only to see which is the optimum number of clusters for the data, although you may decide another one due to other reasons."),
              p("The way to interpret the Elbow Plot, is to select the number where the line makes an 'elbow shape', in terms of the Silhouette Plot the highest point is the one to select."),
              h3("Step 5: Run the KMeans Analysis"),
              p("Navigate to the 'Analysis' tab. Select the variables and the number of clusters, then click 'Run' to perform the KMeans clustering."),
              h3("Step 6: Interpret the Results"),
              p("The results of the clustering analysis, including cluster assignments and visualizations, will be displayed in the 'Analysis' tab. Use these results to interpret the structure and characteristics of the clusters."),
              h3("What does KMeans do? And, why is it useful?"),
              p("It is common for companies for example to analyze their customers, this algorithm allow us to create some groups based on existing numerical data."),
              p("Imagine for example we have a dataset for our clients that contains the last time they made a purchase in the shop, how many times he has bought something, and how much did they spent."),
              p("We can use the KMeans algorithm to cluster the clients in different types!"),
              p("For example, we would get results like this:"),
              img(src = "rfm.png", height = "200px", width = "auto"),
              p("As we can observe we have different groups with different characteristics so we can understand the behaviour of the different types of customers we may have!"),
              p("The following image sums up the idea of what KMeans actually do:"),
              img(src = "kmeans.png", height = "200px", width = "auto"),
              p("Which to simplify it even more, is to group people depending on the characteristics they have."),
              p("Or in more technical words, to group observations according to different characteristics in a way the integrants are similar within a club but different in comparison to other clubs")
      ),
      tabItem(tabName = "optimumk",
              fluidRow(
                box(
                  width = 8, 
                  style = "border-top: 10px solid #31b0d5; background-color: #ffffff; border-color: #31b0d5; padding: 20px; box-shadow: 0 2px 2px rgba(0,0,0,0.1);", 
                  selectInput("id_variable", "Select or Create ID Variable", choices = c("Create New ID Variable"), selected = "Create New ID Variable"),
                  selectInput("analysis_vars", "Select Variables for Analysis", choices = NULL, multiple = TRUE)
                ),
                box(
                  width = 4, 
                  style = "border-top: 10px solid #5cb85c; background-color: #ffffff; border-color: #5cb85c; padding: 20px; box-shadow: 0 2px 2px rgba(0,0,0,0.1);", 
                  div(style = "padding-bottom: 10px;", 
                      checkboxInput("scale_data", "Scale Data", value = FALSE)
                  ),
                  actionButton("run_analysis", "Run", icon = icon("play"), style = "font-size: 18px; width: 100%; border-radius: 12px; background-color: #5cb85c; border-color: #4cae4c; color: white; padding: 10px 20px;")
                )
              ),
              fluidRow(
                column(6, box(title = "Silhouette Plot", status = "info", solidHeader = TRUE, plotOutput("silhouette_plot"), width = 14, style = "border-top: 10px solid #5bc0de;")),
                column(6, box(title = "Elbow Plot", status = "warning", solidHeader = TRUE, plotOutput("elbow_plot"), width = 14, style = "border-top: 10px solid #f0ad4e;"))
              )
      ),
      tabItem(tabName = "analysis",
              fluidRow(
                box(
                  width = 8,
                  style = "border-top: 10px solid #31b0d5; background-color: #ffffff; border-color: #31b0d5; padding: 20px; box-shadow: 0 2px 2px rgba(0,0,0,0.1);",
                  selectInput("id_variable_analysis", "Select or Create ID Variable", choices = c("Create New ID Variable"), selected = "Create New ID Variable"),
                  selectInput("analysis_vars_analysis", "Select Variables for Analysis", choices = NULL, multiple = TRUE)
                ),
                box(
                  width = 4,
                  style = "border-top: 10px solid #5cb85c; background-color: #ffffff; border-color: #5cb85c; padding: 20px; box-shadow: 0 2px 2px rgba(0,0,0,0.1);",
                  div(style = "display: flex; align-items: flex-start; padding-bottom: 10px;",
                      div(
                        style="flex: 1;",
                        checkboxInput("scale_data_analysis", "Scale Data", value = FALSE),
                        radioButtons("plot_type", "Choose Plot Type:", choices = c("PCA Plot" = "pca", "Custom ggplot" = "custom"), selected = "pca")
                      ),
                      numericInput("num_clusters", "Number of Clusters", value = 3, min = 2)
                  ),
                  actionButton("run_analysis_analysis", "Run", icon = icon("play"), style = "font-size: 18px; width: 100%; border-radius: 12px; background-color: #5cb85c; border-color: #4cae4c; color: white; padding: 10px 20px;")
                )
              ),
              fluidRow(
                column(6, box(title = "Cluster Analysis Centroids Results", status = "info", solidHeader = TRUE, 
                              DTOutput("cluster_results"), 
                              downloadButton("download_data", ""),
                              width = 14, style = "border-top: 10px solid #5bc0de;")),
                column(6, box(title = "Visualization", status = "warning", solidHeader = TRUE, width = 14, style = "border-top: 10px solid #f0ad4e;",
                              conditionalPanel(
                                condition = "input.plot_type == 'custom'",
                                selectInput("x_var", "Select X Variable", choices = NULL),
                                selectInput("y_var", "Select Y Variable", choices = NULL)
                              ),
                              plotOutput("cluster_plot")
                ))
              )
      ),
      tabItem(tabName = "cc_methodology",
              p("For the analysis of convergence clubs, we will apply the methodology developed by Phillips and Sul (2007, 2009). This methodology allows us to study the existence of convergence clubs without having to separate our data sample into subgroups through several variables in common."),
              p("Let \\(X_{it}\\) be expenditure in R&D. It can be decomposed as follows in equation (1):"),
              withMathJax(helpText('$$X_{it} = g_{it} + a_{it}$$ (1)')),
              p("In which \\(g_{it}\\) would be the systematic components such as the permanent common components and \\(a_{it}\\) would be the transitory components."),
              p("It is necessary to separate the common components from the idiosyncratic ones, so the following transformation is performed:"),
              withMathJax(helpText('$$X_{it} = \\left( \\frac{g_{it} + a_{it}}{u_{t}} \\right) u_{t} = \\delta_{it} u_{t}$$ (2)')),
              p("In which \\(\\delta_{it}\\) is a time-varying idiosyncratic component and \\(u_{t}\\) is the common component. In this equation (2) \\(u_{t}\\) captures stochastic trend behavior and \\(\\delta_{it}\\) measures the idiosyncratic distance between \\(X_{it}\\) and \\(u_{t}\\)."),
              p("Phillips and Sul (2007) propose to remove the common factor in equation (3):"),
              withMathJax(helpText('$$h_{it} = \\frac{X_{it}}{\\frac{1}{N} \\sum_{i=1}^{N} X_{it}} = \\frac{\\delta_{it}}{\\frac{1}{N} \\sum_{i=1}^{N} \\delta_{it}}$$ (3)')),
              p("Where \\(h_{it}\\) is the variable that indicates the relative transition that measures the load coefficient in relation to the panel average at instant \\(t\\). That is, \\(h_{it}\\) shows us the path of the individual \\(i\\) relative to the panel average. Equation (4) shows us that the cross-sectional mean of \\(h_{it}\\) is unitary and that the variance satisfies the following equation:"),
              withMathJax(helpText('$$H_{it} = \\frac{1}{N} \\sum_{i=1}^{N} (h_{it} - 1)^2 \\rightarrow 0 \\text{ if } \\lim_{t \\rightarrow \\infty} \\delta_{it} = \\delta \\text{ for every } i.$$ (4)')),
              p("Therefore, the convergence of \\(X_{it}\\) requires that the following condition be satisfied:"),
              withMathJax(helpText('$$\\lim_{t \\rightarrow \\infty} \\frac{X_{it}}{X_{jt}} = 1 \\text{ for every } i \\text{ and } j.$$ (5)')),
              p("Phillips and Sul (2007) have defined this condition as relative convergence and in order to specify the null hypothesis of convergence they define \\(\\delta_{it}\\) as:"),
              withMathJax(helpText('$$\\delta_{it} = \\delta_{i} + \\sigma_{it} \\xi_{it}, \\sigma_{it} = \\frac{\\sigma_{i}}{L(t)t^{\\alpha}}, t \\geq 1, \\sigma_{i} > 0 \\text{ for all } i.$$ (6)')),
              p("Where \\(L(t)\\) can be \\(\\log(t)\\), \\(\\log^2(t)\\) or \\(\\log(\\log(t))\\). In our case, the best choice is \\(L(t) = \\log(t)\\). Phillips and Sul (2007) pose the following hypothesis test to test for the existence of absolute convergence: \\(H_0: \\delta_i = \\delta \\text{ and } \\alpha \\geq 0\\) versus its alternative \\(H_A: \\delta_i \\neq \\delta \\text{ or } \\alpha < 0\\)."),
              p("The following t regression model developed by Phillips and Sul (2007) is used:"),
              withMathJax(helpText('$$\\log(H_1/H_t) - 2\\log(\\log(t)) = a + b\\log(t) + \\epsilon_t \\text{ for } t = [rT], [rT] + 1, \\ldots, T \\text{ with } r > 0.$$ (7)')),
              p("In which, if there is convergence \\(H_i\\) will be 0 and, therefore \\(\\log(H_1/H_t)\\) will tend to infinity. For this to occur \\(b\\) has to be greater than or equal to zero, in case it is negative the hypothesis of absolute convergence would be rejected, and we would proceed to analyze if there are convergence clubs."),
              p("For convergence clubs, Phillips and Sul (2007) developed an algorithm to identify the various clubs that might be in a sample. The following process represents how this algorithm works:"),
              HTML('
          <ol>
            <li>Cross-section classification: The different countries are ordered in decreasing order, i.e., from highest to lowest, taking into account the values of the last period.</li>
            <li>Club formation: We start by forming groups from the country with the highest value in the last period. Then we look for the first k such that when we do the log t regression test statistic, we are left with t_k being greater than -1.65. This is done for the first two countries, and in case it is not satisfied, it is performed for the second and third countries, and so on until a pair of countries is found that does satisfy the test. In case there is no pair of countries, i.e., there is no k that meets this requirement, there would be no convergence subgroups in our data sample.</li>
            <li>Screening of individuals to create convergence clubs: In the event that in the club formation, we have encountered a pair, we proceed to perform the same test by adding countries in the order we previously classified. When the criterion is no longer met, we would have our first club.</li>
            <li>Recursion and stopping rule: A subgroup is made with the individuals that have not been screened in the previous step. The log t regression test is performed and if it is greater than -1.65, another group is formed. Otherwise, the three previous steps would be performed with this subgroup.</li>
          </ol>
        '),
        p("Schnurbus et al. (2017) would pose a fifth step, which is to merge clubs. The way it would be done would be to do the log t test regression for clubs 1 and 2, and in case it is met, we would then merge them. The same would then be done for the new club 1 and the next club, and so on until there are no more club mergers, so we would be left with the minimum number of clubs possible.")
      ),
      tabItem(tabName = "cc_instructions",
              p("This section provides step-by-step instructions for performing Club Convergence Analysis using the app and a simple explanation on what it does."),
              h3("Step 1: Upload Your Data"),
              p("First, upload your dataset using the file input widget in the sidebar. You can upload CSV or Excel files."),
              h3("Step 2: Prepare and Order Your Data"),
              p("Navigate to the 'Check the Data Uploaded!' tab. Ensure your data is correctly loaded. Then, go to the 'Data Preparation' tab to order your data as follows:"),
              HTML('
          <ol>
            <li>ID column first.</li>
            <li>Year columns in ascending order (e.g., 2007, 2008, ..., 2020).</li>
            <li>Ensure the year columns do not have prefixes (e.g., "2007" instead of "RD2007").</li>
          </ol>
        '),
        h3("Step 3: Perform Club Convergence Analysis"),
        p("Navigate to the 'Analysis' tab. Select the range of years you want to analyze and press the 'Run' button."),
        h3("Step 4: View and Interpret the Results"),
        p("Use the 'Choose View' option to change the plot view. The way to interpret the findings can be understood in the 'Methodology' section. Additional references will be provided in the 'References' section."),
        p(""),
        h3("What does Convergence do? And, why is it useful?"),
        p("The definition of convergence is:"),
        p(strong("“Convergence is the property of two or more things coming together at a single point.”")),
        p("In economics, this definition changes slightly. Simply put:"),
        p(strong("“Economic convergence in terms of per capita income refers to the process by which regions with lower income levels experience more intense growth, thereby reducing disparities between regions over time.”")),
        p("In simple terms, the idea is as follows:"),
        p(""),
        img(src = "1.png", height = "200px"),
        p(""),
        p("It's easy to analyze visually when there are only two lines. Although it can be analyzed mathematically, the concept and utility are paramount. The problem arises when there are many more lines."),
        p("For example, let's say we want to analyze if there is convergence in Europe in terms of R&D expenditure per inhabitant for each country in the European Union."),
        p(""),
        img(src = "2.png", height = "200px"),
        p(""),
        img(src = "3.png", height = "200px"),
        p(""),
        p("Visually, we might form two groups (or clubs): those closely grouped at the bottom and the rest at the top, which we call a group because they are higher."),
        p("But the problem is that we are not only considering the differences in the magnitude of the values, but also their trajectory over time. For example, some European countries had higher R&D expenditure in 2005 than in 2020, meaning their expenditure has decreased, but not enough to be grouped with the lower club."),
        p("In other words, we can observe the following cases:"),
        p(""),
        img(src = "4.png", height = "200px"),
        p(""),
        p("Some countries' trajectories decrease slightly, while others start to rise. Visually, we could have the following clubs (remember, a club consists of countries with similar trajectories)."),
        p("If we continue forming these lines, we can see the following groups (now colored)."),
        p(""),
        img(src = "5.png", height = "200px"),
        p(""),
        p("To understand it better, let's remove the real data and only show our drawn lines."),
        img(src = "6.png", height = "200px"),
        p(""),
        p("In this case, when we look more closely, we have three clubs, where the members have similar trajectories (not so much in movement, but in direction)."),
        p("Now that the idea is understood a bit more, let's explain it in more detail. The idea of convergence with all members as a 'group' is called Beta Convergence. In this case, we look at whether, considering all members, they are heading toward the same point, or if they continue as they are, it will eventually happen (i.e., those at the bottom growing faster will eventually catch up with those at the top).")
      ),
      tabItem(tabName = "cc_data_prep",
              fluidRow(
                column(12,
                       box(title = "Preview Data", status = "primary", solidHeader = TRUE, width = NULL,
                           DTOutput("preview_data"), style = "margin-left: 20px;")
                )
              ),
              fluidRow(
                column(5,
                       box(title = "Reorder Columns", status = "primary", solidHeader = TRUE, width = NULL,
                           uiOutput("reorder_ui"), 
                           div(style = "margin-top: 20px;",  
                               actionButton("apply_reorder", "Apply Reorder")
                           )
                       )),
                column(7,
                       box(title = "Rename Columns", status = "primary", solidHeader = TRUE, width = NULL,
                           uiOutput("rename_ui"), 
                           actionButton("apply_rename", "Apply Rename")
                       ))
              )
      ),
      tabItem(tabName = "cc_analysis",
              fluidRow(
                box(
                  width = 3,
                  status = "primary",
                  solidHeader = TRUE,
                  fluidRow(
                    column(8,
                           uiOutput("year_slider_ui")
                    ),
                    column(4,
                           actionButton("run_club_analysis", label = NULL, icon = icon("play"), 
                                        style = "margin-top: 35px; margin-left: 10px; background-color: #007bff; border-color: #007bff; color: white;")
                    )
                  ),
                  fluidRow(
                    column(12,
                           radioButtons("view_choice", "Choose View:", choices = list("All Clubs" = "all", "Specific Club" = "specific"), selected = "all"),
                           conditionalPanel(
                             condition = "input.view_choice == 'specific'",
                             numericInput("club_number", "Enter Club Number:", value = 1, min = 1)
                           )
                    )
                  ),
                  fluidRow(
                    column(12,
                           verbatimTextOutput("estimate_mod_result")
                    )
                  )
                ),
                box(
                  width = 9,
                  status = "primary",
                  solidHeader = TRUE,
                  div(style = "height: 200px; overflow-y: scroll;",
                      verbatimTextOutput("print_clubs")
                  )
                )
              ),
              fluidRow(
                box(
                  width = 12,
                  status = "primary",
                  solidHeader = TRUE,
                  plotOutput("plot_clubs", height = "600px"),
                  downloadButton("download_cc_results", "", style = "margin-top: 20px;")
                )
              )
      ),
      tabItem(tabName = "ik_methodology",
              p("The Index Klub methodology involves creating a composite index from multiple variables over several years, similar to the idea Human Development Index (HDI) that takes into account three variables."),
              p("This composite index is then used to analyze convergence clubs."),
              p("Imagine we have three variables: R&D expenditure (RD), GDP, and energy consumption, each measured from 2007 to 2019."),
              p("Our goal is to create a composite index for each year using these variables and analyze the convergence clubs."),
              h3("Steps Involved"),
              p("The following steps outline the process for performing Index Klub analysis:"),
              h3("1. Variable Selection and Data Preparation"),
              p("First, upload your dataset and ensure that it includes all the necessary variables for the analysis. The data should be organized with the ID column first, followed by the variables for each year (e.g., RD2007, RD2008, RD2010, ...,Energy2019)."),
              p("Additionally, due to the magnitude differences across the variables, a 'ranking' scale method is used to normalize the data, ensuring comparability in the 'Index Klub' section."),
              p("The way this ranking works is by assigning a value from 1 to the total observations, instead of the common -1 to 1, or 0 to 1 range it is normally applied to scaling."),
              p("The user may also decide if the ranking for a certain variable is done in an ascending order or not."),
              p("Recall the example made in RFM, we want that the fewer the days since last purchase the 'better' for that matter if the customer bought recently, he will get a 'higher value'."),
              p("For that matter, a higher value means 'better' so recency goes also in line with the values of frequency and monetary for example."),
              h3("2. Coefficient calculation"),
              p("The next step is to perform KMeans clustering on the selected variables followed by a XGBoost model. This helps us group the data into clusters based on their similarity in order to perform a classification model in order to obtain the coefficients of each variable."),
              p("In the app, this step involves selecting the ID variable and entering the prefixes for each of the variables (e.g., RD_, GDP_, energy_). You can add these prefixes using the 'Add Prefix' button."),
              h3("3. Creating the Composite Index & Analyzing Convergence Clubs"),
              p("Using the coefficients obtained from the model, we create a composite index for each year. The index for each year is calculated as follows:"),
              HTML('
          <ul>
            <li>Index2007 = RD2007 * coeff_RD + GDP2007 * coeff_GDP + Energy2007 * coeff_Energy</li>
            <li>Index2008 = RD2008 * coeff_RD + GDP2008 * coeff_GDP + Energy2008 * coeff_Energy</li>
            <li>...</li>
            <li>Index2019 = RD2019 * coeff_RD + GDP2019 * coeff_GDP + Energy2019 * coeff_Energy</li>
          </ul>
        '),
        h3("Example"),
        p("For instance, if we want to analyze the convergence in R&D expenditure, GDP, and energy consumption for European countries, we would follow these steps:"),
        HTML('
          <ol>
            <li>Upload the dataset with columns: Country, RD2007, GDP2007, Energy2007, ..., RD2019, GDP2019, Energy2019.</li>
            <li>Perform KMeans clustering on the data to identify clusters.</li>
            <li>Use a model to determine the importance of each variable in determining the clusters.</li>
            <li>Create a composite index for each year using the determined coefficients.</li>
            <li>Analyze the convergence clubs using the composite indices.</li>
          </ol>
        '),
        p("By following these steps, we can effectively create a composite index and analyze convergence clubs to understand the underlying patterns and groupings in the data."),
        p("This is all done in two sections 'Index Coefficients' in which the KMeans and Classification Model is done and only the coefficients are shown, and in 'Index Club' where the user specifies the coefficient and the index is then created and the app proceeds to perform the club convergence analysis in the index created."),
        br(),
        p("It is important to write the prefix as it is, for example if the columns are RD2007, write 'RD', if it is RD_2007, write 'RD_'."),
        p("The way to interpret the findings can be understood in the 'Methodology' section. Additional references will be provided in the 'References' section.")
      ),
      tabItem(tabName = "ik_preparation",
              fluidRow(
                column(12,
                       box(title = "Preview Data", status = "primary", solidHeader = TRUE, width = NULL,
                           DTOutput("preview_data_ik"), style = "margin-left: 20px;")
                )
              ),
              fluidRow(
                column(5,
                       box(title = "Reorder Columns", status = "primary", solidHeader = TRUE, width = NULL,
                           uiOutput("reorder_ui_ik"), 
                           div(style = "margin-top: 20px;", 
                               actionButton("apply_reorder_ik", "Apply Reorder")
                           )
                       )),
                column(7,
                       box(title = "Rename Columns", status = "primary", solidHeader = TRUE, width = NULL,
                           uiOutput("rename_ui_ik"), 
                           actionButton("apply_rename_ik", "Apply Rename")
                       ))
              )
      ),
      tabItem(tabName = "ik_indexcoefficients",
              fluidRow(
                column(2,
                       selectInput("id_var", "Select ID Variable:", choices = NULL)
                ),
                column(2,
                       textInput("prefix_input", "Enter Prefix:", "")
                ),
                column(2,
                       actionButton("add_prefix", "Add Prefix", style = "margin-top: 25px; background-color: #007bff; border-color: #007bff; color: white;")
                ),
                column(3,
                       uiOutput("prefixes_ui")
                ),
                column(1,
                       actionButton("run_index_analysis", "", icon = icon("play"), 
                                    style = "margin-top: 25px; background-color: #007bff; border-color: #007bff; color: white;")
                ),
                column(1,
                       actionButton("remove_all_prefixes", "Remove All Prefixes", style = "margin-top: 25px; background-color: #dc3545; border-color: #dc3545; color: white;"))
              ),
              fluidRow(
                column(12, box(title = "Importance Plot", status = "warning", solidHeader = TRUE, plotOutput("importance_plot"), width = 12, style = "border-top: 10px solid #f0ad4e;"))
              )
      ),
      tabItem(tabName = "ik_indexclub",
              fluidPage(
                fluidRow(
                  column(12,
                         box(width = 12, status = "primary", solidHeader = TRUE,
                             fluidRow(
                               column(2,
                                      selectInput("id_var_indexclub", "Select ID Variable:", choices = NULL)
                               ),
                               column(2,
                                      textInput("prefix_input_indexclub", "Prefix:", "")
                               ),
                               column(4,
                                      actionButton("add_prefix_indexclub", "Add Prefix", style = "margin-top: 25px; background-color: #007bff; border-color: #007bff; color: white;"),
                                      actionButton("remove_prefix_indexclub", "Remove Prefix", style = "margin-top: 25px; margin-left: 10px; background-color: #dc3545; border-color: #dc3545; color: white;")
                               ),
                               column(2, 
                                      uiOutput("view_choice_ui")
                               ),
                               column(2,
                                      uiOutput("select_result_ui")
                               )
                               
                             ),
                             fluidRow(
                               column(3,
                                      textInput("start_year", "Start Year:", "")
                               ),
                               column(3,
                                      textInput("end_year", "End Year:", "")
                               )
                             ),
                             fluidRow(
                               column(6, 
                                      uiOutput("prefix_coefficient_ui_indexclub"))
                             ),
                             fluidRow(
                               column(12, actionButton("run_index_club_analysis", "Run Index Club Analysis", icon = icon("play"), 
                                                       style = "font-size: 18px; width: 100%; border-radius: 12px; background-color: #5cb85c; border-color: #4cae4c; color: white; padding: 10px 20px"))
                             )
                         )
                  )
                ),
                fluidRow(
                  column(12,
                         box(width = 12, status = "warning", solidHeader = TRUE, 
                             fluidRow(
                               column(12, uiOutput("index_club_analysis_result")),
                               column(12, downloadButton("download_ik_results", "", style = "margin-top: 20px;"))
                             )
                         )
                  )
                )
              )
      )
    )
  )
)


# Server
server <- function(input, output, session) {
  # Reactive value to store the separator
  separator <- reactiveVal(",")
  reactiveData <- reactiveVal()
  prefixes <- reactiveVal(list())
  
  # Handle file upload and attempt to read
  read_file <- reactive({
    req(input$file1)
    inFile <- input$file1
    file_ext <- tools::file_ext(inFile$datapath)
    
    if (file_ext == "csv") {
      tryCatch({
        read.csv(inFile$datapath, sep = separator())
      }, error = function(e) {
        showModal(modalDialog(
          title = "Error: Could not read CSV",
          HTML("The CSV file could not be read with the current separator, please change it and try again.<br/><br/> "),
          radioButtons("separator_choice", "Choose Separator:", choices = c("," = ",", ";" = ";"), selected = separator()),
          footer = tagList(
            modalButton("Cancel"),
            actionButton("retry_read", "Try Again", class = "btn-primary")
          )
        ))
        NULL
      })
    } else if (file_ext == "xlsx") {
      readxl::read_excel(inFile$datapath)
    } else {
      stop("Unsupported file type")
    }
  })
  
  # Manage data type checking and conversion UI
  output$type_conversion_ui <- renderUI({
    df <- read_file()
    req(df)
    nonNumericVars <- names(df)[sapply(df, function(x) !is.numeric(x))]
    
    if (length(nonNumericVars) > 0) {
      fluidRow(
        selectInput("var_to_convert", "Select Variable to Convert to Numeric:", choices = nonNumericVars),
        actionButton("convert_btn", "Convert to Numeric")
      )
    } else {
      h5("All variables are numeric or no data available.")
    }
  })
  
  # Watch for separator change button and open modal
  observeEvent(input$change_sep, {
    file_ext <- if (is.null(input$file1)) {
      "none"
    } else {
      tools::file_ext(input$file1$datapath)
    }
    
    showModal(modalDialog(
      title = "Upload Instructions",
      HTML("The app only allows CSV and XLSX files.<br/><br/> 
If the file is a csv, you can manually change the separator once the file is uploaded. <br/>
The default separator that the app will try to read is the comma separator, in case it is not the correct one, an error message will appear, with the corresponding pop-up to change it.
<br/><br/> In the case of an excel file there is nothing to specify.<br/> One thing to take into account is that for both types of file the first row will be taken into account as the column names. <br/><br/> 
The option to change separator once the file has been uploaded will only show if it is a csv. <br/><br/> 
For that matter, please upload a csv/excel file to use the app, take into account it will take the first sheet of the file as the input. <br/><br/> 
"),
if (file_ext == "csv") {
  radioButtons("separator_choice", "Separator:", choices = list("," = ",", ";" = ";"), selected = separator(), inline = TRUE)
},
footer = tagList(
  modalButton("Cancel"),
  actionButton("ok", "OK", class = "btn-primary")
)
    ))
  })
  
  
  # Update tab items after changing separator
  observeEvent(input$ok, {
    separator(input$separator_choice)
    removeModal()
    updateTabItems(session, "tabs", "general_check")
    read_file()
  })
  
  # Retry_read if separator is changed
  observeEvent(input$retry_read, {
    separator(input$separator_choice)
    removeModal()
    read_file()
  })
  
  # Update of tab items in general chek
  observeEvent(input$file1, {
    updateTabItems(session, "tabs", "general_check")
    df <- read_file()
    reactiveData(na.omit(df))
  })
  
  #Render datatable to check the data (of file read)
  output$check_data <- renderDataTable({
    datatable(read_file(), options = list(scrollX = TRUE))
  })
  
  # Remove NAs of df
  observe({
    req(input$file1)
    df <- read_file()
    reactiveData(na.omit(df))
  })
  
  # Apply change of class
  output$dataTypes <- renderDT({
    df <- reactiveData()
    types_df <- data.frame(
      Type = sapply(df, class)
    )
    datatable(types_df, options = list(paging = FALSE, searching = FALSE, info = FALSE, autoWidth = TRUE))
  })
  
  # Render UI of modification of variable types
  output$modify_types_ui <- renderUI({
    df <- reactiveData()
    varNames <- names(df)
    tagList(
      lapply(varNames, function(var) {
        fluidRow(
          column(6, strong(var)),
          column(6, selectInput(inputId = paste0("select_type_", var),
                                label = "Select Type",
                                choices = c("character", "numeric", "factor", "integer", "logical"),
                                selected = class(df[[var]])))
        )
      }),
      actionButton("apply_changes", "Apply Changes")
    )
  })
  
  # Apply changes of variable type
  observeEvent(input$apply_changes, {
    req(input$file1)
    df <- reactiveData()
    
    updates <- lapply(names(df), function(var) {
      inputId <- paste0("select_type_", var)
      selectedType <- input[[inputId]]
      tryCatch({
        converted <- switch(selectedType,
                            "character" = as.character(df[[var]]),
                            "numeric" = as.numeric(df[[var]]),
                            "factor" = as.factor(df[[var]]),
                            "integer" = as.integer(df[[var]]),
                            "logical" = as.logical(df[[var]]))
        if(is.null(converted)) df[[var]] else converted
      }, error = function(e) {
        showNotification(paste0("Error converting ", var, ": ", e$message), type = "error")
        df[[var]]
      })
    })
    
    if(length(updates) > 0) {
      updated_df <- as.data.frame(updates)
      colnames(updated_df) <- names(df)
      reactiveData(updated_df)
    }
  })
  
  # Render datatable to check the data (of data after saving it or applying changes)
  output$check_data <- renderDT({
    datatable(reactiveData(), options = list(autoWidth = TRUE, scrollX = TRUE, pageLength = 5))
  })
   
  # Update numerical variables to show in selection
  observe({
    df <- reactiveData()
    req(df)
    updateSelectInput(session, "id_variable", choices = c("Create New ID Variable", names(df)))
    numeric_vars <- names(df)[sapply(df, is.numeric)]
    updateSelectInput(session, "analysis_vars", choices = numeric_vars)
  })
  
  # Find optimum k for kmeans
  observeEvent(input$run_analysis, {
    data <- reactiveData()
    req(data)
    
    selected_vars <- intersect(input$analysis_vars, names(data)[sapply(data, is.numeric)])
    req(length(selected_vars) > 0)
    
    if (input$id_variable == "Create New ID Variable") {
      data$id <- seq_len(nrow(data))
    }
    
    if (input$scale_data) {
      data[, selected_vars] <- scale(data[, selected_vars])
    }
    
    reactiveData(data)
    
    # Render silhouette plot
    output$silhouette_plot <- renderPlot({
      fviz_nbclust(data[, selected_vars, drop = FALSE], kmeans, method = "silhouette") +
        labs(subtitle = "Silhouette method")
    })
    
    # Render elbow pot
    output$elbow_plot <- renderPlot({
      fviz_nbclust(data[, selected_vars, drop = FALSE], kmeans, method = "wss") +
        labs(subtitle = "Elbow method")
    })
  })
  
  # Update selection of ID, numeric variables to analyze, X var and Y var to plot
  observe({
    df <- reactiveData()
    req(df)
    numeric_vars <- names(df)[sapply(df, is.numeric)]
    updateSelectInput(session, "id_variable_analysis", choices = c("Create New ID Variable", names(df)))
    updateSelectInput(session, "analysis_vars_analysis", choices = numeric_vars)
    updateSelectInput(session, "x_var", choices = numeric_vars)
    updateSelectInput(session, "y_var", choices = numeric_vars)
  })
   
  
  # Run KMeans analysis
  observeEvent(input$run_analysis_analysis, {
    data <- reactiveData()
    req(data)
    
    selected_vars <- intersect(input$analysis_vars_analysis, names(data)[sapply(data, is.numeric)])
    req(length(selected_vars) > 0)
    
    if (length(selected_vars) == 0 || is.null(data[selected_vars])) {
      showNotification("No valid numeric variables selected or available for analysis.", type = "error")
      return()
    }
    
    tryCatch({
      data_for_clustering <- data[, selected_vars, drop = FALSE]
      if (input$scale_data_analysis) {
        data_for_clustering <- scale(data_for_clustering)
      }
      
      set.seed(123)
      kmeans_result <- kmeans(data_for_clustering, centers = input$num_clusters)
      
      data$cluster <- factor(kmeans_result$cluster)
      aggregated_data <- aggregate(data[, selected_vars, drop = FALSE], by = list(cluster = data$cluster), FUN = mean)
      
      reactiveData(data)
      
      # Datatable showing centroids results (with centroids not being scaled even if the the clusters calculation was based in scaled data)
      output$cluster_results <- renderDT({
        datatable(aggregated_data, options = list(autoWidth = FALSE, scrollX = TRUE, pageLength = 5))
      })
      
      # Plot cluster plot in PCA or ggplot selecting x and y variable
      output$cluster_plot <- renderPlot({
        if (input$plot_type == "pca") {
          fviz_cluster(kmeans_result, data = data_for_clustering,
                       geom = "point", ellipse.type = "convex", 
                       palette = colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))(input$num_clusters),
                       ggtheme = theme_bw())
        } else {
          req(input$x_var, input$y_var)
          ggplot(data, aes(x = .data[[input$x_var]], y = .data[[input$y_var]], color = cluster)) +
            geom_point(size = 3) +
            labs(title = "Custom Cluster Plot", x = input$x_var, y = input$y_var) +
            theme_minimal()
        }
      })
      
    }, error = function(e) {
      showNotification(paste("Error during analysis:", e$message), type = "error")
    })
  })
  
  # Show only numeric variables to select, and option to create new ID or use existing one
  observe({
    df <- reactiveData()
    req(df)
    updateSelectInput(session, "id_variable_analysis", choices = c("Create New ID Variable", names(df)))
    numeric_vars <- names(df)[sapply(df, is.numeric)]
    updateSelectInput(session, "analysis_vars_analysis", choices = numeric_vars)
  })
  
  # Download cluster results
  output$download_data <- downloadHandler(
    filename = function() {
      paste("cluster-results-", format(Sys.time(), "%Y-%m-%d-%H%M"), ".xlsx", sep = "")
    },
    content = function(file) {
      req(reactiveData())
      write.xlsx(reactiveData(), file)
    }
  )
  
  # Show order of the columns (CC preparation)
  output$reorder_ui <- renderUI({
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    orderInput("column_order", "", items = colnames, as.character = TRUE)
  })
  
  # Function to apply reorder (CC preparation)
  observeEvent(input$apply_reorder, {
    df <- reactiveData()
    req(df)
    new_order <- input$column_order
    reactiveData(df[new_order])
  })
  
  # Show rename part in boxes of 6 per row (CC preparation)
  output$rename_ui <- renderUI({
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    
    # Create rows of six inputs each
    tagList(
      lapply(seq(1, length(colnames), by = 6), function(i) {
        fluidRow(
          column(2, textInput(inputId = paste0("rename_", colnames[i]), label = paste("", colnames[i]), value = colnames[i])),
          if (i + 1 <= length(colnames)) column(2, textInput(inputId = paste0("rename_", colnames[i + 1]), label = paste("", colnames[i + 1]), value = colnames[i + 1])),
          if (i + 2 <= length(colnames)) column(2, textInput(inputId = paste0("rename_", colnames[i + 2]), label = paste("", colnames[i + 2]), value = colnames[i + 2])),
          if (i + 3 <= length(colnames)) column(2, textInput(inputId = paste0("rename_", colnames[i + 3]), label = paste("", colnames[i + 3]), value = colnames[i + 3])),
          if (i + 4 <= length(colnames)) column(2, textInput(inputId = paste0("rename_", colnames[i + 4]), label = paste("", colnames[i + 4]), value = colnames[i + 4])),
          if (i + 5 <= length(colnames)) column(2, textInput(inputId = paste0("rename_", colnames[i + 5]), label = paste("", colnames[i + 5]), value = colnames[i + 5]))
        )
      })
    )
  })
  
  # Apply rename (in CC preparation)
  observeEvent(input$apply_rename, {
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    new_names <- sapply(colnames, function(col) {
      input[[paste0("rename_", col)]]
    })
    colnames(df) <- new_names
    reactiveData(na.omit(df))
  })
  
  # Preview data for CC preparation
  output$preview_data <- renderDT({
    datatable(reactiveData(), options = list(autoWidth = TRUE, scrollX = TRUE, pageLength = 5))
  })
  
  # Dynamic year range slider based on data
  output$year_slider_ui <- renderUI({
    df <- reactiveData()
    req(df)
    year_columns <- as.numeric(names(df)[-1])  # We assume the ID is the first variable (it is specified in methodologies and instructions)
    min_year <- min(year_columns, na.rm = TRUE)
    max_year <- max(year_columns, na.rm = TRUE)
    
    sliderInput("year_range", "Select Year Range:",
                min = min_year, max = max_year, value = c(min_year, max_year), sep = "")
  })
  
  # Run club convergence analysis
  observeEvent(input$run_club_analysis, {
    req(input$year_range)
    data <- reactiveData()
    req(data)
    
    start_year <- input$year_range[1]
    end_year <- input$year_range[2]
    
    logData <- log(data[,-1])
    filteredData <- apply(logData, 1, function(x) {
      mFilter::hpfilter(x, freq = 400, type = "lambda")$trend
    })
    
    filteredData <- data.frame(ID = data[,1], t(filteredData), stringsAsFactors = FALSE)
    colnames(filteredData) <- colnames(data)
    
    H <- computeH(filteredData[,-1], quantity = "H")
    
    # Determine the column indices for the selected years
    dataCols <- 2:(end_year - start_year + 2)
    
    clubs <- findClubs(filteredData, dataCols = dataCols, unit_names = 1, refCol = end_year - start_year + 2, time_trim = 1/3, cstar = 0, HACmethod = 'FQSB')
    
    # Generate the results data frame
    tp <- transition_paths(clubs, output_type = 'data.frame')
    community_clubs <- tp |>  select(id = unit_name, club_id = club)
    
    # Print information about clubs
    output$print_clubs <- renderPrint({
      print(clubs)
    })
    
    # Plot club convergence final clubs (all or specific)
    output$plot_clubs <- renderPlot({
      if (input$view_choice == "all") {
        plot(clubs, legend = FALSE, plot_args = list(
          type = 'o',
          xmarks = seq(1, end_year - start_year + 1, 1),
          xlabs = seq(start_year, end_year, 1),
          xlab = "",
          ylab = "h",
          xlabs_dir = 2
        ))
      } else {
        plot(clubs, clubs = input$club_number, avgTP = FALSE, legend = TRUE, plot_args = list(
          type = 'o',
          xmarks = seq(1, end_year - start_year + 1, 1),
          xlabs = seq(start_year, end_year, 1),
          legend_args = list(max_length_labels = 10, y.intersp = 2)
        ))
      }
    })
    
    # Print general beta convergence results
    output$estimate_mod_result <- renderPrint({
      estimate_mod_result <- round(estimateMod(H, time_trim = 1/3, HACmethod = "FQSB"), 3)
      print(estimate_mod_result)
    })
    
    # Define the download handler
    output$download_cc_results <- downloadHandler(
      filename = function() {
        paste("cc-results-", format(Sys.time(), "%Y-%m-%d-%H%M"), ".xlsx", sep = "")
      },
      content = function(file) {
        write.xlsx(community_clubs, file)
      }
    )
  })
  
  # Index Klub Preparation tab logic
  output$reorder_ui_ik <- renderUI({
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    orderInput("column_order_ik", "", items = colnames, as.character = TRUE)
  })
  
  # Reorder in IK preparation
  observeEvent(input$apply_reorder_ik, {
    df <- reactiveData()
    req(df)
    new_order <- input$column_order_ik
    reactiveData(df[new_order])
  })
  
  # Show rename option in rows of six boxes each
  output$rename_ui_ik <- renderUI({
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    
    # Create rows of six inputs each
    tagList(
      lapply(seq(1, length(colnames), by = 6), function(i) {
        fluidRow(
          column(2, textInput(inputId = paste0("rename_ik_", colnames[i]), label = paste("", colnames[i]), value = colnames[i])),
          if (i + 1 <= length(colnames)) column(2, textInput(inputId = paste0("rename_ik_", colnames[i + 1]), label = paste("", colnames[i + 1]), value = colnames[i + 1])),
          if (i + 2 <= length(colnames)) column(2, textInput(inputId = paste0("rename_ik_", colnames[i + 2]), label = paste("", colnames[i + 2]), value = colnames[i + 2])),
          if (i + 3 <= length(colnames)) column(2, textInput(inputId = paste0("rename_ik_", colnames[i + 3]), label = paste("", colnames[i + 3]), value = colnames[i + 3])),
          if (i + 4 <= length(colnames)) column(2, textInput(inputId = paste0("rename_ik_", colnames[i + 4]), label = paste("", colnames[i + 4]), value = colnames[i + 4])),
          if (i + 5 <= length(colnames)) column(2, textInput(inputId = paste0("rename_ik_", colnames[i + 5]), label = paste("", colnames[i + 5]), value = colnames[i + 5]))
        )
      })
    )
  })
  
  # Function to apply rename
  observeEvent(input$apply_rename_ik, {
    df <- reactiveData()
    req(df)
    colnames <- names(df)
    new_names <- sapply(colnames, function(col) {
      input[[paste0("rename_ik_", col)]]
    })
    colnames(df) <- new_names
    reactiveData(na.omit(df))
  })
  
  # Preview data on Index Klub preparation
  output$preview_data_ik <- renderDT({
    datatable(reactiveData(), options = list(autoWidth = TRUE, scrollX = TRUE, pageLength = 5))
  })
  
  # Select ID in Coefficient Klub Index
  observe({
    df <- reactiveData()
    req(df)
    updateSelectInput(session, "id_var", choices = names(df))
  })
  
  # Add prefix
  observeEvent(input$add_prefix, {
    current_prefixes <- prefixes()
    new_prefix <- input$prefix_input
    if (new_prefix != "" && !(new_prefix %in% current_prefixes)) {
      prefixes(c(current_prefixes, new_prefix))
    }
    updateTextInput(session, "prefix_input", value = "")
  })
  
  # Remove prefixes (all)
  observeEvent(input$remove_all_prefixes, {
    prefixes(list())
  })
  
  # Show prefixes added
  output$prefixes_ui <- renderUI({
    prefix_list <- prefixes()
    if (length(prefix_list) > 0) {
      tagList(
        p(paste(prefix_list, collapse = ", "), style = "font-size: 25px; margin-top: 24px;")  
      )
    } else {
      p("No prefixes added", style = "font-size: 25px; margin-top: 24px;") 
    }
  })
  
  # Action after running index analysis to get coefficients
  observeEvent(input$run_index_analysis, {
    data <- reactiveData()
    req(data)
    
    id_var <- input$id_var
    prefix_list <- prefixes()
    req(length(prefix_list) > 0)
    
    selected_columns <- c(id_var, unlist(lapply(prefix_list, function(prefix) {
      grep(paste0("^", prefix), names(data), value = TRUE)
    })))
    
    merged_df <- data[, selected_columns]
    
    scaled_data <- scale(merged_df[,-which(names(merged_df) == id_var)])
    
    # Determine the optimum number of clusters using Elbow and Silhouette methods
    fviz_nbclust(scaled_data, kmeans, method = "wss")
    wss <- (nrow(scaled_data)-1)*sum(apply(scaled_data, 2, var))
    for (i in 2:15) wss[i] <- sum(kmeans(scaled_data, centers=i)$tot.withinss)
    optimal_clusters_elbow <- which.min(wss)
    
    fviz_nbclust(scaled_data, kmeans, method = "silhouette")
    sil_width <- rep(0, 15)
    for (i in 2:15) {
      km.res <- kmeans(scaled_data, centers = i, nstart = 25)
      ss <- silhouette(km.res$cluster, dist(scaled_data))
      sil_width[i] <- mean(ss[, 3])
    }
    optimal_clusters_silhouette <- which.max(sil_width)
    
    # Use the average of both methods as the final number of clusters
    optimal_clusters <- round(mean(c(optimal_clusters_elbow, optimal_clusters_silhouette)))
    
    kmeans_result <- kmeans(scaled_data, centers = optimal_clusters) # Calculate automatically the optimum number of k
    
    # Manually create the average columns for each prefix
    for (prefix in prefix_list) {
      col_name <- paste0("mean_", prefix)
      merged_df <- merged_df |> 
        mutate(!!sym(col_name) := rowMeans(select(merged_df, starts_with(prefix)), na.rm = TRUE))
    }
    
    set.seed(123)
    
    # Select only the ID column and the new mean columns
    df_avg <- merged_df |> 
      select(id_var, starts_with("mean_"))
    
    df_avgkmeans <- cbind(df_avg, cluster = kmeans_result$cluster)
    
    xgboostdf <- df_avgkmeans |>  select(-!!sym(id_var))
    
    grid_tune <- expand.grid(
      nrounds = c(50, 100, 200), #number of trees
      max_depth = c(2, 4, 6), #4-6
      eta = c(0.3), #c(0.025,0.05,0.1,0.3), #Learning rate
      gamma = 0, # pruning --> Should be tuned. i.e c(0, 0.05, 0.1, 0.5, 0.7, 0.9, 1.0)
      colsample_bytree = 1, # c(0.4, 0.6, 0.8, 1.0) subsample ratio of columns for tree
      min_child_weight = 1, # c(1,2,3) # the larger, the more conservative the model
      subsample = 1 # c(0.5, 0.75, 1.0) # used to prevent overfitting by sampling X% training
    ) # for 'better' models play with the ranges as shown in the comments :)
    
    train_control <- trainControl(method = "cv",
                                  number = 3,
                                  verboseIter = TRUE,
                                  allowParallel = TRUE)
    
    xgb_tune <- train(x = xgboostdf[,-which(names(xgboostdf) == "cluster")], 
                      y = xgboostdf[,"cluster"],
                      trControl = train_control,
                      tuneGrid = grid_tune,
                      method = "xgbTree",
                      verbose = TRUE)
    
    xgb_tune$bestTune
    
    train_control <- trainControl(method = "none",
                                  verboseIter = TRUE,
                                  allowParallel = TRUE)
    
    final_grid <- expand.grid(nrounds = xgb_tune$bestTune$nrounds,
                              eta = xgb_tune$bestTune$eta,
                              max_depth = xgb_tune$bestTune$max_depth,
                              gamma = xgb_tune$bestTune$gamma,
                              colsample_bytree = xgb_tune$bestTune$colsample_bytree,
                              min_child_weight = xgb_tune$bestTune$min_child_weight,
                              subsample = xgb_tune$bestTune$subsample)
    
    xgb_model <- train(x = xgboostdf[,-which(names(xgboostdf) == "cluster")],
                       y = xgboostdf[,"cluster"],
                       trControl = train_control,
                       tuneGrid = final_grid,
                       method = "xgbTree",
                       verbose = TRUE)
    
    xgb.pred <- predict(xgb_model, xgboostdf[,-which(names(xgboostdf) == "cluster")])
    
    # Show datatable (option used in debugging part of the app)
    output$index_cluster_results <- renderDT({
      datatable(df_avgkmeans, options = list(autoWidth = FALSE, scrollX = TRUE, pageLength = 5))
    })
    
    # Plot importance plot
    output$importance_plot <- renderPlot({
      importance_matrix <- xgb.importance(model = xgb_model$finalModel)
      xgb.plot.importance(importance_matrix = importance_matrix)
    })
  })
   
  # Show column names to select ID for Index Club
  observe({
    df <- reactiveData()
    req(df)
    updateSelectInput(session, "id_var_indexclub", choices = names(df))
  })
  
  # Update prefix UI
  prefixes_indexclub <- reactiveVal(list())
  
  observeEvent(input$add_prefix_indexclub, {
    current_prefixes <- prefixes_indexclub()
    new_prefix <- input$prefix_input_indexclub
    if (new_prefix != "" && !(new_prefix %in% current_prefixes)) {
      prefixes_indexclub(c(current_prefixes, new_prefix))
    }
    updateTextInput(session, "prefix_input_indexclub", value = "")
  })
  
  # Remove specific prefix
  observeEvent(input$remove_prefix_indexclub, {
    current_prefixes <- prefixes_indexclub()
    prefix_to_remove <- input$prefix_input_indexclub
    updated_prefixes <- setdiff(current_prefixes, prefix_to_remove)
    prefixes_indexclub(updated_prefixes)
    updateTextInput(session, "prefix_input_indexclub", value = "")
  })
  
  # Show prefixes added
  output$prefixes_ui_indexclub <- renderUI({
    prefix_list <- prefixes_indexclub()
    if (length(prefix_list) > 0) {
      tagList(
        p(paste(prefix_list, collapse = ", "), style = "font-size: 25px; margin-top: 24px;")
      )
    } else {
      p("No prefixes added", style = "font-size: 25px; margin-top: 24px;")
    }
  })
  
  # Update prefix coefficients UI
  output$prefix_coefficient_ui_indexclub <- renderUI({
    df <- reactiveData()
    req(df)
    prefix_list <- prefixes_indexclub()
    if (length(prefix_list) > 0) {
      tagList(
        lapply(prefix_list, function(prefix) {
          fluidRow(
            column(6, numericInput(paste0("coeff_", prefix), label = paste0("Coefficient for ", prefix), value = 1)),
            column(6, radioButtons(paste0("rank_order_", prefix), label = paste0("Ranking Order for ", prefix), choices = list("Ascending" = "asc", "Descending" = "desc"), selected = "asc"))
          )
        })
      )
    } else {
      p("No prefixes added", style = "font-size: 18px; margin-top: 24px;")
    }
  })
  
  # Events after "click" run in Klub Index
  observeEvent(input$run_index_club_analysis, {
    data <- reactiveData()
    req(data)
    
    id_var <- input$id_var_indexclub
    prefix_list <- prefixes_indexclub()
    req(length(prefix_list) > 0)
    
    # Initialize coefficients and rank orders
    coefficients <- numeric(length(prefix_list))
    names(coefficients) <- prefix_list
    
    rank_orders <- character(length(prefix_list))
    names(rank_orders) <- prefix_list
    
    # Get coefficients and rank orders from input 
    for (prefix in prefix_list) {
      coeff <- input[[paste0("coeff_", prefix)]]
      rank_order <- input[[paste0("rank_order_", prefix)]]
      coefficients[prefix] <- coeff
      rank_orders[prefix] <- rank_order
    }
    
    # Check for NA coefficients
    if (any(is.na(coefficients))) {
      showNotification("One or more coefficients are missing or invalid.", type = "error")
      print("Coefficients captured:")
      print(coefficients)
      return()
    }
    
    # Convert start and end years to numeric
    start_year <- as.numeric(input$start_year)
    end_year <- as.numeric(input$end_year)
    req(!is.na(start_year), !is.na(end_year), start_year <= end_year)
    
    # Ensure that the columns exist in the data
    year_columns <- unlist(lapply(prefix_list, function(prefix) {
      paste0(prefix, start_year:end_year)
    }))
    
    # If there are no missing years notify the user
    missing_columns <- setdiff(year_columns, colnames(data))
    if(length(missing_columns) > 0) {
      showNotification(paste("Missing columns in the data:", paste(missing_columns, collapse = ", ")), type = "error")
      return()
    }
    
    # Rank the data for each prefix and year
    for (year in start_year:end_year) {
      for (prefix in prefix_list) {
        col_name <- paste0(prefix, year)
        if (rank_orders[prefix] == "asc") {
          data <- data |> 
            mutate(!!sym(col_name) := rank(!!sym(col_name), ties.method = "first"))
        } else {
          data <- data |> 
            mutate(!!sym(col_name) := rank(-!!sym(col_name), ties.method = "first"))
        }
      }
    }
    
    # Create index columns for each year
    years <- start_year:end_year
    for (year in years) {
      col_name <- paste0("Index", year)
      formula <- paste(sapply(prefix_list, function(prefix) {
        paste0(prefix, year, " * ", coefficients[prefix])
      }), collapse = " + ")
      
      
      data <- data |> 
        mutate(!!sym(col_name) := eval(parse(text = formula)))
      
    }
    
    # Select the relevant columns (ID and Index columns)
    result <- data |> 
      select(all_of(id_var), starts_with("Index"))
    
    # Remove "Index" from column names
    colnames(result) <- sub("Index", "", colnames(result))
    
    # Prepare data for club analysis
    logData <- log(result[,-1])
    filteredData <- apply(logData, 1, function(x) {
      mFilter::hpfilter(x, freq = 400, type = "lambda")$trend
    })
    
    filteredData <- data.frame(ID = result[,1], t(filteredData), stringsAsFactors = FALSE)
    colnames(filteredData) <- colnames(result)
    
    H <- computeH(filteredData[,-1], quantity = "H")
    
    # Determine the column indices for the selected years
    dataCols <- 2:(end_year - start_year + 2)
    
    clubs <- findClubs(filteredData, dataCols = dataCols, unit_names = 1, refCol = end_year - start_year + 2, time_trim = 1/3, cstar = 0, HACmethod = 'FQSB')
    
    
    # Generate the results data frame
    tp <- transition_paths(clubs, output_type = 'data.frame')
    community_clubs <- tp |>  select(id = unit_name, club_id = club)
    
    
    # Update the view choice UI of View All clubs or Specific
    output$view_choice_ui <- renderUI({
      fluidRow(
        column(6,
               radioButtons("view_choice", "View:", choices = list("All Clubs" = "all", "Specific" = "specific"), selected = "all")
        ),
        column(6, 
               conditionalPanel(
                 condition = "input.view_choice == 'specific'",
                 numericInput("club_number", "Club Number:", value = 1, min = 1)
               )
        )
      )
    })
    
    
    # Render the plot or print the results option
    output$index_club_analysis_result <- renderUI({
      req(input$result_choice)  
      if (input$result_choice == "plot") {
        plotOutput("plot_clubs", height = "600px")
      } else {
        verbatimTextOutput("print_clubs")
      }
    })
    
    # Update the result choice UI
    output$select_result_ui <- renderUI({
      fluidRow(
        column(12,
               radioButtons("result_choice", "Result:", choices = list("Plot" = "plot", "Print" = "print"), selected = "plot")
        )
      )
    })
    
    # Print club
    output$print_clubs <- renderPrint({
      req(clubs)  # Ensure clubs data is available
      print(clubs)
    })
    
    # Render plot (all & specific)
    output$plot_clubs <- renderPlot({
      req(clubs, input$view_choice, input$start_year, input$end_year)  # Ensure all required inputs are available
      start_year <- as.numeric(input$start_year)
      end_year <- as.numeric(input$end_year)
      
      if (input$view_choice == "all") {
        plot(clubs, legend = FALSE, plot_args = list(
          type = 'o',
          xmarks = seq(1, end_year - start_year + 1, 1),
          xlabs = seq(start_year, end_year, 1),
          xlab = "",
          ylab = "h",
          xlabs_dir = 2
        ))
      } else {
        req(input$club_number)  
        plot(clubs, clubs = input$club_number, avgTP = FALSE, legend = TRUE, plot_args = list(
          type = 'o',
          xmarks = seq(1, end_year - start_year + 1, 1),
          xlabs = seq(start_year, end_year, 1),
          legend_args = list(max_length_labels = 10, y.intersp = 2)
        ))
      }
    })
    
    # Define the download handler
    output$download_ik_results <- downloadHandler(
      filename = function() {
        paste("kindex-results-", format(Sys.time(), "%Y-%m-%d-%H%M"), ".xlsx", sep = "")
      },
      content = function(file) {
        write.xlsx(community_clubs, file)
      }
    )
    
  })
}

# Run the application
shinyApp(ui, server)
