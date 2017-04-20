#ifndef unicode
#define unicode
#endif

#include once "windows.bi"

' События игры

' Подготовка к игре
Const PM_NEWGAME As UINT = WM_USER + 0

' Установка денег в начальное положение
Const PM_DEFAULTMONEY As UINT = WM_USER + 1

' Взятие суммы у игроков
Const PM_DEALMONEY As UINT = WM_USER + 2

' Раздача колоды карт игрокам
Const PM_DEALPACK As UINT = WM_USER + 3

' Ход правого врага
Const PM_RENEMYATTACK As UINT = WM_USER + 4

' Ход левого врага
Const PM_LENEMYATTACK As UINT = WM_USER + 5

' Ход игрока
Const PM_USERATTACK As UINT = WM_USER + 6

' Взятие денег у правого врага при отсутствии карты для хода
Const PM_RENEMYFOOL As UINT = WM_USER + 7

' Взятие денег у левого врага при отсутствии карты для хода
Const PM_LENEMYFOOL As UINT = WM_USER + 8

' Взятие денег у игрока при отсутствии карты для хода
Const PM_USERFOOL As UINT = WM_USER + 9

' Правый враг положил последнюю карту
Const PM_RENEMYWIN As UINT = WM_USER + 10

' Левый враг положил последнюю карту
Const PM_LENEMYWIN As UINT = WM_USER + 11

' Игрок положил последнюю карту
Const PM_USERWIN As UINT = WM_USER + 12

' Ход правого врага с девятки бубен
Const PM_RENEMY_NINEATTACK As UINT = WM_USER + 13

' Ход левого врага с девятки бубен
Const PM_LENEMY_NINEATTACK As UINT = WM_USER + 14

' Ход игрока с девятки бубен
' На самом деле не нужно
' Const PM_USER_NINEATTACK As UINT = WM_USER + 15

' Правый враг кидает карту на поле
Const PM_RENEMY_DEALCARD As UINT = WM_USER + 16

' Левый враг кидает карту на поле
Const PM_LENEMY_DEALCARD As UINT = WM_USER + 17

' Игрок кидает карту на поле
Const PM_USER_DEALCARD As UINT = WM_USER + 18
