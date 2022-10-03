--[[

	Hello magnificient user!
	
	This is the Time Formatting Module (TFM) which is the first module by me. I do plan to start a series of modules, so this is 
	part of the "Crazy Cool Carbyne Collection" (aka Quad-C) (the name of the series). As a fun fact, this module was released on April
	Fool's Day!
	
	Anyways, here is the API (it's VERY simple because this is my first module):
	__________________________________________________________________________________________________________________________________________
	
	tfm:Convert(integer Seconds, string Form, bool AddZero)

	Seconds [MANDATORY] --- provide an integer either as a string or as a number (i.e. 2 or "2", NOT 2.1 or "2.1")
	
	Form [OPTIONAL] --- provide a string that decides how the given seconds will be formatted
	
						Default Form (aka Colon Form):
							* displays in the format xx:xx:xx
							* acceptable strings - "default" or "colon" in any case (i.e. uppercase is all fine)
							* maximum unit is hour, the number displayed can be infinitely large
							* this is the form used when you do not provide a string for this parameter
						Short Form: 
							* displays in the format xx yr(s) xx mon xx d xx hr(s) xx min(s) xx sec
							* acceptable strings - "short" in any case
							* maximum unit is year
							* AddZero does NOT apply whatsoever (i.e. this is not possible: 10 min 09 sec)
							* adjusts to being plural when need (i.e. minutes when it's greater than 1)
								* ONLY yr, hr, min change (please send a request if you want this to be changed)
						Full Form:
							* displays in the format xx year(s) xx month(s) xx day(s) xx hour(s) xx minute(s) xx second(s)
							* acceptable strings - "full" in any case
							* maximum unit is year
							* AddZero does NOT apply whatsoever
							* ajusts to being plural when needed (with ALL units)
							
	AddZero [OPTIONAL] --- provide a boolean value whether you would like to add a zero in front of the biggest unit, for example
						   setting this to true will display 3720 as 01:02:00 as opposed to false where it's 1:02:00
								* by default (if this parameter is not given), this is false
							
						   ***Currently only applicabale to DEFAULT FORM!***

	__________________________________________________________________________________________________________________________________________

	NOTE: The order of the parameters matters. If you want to set AddZero, then you must provide Form before that even though it is optional.

	That is it for now, as you can see, this module is very simple right now. If you want to:
		* request a new feature
		* change an exisiting one or
		* give a suggestion on how to furthur optimize the module's code (I am not the best scripter, but I am willing to learn!),
	You can contact me via a PM on the DevForum.
	
	But, if you want to make minor adjustments that you think will only benefit you, then you are welcome to edit to your desire the script below.
	Have a great time unser!
	
]]


local l = string.lower
local min, hr, d, mon, yr, max = "minute", "hour", "day", "month", "year", "max"
local secsInMonth, secsInYear = 2592000, 30672000
local default, colon, short, full = "default", "colon", "short", "full"
local a = {second = " sec ", minute = " min ", hour = " hr ", day = " d ", month = " mon ", year = " yr "}
local ap = {second = " sec ", minute = " mins ", hour = " hrs ", day = " d ", month = " mon ", year = " yrs "}
local f = {second = " second ", minute = " minute ", hour = " hour ", day = " day ", month = " month ", year = " year "}
local fp = {second = " seconds ", minute = " minutes ", hour = " hours ", day = " days ", month = " months ", year = " years "}

local function quickVar(secs, factor)
			
	return (secs - (secs % factor)) / factor
			
end

local function convert(secs, Form, addZero)
	
	local form
		
	if Form ~= nil then
		
		form = l(Form)
		
	else
		
		form = nil
		
	end
	
	if form == default or form == colon or form == nil then
		
		local remainderMin, remainderSecond, hour, minute = 0, 0, 0, 0

		if secs >= 3600 then
			
			remainderMin = secs % 3600
			remainderSecond = remainderMin % 60
			hour = quickVar(secs, 3600)
			minute = quickVar(remainderMin, 60)
			
		elseif secs < 3600 and secs >= 60 then
			
			remainderSecond = secs % 60
			minute = quickVar(secs, 60)
			
		else
			
			remainderSecond = secs
			minute = 0
			
		end
		
		if hour < 10 and addZero == true then
			
			hour = "0" .. hour
			
		end
		
		if (minute < 10 and secs >= 3600) or (minute < 10 and secs < 3600 and addZero == true) then
			
			minute = "0" .. minute
					
		end
		
		if (remainderSecond < 10 and secs >= 60) then
			
			remainderSecond = "0" .. remainderSecond
			
		end
		
		if secs < 60 then
			
			return secs
		
		elseif secs < 3600 and secs >= 60 then
			
			return minute .. ":" .. remainderSecond
		
		elseif secs >= 3600 then
			
			return hour .. ":" .. minute .. ":" .. remainderSecond
			
		end
		
	elseif form ~= default or form ~= nil or form ~= colon then
		
		if addZero == true then
			
			warn("TFM: Zeros are only togglable for the default form!")
			
		end
		
		local remainderYear, remainderMonth, remainderDay, remainderHour, remainderMin,remainderSecond, year, month, day, hour, minute = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		local displayMin, displaySec, displayHr, displayDay, displayMon, displayYr
		
		if secs < 60 then
			
			if form == short then
				
				if secs > 1 then displaySec = ap.second else displaySec = a.second end
				
			elseif form == full then
				
				if secs > 1 then displaySec = fp.second else displaySec = f.second end
				
			end
			
			return secs .. displaySec
		
		elseif secs < 3600 then
			
			remainderSecond = secs % 60
			minute = quickVar(secs, 60)
						
			if form == short then
								
				if minute > 1 then displayMin = ap.minute else displayMin = a.minute end
				if remainderSecond > 1 then displaySec = ap.second else displaySec = a.second end
						
			elseif form == full then
				
				if minute > 1 then displayMin = fp.minute else displayMin = f.minute end
				if remainderSecond > 1 then displaySec = fp.second else displaySec = f.second end
									
			end
			
			return minute .. displayMin .. remainderSecond .. displaySec

		elseif secs < 86400 and secs >= 3600 then
			
			remainderMin = secs % 3600
			remainderSecond = remainderMin % 60
			hour = quickVar(secs, 3600)
			minute = quickVar(remainderMin, 60)
			
			if form == short then
				
				if hour > 1 then displayHr = ap.hour else displayHr = a.hour end
				if minute > 1 then displayMin = ap.minute else displayMin = a.minute end
				if remainderSecond > 1 then displaySec = ap.second else displaySec = a.second end
							
			elseif form == full then
				
				if hour > 1 then displayHr = fp.hour else displayHr = f.hour end
				if minute > 1 then displayMin = fp.minute else displayMin = f.minute end
				if remainderSecond > 1 then displaySec = fp.second else displaySec = f.second end
				
			end
			
			return hour .. displayHr .. minute .. displayMin .. remainderSecond .. displaySec
			
		elseif secs < secsInMonth and secs >= 86400 then
			
			remainderHour = secs % 86400
			remainderMin = remainderHour % 3600
			remainderSecond = remainderMin % 60
			day = quickVar(secs, 86400)
			hour = quickVar(remainderHour, 3600)
			minute = quickVar(remainderMin, 60)
			
			if form == short then
				
				if day > 1 or day == 0 then displayDay = ap.day else displayDay = a.day end
				if hour > 1 or hour == 0 then displayHr = ap.hour else displayHr = a.hour end
				if minute > 1 or minute == 0 then displayMin = ap.minute else displayMin = a.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = ap.second else displaySec = a.second end
							
			elseif form == full then
				
				if day > 1 or day == 0 then displayDay = fp.day else displayDay = f.day end
				if hour > 1 or hour == 0 then displayHr = fp.hour else displayHr = f.hour end
				if minute > 1 or minute == 0 then displayMin = fp.minute else displayMin = f.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = fp.second else displaySec = f.second end
				
			end
			
			return day .. displayDay .. hour .. displayHr .. minute .. displayMin .. remainderSecond .. displaySec
			
		elseif secs < secsInYear and secs >= secsInMonth then
			
			remainderDay = secs % secsInMonth
			remainderHour = remainderDay % 86400
			remainderMin = remainderHour % 3600
			remainderSecond = remainderMin % 60
			month = quickVar(secs, secsInMonth)
			day = quickVar(remainderDay, 86400)
			hour = quickVar(remainderHour, 3600)
			minute = quickVar(remainderMin, 60)
			
			if form == short then
				
				if month > 1 or month == 0 then displayMon = ap.month else displayMon = a.month end
				if day > 1 or day == 0 then displayDay = ap.day else displayDay = a.day end
				if hour > 1 or hour == 0 then displayHr = ap.hour else displayHr = a.hour end
				if minute > 1 or minute == 0 then displayMin = ap.minute else displayMin = a.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = ap.second else displaySec = a.second end
							
			elseif form == full then
				
				if month > 1 or month == 0 then displayMon = fp.month else displayMon = f.month end
				if day > 1 or day == 0 then displayDay = fp.day else displayDay = f.day end
				if hour > 1 or hour == 0 then displayHr = fp.hour else displayHr = f.hour end
				if minute > 1 or minute == 0 then displayMin = fp.minute else displayMin = f.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = fp.second else displaySec = f.second end
				
			end
			
			return month .. displayMon .. day .. displayDay .. hour .. displayHr .. minute .. displayMin .. remainderSecond .. displaySec
		
		elseif secs >= secsInYear then
			
			remainderMonth = secs % secsInYear
			remainderDay = remainderMonth % secsInMonth
			remainderHour = remainderDay % 86400
			remainderMin = remainderHour % 3600
			remainderSecond = remainderMin % 60
			year = quickVar(secs, secsInYear)
			month = quickVar(remainderMonth, secsInMonth)
			day = quickVar(remainderDay, 86400)
			hour = quickVar(remainderHour, 3600)
			minute = quickVar(remainderMin, 60)
			
			if form == short then
				
				if year > 1 or year == 0 then displayYr = ap.year else displayYr = a.year end
				if month > 1 or month == 0 then displayMon = ap.month else displayMon = a.month end
				if day > 1 or day == 0 then displayDay = ap.day else displayDay = a.day end
				if hour > 1 or hour == 0 then displayHr = ap.hour else displayHr = a.hour end
				if minute > 1 or minute == 0 then displayMin = ap.minute else displayMin = a.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = ap.second else displaySec = a.second end
							
			elseif form == full then
				
				if year > 1 or year == 0 then displayYr = fp.year else displayYr = f.year end
				if month > 1 or month == 0 then displayMon = fp.month else displayMon = f.month end
				if day > 1 or day == 0 then displayDay = fp.day else displayDay = f.day end
				if hour > 1 or hour == 0 then displayHr = fp.hour else displayHr = f.hour end
				if minute > 1 or minute == 0 then displayMin = fp.minute else displayMin = f.minute end
				if remainderSecond > 1 or remainderSecond == 0 then displaySec = fp.second else displaySec = f.second end
				
			end
			
			return year .. displayYr .. month .. displayMon .. day .. displayDay .. hour .. displayHr .. minute .. displayMin .. remainderSecond .. displaySec
			
		end		
		
	end
	
end

local function checkSec(secs)
	
	if string.find(tostring(secs), "%p") ~= nil then
				
		error("TFM: Given seconds are not in integer form!")
		return false
		
	else
		
		return true
				
	end
	
end

local tfm = {}

	function tfm:Convert(secs, form, addZero)		
		
		if type(secs) == "number" then
			
			local passed = checkSec(secs)
			
			if passed == false then
				
				return
				
			end
			
		elseif type(secs) == "string" then
			
			if tonumber(secs) ~= nil then
				
				secs = tonumber(secs)
				local passed = checkSec(secs)
				
				if passed == true then
					
					secs = tonumber(secs)
					
				else
					
					return
					
				end
			
			else
				
				error("TFM: Given string for seconds is not valid. Please make sure the given string has a number in it!")
				return
				
			end
			
		else
			
			error("TFM: Given seconds are not even a number or a valid string!")
			return
		
		end
		
		return convert(secs, form, addZero)
		
	end

return tfm
