#IfWinActive  ahk_class Turbine Device Class

GLOBAL window=Me									;;;;;;;;;;;;;;;;;;;;;;;;;;

F7::
sendmode play
ahk_class = Turbine Device Class

WinGet, PID, PID, %window%
GLOBAL HWND := DllCall("OpenProcess", "Uint", 0x1F0FFF, "int", 0, "int", PID)
GLOBAL none="none"
GLOBAL delay=1000
GLOBAL wx
GLOBAL wy

GLOBAL rundelay=150									;;;;;;;;;;;;;;;;;;;;;;;;
GLOBAL level=24										;;;;;;;;;;;;;;;;;;
GLOBAL stat24="statdex.bmp"								;;;;;;;;;;;;;;;;;;;;;
GLOBAL stat28="statdex.bmp"								;;;;;;;;;;;;;;;;;;;;;;
GLOBAL feat21="featgreatdexterity.bmp"							;;;;;;;;;;;;;;;;;;;;;;
GLOBAL feat24="featgreatdexterity.bmp"							;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GLOBAL feat26="featholystrike.bmp"							;;;;;;;;;;;;;;;;;;;;;;;;;;;
GLOBAL feat27="featgreatdexterity.bmp"							;;;;;;;;;;;;;;;;;;;;;;
GLOBAL feat28="feattough.bmp"								;;;;;;;;;;;;;;;;;;;;;;;;
diff=normal.bmp										;сложность, elite.bmp, hard.bmp, norm.bmp
monkrecall=0										;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x015ACF04, "Uint*", hpointer, "Uint", 4, "Uint *", 0)
GLOBAL hpointer:=hpointer+0x24528

WinGetPos, , , wx, wy, A
i=0
j=0
pi=3.141592653589793
;gui new
;Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  
;Gui, Add, text, vMyText,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;WinSet, TransColor, 000000 500
;Gui, Show, x10 y460 NoActivate  
hi=0

giant := Object()
giantwild := Object()
market := Object()
crucible := Object()







read(byref xx, byref yy, byref zz, byref hh)
{

	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807680, "Float*", xx, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807684, "Float*", yy, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807688, "Float*", zz, "Uint", 4, "Uint *", 0)
;	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x015ACF04, "Uint*", hpointer, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", hpointer, "Float*", hh, "Uint", 4, "Uint *", 0)
}

bearing(xx, yy, x0, y0, h)
{
	xx:=x0-xx
	yy:=y0-yy
	if (xx!=0 and yy>0)
		return ((atan(xx/yy))*57.2957795-h)
	else if (xx!=0 and yy<0)
		return (180+(atan(xx/yy))*57.2957795-h)
	else if (xx=0 and yy>0)
		return 0
	else if (xx=0 and yy<0)
		return 180
	else if (xx>0 and yy=0)
		return 90
	else if (xx<0 and yy=0)
		return 270
}

parser(byref matr, filename)
{
	Loop, read, %a_scriptdir%\scriptlogic\%filename%
	{
		i=%a_index%
		Loop, parse, A_LoopReadLine, %A_Space%
		{
			j=%a_index%
			matr[i,j]:=a_loopfield
		}
;		matr.max:=i
	}

}

move(xn, yn, i)
{
	read(xx,yy,zz,hh)
	while ((abs(xn-xx)>5) or (abs(yn-yy)>5))
	{
		read(xx,yy,zz,hh)
		res:=bearing(xx, yy, xn, yn, hh)
		mousemove res*mult, 0, 100, R
;		GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
		sleep rundelay		
	}
	while ((abs(xn-xx)>1.5) or (abs(yn-yy)>1.5))
	{
		read(xx,yy,zz,hh)
;		GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
		sleep rundelay		
	}
}

crutch(xn, yn, mode, i)
{
	read(xx,yy,zz,hh)
	if mode="+x"
	{
;		msgbox +x
		res:=bearing(xx, yy, (xn+160), yn, hh)
		
	}
	else if mode="+y"
		res:=bearing(xx, yy, xn, (yn+160), hh)
	else if mode="-x"
		res:=bearing(xx, yy, (xn-160), yn, hh)
	else if mode="-y"
		res:=bearing(xx, yy, xn, (yn-160), hh)
	else if mode="s"
		res:=0
	mousemove, res*mult, 0, 100, R
	while ((abs(xn-xx)>3) or (abs(yn-yy)>3))
	{
		read(xx,yy,zz,hh)
;		GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
		sleep 150		
	}
}


