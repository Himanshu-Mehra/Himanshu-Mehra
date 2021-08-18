- 👋 Hi, I’m @Himanshu-Mehra
- 👀 I’m interested in dnif...
- 🌱 I’m currently learning ...
- 💞️ I’m looking to collaborate on ...
- 📫 How to reach me ...


_fetch * from event where $Duration=8h group count_unique $UserAgent limit 1000
>>_checkif lookup common_ttps known_browsers join $ScopeID=$ScopeID str_compare $UserAgent eq $Known_Browser exclude
>>_checkif lookup common_ttps known_non-browsers join $ScopeID=$ScopeID str_compare $UserAgent eq $Known_Nonbrowser exclude
>>_store in_disk common_ttps unknown_agents stack_replace

"$ top -bn1 | grep ""Cpu(s)"" | \
           sed ""s/.*, *\([0-9.]*\)%* id.*/\1/"" | \
           awk '{print 100 - $1""%""}'"
           
<!---
Himanshu-Mehra/Himanshu-Mehra is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
