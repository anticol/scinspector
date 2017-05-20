#!/bin/bash

LANGUAGE=$1

if [ $LANGUAGE = "-c" ]
then

declare -a csearchRegexsArray=(
	#0
	'\bauto\b'
	
	#1
	'fflush\(\s*stdin\s*\)'
	
	#3	
	'goto'
	
	#4
	'\bgets\('
	
	#5
	'while\([a-zA-Z0-9()=<>\[\]\s]*\);[\s]*{'
	
	#6
	'(char|int|bool|float|double)\b\s*[a-zA-Z0-9_]*\s*=\s*NULL;');

declare -a csearchErrorsArray=(
	#0
	'usingKeywordAuto'
	
	#1
	'usingFflush_stdin'
	
	#2         
	'usingGoto'
	
	#3
	'usingGets'
	
	#4
	'wrongUsageOfWhile'
	
	#5
	'nullInPrimitveVar');
	

################################################################################################################

declare -a grepRegexsArray=(
	#0
	'malloc\((?!.*sizeof\().*\);'
	
	#1  
	'fopen\([\s]*"[\sa-zA-Z_:\\\/.\]\*]*"[\s]*,[\s]*"(([rwa][^+].*)|([rwa][+].+)|([^rwa].*)|[\s]*)[\s]*\"[\s]*\);'
	
	#2
	'\?\s*(true|false)\s*:\s*(true|false)'
	
	#3
	'\(\s*\*\s*[\w]*\s*\)\s*\.\s*[\w]*'
	
	#4
	'for\s*\(\s*;.*(==|!=|>=|<=|<|>)+.*;\s*\)\s*{'
	
	#5
	'for\s*\(\s*;\s*;\s*\)'
	
	#6
	'int\s*[\w]*\s*=\s*[\d]*\.[\d]+\s*;'
	
	#7
	'\b([\w]*)\s*=\s*realloc\s*\(\s*\1\s*,\s*[\w]*\s*\)\s*;');

declare -a grepErrorsArray=(
	#0
	'mallocWithoutSizeof'
	
	#1
	'wrongFopenArgument'
	
	#2
	'redundantTernaryOperator'
	
	#3
	'notUsingArrowOperator'
	
	#4
	'forInseadOfWhile'	

	#5          
	'infiniteForLoop'
	
	#6
	'decimalSavedToInt'
	
	#7
	'wrongUsageOfRealloc');
	

################################################################################################################

declare -a cppcheckErrorsArray=(
	'arrayIndexOutOfBounds'
	'uninitvar'
	'negativeIndex'
	'uninitStructMember'
	'invalidScanfFormatWidth'
	'checkCastIntToCharAndBack');

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

else

declare -a csearchRegexsArray=(
	#0
	'\bNULL\b'
	
	#1
	'\?\s*(true|false)\s*:\s*(true|false)'
	
	#2
	'for\s*\(\s*;.*(==|!=|>=|<=|<|>)+.*;\s*\)\s*{'
	
	#3
	'for\s*\(\s*;\s*;\s*\)'
	
	#4      	
	'malloc\s*\(|realloc\s*\(|calloc\s*\(|free\s*\('
	
	#5
	'(getchar\s*\()|(putchar\s*\()|(gets\s*\()|(puts\s*\()|(scanf\s*\()|(printf\s*\()'
	
	#6
	'\bconst_cast\b\s*<|\breinterpret_cast\b\s*<'
	
	#7
	'char\s*\*\w+\s*\='
	
	#8
	'const\s*(int|char|bool|float|double|long)\s*&\s*\w*\s*='
	
	#9
	'goto'

	#10         
	'fflush\(\s*stdin\s*\)'
	
	#11
	'while\([a-zA-Z0-9()=<>\[\]\s]*\);[\s]*{');

declare -a csearchErrorsArray=(
	#0
	'usingNull'
	
	#1
	'redundantTernaryOperator'
	
	#2
	'forInseadOfWhile'
	
	#3
	'infiniteForLoop'
	
	#4		
	'usingMemoryFuncFromC'
	
	#5
	'usingIOFuncFromC'
	
	#6
	'usingReintOrConstCast'
	
	#7
	'usingCharPointer'
	
	#8	
	'constRefPrimitiveType'
	
	#9	
	'usingGoto'
	
	#10
	'usingFflush_stdin'
	
	#11
	'wrongUsageOfWhile');

################################################################################################################

declare -a grepRegexsArray=(
	
	#0
	'\(\s*\*\s*[\w]*\s*\)\s*\.\s*[\w]*'
	
	#1
	'int\s*[\w]*\s*=\s*[\d]*\.[\d]+\s*;'
	
	#2
	'([0-9]+\.[0-9]+\s*(==|!=))|((==|!=)\s*[0-9]+\.[0-9]+\s*)'
	
	#3
	'#DEFINE'
	
	#4
	'catch\s*\(\s*\.\.\.\s*\)'
	
	#5
	'catch\([\w\s&]*\)\s*\{\s*\}'
	
	#6
	"throw\s*((\-*\d*)|true|false|\"[\s\w]*\"|(\'[\w\s]\'))\s*;"
	
	#7
	'catch\s*\((?!.*&).*\)\s*');

declare -a grepErrorsArray=(
	
	#0
	'notUsingArrowOperator'
	
	#1		
	'decimalSavedToInt'
	
	#2
	'wrongFloatingCmp'
	
	#3
	'usingDefine'
	
	#4
	'undefinedException'
	
	#5
	'emptyCatchBlock'
	
	#6
	'throwingPrimitiveType'
	
	#7
	'notCatchingReference');

################################################################################################################

declare -a cppcheckErrorsArray=(
	'uninitvar'
	'stlOutOfBounds');

fi

