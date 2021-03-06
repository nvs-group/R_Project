## app.R ##
library(shiny)
library(shinydashboard)
library(markdown)
library(readr)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
selectedrowindex = 0
#Read in main data table from your local directory
#master1 <- read.csv("master1.txt")
master1 <- read.csv("https://www.dropbox.com/s/fgty42qwpkzudwz/master1.txt?dl=1")
#Read cip data table and order alphabetically
cip2 <- read_tsv("cip_code.txt")
cip1 <- cip2[order(cip2$CIP_Category),]
#Read soc data table and order alphabetically
soc2 <- read_tsv("soc_code.txt")
soc1 <- soc2[order(soc2$SOC_Cat_Name),]
#split soc into two groups
soc_group1 <- (soc1$SOC_Cat_Name[1:12])
soc_group2 <- (soc1$SOC_Cat_Name[13:24])
#spit cip into 4 groups
cip_group1 <- (cip1$CIP_Category[1:10])
cip_group2 <- (cip1$CIP_Category[11:19])
cip_group3 <- (cip1$CIP_Category[20:28])
cip_group4 <- (cip1$CIP_Category[29:37])
salary1 <- data.frame(age1 = double(), age_factor1 = double(), xsalary1 = double(), run_total1 = double())
salary2 <- data.frame(age1 = double(), age_factor1 = double(), xsalary1 = double(), run_total1 = double())
salary3 <- data.frame(age1 = double(), age_factor1 = double(), xsalary1 = double(), run_total1 = double())
lap.plot <- ggplot()
roi.data <- data.frame(school.n = character(), roi.n = factor())

