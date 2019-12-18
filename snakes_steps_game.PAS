{**********************************
*  Program: Final project         *
*                                 *
*  By :                           *
*     Fatemeh PourMohammadHadi    *
*                                 *
*  Professor :  Mr. Zarei         *
**********************************}
program snakesandsteps;
 uses crt,graph,dos;
 type
  arraytype=array [1..5] of shortint;
  recordtype=record
   color:shortint; number:shortint; end;

 var
  s:string;
  ok:shortint;
  ch,ch1:char;
  st,st1,st2:string;
  score:shortint;
  i,t:shortint;
  num:integer;
  player:array [1..4] of recordtype;
  table:array [1..100] of shortint;
  snake,snakes,step,steps:arraytype;

  { * * * * * Sounds * * * * * * }
{ This procedure makes sounds for setting block, erasing lines and changing level }
procedure Sounds(SoundModel:byte);
var I:integer;
begin
  Case SoundModel of
    1 : for I:=1 to 20 do       { Sound for setting block }
        begin
          Sound(5*Random(500)+900);
          Delay(1);
        end;

    2 : begin                   { Sound for erasing lines }
	  Sound(800); Delay(90);
	  Sound(600); Delay(90);
	  Sound(400); Delay(90);
        end;

    3 : for I:=1 to 10 do       { Sound for changing level }
        begin
          Sound(50*Random(100)+500);
          Delay(50);
        end;
  end;
  NoSound;
end;



{* * * * * GetXY * * * * * * }
{Get a string from user}

procedure GetXY(X, Y, W, H: Word;
                Font, Size, FClr, BClr, CClr, TypeNo: Byte ;
                var St: String);

const BT=90;