logic(matr)
{
	tmp:=matr._maxindex()
	loop %tmp%
	{
		i=%a_index%
		if matr[i,3]="n"
		{
			move(matr[i,1], matr[i,2], i)
			continue
		}
		else if matr[i,3]="j"
		{
			move(matr[i,1], matr[i,2], i)
			send {space}
			sleep 50
			continue
		}
		else if matr[i,3]="t"
		{
			move(matr[i,1], matr[i,2], i)
			send {w up}
			sleep 50
			talk()
			send {w down}
			sleep 50
			continue
		}
		else if matr[i,3]="l"
		{
;			move(matr[i,1], matr[i,2], i)
			send {w up}
			sleep 50
			if level=20
				level(none, feat21)
			else if level=21
				level(none, none)
			else if level=22
				level(none, none)
			else if level=23
				level(stat24, feat24)
			else if level=24
				level(none, none)
			else if level=25
				level(none, feat26)
			else if level=26
				level(none, feat27)
			else if level=27
				level(stat28, feat28)
			level:=level+1
			if level=28
				exit
			send {w down}
			sleep 50
			continue
		}
		else if matr[i,3]="p"
		{
			move(matr[i,1], matr[i,2], i)
			send {w up}
			sleep 500
			send {w down}
			sleep 50
			continue
		}
		else if matr[i,3]="s"
		{
;			move(matr[i,1], matr[i,2], i)
			send {w up}
			sleep 50
			continue
		}
		else if matr[i,3]="kx"
		{
			read(xx,yy,zz,hh)			
			res:=bearing(xx, yy, (matr[i,1]+160), matr[i,2], hh)
			mousemove, res*mult, 0, 100, R
			while ((abs(matr[i,1]-xx)>3) or (abs(matr[i,2]-yy)>3))
			{
				read(xx,yy,zz,hh)
;				GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
				sleep rundelay		
			}
			continue
		}
		else if matr[i,3]="ky"
		{
			read(xx,yy,zz,hh)			
			res:=bearing(xx, yy, matr[i,1], (matr[i,2]+160), hh)
			mousemove, res*mult, 0, 100, R
			while ((abs(matr[i,1]-xx)>3) or (abs(matr[i,2]-yy)>3))
			{
				read(xx,yy,zz,hh)
;				GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
				sleep rundelay		
			}
			continue
		}
		else if matr[i,3]="kx-"
		{
			read(xx,yy,zz,hh)			
			res:=bearing(xx, yy, (matr[i,1]-160), matr[i,2], hh)
			mousemove, res*mult, 0, 100, R
			while ((abs(matr[i,1]-xx)>3) or (abs(matr[i,2]-yy)>3))
			{
				read(xx,yy,zz,hh)
;				GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
				sleep rundelay		
			}
			continue
		}
		else if matr[i,3]="ky-"
		{
			read(xx,yy,zz,hh)			
			res:=bearing(xx, yy, matr[i,1], (matr[i,2]-160), hh)
			mousemove, res*mult, 0, 100, R
			while ((abs(matr[i,1]-xx)>3) or (abs(matr[i,2]-yy)>3))
			{
				read(xx,yy,zz,hh)
;				GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
				sleep rundelay		
			}
			continue
		}
	}
}



talk()
{
	j=0
	send {q}
	sleep 50
	send {e}
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\arrow.bmp			
	while (errorlevel=1 and j<=delay)						
	{
		sleep 100
		j:=j+100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\arrow.bmp	
	}
	while errorlevel=0								
	{
		send ^{F1}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\arrow.bmp	
	}	
}

