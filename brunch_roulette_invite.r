#BRUNCH ROULETTE
library(gmailr) #send email using gmail RESTful API. https://github.com/r-lib/gmailr
# library(mailR)

gm_auth()

#TODO get a list of the people who want the survey link
  participants_uploaded <- c("") #ideally as a list c("email1@gg","email2@gg")

# New token
gm_auth_configure(path="brunch_roulette_client.json")
gm_auth()  
  
#Individual email info:
#host email info
email_source <- 'brunchroulette@gmail.com'
email_target <- c('jessie.mueller@gmail.com', 
                 'brunchroulette@gmail.com')
brunch_category_name <- 'Pancake Masterpieces'
attachment_path <- "test for now"
form_link <- "https://docs.google.com/forms/d/e/1FAIpQLSd6LmltiGmarGKWztKRRSyH9lTCsnS5DLs1uagUkMvpJDjEKw/viewform?usp=sf_link"
html_body <- paste("Welcome to Brunch Roulette! The theme for this round is 
                   \'Pancake Masterpieces\', and the submission link to participate 
                   can be found at <a href=\"https://docs.google.com/forms/d/e/
                   1FAIpQLSd6LmltiGmarGKWztKRRSyH9lTCsnS5DLs1uagUkMvpJDjEKw/viewform?usp=sf_link\"
                   > this google survey link</a>")

brunch_roulette_email <- gm_mime() %>%
  gm_to(email_target) %>%
  gm_from(email_source) %>%
  gm_subject(paste("Brunch Roulette Assignment:",brunch_category_name)) %>% 
  gm_html_body(html_body)


# Verify it looks correct
gm_create_draft(brunch_roulette_email)

# Send the invite message
gm_send_message(brunch_roulette_email)


