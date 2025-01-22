import pandas as pd

# access to command line args via sys.argv, sys.argv[0] by default contains the name of the script itself.
import sys

# prints the system arguments
print(sys.argv)


# Day contains the first argument that we pass in the command line
day = sys.argv[1]


# print the day and the statement.
print(f"Job executed successfully for the day of {day}")