level(ability, feat)
{
	click up right
	sleep 50
	click up right
	sleep 50
	
	talk()

	sendmode event
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\advancement.bmp
	mouseclick, left, x, y
	sleep 50
;	mouseclick, left, x, y
;	sleep 50

	if ability!=none
	{
		imagesearch, x3, y3, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\%ability%
		imagesearch, x, y, x3, y3, wx, wy, %a_scriptdir%\scriptlogic\statplus.bmp
		mouseclick, left, x, y
		sleep 50
		mouseclick, left, x, y

		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp
		while errorlevel!=0
		{
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp	
		}
		mouseclick, left, x, y
		sleep 50
		mouseclick, left, x, y
	}

	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\advancement.bmp
	mouseclick, left, x, y
	sleep 50
;	mouseclick, left, x, y
;	sleep 50

	if feat!=none
	{
		imagesearch, x1, y1, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featempt.bmp
		while errorlevel=1
		{
			sleep 100
			imagesearch, x1, y1, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featempt.bmp
		}
		imagesearch, x2, y2, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featslider.bmp
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptfeats\%feat%
		while errorlevel!=0
		{
			MouseClickDrag, left, x2, y2, x2, (y2+5)
			y2:=y2+5
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptfeats\%feat%
		}

		sleep 50
		MouseClickDrag, left, x, y, x1, y1
		sleep 50
		mousemove, (wx/2), (wy/2)
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp
		while errorlevel!=0
		{
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp	
		}
		mouseclick, left, x, y
		sleep 50
;		mouseclick, left, x, y
	}

	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\advancement.bmp
	mouseclick, left, x, y
	sleep 50
;	mouseclick, left, x, y
;	sleep 50

	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\finish.bmp
	while errorlevel!=0
	{
		sleep 100
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\finish.bmp	
	}	
	mouseclick, left, x, y
	sleep 10000

	sendmode play

	mousemove, (wx/2), (wy/2)
	sleep 50

	sleep 50
	click down right
	sleep 50
	click down right
	sleep 50
}

parser(giantwild, "giantwild.txt")
parser(crucible, "crucible.txt")
parser(giant, "giant.txt")
parser(market, "market.txt")

mousemove, (wx/2), (wy/2)
sleep 50

click down right
sleep 50
click down right
sleep 50
read(xx,yy,zz,hh)
mousemove, 1000, 0,100, R
GLOBAL mult:=hh
sleep 500
read(xx,yy,zz,hh)
mult:=1000/abs(hh-mult)
mousemove, -1000, 0,100, R
sleep 500
click up right
sleep 50
click up right
sleep 50

