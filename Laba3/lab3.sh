#!/bin/bash
#Размеры поля 12 х 12. В соответствии с этими значениями было принято решение сделать пробелы между цифрами и ширину самих цифр в  6 единиц. 

rotate90(){ # функция для поворота черепашки на месте на 90 градусов по часовой стрелке
		rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[0.0, 0.0, 0.0]' '[0.0, 0.0,-1.564]'
}

crotate90(){ # функция для поворота черепашки на месте на 90 градусов против часовой стрелки
		rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[0.0, 0.0, 0.0]' '[0.0, 0.0,1.564]'
}

move(){ # функция для перемещения вперед на заданное количество шагов
	rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- [$1', 0.0, 0.0]' '[0.0, 0.0,0.0]'
}

penoff(){
	rosservice call /turtle1/set_pen  0 0 0 5 on
}

penon(){
	rosservice call /turtle1/set_pen  255 177 10 5 off
}

teleport(){
	rosservice call /turtle1/teleport_absolute $1 $2 0.0
}

teleportpen(){ # функция, чтобы переместить черепашку в указанные координаты, не оставляя след
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

rosservice call /clear
tabnum

