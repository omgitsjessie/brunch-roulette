# BRUNCH ROULETTE - Parse submissions and assign images
library(gmailr) #send email using gmail RESTful API. https://github.com/r-lib/gmailr

#todo replace with date + format
time_to_begin <- ''

#todo replace with survey drive location
drive_directory <- ''


gm_auth()

#TODO get a list of all the images uploaded to the specific google drive along with the uploader email
#TODO get a list of the people participating based on unique uploaders to a specific google drive
participants_uploaded <- c("") #ideally as a list c("email1@gg","email2@gg")
#TODO add any extras that are participating but didn't upload
extra_participants <- c("") #Email addresses added last minute ideally as a list c("email3@gg","email4@gg")
#TODO for each person participating based on upload, make a sequence where they are ordered in a loop. Or randomize sequence.
#TODO for each person participating based on upload, select their assignment based on who is after them in loop sequence. Last person gets first person's photo.
#TODO for each extra person assign them a random photo that hadn't yet been selected if available. If not then assign any random photo

#TODO for each person participating, send an email with their assigned photo.

# New token - invalid credentials?
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
html_body <- paste("Game time! The theme for this round is \'Pancake Masterpieces\', 
                   and your assigned submission is from <user>, and is attached to this email.  
                   You have one hour to complete your recipe, take a photo, and upload to this drive link. 
                   Rules: You can only use what is currently in your kitchen, and everything 
                   must be edible.  Good luck!")

brunch_roulette_email <- gm_mime() %>%
  gm_to(email_target) %>%
  gm_from(email_source) %>%
  gm_subject(paste("Brunch Roulette Assignment:",brunch_category_name)) %>% 
  gm_html_body(html_body)


# Verify it looks correct
gm_create_draft(brunch_roulette_email)

# Send the invite message
gm_send_message(brunch_roulette_email)