ui <- dashboardPage(
  dashboardHeader(title = "College Planning"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home Page", tabName = "home", icon = icon("home")),
      menuItem("My Profile", tabName = "profile", icon = icon("user"),
               menuSubItem("Instructions", tabName = "instructions"),
               menuSubItem("School Select", tabName = "school"),
               menuSubItem("Degree Select", tabName = "degree"),
               menuSubItem("Occupation Select", tabName = "occupation"),
               menuSubItem("Curriculum Select", tabName = "curriculum"),
               menuSubItem("Salary Select", tabName = "salary"),
               menuSubItem("Tuition Select", tabName = "tuition")),
      menuItem("Scenerios", tabName = "Scenerios", icon = icon("tasks"),
               menuSubItem("Build Scenerios", tabName = "build"),
               menuSubItem("Compare Scenerios", tabName = "compare")),
      menuItem("Tools", tabName = "tools", icon = icon("toolbox")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "profile",
              h2("Thanks")
      ),
      tabItem(tabName = "about",
              h2("Welcome and Hello")
      ),
      tabItem(tabName = "tools",
              h2("This is where tools go."),
              checkboxGroupInput(inputId = "column.names", label = "Pick the columns you would like",
                                 selected = c("school.name", "degree.name", "occ.name", "cip.name", "cip.cat",
                                              "soc.cat"), choices = names(master1))
      ),
      tabItem(tabName = "instructions",
              h2("Go through each tab and select the items you currently know about")
      ),
      tabItem(tabName = "school",
              h3("I know exactly where I want to go:"),
              box(
                width = 5,
                selectInput(inputId = "pre.school.name",
                            label = "",
                            choices = levels(master1$school.name),
                            multiple = TRUE)
              )
      ),
      tabItem(tabName = "degree",
              h3("What is the highest degree you are planning to get?"),
              box(
                width = 5,
                selectInput(inputId = "pre.degree.name",
                            label = "",
                            choices = levels(master1$degree.name),
                            multiple = TRUE)
              )
      ),
      tabItem(tabName = "occupation",
              h3("Which of these occupations would you consider?"),
              
              fluidRow(
                box(
                  width = 4,
                  checkboxGroupInput(inputId = "pre.occupation1",
                                     label = "",
                                     choices = soc_group1)),
                box(width = 4,
                    checkboxGroupInput(inputId = "pre.occupation2",
                                       label = "",
                                       choices = soc_group2))
              )
      ),
      tabItem(tabName = "curriculum",
              h3("Please check all curriculum that you are interested in"),
              fluidRow(
                box(width = 3,
                    checkboxGroupInput(inputId = "survey.Cip_Category1",
                                       label = "Categories",
                                       choices = cip_group1)
                ),
                box(width = 3,
                    checkboxGroupInput(inputId = "survey.Cip_Category2",
                                       label = "",
                                       choices = cip_group2)
                ),
                box(width = 3,
                    checkboxGroupInput(inputId = "survey.Cip_Category3",
                                       label = "",
                                       choices = cip_group3)
                ),
                box(width = 3,
                    checkboxGroupInput(inputId = "survey.Cip_Category4",
                                       label = "",
                                       choices = cip_group4)
                )
              )
      ),
      tabItem(tabName = "salary",
              h3("How much income would you like to make in 10 to 15 years?"),
              box(
                sliderInput(inputId = "pre.income",
                            label = "",
                            value = min(sort(unique(master1$X10p))),
                            min = min(sort(unique(master1$X10p))),
                            max = max(sort(unique(master1$X10p))))
              )
      ),
      tabItem(tabName = "tuition",
              h3("How much tuition would you like to pay per years?"),
              box(
                sliderInput(inputId = "pre.tuition",
                            label = "",
                            value = max(sort(unique(master1$InStOff))),
                            min = min(sort(unique(master1$InStOff))),
                            max = max(sort(unique(master1$InStOff))))
              )
      ),
      tabItem(tabName = "build",
              fluidRow(
                box(width = 3,
                    
                    selectInput(inputId = "nvs.school.name",
                                label= "School Name:",
                                choices =  levels(master1$school.name),
                                multiple = TRUE),
                    
                    selectInput(inputId = "nvs.degree.name",
                                label = "Degree Name:",
                                choices =  levels(master1$degree.name),
                                multiple = TRUE),
                    
                    selectInput(inputId = "nvs.cip.cat",
                                label = "Curriculum Category:",
                                choices = cip1$CIP_Category,
                                multiple = TRUE),
                    
                    selectInput(inputId = "nvs.cip.name",
                                label = "Curriculum Name:",
                                choices = levels(master1$cip.name),
                                multiple = TRUE),
                    
                    selectInput(inputId = "nvs.occ.cat",
                                label = "Occupation Category:",
                                choices = soc1$SOC_Cat_Name,
                                multiple = TRUE),
                    
                    selectInput(inputId = "nvs.occ.name",
                                label = "Occupation Name:",
                                choices = levels(master1$occ.name),
                                multiple = TRUE),
                    
                    sliderInput(inputId = "nvs.income",
                                label = "Desired Income Level:",
                                value = min(sort(unique(master1$X10p))),
                                min = min(sort(unique(master1$X10p))),
                                max = max(sort(unique(master1$X10p)))),
                    
                    sliderInput(inputId = "nvs.tuition",
                                label = "Desired Tuition Level",
                                value = max(sort(unique(master1$InStOff))),
                                min = min(sort(unique(master1$InStOff))),
                                max = max(sort(unique(master1$InStOff))))
                ),
                box(
                  width = 9,
                  div(style = 'overflow-x: scroll',DT::dataTableOutput(outputId = "nvs.choice.table"))
                )
              )
      ),
      
      tabItem(tabName = "compare",
              fluidRow(
                box(width = 2,
                    numericInput(inputId = "age.begin", label = "Age to begin", min = 17, max = 69, value =  17)
                ),
                box(width = 2,
                    numericInput(inputId = "career.length", label = "Length of career", min = 1, max = 53, value = 20)
                )
              ),
              fluidRow(
                uiOutput(outputId = "row.choice.table1"),
                uiOutput(outputId = "row.choice.table2"),
                uiOutput(outputId = "row.choice.table3")
              ),
              hr(),
              fluidRow(
                box(width = 4,
                    DT::dataTableOutput(outputId = "row.choice.wage1")
                ),
                box(width = 4,
                    DT::dataTableOutput(outputId = "row.choice.wage2")
                ),
                box(width = 4,
                    DT::dataTableOutput(outputId = "row.choice.wage3")
                )
              ),
              hr(),
              fluidRow(
                box(width = 6,
                    plotOutput("cummulative.plot")
                ),
                box(width = 6,
                    plotOutput("roi.plot"))
              )
      )
    )
  )
)

