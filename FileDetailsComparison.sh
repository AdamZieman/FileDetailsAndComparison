#!/bin/bash
# By: Adam Zieman
# Course: CSCI 275 (UNIX Scripting)
# Description:
  # This script requires exactly two positional parameters.
  # Both positional parameters must be an absolute file path to an
  # ordinary file.
  # The script will provide the following information about each file:
    # file name
    # file size in bytes
    # file permissions
    # a guess about the file contents
    # number of words
  # Additionally the script will compare:
    # file size in bytes
    # word count
  # The script will also test:
    # that two different file names are provided
    # that the files exist
    # that the files are ordinary files
    # the user running the script has read access to both files
#--------------------------------------------------------------------#
# Test Conditions

# does not continue the script if the files are the same
if [ $1 = $2 ]
  then
    exit 1
fi

# does not continue if the files do not exist
if [ ! -e $1 ]
  then
    exit 1
  elif [ ! -e $2 ]
  then
    exit 1
fi

# does not continue if the files are not ordinary
if [ ! -f $1 ]
  then
    exit 1
  elif [ ! -f $2 ]
  then
    exit 1
fi

# does not continue if the user does not have read permission
if [ ! -r $1 ]
  then
    exit 1
  elif [ ! -r $2 ]
  then
    exit 1
fi

#--------------------------------------------------------------------#

# Assign variables to positional parameters
file1=$1
file2=$2

# Seperate file name from file path
fileName1=$(echo $file1 | gawk -F "/" '{print $NF}')
fileName2=$(echo $file2 | gawk -F "/" '{print $NF}')

# Use the stat utility with option -c%s to get file byte size
fileSize1=$(stat -c%s $file1)
fileSize2=$(stat -c%s $file2)

# Use the wc utility to get the total word count of each file
wordCount1=$(wc $file1 | gawk '{print $2}')
wordCount2=$(wc $file2 | gawk '{print $2}')

# Use the stat utility with option --printf%a to get the file
# permissions in octal
filePermission1=$(stat --printf=%a $file1)
filePermission2=$(stat --printf=%a $file2)

# Mathematically seperate the permissions in octal and assign
# the value to the appropriate access class
othersPermission1=$((filePermission1 % 10))
groupPermission1=$(( (filePermission1 % 100) / 10))
ownerPermission1=$(( (filePermission1 % 1000) / 100))

othersPermission2=$((filePermission2 % 10))
groupPermission2=$(( (filePermission2 % 100) / 10))
ownerPermission2=$(( (filePermission2 % 1000) / 100))

# Assign a string contraining the respective access type to
# the appropriate access class
ownerAccessType1=""
case "$ownerPermission1" in
  0)
    ownerAccessType1="no permissions"
    ;;
  1)
    ownerAccessType1="execute permission only"
    ;;
  2)
    ownerAccessType1="write permission only"
    ;;
  3)
    ownerAccessType1="write and execute permissions"
    ;;
  4)
    ownerAccessType1="read permssion only"
    ;;
  5)
    ownerAccessType1="read and execute permissions"
    ;;
  6)
    ownerAccessType1="read and write permissions"
    ;;
  7)
    ownerAccessType1="read, write, and execute permissions"
    ;;
esac

groupAccessType1=""
case "$groupPermission1" in
   0)

     groupAccessType1="no permissions"                            
     ;;                                                           
   1)                                                             
     groupAccessType1="execute permission only"                   
     ;;                                                           
   2)                                                             
     groupAccessType1="write permission only"                     
     ;;                                                           
   3)                                                             
     groupAccessType1="write and execute permissions"             
     ;;                                                           
   4)                                                             
     groupAccessType1="read permssion only"                       
     ;;                                                           
   5)                                                             
     groupAccessType1="read and execute permissions"              
     ;;                                                           
   6)                                                             
     groupAccessType1="read and write permissions"                
     ;;                                                           
   7)                                                             
     groupAccessType1="read, write, and execute permissions"
     ;;
esac

othersAccessType1=""
case "$othersPermission1" in
   0)
     othersAccessType1="no permissions"
     ;;
   1)
     othersAccessType1="execute permission only"
     ;;
   2)
     othersAccessType1="write permission only"
     ;;
   3)
     othersAccessType1="write and execute permissions"
     ;;
   4)
     othersAccessType1="read permssion only"
     ;;
   5)
     othersAccessType1="read and execute permissions"
     ;;
   6)
     othersAccessType1="read and write permissions"
     ;;
   7)
     othersAccessType1="read, write, and execute permissions"
     ;;
esac