while i=0
{
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
	while errorlevel!=0
	{
		sleep 100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
	}

	mousemove, (wx/2), (wy/2)
	sleep 50

	click down right
	sleep 50
	click down right
	sleep 50
	mousemove, 0, 180*mult, 100, R	
	send {w down}
	sleep 50
	logic(giantwild)
	click up right
	sleep 50
	click up right
	sleep 50

	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\level.bmp	
	while errorlevel!=0
	{

		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
		while errorlevel=0								;цикл который будет работать пока не войдем в квест
		{
			send {q}								;открываем меню
			sleep 100
			send {e}
;			sleep delay								;раскомментить в случае проблем
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
			j=0
			while ((errorlevel=1) and (j<=delay))					;ждем 1 сек как откроется меню
			{
				sleep 100
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
				j:=j+100
			}

			if j>delay 								;если меню за 1 сек не открылось повторяем цикл с самого начала
			{
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
				continue 1
			}

			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\reset.bmp		;смотрим нужно ли ресетить квест и ресетим
			if errorlevel=0
			{
				mouseclick, left, x, y						;reset button
				sleep 100
				mouseclick, left, x, y
				sleep 100
				imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\yes.bmp				
				while errorlevel=1
				{
					sleep 100
					imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\yes.bmp				
				}
				while errorlevel=0
				{
					sleep 100
					mouseclick, left, x, y
					sleep 50
					mousemove, (wx/2), (wy/2)
					imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\yes.bmp				
				}
;				MouseClick, left, (wx/2-48), (wy/2+60)        			;Yes BUTTON
;				sleep 50
;				MouseClick, left, (wx/2-48), (wy/2+60)        			
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
				while errorlevel=0
				{
					sleep 100
					imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
				}
				send {q}
				sleep 100
				send {e}
;				sleep delay							;раскомментить в случае проблем
				j=0
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
				while ((errorlevel=1) and (j<=delay))
				{
					sleep 100
					imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
					j:=j+100
				}
				if j>delay 							;если меню за 1 сек не открылось повторяем цикл с самого начала
				{
					imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
					continue 1
				}
			}

			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\%diff%		;ищем кнопку с элитной сложностью
			if errorlevel=0
			{
				mouseclick, left, x, y						;жмем элиту
				sleep 100
				mouseclick, left, x, y
				sleep 100
			}
	
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\enter.bmp		;ищем и жмем вход
			if errorlevel=0
			{
				mouseclick, left, x, y
				sleep 100
				mouseclick, left, x, y
				sleep 100
			}
		
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp		;смотрим находимся ли мы еще в руинах
		}
	
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\crucible.bmp			;смотрим вошли ли мы в крусибл
		while errorlevel!=0
		{
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\crucible.bmp
		}
		mousemove, (wx/2), (wy/2)
		sleep 50
		send {w down}
		sleep 50
		send {w down}
		sleep 50
		click down right
		sleep 50
		click down right
		sleep 50
		logic(crucible)
		
		sleep 300									;отжимаем ПКМ
		click, up, right
		sleep 300
	
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\recall.bmp			;ищем кнопку рекол, делаем это вне цикла дабы, если ддошка лагнет и будем грузиться дольше 20 секунд, не жамкать на рекол в гиантхолде
		while i=0									;цикл будем крутить пока не среколимся
		{
			sleep 50
			click, up, right
			j=0
			mouseclick, left, x, y							;жмем рекол
			sleep 100
			mouseclick, left, x, y
			sleep 100	

			if monkrecall=1								;жмем первую или вторую стоку
			{
				Send ^{1}
				monkrecall=2
			}
			else if monkrecall=2
			{
				send ^{3}
				monkrecall=1
			}
			sleep, 230	
	
			MouseClick, left, (wx/2-48), (wy/2+100)        				;Yes BUTTON
	
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp			;ждем 20 секунд или пока не среколимся
			while (errorlevel=1 and j<=20000)
			{
				sleep 100
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
				j:=j+100
	
			}
			if j>20000
				continue
			if errorlevel=0								;если наконец в руинах - прекращаем
					break
		}
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
		while errorlevel!=0
		{	
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
		}

		send {s down}
		read(xx,yy,zz,hh)
		while ((abs(giantwild[giantwild._maxindex(),1]-xx)>3) or (abs(giantwild[giantwild._maxindex(),2]-yy)>3))
		{
			read(xx,yy,zz,hh)
;			GuiControl,, MyText, x:%xx%     y:%yy%     z:%zz%    h:%hh%   bear%i%:%res%
			sleep rundelay		
		}
		send {s up}
		sleep 50

		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\level.bmp
	}
	

	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
	while errorlevel=0
	{
		sleep 100
		send ^{2}
		sleep 1000
		send ^{2}
		sleep 1000
				
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
		while errorlevel=1
		{
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\marketmap.bmp
			if errorlevel=0
				break 2
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\marketfail.bmp
			if errorlevel=0
				break
			errorlevel=1
		}
		errorlevel=0
	}

/*
	read(xx,yy,zz,hh)
	while hh!=268.593750
	{
		sleep 100
		send ^{2}
		sleep 1000
		send ^{2}
		sleep 1000

		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\ruins.bmp
		if errorlevel=0
		{
			sleep 5000
			continue 1
		}
		else if errorlevel=1
		{
			j=0
			while j=0
			{
				sleep 100
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\market.bmp
				if errorlevel=0
					break
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\market1.bmp
				if errorlevel=0
					break
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\market2.bmp
				if errorlevel=0
					break
			}
		}
		read(xx,yy,zz,hh)
	}
*/	

	send {w down}
	sleep 50
	send {w down}
	sleep 50
	click down right
	sleep 50
	click down right
	sleep 50
	mousemove, 0, -90*mult, 100, R
	sleep 50		
	logic(market)
	sleep 50
	mousemove, 0, 90*mult, 100, R	
	sleep 50
	click up right
	sleep 50
	click up right
	sleep 50	
	
	j:=delay+1
	while j>delay
	{
		send {q}
		sleep 50
		send {e}
		sleep 50
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
		j=0
		while ((errorlevel=1) and (j<=delay))					;ждем 1 сек как откроется меню
		{
			sleep 100
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
			j:=j+100
		}
		mouseclick, left, x, y
		sleep 100
		mouseclick, left, x, y
		sleep 100
	}


	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\enter.bmp		;ищем и жмем вход
	if errorlevel=0
	{
		mouseclick, left, x, y
		sleep 100
		mouseclick, left, x, y
		sleep 100
	}	


	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\giant.bmp
	while errorlevel!=0
	{
		send ^{4}
		sleep 1000
		send ^{4}
		sleep 2000
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\gtmenu.bmp
		if errorlevel=0
		{
			imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\gtaccept.bmp
			mouseclick, left, x, y						;жмем элиту
			sleep 100
			mouseclick, left, x, y
			sleep 100
		}
		sleep 5000
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\giant.bmp
	}	
	
	mousemove, (wx/2), (wy/2)
	sleep 50
	send {w down}
	sleep 50
	send {w down}
	sleep 50
	click down right
	sleep 50
	click down right
	sleep 50	
	mousemove, 0, -135*mult, 100, R
	logic(giant)
;	mousemove, 0, 135*mult, 100, R
	sleep 50
	click up right
	sleep 50
	click up right
	sleep 50

	j:=delay+1
	while j>delay
	{
		send {e}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
		j=0
		while ((errorlevel=1) and (j<=delay))					;ждем 1 сек как откроется меню
		{
			sleep 100
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\scriptlogic\menu.bmp
			j:=j+100
		}
	}
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\enter.bmp		;ищем и жмем вход
	if errorlevel=0
	{
		mouseclick, left, x, y
		sleep 100
		mouseclick, left, x, y
		sleep 100
	}

}
return


