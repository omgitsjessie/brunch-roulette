library(shiny)
library(shinyTime) #date and time input for shiny app

ui <- fluidPage(
  # Req'd inputs:
    # Brunch theme
    # email addresses in a list
    # Time and date of contest
    # Link to google drive folder for images
    # Link to survey

  # Buttons
    # Send invitations
    # Send images

  textInput("brunch_theme_set", "Enter a name for your brunch theme:"),
  textInput("list_of_email_addresses", "Enter a comma-separated list of email addresses:"),
  dateInput("date_of_brunch", "Enter date for brunch: ", Sys.Date()),
  timeInput("time_of_brunch", "Enter time for brunch (local)", value = strptime("12:34:56", "%T")),
  textInput("gdrive_folder_for_images", "Enter the folder URL to store images"),
  textInput("gsurvey_to_submit_images", "Enter the survey URL to send to participants"),
  
  actionButton("send_emails_to_kickoff", "Send Invitation Emails"),
  actionButton("kickoff_brunch", "Send Images / KICKOFF")

)



server <- function(input,
                   output) {
  observeEvent(input$send_emails_to_kickoff, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Recipients should receive kickoff emails in the next few minutes!')
  })
  
  observeEvent(input$kickoff_brunch, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Recipients should receive their assigned image in the next few minutes!')
    
  })
  
}

shinyApp(ui = ui, server = server)