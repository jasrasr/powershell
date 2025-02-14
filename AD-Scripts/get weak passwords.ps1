install-module dsinternals
import-module dsinternals
$weakpasswordsfilepath="c:\temp\passwords.txt"//-
$server="cledc1"
get-adreplaccount -samaccount jason.lamb -server $server
 -weakpasswordsfilepath $weakpasswordsfilepath -fullreport -verbos