#ifndef unicode
#define unicode
#endif

#include once "windows.bi"

' События игры

' Подготовка к игре
' wParam — не используется
' lParam — не используется
Const PM_NEWGAME As UINT = WM_USER + 0

' Установка денег в начальное положение
' wParam — не используется
' lParam — не используется
Const PM_DEFAULTMONEY As UINT = WM_USER + 1

' Взятие суммы у игроков
' wParam — не используется
' lParam — не используется
Const PM_DEALMONEY As UINT = WM_USER + 2

' Раздача колоды карт игрокам
' wParam — не используется
' lParam — не используется
Const PM_DEALPACK As UINT = WM_USER + 3

' Ход персонажа
' wParam — номер карты в массиве
' lParam — если не равен нулю, то карта уже найдена
Const PM_RENEMYATTACK As UINT = WM_USER + 4
Const PM_LENEMYATTACK As UINT = WM_USER + 5
Const PM_USERATTACK As UINT = WM_USER + 6

' Взятие денег у игрока при отсутствии карты для хода
' wParam — не используется
' lParam — не используется
Const PM_RENEMYFOOL As UINT = WM_USER + 7
Const PM_USERFOOL As UINT = WM_USER + 8
Const PM_LENEMYFOOL As UINT = WM_USER + 9

' Персонаж положил последнюю карту
' wParam — не используется
' lParam — не используется
Const PM_RENEMYWIN As UINT = WM_USER + 10
Const PM_USERWIN As UINT = WM_USER + 11
Const PM_LENEMYWIN As UINT = WM_USER + 12

' Персонаж кидает карту на поле
' wParam — номер карты в массиве
' lParam — не используется
Const PM_RENEMYDEALCARD As UINT = WM_USER + 13
Const PM_USERDEALCARD As UINT = WM_USER + 14
Const PM_LENEMYDEALCARD As UINT = WM_USER + 15

' Новый тур игры
' wParam — не используется
' lParam — не используется
Const PM_NEWSTAGE As UINT = WM_USER + 16