server <- function(input, output, session) {
  #Reactive variable that uses selected choices or full column if empty
  
  
  school.name_var <- reactive({
    if(is.null(input$nvs.school.name )) {
      unique(master1$school.name)} else {
        input$nvs.school.name
      }
  })
  #Reactive variable that uses selected choices or full column if empty 
  degree.name_var <- reactive({
    if(is.null(input$nvs.degree.name )) {
      unique(master1$degree.name)} else {
        input$nvs.degree.name
      }
  })
  #Reactive variable that uses selected choices or full column if empty
  occ.name_var <- reactive({
    if(is.null(input$nvs.occ.name)) {
      unique(master1$occ.name)} else {
        input$nvs.occ.name
      }
  })  
  #Reactive variable that uses selected choices or full column if empty
  cip.name_var <- reactive({
    if(is.null(input$nvs.cip.name)) {
      unique(master1$cip.name)} else {
        input$nvs.cip.name
      }
  })
  cip.cat_var <- reactive ({
    if(is.null(input$nvs.cip.cat)){
      unique(master1$cip.cat)} else {
        cip1$CIP_Code[cip1$CIP_Category %in% input$nvs.cip.cat]
      }
  })
  occ.cat_var <- reactive ({
    if(is.null(input$nvs.occ.cat)){
      unique(master1$soc.cat)} else {
        soc1$SOC_Code[soc1$SOC_Cat_Name %in% input$nvs.occ.cat]
      }
  })
  occ_var <- reactive ({
    soc1$SOC_Cat_Name[soc1$SOC_Cat_Name %in% input$pre.occupation1 | soc1$SOC_Cat_Name %in% input$pre.occupation2]
  })
  cip_var <- reactive ({
    cip1$CIP_Category[cip1$CIP_Category %in% input$survey.Cip_Category1 |cip1$CIP_Category %in% input$survey.Cip_Category2 |
                        cip1$CIP_Category %in% input$survey.Cip_Category3 | cip1$CIP_Category %in% input$survey.Cip_Category4]
  })
  #Filter for First Table
  table_var <- reactive({
    filter(master1, school.name %in% school.name_var(), degree.name %in% degree.name_var(),
           occ.name %in% occ.name_var(), cip.name %in% cip.name_var(),
           cip.cat %in% cip.cat_var(), soc.cat %in% occ.cat_var()) 
  })
  #X10p >= input$nvs.income, InStOff <= input$nvs.tuition,
  observe ({
    req(cip_var())
    updateSelectInput(session, "nvs.cip.cat", "Curriculum Category:", selected = cip_var())
  })
  observe({
    req(occ_var())
    updateSelectInput(session, "nvs.occ.cat", "Occupation Category:", selected = occ_var())
  }) 
  observe({
    if(is.null(input$nvs.school.name)) {
      updateSelectInput(session, "nvs.school.name", "School Name:", choices = unique(table_var()$school.name))  
    }
    if(is.null(input$nvs.degree.name)) {
      updateSelectInput(session, "nvs.degree.name", "Degree Name:", choices = unique(table_var()$degree.name))
    }
    if(is.null(input$nvs.occ.name)) {
      updateSelectInput(session, "nvs.occ.name", "Occupation Name:", choices = unique(table_var()$occ.name))
    }
    if(is.null(input$nvs.cip.name)) {
      updateSelectInput(session, "nvs.cip.name", "Curriculum Name:", choices = unique(table_var()$cip.name))
    }
    if(is.null(input$nvs.cip.cat)) {
      updateSelectInput(session, "nvs.cip.cat", "Curriculum Category:",
                        choices = cip1$CIP_Category[cip1$CIP_Code %in% table_var()$cip.cat])
    }
    if(is.null(input$nvs.occ.cat)){
      updateSelectInput(session, "nvs.occ.cat", "Occupation Category:", 
                        choices = soc1$SOC_Cat_Name[soc1$SOC_Code %in% table_var()$soc.cat])
    }
  })
  
  #First Table
  observe ( {  
    #   req(input$nvs.school.name)
    
    output$nvs.choice.table <- renderDataTable({
      DT::datatable(data = table_var()  %>% select(input$column.names), 
                    options = list(pageLength = 10),selection = list(mode = "multiple"))
    })
  })
  #ObserveEvents go back here  
  # from school choice on preference page  
  observeEvent(input$pre.school.name, {
    updateSelectInput(session, "nvs.school.name", "School Name:", selected = input$pre.school.name)
  })
  #Import degree choice to scenerio from degree choice on preference page  
  observeEvent(input$pre.degree.name, {
    updateSelectInput(session, "nvs.degree.name", "Degree Name:", selected = input$pre.degree.name)
  })
  # from income level choice on preference page  
  observeEvent(input$pre.income, {
    updateSliderInput(session, "nvs.income", "Desired Income Level:", value = input$pre.income)
  })
  # from tuition cost level choice on preference page  
  observeEvent(input$pre.tuition, {
    updateSliderInput(session, "nvs.tuition", "Desired Tuition Level:", value = input$pre.tuition)
  })
  #Table prep with filters and Column choices for second table
  new_var <- reactive({
    table_var()[input$nvs.choice.table_rows_selected,] %>% select(occ.name, school.name, degree.name, X17p, InStOff, degree.code)
    #    table_var() %>% select(input$column.names)
  })
  
  #choice Tables after choosing rows  
  observe ({
    if(nrow(new_var()) > 0) {
      output$row.choice.table1 <- renderUI({
        box(width = 4,
            strong("Occupation :"), 
            new_var()$occ.name[1], br(),
            strong("School :"), 
            new_var()$school.name[1], br(),
            strong("Degree :"), 
            new_var()$degree.name[1], br(),
            strong("Salary :"), 
            new_var()$X17p[1], br(),
            strong("Tuition :"), 
            new_var()$InStOff[1])
      })
      dc <- new_var()$degree.code[1]
      if (dc == 1){
        years <- 1} else 
          if (dc == 2) {
            years <- 2} else 
              if (dc == 3) {
                years <- 2} else 
                  if (dc == 5) {
                    years <- 4} else 
                      if (dc == 6) {
                        years <- 1} else 
                          if (dc == 7) {
                            years <- 2} else 
                              if (dc == 8) {
                                years <- 1} else 
                                  if (dc == 13) {
                                    years <- 3} else 
                                      if (dc == 14){
                                        years <- 1} else 
                                          if (dc == 17) {
                                            years <- 2} else 
                                              if (dc == 18) {
                                                years <- 1}
      
      y <- 0
      a <- input$age.begin
      for(i in (a:(a + (years - 1)))) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- as.double(new_var()[1,] %>% select(InStOff))
        y <- y - x
        s1 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary1 <- rbind(salary1, s1)
      }
      x <- as.double(new_var()[1,] %>% select(X17p))
      a <- input$age.begin + years
      af <- (1 + ((0.00002 * (a ^ 2)) - 0.0034 * a + 0.127 ))
      y <- x + y
      s1 <- list(age1 = a, age_factor1 = af, xsalary1 = x, run_total1 = y)
      salary1 <- rbind(salary1, s1)
      for(i in (a+1:input$career.length)) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- x * af
        x <- round(x, 0)
        y <- x + y
        s1 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary1 <- rbind(salary1, s1)
      }
      totalcost1 <- new_var()$InStOff[1] * years
      runtot1 <- (salary1$run_total[nrow(salary1)])
      roi1 <- (runtot1 + totalcost1) / totalcost1 * 100
      r1 <- list(school.n = paste("1",new_var()$school.name[1], "\n", new_var()$occ.name[1]), roi.n = roi1)
      roi.data <- rbind(roi.data, r1)
      
      output$row.choice.wage1 <- renderDataTable({
        DT::datatable(data = salary1, options = list(pageLength = 10, searching = FALSE, ordering = FALSE),
                      selection = "none")
      })
      output$cummulative.plot <- renderPlot({
        ggplot() + geom_line(data = salary1, aes(x = age1 ,y = run_total1/1000, colour="First"),
                             show.legend = TRUE) +
          scale_colour_manual(name="Occupation", values = c("First" = "blue", "Second" = "green", "Third" = "red"),
                              labels = new_var()$school.name) +
          xlab('AGE') +
          ylab('Total Earnings') +
          labs(title = "Cummulative Cash Flow") +
          theme(plot.title = element_text(hjust = 0.5))
      })
      output$roi.plot <- renderPlot({
        ggplot(roi.data, aes(x=school.n, y = roi.n)) + geom_bar(stat = "identity", width = 0.4) +
          xlab('School') +
          ylab('Percent') +
          labs(title = "ROI") +
          theme(plot.title = element_text(hjust = 0.5))
      })
    }
    if(nrow(new_var()) > 1) {
      output$row.choice.table2 <- renderUI({
        box(width = 4,
            strong("Occupation :"), 
            new_var()$occ.name[2], br(),
            strong("School :"), 
            new_var()$school.name[2], br(),
            strong("Degree :"), 
            new_var()$degree.name[2], br(),
            strong("Salary :"), 
            new_var()$X17p[2], br(),
            strong("Tuition :"), 
            new_var()$InStOff[2])
      })
      dc <- new_var()$degree.code[2]
      if (dc == 1){
        years <- 1} else 
          if (dc == 2) {
            years <- 2} else 
              if (dc == 3) {
                years <- 2} else 
                  if (dc == 5) {
                    years <- 4} else 
                      if (dc == 6) {
                        years <- 1} else 
                          if (dc == 7) {
                            years <- 2} else 
                              if (dc == 8) {
                                years <- 1} else 
                                  if (dc == 13) {
                                    years <- 3} else 
                                      if (dc == 14){
                                        years <- 1} else 
                                          if (dc == 17) {
                                            years <- 2} else 
                                              if (dc == 18) {
                                                years <- 1}
      
      y <- 0
      a <- input$age.begin
      
      for(i in (a:(a + (years - 1)))) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- as.double(new_var()[2,] %>% select(InStOff))
        y <- y - x
        s2 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary2 <- rbind(salary2, s2)
      }
      x <- as.double(new_var()[2,] %>% select(X17p))
      a <- input$age.begin + years
      af <- (1 + ((0.00002 * (a ^ 2)) - 0.0034 * a + 0.127 ))
      y <- x + y
      s2 <- list(age1 = a, age_factor1 = af, xsalary1 = x, run_total1 = y)
      salary2 <- rbind(salary2, s2)
      for(i in (a+1:input$career.length)) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- x * af
        x <- round(x, 0)
        y <- x + y
        s2 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary2 <- rbind(salary2, s2)
      }
      totalcost1 <- new_var()$InStOff[2] * years
      runtot1 <- (salary2$run_total[nrow(salary2)])
      roi2 <- (runtot1 + totalcost1) / totalcost1 * 100
      r2 <- list(school.n = paste("2", new_var()$school.name[2], "\n", new_var()$occ.name[2]), roi.n = roi2)
      roi.data <- rbind(roi.data, data.frame(as.list(r2)))
      
      output$row.choice.wage2 <- renderDataTable({
        DT::datatable(data = salary2, options = list(pageLength = 10, searching = FALSE, ordering = FALSE),
                      selection = "none")
      })
      
      output$cummulative.plot <- renderPlot({
        ggplot() + geom_line(data = salary1, aes(x = age1 ,y = run_total1/1000, colour = "First"),
                             show.legend = TRUE) +
          geom_line(data = salary2, aes(x = age1, y = run_total1/1000, colour = "Second"), 
                    show.legend = TRUE) +
          scale_colour_manual(name="Occupation", values = c("First" = "blue", "Second" = "green", "Third" = "red"),
                              labels = new_var()$school.name)  +
          xlab('AGE') +
          ylab('Total Earnings') +
          labs(title = "Cummulative Cash Flow") +
          theme(plot.title = element_text(hjust = 0.5))
      })
      output$roi.plot <- renderPlot({
        ggplot(roi.data, aes(x = school.n, y = roi.n)) + geom_bar(stat = "identity", width = 0.3) +
          xlab('School') +
          ylab('Percent') +
          labs(title = "ROI") +
          theme(plot.title = element_text(hjust = 0.5))
      })
    }
    if(nrow(new_var()) > 2) {
      output$row.choice.table3 <- renderUI({
        box(width = 4,
            strong("Occupation :"), 
            new_var()$occ.name[3], br(),
            strong("School :"), 
            new_var()$school.name[3], br(),
            strong("Degree :"), 
            new_var()$degree.name[3], br(),
            strong("Salary :"), 
            new_var()$X17p[3], br(),
            strong("Tuition :"), 
            new_var()$InStOff[3])
      })
      dc <- new_var()$degree.code[3]
      if (dc == 1){
        years <- 1} else 
          if (dc == 2) {
            years <- 2} else 
              if (dc == 3) {
                years <- 2} else 
                  if (dc == 5) {
                    years <- 4} else 
                      if (dc == 6) {
                        years <- 1} else 
                          if (dc == 7) {
                            years <- 2} else 
                              if (dc == 8) {
                                years <- 1} else 
                                  if (dc == 13) {
                                    years <- 3} else 
                                      if (dc == 14){
                                        years <- 1} else 
                                          if (dc == 17) {
                                            years <- 2} else 
                                              if (dc == 18) {
                                                years <- 1}
      
      y <- 0
      a <- input$age.begin
      
      for(i in (a:(a + (years - 1)))) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- as.double(new_var()[3,] %>% select(InStOff))
        y <- y - x
        s3 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary3 <- rbind(salary3, s3)
      }
      x <- as.double(new_var()[3,] %>% select(X17p))
      a <- input$age.begin + years
      af <- (1 + ((0.00002 * (a ^ 2)) - 0.0034 * a + 0.127 ))
      y <- x + y
      s3 <- list(age1 = a, age_factor1 = af, xsalary1 = x, run_total1 = y)
      salary3 <- rbind(salary3, s3)
      for(i in (a+1:input$career.length)) {
        af <- (1 + ((0.00002 * (i ^ 2)) - 0.0034 * i + 0.127 ))
        x <- x * af
        x <- round(x, 0)
        y <- x + y
        s3 <- list(age1 = i, age_factor1 = af, xsalary1 = x, run_total1 = y)
        salary3 <- rbind(salary3, s3)
      }
      totalcost1 <- new_var()$InStOff[3] * years
      runtot1 <- (salary3$run_total[nrow(salary3)])
      roi3 <- (runtot1 + totalcost1) / totalcost1 * 100
      r3 <- list(school.n = paste("3", new_var()$school.name[3], "\n", new_var()$occ.name[3]), roi.n = roi3)
      roi.data <- rbind(roi.data, data.frame(as.list(r3)))
      
      output$row.choice.wage3 <- renderDataTable({
        DT::datatable(data = salary3, options = list(pageLength = 10, searching = FALSE, ordering = FALSE),
                      selection = "none")
      })
      output$cummulative.plot <- renderPlot({
        ggplot() + geom_line(data = salary1, aes(x = age1 ,y = run_total1/1000, colour = "First"),
                             show.legend = TRUE) +
          geom_line(data = salary2, aes(x = age1, y = run_total1/1000, colour = "Second"),
                    show.legend = TRUE) +
          geom_line(data = salary3, aes(x = age1, y = run_total1/1000, colour = "Third"),
                    show.legend = TRUE) +
          scale_colour_manual(name="Occupation", values = c("First" = "blue", "Second" = "green", "Third" = "red"),
                              labels = new_var()$school.name)  +
          xlab('AGE') +
          ylab('Total Earnings') +
          labs(title = "Cummulative Cash Flow") +
          theme(plot.title = element_text(hjust = 0.5))
      })
      output$roi.plot <- renderPlot({
        ggplot(roi.data, aes(x = school.n, y = roi.n)) + geom_bar(stat = "identity", width = 0.3) +
          xlab('School') +
          ylab('Percent') +
          labs(title = "ROI") +
          theme(plot.title = element_text(hjust = 0.5))
      })
    }
  })
  observe({
    if(nrow(new_var()) < 3) {
      output$row.choice.wage3 <- renderDataTable({ NULL })
      output$row.choice.table3 <- renderUI( NULL )
    }
    if(nrow(new_var()) < 2) {
      output$row.choice.wage2 <- renderDataTable({ NULL })
      output$row.choice.table2 <- renderUI( NULL )
    }
    if(nrow(new_var()) < 1) {
      output$row.choice.wage1 <- renderDataTable({ NULL })
      output$row.choice.table1 <- renderUI( NULL )
      output$cummulative.plot <- renderPlot( {NULL})
      output$roi.plot <- renderPlot ({NULL})
    }
  })
}
shinyApp(ui = ui, server = server)