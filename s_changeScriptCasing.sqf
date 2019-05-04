/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _changeScriptCasing = {
	_inString = false;
	_curString = "";
	_quotes = ["""","'"];

	_string = _this splitString '';
	_permitted = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
	{
		if (_x in _quotes) then {
			if !_inString then {
				_curString = _x;
				_inString = true;
			} else {
				if (_x == _curString) then {
					_inString = false;
				};
			};
		};
		if !_inString then {
			if (_x in _permitted) then {
				_string set [_forEachIndex,[toLower _x,toUpper _x] select (floor random 2)];	
			} else {
				if ((toarray _x) isequalto [9]) then {
					_string set [_forEachIndex,''];	
				};
			};
		};
	} foreach _string;

	_string joinString ''
};