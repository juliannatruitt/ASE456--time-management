# Version 1 design:

## Home page: 
- At the top list: "date", "to", "from", "description", "tag"
- have all tasks listed from the database on the screen
- Have an add button that takes you to the add a task page
- have a search button that will take you to a page where you can search a specific task

## Add task page:
- use a date picker so that user can easily locate and add date. (this also works as input validation)
- have a drop down menu for time for the TO and FROM attributes. having a AM or PM option will also help with organization
- have a text box to enter in a description
- have a drop down menu of previously made tasks, and also give the option to create a new tag (which will bring up a pop up box)

## Query a task page (search): 
- users can search by date, description, or tag
- drop down menu with those options to limit user input\
- with date you can use format yyyy/mm/dd or can say "today"
- for description, it will look at any rows with that contain the text you input, so it does not have to be an exact match.
- if no rows match, it will say that no results are found.