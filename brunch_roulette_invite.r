# BRUNCH ROULETTE: Set up and send the automated invites

library(gmailr) #send email using gmail RESTful API
library(dplyr) # pipe and date handling
library(lubridate) # date handling
library(hms) # time handling


# Set up your key path so it can authenticate and interact
gm_auth_configure(path="brunch_roulette_client.json")
# Authenticate your source email account to work with R and send emails
gm_auth()

# Invitation email composition

    #host email info - replace with whatever account will be configured to run the scripts
    email_source <- 'brunchroulette@gmail.com'
        # email_target <- participants_uploaded
    
    # Manually add a list of the people who want the survey link
    participants_uploaded <- c('jessie.mueller@gmail.com', 
                               'brunchroulette@gmail.com') 
    
    # Name of roulette theme
    brunch_category_name <- 'Pancake Masterpieces'
    
    # Brief standalone description of roulette theme
    brunch_category_descrip <- 'For this theme, players will submit works of actual art, 
    which will then have to be recreated with pancakes during the competition. '
    
    # scheduled time to kickoff the actual event, plus strings for email pieces
    event_timestamp <- '2022-05-01 10:00:00 MDT'
      event_day <- event_timestamp %>% wday(label = TRUE, abbr = FALSE) # Full day of week (Sunday / Monday etc)
      event_month <- event_timestamp %>% 
        as_datetime() %>% 
        month(label = TRUE, abbr = FALSE)
      event_month <- event_timestamp %>% as_datetime() %>% day()
      event_time <- event_timestamp %>% as_datetime() # %>% hms()
      
      '2022-05-01 10:00:00' %>% as_datetime()
    
    # google drive link associated with submitted images -- not necessary for invite but good to track here
    attachment_path_submissions <- "https://drive.google.com/drive/folders/0B75tBjB0bN9_fjJzQWdnU2Zqc0xTVVVKdUctRFJ3ZnhXLVpack9wQ3ppeEo3WUVib2YtT2s?resourcekey=0-wSTXVMTzQsDoNldCTvyg4A"
    
    # google survey to facilitate submitted images
    form_link <- "https://docs.google.com/forms/d/e/1FAIpQLSd6LmltiGmarGKWztKRRSyH9lTCsnS5DLs1uagUkMvpJDjEKw/viewform?usp=sf_link"
    
    # text body of the email that will invite players
    html_body <- paste("Welcome to Brunch Roulette! The theme for this round is 
                       \'", brunch_category_name, "\', and the submission link to participate 
                       can be found at <a href=\"https://docs.google.com/forms/d/e/
                       1FAIpQLSd6LmltiGmarGKWztKRRSyH9lTCsnS5DLs1uagUkMvpJDjEKw/viewform?usp=sf_link\"
                       > this google survey link</a>. ", brunch_category_descrip, "Good luck!")

# Build the draft invitation email object from its composite parts
brunch_roulette_email <- gm_mime() %>%
  gm_to(participants_uploaded) %>%
  gm_from(email_source) %>%
  gm_subject(paste("Brunch Roulette Assignment:",brunch_category_name)) %>% 
  gm_html_body(html_body)

# Create the draft and then verify it looks correct in your dedicated email account
gm_create_draft(brunch_roulette_email)

# Send the invite message
gm_send_message(brunch_roulette_email)

# ?todo - reminder the day before if they haven't submitted an image?
