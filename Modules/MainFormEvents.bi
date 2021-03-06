#ifndef MAINFORMEVENTS_BI
#define MAINFORMEVENTS_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"

Const CardNotAssignment As Integer = 0
Const CardAssignment As Integer = 1

' Подготовка к игре
' wParam — не используется
' lParam — не используется
Const PM_NEWGAME As UINT = WM_USER + 0

' Взятие суммы у игроков
' wParam — не используется
' lParam — не используется
Const PM_DEALMONEY As UINT = WM_USER + 2

' Раздача колоды карт игрокам
' wParam — не используется
' lParam — не используется
Const PM_BANKDEALPACK As UINT = WM_USER + 3

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
Const PM_PLAYERWIN As UINT = WM_USER + 11
Const PM_LENEMYWIN As UINT = WM_USER + 12

' Новый тур игры
' wParam — не используется
' lParam — не используется
Const PM_NEWSTAGE As UINT = WM_USER + 13

#define POST_MESSAGE_PM_NEWGAME(hWin) PostMessage((hWin), PM_NEWGAME, 0, 0)
#define POST_MESSAGE_PM_DEALMONEY(hWin) PostMessage((hWin), PM_DEALMONEY, 0, 0)
#define POST_MESSAGE_PM_BANKDEALPACK(hWin) PostMessage((hWin), PM_BANKDEALPACK, 0, 0)

#define POST_MESSAGE_PM_RENEMYATTACK(hWin, CardNumber, AssignmentFlag) PostMessage((hWin), PM_RENEMYATTACK, (CardNumber), (AssignmentFlag))
#define POST_MESSAGE_PM_LENEMYATTACK(hWin, CardNumber, AssignmentFlag) PostMessage((hWin), PM_LENEMYATTACK, (CardNumber), (AssignmentFlag))
#define POST_MESSAGE_PM_USERATTACK(hWin, CardNumber, AssignmentFlag) PostMessage((hWin), PM_USERATTACK, (CardNumber), (AssignmentFlag))

#define POST_MESSAGE_PM_ASSIGNMENT_RENEMYATTACK(hWin, CardNumber) PostMessage((hWin), PM_RENEMYATTACK, (CardNumber), CardAssignment)
#define POST_MESSAGE_PM_ASSIGNMENT_LENEMYATTACK(hWin, CardNumber) PostMessage((hWin), PM_LENEMYATTACK, (CardNumber), CardAssignment)
#define POST_MESSAGE_PM_ASSIGNMENT_USERATTACK(hWin, CardNumber) PostMessage((hWin), PM_USERATTACK, (CardNumber), CardAssignment)

#define POST_MESSAGE_PM_NOTASSIGNMENT_RENEMYATTACK(hWin) PostMessage((hWin), PM_RENEMYATTACK, 0, CardNotAssignment)
#define POST_MESSAGE_PM_NOTASSIGNMENT_LENEMYATTACK(hWin) PostMessage((hWin), PM_LENEMYATTACK, 0, CardNotAssignment)
#define POST_MESSAGE_PM_NOTASSIGNMENT_USERATTACK(hWin) PostMessage((hWin), PM_USERATTACK, 0, CardNotAssignment)

#define POST_MESSAGE_PM_RENEMYFOOL(hWin) PostMessage((hWin), PM_RENEMYFOOL, 0, 0)
#define POST_MESSAGE_PM_USERFOOL(hWin) PostMessage((hWin), PM_USERFOOL, 0, 0)
#define POST_MESSAGE_PM_LENEMYFOOL(hWin) PostMessage((hWin), PM_LENEMYFOOL, 0, 0)

#define POST_MESSAGE_PM_RENEMYWIN(hWin) PostMessage((hWin), PM_RENEMYWIN, 0, 0)
#define POST_MESSAGE_PM_PLAYERWIN(hWin) PostMessage((hWin), PM_PLAYERWIN, 0, 0)
#define POST_MESSAGE_PM_LENEMYWIN(hWin) PostMessage((hWin), PM_LENEMYWIN, 0, 0)

#define POST_MESSAGE_PM_NEWSTAGE(hWin) PostMessage((hWin), PM_NEWSTAGE, 0, 0)

#endif
