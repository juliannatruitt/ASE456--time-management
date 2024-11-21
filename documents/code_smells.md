# Code Smells:
- dead code
  - PROBLEM: some code from feature 1 to feature 2 is no longer being used.
  - SOLUTION: remove code that is not being used anymore
- long method
  - PROBLEM: the getFromDatabase method (method to query date/description/task) in the database_functions.dart is very long
  - SOLUTION: separate queryDate, queryDescription, and queryTask into separate methods to eliminate the method from being extremely long and hard to read.
- duplicate code
  - PROBLEM: many of the functions in the database_functions use the same duplicate code for a portion of the method
  - SOLUTION: 