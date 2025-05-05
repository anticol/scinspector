# scinspector
  Scinspector (Source Code Inspector) is script for searching chosen mistakes in source codes written in C and C++. <br>
  
  This script is one of the result of my bachelor thesis - Analyzing most common programming mistakes of C/C++ students<br>

  For more information about controlling mistakes and this script read thesis (https://is.muni.cz/th/433826/fi_b/)<br>

 
  INSTALATION
  ----------------------------------------------------------------------------------------
  You need to install command line version of:<br>

  o Go Lang - https://golang.org/doc/install<br>
  o Google Code Search - https://github.com/google/codesearch<br>
  o Cppcheck - http://cppcheck.sourceforge.net/<br>


  INPUT
  ----------------------------------------------------------------------------------------
  General format:<br>

  ./scinpector -c|-cpp directory [options...]<br>

  o switch -c resp. -cpp for control of source codes in C resp. C++<br>
  o directory - input directory with all source codes<br>
  o options - optional switches (more information in MANPAGE)<br>

  Input directory must have this structure:
<p align="center">
  <img src="https://raw.githubusercontent.com/anticol/scinspector/master/readme_images/directory_structure.png" width="610" height="280"/>
</p>

  In first level, there are directories of students (001,002), second level contains 
  directories with all homework (hw01,hw02,hw01), third level contains directories with 
  all submitted homework (221005_nanecisto,135004_naostro,...), these directories contain
  files with controlled source codes.

  Name of the directory with submitted homework must be in format 'id_naostro' resp.
  'id_nanecisto'

  For fast control of your source codes create directory with this path:
  directory/yourName/projectName/firstVersion_naostro/

  Insert your source codes into directory firstVersion_naostro.


  OUTPUT
  ----------------------------------------------------------------------------------------
  Output of this script consists of 2 files.

  o results.txt - contains: <br>
    • Controlling  semester<br>
    • Mark of the mistake <br>
    • Mode of submitted homework<br>
    • Mark of the student<br>
    • Mark of the homework<br>
    • Name of the directory with submitted homework<br>
    • Name of the file containing mistake<br>
    • Number of line, where the mistake occurred<br><br>
  o results_stats.txt - contains:<br>
    • Mark of the mistake<br>
    • Total number of occurrences of the mistake.<br>


  Information are from the absolute path of file where mistake occurred, due to this fact
  structure of input directory is important.


  Example of output file - results.txt
  <p align="center">
  <img src="https://raw.githubusercontent.com/anticol/scinspector/master/readme_images/results.png" width="450" height="150"/>
</p>


  Example of output file - results_stats.txt
   <p align="center">
  <img src="https://raw.githubusercontent.com/anticol/scinspector/master/readme_images/stats.png" width="220" height="250"/>
</p>             


  MANPAGE
  ----------------------------------------------------------------------------------------
  For manual page with all optional possibilities use this command:
  ./scinpector --help
  
   <p align="center">
  <img src="https://raw.githubusercontent.com/anticol/scinspector/master/readme_images/manpage.png" width="500" height="390"/>
</p>    



  USAGE EXAMPLES
  ----------------------------------------------------------------------------------------

  Control of all homework submitted in 'nanecito' mode in C++ of student 003, of homework hw03 in directory pb161_spring17<br>
  ./scinspector -cpp pb161_spring17 -s=003 -hw=hw03 -n

  Control of all homework  submitted in last 'naostro' mode in C++ of student 003 in directory pb071_spring17<br>
  ./scinspector -c pb071_spring17 -s=003 -lo

  Control of all homework  submitted in 'naostro' mode in C++ of all students, of homework hw04 in directory pb161_autumn17, 
  values in output file will be separated by dash<br>
  ./scinspector -cpp pb161_autumn17 -hw=hw04 -d='-' -o

  Control of all submitted homework in C, of all students in directory pb071_autumn17<br>
  ./scinspector -c pb071_autumn17 


  Output form of scinspector:
  
   
   <p align="center">
  <img src="https://raw.githubusercontent.com/anticol/scinspector/master/readme_images/script_example.png" width="400" height="280"/>
</p>    

  LICENSE
  ----------------------------------------------------------------------------------------

  Copyright [2017] [David Horov]

  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


  CONTACT
  ----------------------------------------------------------------------------------------
  Your can contact author using email - horov.david@gmail.com


Other projects: 
- Free utility tools: https://freeutilitytools.com/
