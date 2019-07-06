# Godot-3D-Player-Controller

![Screenshot](https://imgur.com/n5JH4cG.png)

This project is ment as a starter 3D player controller for Godot 3.1. The player object consists of a collision model and the ability to jump, sprint, look around, and walk. You can easily modify the controler do add functionality such as climbing ladders or third person perspective by moving the camera behind the player. The player script also exports a lot of useful variables that can be adjusted to suit your project.

***

### Setup
To implement the 3D controller in your own project copy the player layout as seen in image below. Then add script `Player.gd` to the kinematic body "Player".

![Layout](https://imgur.com/XZZrFp4.png)

Now map the input controls under `Project > Project Settings > Input Map` as seen below.

<img src="https://imgur.com/0TdxnUi.png" width="512">

Remember to change the physics fps to the same as the display refresh rate or flickering will appare.

All done.

***

![Gif](https://media.giphy.com/media/jRxGHB9HilE5hZFR15/giphy.gif)
