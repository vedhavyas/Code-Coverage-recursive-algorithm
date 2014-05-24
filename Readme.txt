Code Coverage Report Generation Tool

Package Contains : 	1.Config.txt
			2.changeFileNames.sh
			3.setPasswordLessLogin.sh
			4.getFilesFromRemote.sh
			5.captureFilesFromRemote.sh
			6.generateCoverageReport.sh

Config.txt - file through which all the deatils are acquired like source path, test name, test number, remote server etc...

Steps to generate Coverage report when Binary is compiled and executed on the same Server:
1. Include necessary deatils in Config.txt
2. compile the your code.
3. Execute and run the necessary test and stop the binary.
4. Now the source path will have both GCNO and GCDA files.
5. execute changeFileNames.sh script.
6. proceed with the your next test and repeat step 5 until all the test Scenarios are over.
7. Now execute generateCoverageReport.sh script and the voila!! report will be generated at the location which was mentioned in config.txt under coverageReportFolderPath section.


Steps to generate Coverage report when binary is executed on remote machie :
Steps 1,2,3 from above scenario should be implemented first.
4. execute setPasswordLessLogin.sh script which allows the other scripts to get GCDA files from rempte server without any password.
5. then execute getFilesFromRemote.sh scripts to get the GCDA files from remote server.
6. execute changeFileNames.sh script.
7. proceed with the your next test and repeat step 6 until all the test Scenarios are over.
8. Now execute generateCoverageReport.sh script and the voila!! report will be generated at the location which was mentioned in config.txt under coverageReportFolderPath section.

DO NOT SET ANY ENVIRONMENT VARIABLES MENTIONED IN THE PDF(http://ceg.mahindracomviva.com/twiki/pub/Main/SofEnggPractices/Code_Coverage_steps.pdf) IN ORDER FOR THE SCRIPTS TO RUN PROPERLY.
