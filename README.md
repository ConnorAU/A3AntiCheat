# A3AntiCheat
Script based anticheat for Arma 3.

This anticheat has been active on a single life server (avg 70 players during peak time) since July 2017. In the 22 months since, it has banned over 900 malicous accounts. It runs most of its checks during the client init sequence and then spawns a few threads for monitoring purposes, which has negligible impact on client performance.  

I have removed all references to that server to keep them a little safer because they do still use the anticheat (I think) and haven't included the server extension that ran along side this either. It was only used for checking playerids against the infistar & wskoth ban lists, as well as placing bans through the battlemetrics API.  

This is not a plug-and-play anticheat. My intention in releasing it is so anyone can read through what I consider to be a very competent anticheat, learn something from it and apply that knowledge to their own custom anticheat.

It is important to note any script based anticheat will never be able to replace battleye. This is a second layer of defense for catching those who slip through the cracks.

I am walking away from arma so I can properly focus on getting my life together, so this is kind of a farewell gift I guess. Considering how effective it has been, I'd say it is easily the best work I've done in arma.

# Detections
Noteworthy detection capabilities:
- Terminated anticheat threads
- Hijacked anticheat threads
- Blocked anticheat initialization
- Alternate accounts
- InfiStar global bans
- WSKOTH global bans
- Spoofed playerid
- Unknown addon patches
- Modified addon patch source
- Modified display eventhandlers
- Unknown code variables
- Unknown function class
- Modified function class source
- Modified function file path
- Modified function character count
- Modified display controls
- Unauthorised eventhandlers added to player and some displays

Full list of detection descriptions can be found [here](https://github.com/ConnorAU/A3AntiCheat/blob/master/s_flagged.sqf#L43-L181).

# Links
- [Discord](https://discord.gg/DMkxetD)
- [License](https://github.com/ConnorAU/A3AntiCheat/blob/master/LICENSE)
