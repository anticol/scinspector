#Copyright [2017] [David Horov]

#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License. 

#!/bin/bash

#Name of the script
SCRIPT_NAME=$(basename "$0")

#Function which prints man page of script
function usage(){
man -l manscinspector.1
}


#If no arguments entered
if [ $# -lt 1 ]
then
echo "No argument entered or missing argument !"
echo "Usage: '"$SCRIPT_NAME" --help' for more information."        # unknown option
exit 1
fi

#If first argument is help
if [ $1 = "--help" ]
then
usage
exit 1
fi

#If not enough arguments are entered
if [ $# -lt 2 ]
then
echo "No argument entered or missing argument !"
echo "Usage: '"$SCRIPT_NAME" --help' for more information."        # unknown option
exit 1
fi

#Checking if first argument is correct
if [ $1 != "-cpp" ]
then 
if [ $1 != "-c" ]
then
echo "argument "$1" is not valid option"
exit 1
fi 
fi

#Checking if second argument is a directory
if ! [[ -d ${2} ]] 
then
echo "argument "$2" is not a directory"
exit 1
fi


#Preparing global environment
HW=*
STUDENT=*
TYPE=*
LANGUAGE=$1
DIRECTORY=$2
LAST_NAOSTRO="false"
DELIMETER=","


#Parsing optional arguments and saving results to main variables
for i in "${@:3}"
do
case $i in
    --help*)
     usage
     exit 1
    ;;  
    -o*|--naostro*)
    TYPE="*naostro*"
    shift # past argument=value
    ;;
    -lo*|--lastnaostro*)
    LAST_NAOSTRO="true"
    TYPE="*naostro*"
    shift # past argument=value
    ;;

    -n*|--nanecisto*)
    TYPE="*nanecisto*"
    shift # past argument=value
    ;;
    -h=*|--hw=*)
    HW="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--student=*)
    STUDENT="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--delimiter=*)
    DELIMETER="${i#*=}"
    shift # past argument=value
    ;;
    *)
    echo "Invalid argument"
    echo "Usage: '"$SCRIPT_NAME" --help' for more information."        # unknown option
    exit 1
    ;;
esac
done

#Saving the start time
START_TIME=$SECONDS

#Informing what is going to be checked
if [ "$HW" = "*" ]; then echo "Checking all homeworks"; else echo "Checking homework: "$HW;  fi
if [ "$STUDENT" = "*" ]; then echo "Checking all students"; else echo "Checking student: "$STUDENT; fi
if [ "$TYPE" == "*naostro*" ]; then echo "Checking homeworks submitted in \"naostro\" mode"; 
elif [ "$TYPE" == "*nanecisto*" ]; then  echo "Checking homeworks submitted in \"nanecisto\" mode"; 
else echo "Checking homeworks submitted in \"naostro\" and \"nanecisto\" mode"; fi
echo "Checking homeworks in directory: "$DIRECTORY


#Clean the environment from last run of the script
./cindex -reset
rm -f results.txt checking_files.txt result_last_naostro.txt  csearch-results.txt cppcheck-results.txt cppcheck.txt grepcheck-results.txt cppcheck-filtered.txt grepout.txt cppcheckout.txt indexedFiles.txt results_stats.txt list_of_checking_files.txt results_pom.txt


#Prepare variables from external file
chmod +x variables.sh
if [ $LANGUAGE == "-c" ]
then
. ./variables.sh -c
else
. ./variables.sh -cpp
fi

