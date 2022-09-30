#!/bin/bash


# first update device
sudo apt update
sudo apt full-upgrade

# install pip if not yet installed
sudo apt install python3-pip

# qt5, tkinter, [more stuff]
sudo apt install qtbase5-dev qtchooser
sudo apt install qt5-qmake qtbase5-dev-tools
sudo apt install qtcreator
sudo apt install qtdeclarative5-dev
sudo apt install python3-pyqt5
sudo apt install pyqt5-dev
sudo apt install pyqt5-dev-tools

# pip qt5 installs
sudo pip3 install pyuic5-tool
sudo pip3 install pyqtgraph

# other useful stuff
sudo apt install git
#sudo apt install subversion
sudo apt install microcom
#sudo apt install putty
sudo apt install dfu-util
sudo apt install python-tk

# other pip installs
#sudo pip3 install rshell
sudo pip3 install pyusb
sudo pip3 install pyvisa
sudo pip3 install pyvisa-py