ownerAccessType2=""
case "$ownerPermission2" in
  0)
    ownerAccessType2="no permissions"
    ;;
  1)
    ownerAccessType2="execute permission only"
    ;;
  2)
    ownerAccessType2="write permission only"
    ;;
  3)
    ownerAccessType2="write and execute permissions"
    ;;
  4)
    ownerAccessType2="read permssion only"
    ;;
  5)
    ownerAccessType2="read and execute permissions"
    ;;
  6)
    ownerAccessType2="read and write permissions"
    ;;
  7)
    ownerAccessType2="read, write, and execute permissions"
    ;;
esac

groupAccessType2=""
case "$groupPermission2" in
   0)
     groupAccessType2="no permissions"                            
     ;;                                                           
   1)                                                             
     groupAccessType2="execute permission only"                   
     ;;                                                           
   2)                                                             
     groupAccessType2="write permission only"                     
     ;;                                                           
   3)                                                             
     groupAccessType2="write and execute permissions"             
     ;;                                                           
   4)                                                             
     groupAccessType2="read permssion only"                       
     ;;                                                           
   5)                                                             
     groupAccessType2="read and execute permissions"              
     ;;                                                           
   6)                                                             
     groupAccessType2="read and write permissions"                
     ;;                                                           
   7)                                                             
     groupAccessType2="read, write, and execute permissions"
     ;;
esac

othersAccessType2=""
case "$othersPermission2" in
   0)
     othersAccessType2="no permissions"
     ;;
   1)
     othersAccessType2="execute permission only"
     ;;
   2)
     othersAccessType2="write permission only"
     ;;
   3)
     othersAccessType2="write and execute permissions"
     ;;
   4)
     othersAccessType2="read permssion only"
     ;;
   5)
     othersAccessType2="read and execute permissions"
     ;;
   6)
     othersAccessType2="read and write permissions"
     ;;
   7)
     othersAccessType2="read, write, and execute permissions"
     ;;
esac

# Guess what the contents of the file are
guessContents1=$(file $file1 | gawk '{$1=""; print}')
guessContents2=$(file $file2 | gawk '{$1=""; print}')

# Display information on both files to standard output
echo
echo Information for the first file:
echo The file is named $fileName1
echo The file size is $fileSize1 bytes.

# If word count is 1, echo word
if [ $wordCount1 -eq "1" ]
  then
    echo The file has $wordCount1 total word.
  else
    echo The file has $wordCount1 total words.
fi

echo The owner has $ownerAccessType1 on the file.
echo The group has $groupAccessType1 on the file.
echo Others have $othersAccessType1 on the file.
echo The file contents are most likely: $guessContents1
echo
echo Information for the second file:
echo The file is named $fileName2
echo The file size is $fileSize2 bytes.

# If word count is 1, echo word
if [ $wordCount2 -eq "1" ]
  then    moreWordsFile="$fileName1 and $fileName2 have the same word count."
    echo The file has $wordCount2 total word.
  else
    echo The file has $wordCount2 total words.
fi

echo The owner has $ownerAccessType2 on the file.
echo The group has $groupAccessType2 on the file.
echo Others have $othersAccessType2 on the file.
echo The file contents are most likely: $guessContents2

#--------------------------------------------------------------------#

# Determine which file is larger and by how many bytes
fileSizeDifference=0
largerFile=""
if [ $fileSize1 -gt $fileSize2 ]
  then
    largerFile="$fileName1 is larger than $fileName2" \
    fileSizeDifference=$((fileSize1 - fileSize2))
  elif [ $fileSize2 -gt $fileSize1 ]
  then
    largerFile="$fileName2 is larger than $fileName1" \
    fileSizeDifference=$((fileSize2 - fileSize1))
  else
    largerFile="$fileName1 and $fileName2 have an identical file size"
fi

# Determine which file has more words and by how many words
wordCountDifference=0
moreWordsFile=""
if [ $wordCount1 -gt $wordCount2 ]
  then
    moreWordsFile="$fileName1 has more words than $fileName2" \
    wordCountDifference=$((wordCount1 - wordCount2))
  elif [ $wordCount2 -gt $wordCount1 ]
  then
    moreWordsFile="$fileName2 has more words than $fileName1" \
    wordCountDifference=$((wordCount2 - wordCount1))
  else
    moreWordsFile="$fileName1 and $fileName2 have the same amount of words."
fi

# Display the comparisons of both files to standard output
echo
echo ---------------------------------------------------------------
echo
echo When comparing the file sizes:
echo $largerFile

# If byte difference is 1, echo byte
if [ $fileSizeDifference -eq "1" ]
  then
    echo By: $fileSizeDifference byte
  else
    echo By: $fileSizeDifference bytes
fi

echo

echo When comparing the word count of the files:
echo $moreWordsFile

# If there are no words do not print the difference
if [ $wordCountDifference -gt "0" ]
  then    
    echo There is a $wordCountDifference word difference
fi

echo

