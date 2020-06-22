#!/bin/bash

rotate90(){ #поворот черепашки на месте на 90 градусов по часовой стрелке
		rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[0.0, 0.0, 0.0]' '[0.0, 0.0,-1.564]'
}

crotate90(){ #поворот черепашки на месте на 90 градусов против часовой стрелки
		rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[0.0, 0.0, 0.0]' '[0.0, 0.0,1.564]'
}

move(){ #перемещение вперед на заданное количество шагов
	rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- [$1', 0.0, 0.0]' '[0.0, 0.0,0.0]'
}

penoff(){ #убрать ручку
	rosservice call /turtle1/set_pen  0 0 0 5 on
}

penon(){ #опустить ручку
	rosservice call /turtle1/set_pen  255 177 10 5 off
}

teleport(){ #перемещение черепашки в указанные координаты
	rosservice call /turtle1/teleport_absolute $1 $2 0.0
}

teleportpen(){ #перемещение черепашки в указанные координаты, не оставляя след
	rosservice call /turtle1/set_pen  0 0 0 5 on
	rosservice call /turtle1/teleport_absolute $1 $2 0.0
	rosservice call /turtle1/set_pen  255 177 10 5 off
}

#ниже представлены функции для рисования цифр посредством чередования вышезаданных функций
two(){
	move 1
	rotate90
	move 1
	rotate90
	move 1
	crotate90
	move 1
	crotate90
	move 1
}

four(){
	rotate90
	move 1
	crotate90
	move 1
	crotate90
	move 1
	rotate90
	rotate90
	move 2
}

nine(){
	move 1
	crotate90
	move 2
	crotate90
	move 1
	crotate90
	move 1
	crotate90
	move 1
}

three(){
	move 1
	crotate90
	move 1
	crotate90
	move 1
	rotate90
	rotate90
	penoff
	move 1
	crotate90
	penon
	move 1
	crotate90
	move 1
}

#ниже описана функция вычерчивания номера 242293 посредством чередования вышезаданных функций
tabnum(){
teleportpen 0.5 7
two
teleportpen 2 7
four
teleportpen 3.5 7
two
teleportpen 5 7
two
teleportpen 6.5 5
nine
teleportpen 8 5
three
teleportpen 10 5
}

#наконец, можно нарисовать номер
rosservice call /clear
tabnum

