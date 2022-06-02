# Flood-Recovery-Bot
A virtual prototype of an autonomous robotic recovery system that demonstrates goal-seeking behaviors in navigating through a predefined area.

<p align="center">
  <img src="flood-recovery-bot.gif" />  
</p>

---
## What is it?
A robot simulation that is programmed to aid in disaster recovery.

---
## Table of contents
- [Purpose](#purpose)
- [Method](#method)
- [Installation](#installation)
- [Navigation](#navigation)
- [Reflection](#reflection)
- [Links](#links)

---
## Purpose
The robot’s goal is to detect the humans and animals by sensing heat while avoiding the water and building debris.

---
## Method
I modeled a scene that represents the aftermath of a flood, with models to represent huamn bodies, water puddles and scattered debris. I modified the bubbleRob robot to add an infrared laser which is used to detect the heat, a sensor laser to detect water, and an ultrasonic sensor to detect the building debris. The robot gathers knowledge from the sensors to decide its recovery path, and then uses the results of the sensors to decide which set of instructions to follow. By default, it will follow an uncertain path until something changes, then it will use reasoning to decide what to do next.

---
## Installation
1. Download <a href="https://www.coppeliarobotics.com/downloads" target="_blank">Coppelia Robotics</a>
2. Open scene.ttt
3. Press 'run'
4. Observe flood recovery bot as it navigates through the scene, detecting heat and barriers
5. Press 'stop' to end the simulation
 
---
## Navigation
Run the program from 'main.py'. In the terminal:  
**Make a selection**
- [1] to check on the status of s pecific package, 
  - Enter the package ID to check the status of
  - Enter the time to check the status of the specific package in HH:MM:SS format
- [2] to check on the status of all packages en route. 
  - Enter the time to check the status of all packages in HH:MM:SS format
- The requested information with display with it's delivery status and events

---
## Reflection
To improve the robot’s performance using reinforced learning, I would create an algorithm that first maps the measurements of the room that it is surveying to use in a game that sets an end goal for the robot. It would enable the robot to begin with a completely random, uncertain path, and after trial-and-error, it would develop a sophisticated plan to find the reward, which would be locating the living beings.

---
## Links
