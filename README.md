# wat
The Linux coreutils spin off of cat, but for Windows.   

## How it works:
  1. Reads the 2nd argument as a file path. 
  2. Allocates heap space for the file based on file size.
  3. Reads file to the heap and prints the contents to the user.
