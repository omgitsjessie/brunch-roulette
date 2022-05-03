# BRUNCH ROULETTE - Parse submissions and assign images
library(gmailr) #send email using gmail RESTful API. https://github.com/r-lib/gmailr
library(googledrive) # check drive folders and access images / submissions
library(dplyr) # pipe and date handling
library(lubridate) # date handling
library(hms) # time handling

email_source <- 'brunchroulette@gmail.com'
gdrive_scope <- 'https://www.googleapis.com/auth/drive.readonly' # makes edit / delete impossible
  # you can also use service account tokens here (see https://googledrive.tidyverse.org/reference/drive_auth.html)

# out of band gdrive auth (this will authenticate in browser first time)
drive_auth()

  # allow Tidyverse API Packages access to your specific google account in browser
  # close page and return to R

# confirm you're in the right account
    # drive_user()

# adjust directory name to whatever you're using
gdrive_directory <- "Please upload 1-10 images for this week\'s Brunch Roulette.  (File responses)"

# Make a list of all the files in that directory
uploaded_file_list <- drive_ls(gdrive_directory) %>% as.data.frame()

# Build a table with the distinct set of users who have uploaded to this directory
participants_uploaded <- data.frame(matrix(ncol=1, nrow = nrow(uploaded_file_list)))
colnames(participants_uploaded) <- c('submission_email')

for (i in 1:nrow(uploaded_file_list)) {
  participants_uploaded[i,1] <- uploaded_file_list[['drive_resource']][[i]][['sharingUser']][['emailAddress']]
}

player_list <- unique(participants_uploaded$submission_email)

# manually add any extras that are participating but didn't upload - last minute folks
# added here as a list c("email3@gg","email4@gg")
extra_participants <- c("jessie.mueller@gmail.com", "second@email")
# extra_participants <- c("") 

# total set of participants: the people who have uploaded content and last minute adds
# randomize the participants first, the others don't matter since they're not supplying content it'll be random anyway
if(extra_participants == '') {
  brunch_participants <- player_list} else {brunch_participants <- paste(c(player_list, extra_participants))} 

# clean it up so you can add columns to this as a dataframe
brunch_participants <- brunch_participants %>% as.data.frame()
colnames(brunch_participants) <- c('participants')

# Assign a random order to the participant list. Image assignment:
#   Each person will be assigned an image supplied by the next person. 
#   If the next person did not supply an image, they will receive an unassigned image from someone who submitted more than one
#     If there are no extra images, they'll receive a randomly assigned image

# todo - this only works if everyone submits; instead assign 
# to the submitters first so you aren't interleaving people w/o submissions
brunch_participants$random <- sample(1:nrow(brunch_participants), nrow(brunch_participants), replace = F)
brunch_participants <- brunch_participants[order(brunch_participants$random),]

#Choose the 
brunch_participants[1,'assigned_from'] <- brunch_participants[nrow(brunch_participants),'participants']
for (i in 2:nrow(brunch_participants)) {
  brunch_participants[i,'assigned_from'] <- brunch_participants[(i-1),'participants']
}
  
# TODO for each person participating, send an email with their assigned photo, 
# and a link to submit their final images.
# Add the variable references (sender and attachment link) 

# attachments - download images into temp folder? 
# look to see if you can insert an image object link instead

#todo replace with date + format
time_to_begin <- ''

#todo replace with survey drive location
drive_directory <- ''

gm_auth()

# replace with your token name / path
gm_auth_configure(path="brunch_roulette_client.json")
gm_auth()  

#Individual email info:
# this will be consistent across all emails
email_source <- 'brunchroulette@gmail.com'
attachment_path <- "test for now"
form_link <- "https://docs.google.com/forms/d/e/1FAIpQLSd6LmltiGmarGKWztKRRSyH9lTCsnS5DLs1uagUkMvpJDjEKw/viewform?usp=sf_link"
brunch_category_name <- 'Pancake Masterpieces'

# this will change for each email
email_target <- '' # TODO fix -- should be brunch_participants[i,1]
image_contributor <- '' # TODO fix -- should be brunch_participants[i,3]

html_body <- paste("Game time! The theme for this round is \'",brunch_category_name,"\', 
                   and your assigned submission is from ",image_contributor,", and is attached to this email.  
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