var XC, I : Word;
    Key, Key0 : Byte;
    Temp,t1,t2 : Word;
    Ins : Boolean;
{Set cursor in it's place}
procedure Cursor(State: Boolean);
begin
  GetTime(Temp,Temp,Temp,t2);
  if ((t2-t1) < (BT div 2)) then SetColor(CClr) else SetColor(BClr);
  if (not State) then SetColor(BClr);
  if (t2-t1) > (BT) then GetTime(Temp,Temp,Temp,t1);
  Line(XC,Y+3,XC,Y+H-3); Line(XC,Y+3,XC+1,Y+3);
end;
{Clear tabel}
procedure ClrTbl;
begin
  SetFillStyle(1,BClr); Bar(X,Y,X+W,Y+H);
end;
{Return width of a string in pixel}
function TW(S : String):Word;
var k: Byte;
    l: Word;
begin
  l:=0;
  for k:=1 to Length(S) do Inc(l,TextWidth(S[k]));
  TW:=l;
end;
{}

begin{GetXY}
  Ins:=True;
  SetTextStyle(Font,0,Size);
  if H<TextHeight('A')+10 then H:=TextHeight('y')+10;
  {}
  SetFillStyle(1,BClr); Bar(X,Y,X+W,Y+H);
  I:=Length(St);
  repeat
    XC:= X + TW(Copy(St,1,I));
    SetColor(FClr); OutTextXY(X+1,Y,St);
    Cursor(True);
    if KeyPressed then
    begin
      Cursor(False);
      Key:=Ord(ReadKey);
      case Key of
        27,13  : Break;
        32..126: if (TypeNo=1) or ((TypeNo=2) and (Key in [48..57])) then
                   if TextWidth(St+Chr(Key))<W then
                   begin
                     Inc(I);
                     if not Ins then Delete(St,I,1);
                     Insert(Chr(Key),St,I);
                     ClrTbl;
                   end;
        8: if I>0 then                                    {Back space}
           begin
             Delete(St,I,1);
             Dec(I);
             ClrTbl;
           End;
        0 : begin
              Key0:=Ord(Readkey);
              case Key0 of
                71 : I:=0;                                {Home}
                79 : I:=Length(St);                       {End}
                75 : if I>0 Then Dec(I);                  {Left arrow}
                77 : if I<Length(St) then Inc(I);         {Right arrow}
                82 : Ins:=not Ins;                        {Insert}
                83 : begin                                {Delete}
                       Delete(St,I+1,1);
                       ClrTbl;
                     end;
              end; {case}
            end;
      end; {case}
    end; {if}
  until False;
  {}
end; {GetXY}


{ * * * * * Window * * * * * * }
{This procedure draws a window in term of coordinate that gives.}
procedure Window(x1, y1, x2, y2 :Integer; BackColor, BorderColor :Byte);
var m: Integer;
begin
  SetFillStyle(1,BackColor);
  Bar(x1,y1,x2,y2);
  for m:=0 to 2 do
  begin
    SetColor(BorderColor + 8*(m mod 2));
    Rectangle(x1+m,y1+m,x2-m,y2-m);
  end;
end;


{ * * * * * Screen * * * * * * }
{This procedure draws game screen}
procedure Screen;
var m,n,Xp,Yp: Integer;
begin
  Window(0,0,GetMaxX,GetMaxY,1,1);
  n:=0;
  for m:=1 to 7 do
  begin
    SetColor(m); Rectangle(n*3,n*3,GetMaxX-n*3,GetMaxY-n*3);
    SetColor(m+8); Rectangle(n*3+1,n*3+1,GetMaxX-n*3-1,GetMaxY-n*3-1);
    SetColor(m); Rectangle(n*3+2,n*3+2,GetMaxX-n*3-2,GetMaxY-n*3-2);
    Inc(n);
  end;

  setfillstyle(1,0);  {draws Game board}
  bar((getmaxx-300)div 2,50,(getmaxx-300) div 2+300,350);
  setcolor(15);
  rectangle((getmaxx-300)div 2,50,(getmaxx-300) div 2+300,350);
  for m:=1 to 9 do
   line((getmaxx-300) div 2,50+m*30,(getmaxx-300) div 2+300,50+m*30);
  for m:=1 to 9 do
   line((getmaxx-300) div 2+30*m,50,(getmaxx-300) div 2+30*m,350);
  setcolor(14);
  SetTextStyle(5,0,1);
  for m:=1 to 99 do
   begin
    str(m,st);
    if (m mod 10)=0 then
     begin
      Xp:=9*30+(getmaxx-300) div 2+5;
      Yp:=((m div 10)-1)*30+45;
     end
    else
     begin
      Xp:=((m mod 10)-1)*30+(getmaxx-300) div 2+5;
      Yp:=(m div 10)*30+45;
     end;
    OutTextXY(Xp,Yp,st);
    OutTextXY(9*30+(getmaxx-300) div 2+5,((100 div 10)-1)*30+45,'H');
   end;

  setfillstyle(1,9); {draws score board}
  bar((getmaxx-300) div 2,360,(getmaxx-300) div 2+300,450);
  setcolor(5);
  rectangle((getmaxx-300) div 2,360,(getmaxx-300) div 2+300,450);
  rectangle((getmaxx-300) div 2+1,360+1,(getmaxx-300) div 2+300-1,450-1);

  SetfillStyle(1,15); {draws number of players board}
  bar(30,360,(getmaxx-300) div 2-10,450);
  SetColor(4);
  rectangle(30,360,(getmaxx-300) div 2-10,450);
  rectangle(30+1,360+1,(getmaxx-300) div 2-10-1,450-1);
  str(num,st);
  st:=concat('we have ',st);
  OutTextXY(40,370,st);
  OutTextXY(40,400,'players');

  SetfillStyle(1,15); {draws players board}
  bar((getmaxx-300) div 2+300+10,360,getmaxx-30,450);
  SetColor(4);
  rectangle((getmaxx-300) div 2+300+10,360,getmaxx-30,450);
  rectangle((getmaxx-300) div 2+300+10+1,360+1,getmaxx-30-1,450-1);
  t:=random(10);
  for i:=1 to num do
   player[i].color:=t+i;
  for m:=num+1 to 4 do
   player[m].color:=15;
  SetColor(4);
  OutTextXY((getmaxx-300) div 2+300+20,370,'P1:');
  OutTextXY((getmaxx-300) div 2+300+80,370,'P2:');
  OutTextXY((getmaxx-300) div 2+300+20,400,'P3:');
  OutTextXY((getmaxx-300) div 2+300+80,400,'P4:');
  SetFillStyle(1,player[1].color);
  PieSlice((getmaxx-300) div 2+300+65,386,0,360,5);
  SetFillStyle(1,player[2].color);
  PieSlice((getmaxx-300) div 2+300+125,386,0,360,5);
  SetFillStyle(1,player[3].color);
  PieSlice((getmaxx-300) div 2+300+65,416,0,360,5);
  SetFillStyle(1,player[4].color);
  PieSlice((getmaxx-300) div 2+300+125,416,0,360,5);

  setfillstyle(1,9);{draws steps board}
  bar((getmaxx-300) div 2+300+10,50,getmaxx-30,350);
  setcolor(5);
  rectangle((getmaxx-300) div 2+300+10,50,getmaxx-30,350);
  rectangle((getmaxx-300) div 2+300+10+1,50+1,getmaxx-30-1,350-1);
  SetTextStyle(1,0,1);
  SetColor(15);
  OutTextXY((getmaxx-300) div 2+300+20,65,'STEPS:');
  for m:=1 to 5 do
    begin
      SetTextStyle(1,0,1);
      SetColor(14);
      str(step[m],st);
      str(steps[m],st1);
      str(m,st2);
      st:=concat(st2,': ',st,' To ',st1);
      OutTextXY((getmaxx-300) div 2+300+20,50+m*50,st);
    end;

  setfillstyle(1,9);  {draws snakes board}
  bar(30,50,(getmaxx-300) div 2-10,350);
  setcolor(5);
  rectangle(30,50,(getmaxx-300) div 2-10,350);
  rectangle(30+1,50+1,(getmaxx-300) div 2-10-1,350-1);
  SetTextStyle(1,0,1);
  SetColor(15);
  OutTextXY(40,65,'SNAKES:');
  for m:=1 to 5 do
    begin
      SetTextStyle(1,0,1);
      SetColor(14);
      str(snake[m],st);
      str(snakes[m],st1);
      str(m,st2);
      st:=concat(st2,': ',st,' To ',st1);
      OutTextXY(40,50+m*50,st);
    end;
end;

{ * * * * * * OutTextCenter * * * * * * }
{ Write text in Y and center of screen.}
procedure OutTextCenter(Y:Word ; Font, Size, Color1: Byte; Shadow:Boolean; S:String);
begin
  SetTextStyle(Font,0,Size);
  if Shadow then begin SetColor(8); OutTextXY((GetMaxX-TextWidth(S)) div 2-2,Y+2,S); end;
  SetColor(Color1); OutTextXY((GetMaxX-TextWidth(S)) div 2,Y,S);
end;

{ * * * * * GameOver * * * * * * }
{This procedure shows game over window and ask for quit or continue the game}
function GameOver : Boolean;
begin
  Window(220,150,420,300,4,5);
  if ok=1 then
   begin
    str(t,st);
    st:=concat('Player',st,'Won');
    OutTextCenter(162,1,1,0,False, 'You Won');
    OutTextCenter(160,1,1,10,False, 'You Won');
   end
  else
   begin
    OutTextCenter(162,1,1,0,False, 'Game Over');
    OutTextCenter(160,1,1,10,False, 'Game Over');
   end;
  OutTextCenter(212,1,1,0,False, 'Enter : Continue');
  OutTextCenter(210,1,1,11,False, 'Enter : Continue');
  OutTextCenter(252,1,1,0,False, 'Esc : Quit game');
  OutTextCenter(250,1,1,11,False, 'Esc : Quit game');
  GameOver:=False;
  repeat
    Ch:=ReadKey;
    if Ch=#27 then
    begin
      GameOver:=True;
    end;
 until Ch in [#13,#27];
end;

{ * * * * * Do You Want to Exit * * * * * * }
{This procedure shows Do You Want to Exit window and ask for quit or continue the game}
function DoYou : Boolean;
begin
  Window(200,150,440,300,4,5);
  OutTextCenter(162,1,1,0,False, 'Do You Want to Exit?');
  OutTextCenter(160,1,1,10,False, 'Do You Want to Exit?');
  OutTextCenter(212,1,1,0,False, 'Enter : NO');
  OutTextCenter(210,1,1,11,False, 'Enter : NO');
  OutTextCenter(252,1,1,0,False, 'Esc : YES');
  OutTextCenter(250,1,1,11,False, 'Esc : YES');
  DoYou:=False;
  repeat
    Ch:=ReadKey;
    if Ch=#27 then
    begin
      DoYou:=True;
    end;
 until Ch in [#13,#27];
end;

{ * * * * * * * Questions  * * * * * * }
{ Show Questions screen}
procedure Questions;
var
    m,n: Byte;
    int,error:integer;
    invalidnumber:boolean;
    r:integer;
begin
 repeat
  ClearDevice;
  ch:=#0;
  n:=0;
  for m:=1 to 7 do
  begin
    SetColor(m); Rectangle(n*3,n*3,GetMaxX-n*3,GetMaxY-n*3);
    SetColor(m+8); Rectangle(n*3+1,n*3+1,GetMaxX-n*3-1,GetMaxY-n*3-1);
    SetColor(m); Rectangle(n*3+2,n*3+2,GetMaxX-n*3-2,GetMaxY-n*3-2);
    Inc(n);
  end;
  OutTextCenter(50,1,3,15,true,'ENTER YOUR FAVORITE NUMBERS');
  OutTextCenter(100,1,1,15,false,'Enter Number of Players');

  for m:=1 to 5 do
   begin
    str(m,st);
    st:=concat('Snake ',st,' :');
    OutTextXY(40,100+50*m,st);
    OutTextXY(180,100+50*m,'DownTo :');
   end;

   for m:=1 to 5 do
   begin
    str(m,st);
    st:=concat('Step ',st,' :');
    OutTextXY((GetMaxx div 2)+40,100+50*m,st);
    OutTextXY((GetMaxx div 2)+180,100+50*m,'To :');
   end;
   for m:=1 to 5 do
     begin
      snake[m]:=0;
      snakes[m]:=0;
      step[m]:=0;
      steps[m]:=0;
     end;
     repeat
       s:='';
       GetXY(450,100,16,16,1,2,14,8,14,2,s);
       val(s,int,error);
       num:=int;
     until ((error=0) and (int<5) and (int>0) );

     for m:=1 to 5 do {give snake}
      begin
       repeat
           s:='';
           OutTextCenter(getmaxy-50,1,1,0,false,'Invalid Number');
           GetXY(140,100+50*m,30,30,1,2,14,1,14,2,s);
           val(s,int,error);
           invalidnumber:=false;
           for r:=1 to 5 do
            if ((snake[r]=int) or (snakes[r]=int) or (step[r]=int) or (steps[r]=int)) then
              begin
               sounds(2);
               invalidnumber:=true;
               OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
               delay(300);
              end;
           snake[m]:=int;
      until((error=0) and (int>0) and (invalidnumber=false) and  (int<101));
      sounds(1);
      end;

     for m:=1 to 5 do {give snakes }
      begin
       repeat
          s:='';
          OutTextCenter(getmaxy-50,1,1,0,false,'Invalid Number');
          GetXY(270,100+50*m,30,30,1,2,14,2,14,2,s);
          val(s,int,error);
          invalidnumber:=false;
          for r:=1 to 5 do
           if ((snake[r]=int) or (snakes[r]=int) or (step[r]=int) or (steps[r]=int) )then
             begin
               sounds(2);
               invalidnumber:=true;
               OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
               delay(300);
             end;
          snakes[m]:=int;
          if invalidnumber=false then
           begin
             if (snakes[m]>snake[m]) then
               begin
                sounds(2);
                invalidnumber:=true;
                OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
                delay(300);
              end;
           end;
          if ((snake[m]=1) and (snakes[m]=1)) then
           invalidnumber:=false;
       until ((error=0) and (int>0) and (invalidnumber=false) and  (int<101));
       sounds(1);
      end;

     for m:=1 to 5 do    {Give step}
      begin
         repeat
          s:='';
          outtextxy(80*m,getmaxy-40,s);
          OutTextCenter(getmaxy-50,1,1,0,false,'Invalid Number');
          GetXY((GetMaxx div 2)+40+90,100+50*m,30,30,1,2,14,4,14,2,s);
          val(s,int,error);
          invalidnumber:=false;
          for r:=1 to 5 do
           if ((snake[r]=int) or (snakes[r]=int) or (step[r]=int) or (steps[r]=int) ) then
             begin
              sounds(2);
              invalidnumber:=true;
              OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
              delay(300);
             end;
          step[m]:=int;
       until  ((error=0) and (int>0) and (invalidnumber=false) and  (int<101) );
       sounds(1);
      end;

     for m:=1 to 5 do     {Give steps}
      begin
       repeat
          s:='';
          OutTextCenter(getmaxy-50,1,1,0,false,'Invalid Number');
          GetXY((GetMaxx div 2)+180+50,100+50*m,30,30,1,2,14,5,14,2,s);
          val(s,int,error);
          invalidnumber:=false;
          for r:=1 to 5 do
           begin
            if ((snake[r]=int) or (snakes[r]=int) or (step[r]=int) or (steps[r]=int)) then
             begin
              sounds(2);
              invalidnumber:=true;
              OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
              delay(300);
             end;
           end;
          steps[m]:=int;
          if invalidnumber=false then
           begin
            if (steps[m]<step[m]) then
             begin
              sounds(2);
              invalidnumber:=true;
              OutTextCenter(getmaxy-50,1,1,4,false,'Invalid Number');
              delay(300);
             end;
           end;
          if ((step[m]=99) and (steps[m]=99)) then
           invalidnumber:=false;
       until((error=0) and (int>0) and (invalidnumber=false) and  (int<101)) ;
       sounds(1);
      end;
 until DoYou=true;
end;

{ * * * * * * * Title * * * * * * }
{ Show beginning screen.}
procedure Title;
var
    m,n: Byte;
begin
  ClearDevice;
  n:=0;
  for m:=1 to 7 do
  begin
    SetColor(m); Rectangle(n*3,n*3,GetMaxX-n*3,GetMaxY-n*3);
    SetColor(m+8); Rectangle(n*3+1,n*3+1,GetMaxX-n*3-1,GetMaxY-n*3-1);
    SetColor(m); Rectangle(n*3+2,n*3+2,GetMaxX-n*3-2,GetMaxY-n*3-2);
    Inc(n);
  end;
  SetBKColor(8);
  SetFillStyle(3,1); FloodFill(30,30,7);
  OutTextCenter(27,5,1,7,False, 'In the Name of Allah');
  OutTextCenter(25,5,1,10,False, 'In the Name of Allah');
  OutTextCenter(45,10,4,7,False, 'snakes and steps');
  OutTextCenter(40,10,4,12,False, 'snakes and steps');
  OutTextCenter(227,1,1,7,False, 'Finall project of Pascal course');
  OutTextCenter(225,1,1,10,False, 'Finall project of Pascal course');
  OutTextCenter(282,5,1,7,False, 'Professor :');
  OutTextCenter(280,5,1,14,False, 'Professor :');
  OutTextCenter(312,5,2,7,False, 'Mr. Zarei');
  OutTextCenter(310,5,2,10,False, 'Mr. Zarei');
  OutTextCenter(361,5,1,7,False, 'by :');
  OutTextCenter(360,5,1,14,False, 'by :');
  OutTextCenter(392,5,2,7,False, 'Fatemeh Pour Mohammadhadi');
  OutTextCenter(390,5,2,10,False, 'Fatemeh Pour Mohammadhad');
  OutTextCenter(422,5,1,7,False, '82113800');
  OutTextCenter(420,5,1,10,False, '82113800');
  readkey;
  SetBKColor(0);
  ClearDevice;
end;


{ * * * * * PutCircle * * * * * * }
{This procedure draws a circle}
procedure PutCircle(nb:integer; color2:shortint);
var Xp,Yp:integer;
begin
  if (nb mod 10)=0 then
            begin
             Xp:=9*30+((getmaxx-300) div 2)+15;
             Yp:=((nb div 10)-1)*30+65;
            end
          else
            begin
             Xp:=((nb mod 10)-1)*30+((getmaxx-300) div 2)+15;
             Yp:=(nb div 10)*30+65;
            end;
  if Color2<>0 then SetFillStyle(1,Color2 + 8) else SetFillStyle(1,Color2);
  PieSlice(Xp,Yp,0,360,5);
  SetColor(Color2);
  Circle(Xp, Yp,5);
  Circle(Xp, Yp,4);
end;


{* * * * * * ShowScore * * * * * *}
{this procedure put score in score board}
procedure ShowScore;
 begin
  setfillstyle(1,9);
  bar((getmaxx-300) div 2,360,(getmaxx-300) div 2+300,450);
  setcolor(5);
  rectangle((getmaxx-300) div 2,360,(getmaxx-300) div 2+300,450);
  rectangle((getmaxx-300) div 2+1,360+1,(getmaxx-300) div 2+300-1,450-1);{clear score board}
  SetColor(15);
  SetTextStyle(1,0,1);
  str(i,st);
  st:=concat('player ',st,' score is : ');
  OutTextXY((getmaxx-300) div 2+10,390 ,st); {clear score board}
  SetColor(14);
  SetTextStyle(1,0,1);
  str(score,st);
  if score=6 then
   begin
    OutTextXY((getmaxx-300) div 2+180,390,st);
    OutTextXY((getmaxx-300) div 2+10,420,'press key again');
   end
  else
   begin
    OutTextXY((getmaxx-300) div 2+180,390,st);
    if (i mod num)=0 then
     OutTextXY((getmaxx-300) div 2+10,360,'player 1 press key')
    else
     begin
      str((i+1),st);
      st:=concat('player ',st,' press key');
      OutTextXY((getmaxx-300) div 2+10,360,st);
     end;
   end;
 end;


{ * * * * * * * * * * * * * * }
{ *           Main          * }
{ * * * * * * * * * * * * * * }

var
    GraphDriver,GraphMode  : Integer;
    k:shortint;
    x,y:shortint;
begin
  GraphDriver:= Detect;
  InitGraph(GraphDriver,GraphMode,'');       { Activate graphic mode }
  Randomize;
  repeat
    Title;
    Questions;
    Screen;
    for i:=1 to 4 do
     player[i].number:=0;
    for k:=1 to 5 do
      begin
       table[snake[k]]:=-1*snakes[k];
       table[step[k]]:=-1*steps[k];
      end;
    ok:=0;
    ch1:=#0;
    repeat
     for i:=1 to num do
      repeat
       ch:=readkey;
       score:=random(6)+1;
       showscore;
       if player[i].number<>0 then
         begin
          PutCircle(player[i].number,0);
          table[player[i].number]:=0;
         end;
       if player[i].number=0 then
        begin
         if score=6 then
           begin
            player[i].number:=1;
            table[1]:=player[i].color;
           end;
        end
       else
        player[i].number:=player[i].number+score;
       if player[i].number<>0 then   {}
       begin
       if table[player[i].number]<0 then
         begin
          player[i].number:=-1*table[player[i].number];
          sounds(1);
         end;
       for k:=1 to num do
       begin
        if ((player[i].number=player[k].number) and (k<>i)) then
          begin
            if player[k].number<>100 then
            begin
             player[k].number:=0;
             sounds(2);
            end
            else player[i].number:=player[i].number-score;
          end;
       end;
       if player[i].number<=100 then
         begin
          PutCircle(player[i].number,player[i].color);
          table[player[i].number]:=player[i].color;
         end
       else
         player[i].number:=player[i].number-score;
         PutCircle(player[i].number,player[i].color);
       if player[i].number=100 then
         begin
          sounds(3);
          ok:=1;
          t:=i;
          break;
         end;
       end;
      until (ch=#27) or (score<>6);
    until (ch=#27) or (ok=1);
  until GameOver=true;
end.