F6::
ahk_class = Turbine Device Class
i=0
j=0

WinGet, PID, PID, %window%
HWND := DllCall("OpenProcess", "Uint", 0x1F0FFF, "int", 0, "int", PID)
gui new
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  
Gui, Add, text, vMyText,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
WinSet, TransColor, 000000 500
Gui, Show, x10 y460 NoActivate  
while i=0
{
	re:=dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807680, "Float*", x, "Uint", 4, "Uint *", 0)
	msgbox %re% - %errorlevel%
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807684, "Float*", y, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x01807688, "Float*", z, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", 0x015ACF04, "Uint*", hpointer, "Uint", 4, "Uint *", 0)
	dllcall("ReadProcessMemory", "Uint", HWND, "Uint", hpointer+0x24528, "Float*", h, "Uint", 4, "Uint *", 0)
        GuiControl,, MyText, x:%x%     y:%y%     z:%z%    h:%h%
        sleep 500
}
return

F1::
sendmode event
ahk_class = Turbine Device Class
WinGetPos, , , wx, wy, A
ability=statwis.bmp
feat=featgm.bmp


imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\advancement.bmp
mouseclick, left, x, y
sleep 50
;mouseclick, left, x, y
;sleep 50

imagesearch, x3, y3, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\%ability%
imagesearch, x, y, x3, y3, wx, wy, %a_scriptdir%\scriptlogic\statplus.bmp
mouseclick, left, x, y
;sleep 50
;mouseclick, left, x, y

imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp
while errorlevel!=0
{
	sleep 100
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp	
}
mouseclick, left, x, y

imagesearch, x1, y1, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featempt.bmp
while errorlevel=1
{
	sleep 100
	imagesearch, x1, y1, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featempt.bmp
}
imagesearch, x2, y2, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\featslider.bmp
imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptfeats\%feat%
while errorlevel!=0
{
	MouseClickDrag, left, x2, y2, x2, (y2+5)
	y2:=y2+5
	sleep 100
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptfeats\%feat%
}

sleep 50
MouseClickDrag, left, x, y, x1, y1
sleep 50
mousemove, (wx/2), (wy/2)
imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp
while errorlevel!=0
{
	sleep 100
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\scriptlogic\next.bmp	
}
mouseclick, left, x, y
return


F3::
ahk_class = Turbine Device Class
i=0
j=0
while i=0
{	
	msgbox i
	while ((j=0) and (i=0))
	{
		msgbox j
		break 2
	}
	if j=0
	{
		msgbox j2
	}

}
msgbox end


