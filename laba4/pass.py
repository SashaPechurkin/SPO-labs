#!/usr/bin/env python
# -*- coding: cp1251 -*-

import rospy
import math
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan

class Robot:
	def __init__(self):
        	# Creates a node with name 'turtlebot_controller' and make sure it is a
		# unique node (using anonymous=True).
        	rospy.init_node('antpot', anonymous=True)

        	# Publisher which will publish to the topic '/turtle1/cmd_vel'.
        	self.velocity_publisher = rospy.Publisher('/cmd_vel', Twist, queue_size=10)

        	# A subscriber to the topic '/turtle1/pose'. self.update_pose is called
        	# when a message of type Pose is received.
        	self.pose_subscriber = rospy.Subscriber('/base_scan', LaserScan, self.update_pose)

        	self.pose = LaserScan()
        	for i in range(18):
        		self.pose.ranges.append(0)
        	self.rate = rospy.Rate(10)
		self.dist_forward=0
		self.dist_right=10
		self.dist_left=10

	def update_pose(self, data):
		# 18 датчиков - 6 отвечают за левую сторону,
		# 6 за правую и 6 за переднюю
		# берется минимальное значение с каждой стороны
        	self.pose = data
		self.dist_right=min(self.pose.ranges[0:6])
		self.dist_forward=min(self.pose.ranges[6:12])
		self.dist_left=min(self.pose.ranges[12:18])
	
	
	def labyrint(self):	
		# основная задача робота - ехать вдоль правой стенки
		vel_msg = Twist()
		# если справа далеко до стенки, то надо подъехать к ней поближе
		if (self.dist_right>=0.7) and (self.dist_forward>=0.6):
			print ('move_right')
			vel_msg.linear.x = 0.5
			vel_msg.linear.y = 0
			vel_msg.linear.z = 0
			vel_msg.angular.x = 0
			vel_msg.angular.y = 0
			vel_msg.angular.z = -0.5
		# робот должен держаться на расстоянии
		# от 0.4 до 0.7 клеток от стенки
		elif (self.dist_right<0.7) and (self.dist_right>=0.4) and (self.dist_forward>=0.6):
			print ('move_forward')
			vel_msg.linear.x = 0.5
			vel_msg.linear.y = 0
			vel_msg.linear.z = 0
			vel_msg.angular.x = 0
			vel_msg.angular.y = 0
			vel_msg.angular.z = 0
		elif (self.dist_right<0.4) and (self.dist_forward>=0.6):
			print ('move_left')
			vel_msg.linear.x = 0.5
			vel_msg.linear.y = 0
			vel_msg.linear.z = 0
			vel_msg.angular.x = 0
			vel_msg.angular.y = 0
			vel_msg.angular.z = 0.5
		# если перед роботом стена, то он должен повернуть налево или направо
		elif (self.dist_forward<0.6):
			if (self.dist_right<self.dist_left):
				print ('move_left_around')
				vel_msg.linear.x = 0
				vel_msg.linear.y = 0
				vel_msg.linear.z = 0
				vel_msg.angular.x = 0
				vel_msg.angular.y = 0
				vel_msg.angular.z = 0.5
			else:
				print ('move_right_around')
				vel_msg.linear.x = 0
				vel_msg.linear.y = 0
				vel_msg.linear.z = 0
				vel_msg.angular.x = 0
				vel_msg.angular.y = 0
				vel_msg.angular.z = -0.5
		print ('forward', self.dist_forward)
		print ('right', self.dist_right)
		print ('left', self.dist_left)
		self.velocity_publisher.publish(vel_msg)
		self.rate.sleep()		
		return
	
	def move(self):
		while not rospy.is_shutdown():
			self.labyrint()

if __name__ == '__main__':
    try:
	x = Robot()
	x.move()
    except rospy.ROSInterruptException:
        pass