#Choose last "naostro" homework if required
if [ $LAST_NAOSTRO == "true" ]
then
for f in $PWD/$DIRECTORY/$STUDENT/$HW
do
ls $f/* -d  | sort --reverse | head -n 1 | grep naostro >> checking_files.txt
done

#Choose hw specified in optional argument( * by default)
else
#Find last 'naostro" homework  and put the path of the directory to the file
for f in $PWD/$DIRECTORY/$STUDENT/$HW/$TYPE
do
ls $f -d   >> checking_files.txt
done

fi

for i in $(cat checking_files.txt)
do
ls $i/*  >> list_of_checking_files.txt

done

cat list_of_checking_files.txt  | grep "\.c" > checking_files2.txt


#Change first number to '2' if you want to turn off running cindex and csearch
if [ 0 -lt 1 ]
then

#Index all found files
echo "indexing files..."
./cindex $(cat checking_files2.txt) &> indexedFiles.txt
echo -e "\e[32mindexing has been done"
echo -e "\e[39m"


#Run csearch control
echo "running csearch..."
counter=0

for regex in "${csearchRegexsArray[@]}"
do

result=$(./csearch -n "$regex")

array=()
while read -r line; do
   array+=("$line")
done <<< "$result"

#Parse found information and save to output file
for i in "${array[@]}"
do

pathWithLine=$(echo $i |  tr " " "\n" | head -n 1)
pathWithLineRow=$(echo $pathWithLine | tr ":" "\n" )
path=$(echo $pathWithLineRow | tr " " "\n" | sed -n "1p")
path_array=$(echo $path | tr "/" "\n")
hw_dir=$(echo "$path_array" | tail -2 | head -1 )
student_num=$(echo "$path_array" | tail -4 | head -1)
hw_num=$(echo "$path_array" | tail -3 | head -1)
line=$(echo $pathWithLineRow | tr " " "\n" | sed -n "2p")
typeAndName=$(echo $path | tr "_" "\n" | tail -n 1)
type=$(echo $typeAndName | tr  "/" "\n" | head -n -1)
fileName=$(echo $typeAndName | tr "/" "\n" | tail -n 1)
mistake=${csearchErrorsArray[$counter]}


if [ "$i" != "" ]; then echo -e $mistake$DELIMETER$type$DELIMETER$student_num$DELIMETER$hw_num$DELIMETER$hw_dir$DELIMETER$fileName$DELIMETER$line >> csearch-results.txt; fi

done
counter=$((counter+1))

done

echo -e "\e[32mcsearch has finished"
echo -e "\e[39m"

fi


#Change first number to '2' if you want to turn off running cppcheck
if [ 0 -lt 1 ]
then

#Run cpcheck and filter desired mistakes
echo "running cppcheck..."

cppcheck -q --template='{file}\t{line}\t{id}' --file-list=checking_files.txt &> cppcheckout.txt


for regex in "${cppcheckErrorsArray[@]}"
do
cat cppcheckout.txt | grep "$regex" >> cppcheck-filtered.txt
done

while read line; do

#Parse found information and save to output file
path=$(echo $line | tr " " "\n" | sed -n "1p")
path_array=$(echo $path | tr "/" "\n")
hw_dir=$(echo "$path_array" | tail -2 | head -1 )
student_num=$(echo "$path_array" | tail -4 | head -1)
hw_num=$(echo "$path_array" | tail -3 | head -1)
lineNum=$(echo $line | tr " " "\n" | sed -n "2p")
typeAndName=$(echo $path | tr "_" "\n" | tail -n 1)
type=$(echo $typeAndName | tr  "/" "\n" | head -n -1)
fileName=$(echo $typeAndName | tr "/" "\n" | tail -n 1)
mistake=$(echo $line | tr " " "\n" | sed -n "3p")

echo -e $mistake$DELIMETER$type$DELIMETER$student_num$DELIMETER$hw_num$DELIMETER$hw_dir$DELIMETER$fileName$DELIMETER$lineNum >> cppcheck-results.txt

done < cppcheck-filtered.txt


echo -e "\e[32mcppcheck has finished"
echo -e "\e[39m"

fi


#Change first number to '2' if you want to turn off running grep commands
if [ 0 -lt 1 ]
then

#run grep search
echo "running grep commands..."
while read i; do
if [[ $LANGUAGE == "-c" ]]
then

grep -Prni "${grepRegexsArray[0]}" $i |grep -v 'char' | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[0]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[1]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[1]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[2]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[2]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[3]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[3]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[4]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[4]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[5]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[5]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[6]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[6]},/" >> grepout.txt
grep -Prni "${grepRegexsArray[7]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[7]},/" >> grepout.txt

elif [ "$LANGUAGE" == "-cpp" ]
then
grep -Prni --include="*.cpp" "${grepRegexsArray[0]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[0]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[1]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[1]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[2]}" $i | cut -d ' ' -f 1 | sed -e "s/^/${grepErrorsArray[2]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[3]}" $i | cut -d ' ' -f 1   | sed -e "s/^/${grepErrorsArray[3]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[4]}" $i | cut -d ' ' -f 1   | sed -e "s/^/${grepErrorsArray[4]},/" >> grepout.txt
grep -Prniz --include="*.cpp" "${grepRegexsArray[5]}" $i | head -n 1 | cut -d ' ' -f 1   | sed -e "s/^/${grepErrorsArray[5]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[6]}" $i | cut -d ' ' -f 1   | sed -e "s/^/${grepErrorsArray[6]},/" >> grepout.txt
grep -Prni --include="*.cpp" "${grepRegexsArray[7]}" $i | grep -v '\.\.\.' | cut -d ' ' -f 1   | sed -e "s/^/${grepErrorsArray[7]},/" >> grepout.txt
else
echo "problem"
fi
done <checking_files.txt



while read line; do

#Parse found information and save to output file
path=$(echo $line | tr "," "\n" | sed -n "2p")
path_arrays=$(echo $path | tr "/" ",")
path_array=$(echo $path_arrays | tr "," "\n" | tail -n 4)
student_num=$(echo $path_array |  cut -d' ' -f1)
hw_dir=$(echo $path_array |  cut -d' ' -f3)
hw_num=$(echo $path_array |  cut -d' ' -f2)
fileAndName=$(echo $path_array |  cut -d' ' -f4)
lineNum=$(echo $fileAndName | cut -d':' -f2)
fileName=$(echo $fileAndName  | cut -d':' -f1)
type=$(echo $hw_dir | cut -d'_' -f4)
mistake=$(echo $line | tr "," "\n" | sed -n "1p")


if [ -n "${mistake/[ ]*\n/}" ] && [ -n "${type/[ ]*\n/}" ] && [ -n "${student_num/[ ]*\n/}" ] && [ -n "${hw_num/[ ]*\n/}" ]&& [ -n "${hw_dir/[ ]*\n/}" ] && [ -n "${fileName/[ ]*\n/}" ] && [ -n "${lineNum/[ ]*\n/}" ] && [ -n "${mistake/[ ]*\n/}" ]; then
echo -e $mistake$DELIMETER$type$DELIMETER$student_num$DELIMETER$hw_num$DELIMETER$hw_dir$DELIMETER$fileName$DELIMETER$lineNum  >> grepcheck-results.txt
fi
done < grepout.txt

echo -e "\e[32mgrep commands have finished"
echo -e "\e[39m"

fi

#Prepare output files
touch results_pom.txt
touch results.txt
touch results_stats.txt

#Save found mistaked to final output file
if [ -f grepcheck-results.txt ]; then
cat grepcheck-results.txt  | grep -v inary >> results_pom.txt
fi

if [ -f cppcheck-results.txt ]; then
cat cppcheck-results.txt >> results_pom.txt
fi

if [ -f csearch-results.txt  ]; then
cat csearch-results.txt  >> results_pom.txt
fi

subjectAndSemester=$(echo $DIRECTORY | cut -d'/' -f1)

#Add mark of the semester into beginning of each line
while read line
do
echo $subjectAndSemester$DELIMETER$line >> results.txt
done < results_pom.txt


#Create results_stats file with statistics about mistakes
totalCounter=0
for mistake in "${cppcheckErrorsArray[@]}"
do
counter=$(cat results.txt | grep "\b$mistake\b" | wc -l)
 (( totalCounter+= counter ))

printf "%-25s \t %5s\n" $mistake $counter >> results_stats2.txt

done

for mistake in "${csearchErrorsArray[@]}"
do
counter2=$(cat results.txt | grep "\b$mistake\b" | wc -l)
 (( totalCounter+= counter2 ))

printf "%-25s \t %5s\n" $mistake $counter2>> results_stats2.txt
done

for mistake in "${grepErrorsArray[@]}"
do

counter3=$(cat results.txt | grep "\b$mistake\b" | wc -l)
 (( totalCounter+= counter3 ))

printf "%-25s \t %5s\n" $mistake $counter3>> results_stats2.txt
done

cat results_stats2.txt | sort -k2 -n -r > results_stats.txt

if [ $totalCounter == 0 ]
then
echo -e "\e[42mNo mistakes found"
else
echo -e "\e[41mTotal number of mistakes:$totalCounter"
fi
echo -e "\e[49m"

 
rm -f checking_files.txt result_last_naostro.txt csearch-results.txt cppcheck-results.txt cppcheck.txt grepcheck-results.txt cppcheck-filtered.txt grepout.txt cppcheckout.txt indexedFiles.txt  list_of_checking_files.txt results_pom.txt results_stats2.txt

#Inform user about time elapsed
ELAPSED_TIME=$(($SECONDS - $START_TIME))

echo -e "\e[34mTotal time of execution: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"
echo -e "\e[39m"