F8::
pause
return




F9::
SendMode Play
i=0
speed=1.02    							                	;ебашь сюда 150/твоя_скорость епт
delay=1000										;ожидание в миллисекундах открытия всех окон, в случае проблем со входом в крусиблю раскомментить две строки где то дальше
monkrecall=1										;использование монкорекола 0=выкл, 1=вкл
np=0											;поворот перед крусиблом, настоятельно рекомендуется держать выключенным, 0=выкл, 1=вкл
diff=norm.bmp										;сложность, elite.bmp, hard.bmp, norm.bmp
ahk_class = Turbine Device Class
WinGetPos, , , wx, wy, A

While i = 0
{
	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\ruins.bmp
	if errorlevel=0
	{
		Send {s down}								;бежим взад
		sleep 2600*speed
		Send {s up}
		sleep 100
	}
	
	if np=1
	{
		mousemove, (wx/2), (wy/2)							
		click, down, right								
		sleep 50
		click, down, right		
		sleep 300
		MouseMove, 1100, 0, 100, R
		sleep 50
		click, up, right								
		sleep 50
		click, up, right				
		sleep 50
	}

	while errorlevel=0								;цикл который будет работать пока не войдем в квест
	{
		send {q}								;открываем меню
		sleep 100
		send {e}
;		sleep delay								;раскомментить в случае проблем
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
		j=0
		while (errorlevel=1 and j<=delay)					;ждем 1 сек как откроется меню
		{
			sleep 100
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
			j:=j+100
		}

		if j>=delay 								;если меню за 1 сек не открылось повторяем цикл с самого начала
		{
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\ruins.bmp
			continue 2							;заменить на 1, если np=1 
		}

		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\reset.bmp		;смотрим нужно ли ресетить квест и ресетим
		if errorlevel=0
		{
			mouseclick, left, x, y						;reset button
			sleep 100
			mouseclick, left, x, y
			sleep 100
			MouseClick, left, (wx/2-48), (wy/2+60)        			;Yes BUTTON
;			sleep 50
;			MouseClick, left, (wx/2-48), (wy/2+60)        			
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
			while errorlevel=0
			{
				sleep 100
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
			}
			send {q}
			sleep 100
			send {e}
;			sleep delay							;раскомментить в случае проблем
			j=0
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
			while (errorlevel=1 and j<=delay)
			{
				sleep 100
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\menu.bmp
				j:=j+100
			}
			if j>=delay 							;если меню за 1 сек не открылось повторяем цикл с самого начала
			{
				imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\ruins.bmp
				continue 2
			}
		}

		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\%diff%			;ищем кнопку с элитной сложностью
		if errorlevel=0
		{
			mouseclick, left, x, y						;жмем элиту
			sleep 100
			mouseclick, left, x, y
			sleep 100
		}

		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\enter.bmp		;ищем и жмем вход
		if errorlevel=0
		{
			mouseclick, left, x, y
			sleep 100
			mouseclick, left, x, y
			sleep 100
		}
	
		imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\ruins.bmp		;смотрим находимся ли мы еще в руинах
	}

	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\crucible.bmp			;смотрим вошли ли мы в крусибл
	while errorlevel=1
	{
		sleep 100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\crucible.bmp
	}

	mousemove, (wx/2), (wy/2)							;двигаем мышь в центр дабы ПКМ могли нажать
	click, down, right								;зажимаем ПКМ
	sleep 50
	click, down, right

	Send {w down}
	sleep 5100*speed								;бежим до бочки
	Send {Space}									;прыгаем над бочком
	sleep 50
	MouseMove, -30, 0, 100, R							;поворачиваем чуть налево
	Sleep 4000*speed
	send {space}									;прыгаем меж шкафом и гоблином
	sleep 850*speed
	MouseMove, 120, 0, 100, R							;поворачиваем к гиганту
	Sleep 650*speed
	Send {w up}
	sleep 100
	MouseMove, 1090, 0, 100, R							;разворачиваемся на ~180 ибо триггер сработал
	sleep 100
	Send {w down}
	sleep 1900*speed								;бежим к первому
	Send {w up}
	MouseMove, 400, 0, 100, R							;разворачиваемся к первому
	sleep 100

	Send {q}      									;говорим с первым
	sleep, 100
	Send {e}
	j=0
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp			
	while (errorlevel=1 and j<=delay)						;ждем %delay% пока не начнется разговор, если не начинается - реколимся
	{
		sleep 100
		j:=j+100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	if j>=delay
		goto recall
	while errorlevel=0								;жамкаем Ф1 пока трелка не пропадет
	{
		send ^{F1}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	MouseMove, -400, 0, 100, R							;разворачиваемся от первого
	sleep 100

	Send {w down}
	sleep 2200*speed								;бежим ко второму
	Send {w up}
	MouseMove, 400, 0, 100, R							;разворачиваемся ко второму
	sleep 100

	Send {q}									;говорим со вторым
	sleep, 100
	Send {e}
	j=0
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp			
	while (errorlevel=1 and j<=delay)
	{
		sleep 100
		j:=j+100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	if j>=delay
		goto recall
	while errorlevel=0
	{
		send ^{F1}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	MouseMove, 650, 0, 100, R							;разворачиваемся от второго
	sleep 100

	Send {w down}
	sleep 2000*speed								;бежим к третьему
	MouseMove, 300, 0, 100, R							;первый поворот направо
	sleep 2150*speed
	MouseMove, -390, 0, 100, R							;второй поворот налево
	sleep 900*speed
	Send {w up}
	sleep, 100

	Send {q}									;говорим с третьим
	sleep, 100
	Send {e}
	j=0
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp			
	while (errorlevel=1 and j<=delay)
	{
		sleep 100
		j:=j+100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	if j>=delay
		goto recall
	while errorlevel=0
	{
		send ^{F1}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	MouseMove, 1050, 0, 100, R							;разворачиваемся от третьего
	sleep 100

	Send {w down}
	sleep 1000*speed								;бежим к третьему
	MouseMove, 300, 0, 100, R							;поворот направо
	sleep 2150*speed
	MouseMove, -200, 0, 100, R							;поворот налево
	sleep 1900*speed
	Send {w up}
	sleep, 100

	Send {q}									;говорим с четвертым
	sleep, 100
	Send {e}
	j=0
	imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp			
	while (errorlevel=1 and j<=delay)
	{
		sleep 100
		j:=j+100
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}
	if j>=delay
		goto recall
	while errorlevel=0
	{
		send ^{F1}
		sleep 50
		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\arrow.bmp	
	}


recall:											;метка рекола

	sleep 300									;отжимаем ПКМ
	click, up, right
	sleep 300

	imagesearch, x, y, 0, 0, wx, wy, %a_scriptdir%\recall.bmp			;ищем кнопку рекол, делаем это вне цикла дабы, если ддошка лагнет и будем грузиться дольше 20 секунд, не жамкать на рекол в гиантхолде
	while i=0									;цикл будем крутить пока не среколимся
	{
		sleep 50
		click, up, right
		j=0
		mouseclick, left, x, y							;жмем рекол
		sleep 100
		mouseclick, left, x, y
		sleep 100	

		if monkrecall=1								;жмем первую или вторую стоку
		{
			Send ^{1}
			monkrecall=2
		}
		else if monkrecall=2
		{
			send ^{3}
			monkrecall=1
		}
		sleep, 230

		MouseClick, left, (wx/2-48), (wy/2+100)        				;Yes BUTTON

		imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\ruins.bmp			;ждем 20 секунд или пока не среколимся
		while (errorlevel=1 and j<=200)
		{
			sleep 100
			imagesearch, , , 0, 0, wx, wy, %a_scriptdir%\ruins.bmp
			j:=j+1

		}
		if errorlevel=0								;если наконец в руинах - прекращаем
			break
	}
}
return

F11::
Sendmode Play
i=0
ahk_class = Turbine Device Class
while i=0
{
MouseMove, -200, 0, 100, R
sleep 500
MouseMove, 200, 0, 100, R
sleep 500
}
return


F12::
if i = 1
{
Run, wmic path win32_networkadapter where NetConnectionID="1" call enable, , hide
i=0
}
else 
{
Run, wmic path win32_networkadapter where NetConnectionID="1" call disable, , hide
i = 1
}
return
