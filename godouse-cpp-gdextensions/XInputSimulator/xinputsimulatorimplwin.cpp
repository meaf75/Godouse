
//    Copyright 2013 Dustin Bensing

//    This file is part of XInputSimulator.

//    XInputSimulator is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Lesser Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    any later version.

//    XInputSimulator is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Lesser Public License for more details.

//    You should have received a copy of the GNU Lesser Public License
//    along with XInputSimulator.  If not, see <http://www.gnu.org/licenses/>.

#ifdef _WIN32

#include "xinputsimulatorimplwin.h"
#include "xinputsimulator.h"
#include "notimplementedexception.h"
#include <iostream>

#include <Windows.h>

#define MOUSEEVENTF_HWHEEL 0x01000

XInputSimulatorImplWin::XInputSimulatorImplWin()
{
    this->initCurrentMousePosition();
}

void XInputSimulatorImplWin::initCurrentMousePosition()
{
    POINT p;
    if (GetCursorPos(&p))
    {
        this->currentX = p.x;
        this->currentY = p.y;
    }
}

void XInputSimulatorImplWin::mouseMoveTo(int x, int y)
{
    SetCursorPos(x, y);

    this->currentX = x;
    this->currentY = y;
}

void XInputSimulatorImplWin::mouseMoveRelative(int x, int y)
{
    int newX = this->currentX + x;
    int newY = this->currentY + y;

    SetCursorPos(newX, newY);

    this->currentX = newX;
    this->currentY = newY;
}

void XInputSimulatorImplWin::mouseDown(int button)
{
    INPUT in={0};
    in.type = INPUT_MOUSE;

    if (button == XInputSimulator::LEFT_MOUSE_BUTTON) { // Left button
        in.mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    } else if (button == XInputSimulator::RIGHT_MOUSE_BUTTON) { // Right button
        in.mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;
    } else if (button == XInputSimulator::MIDDLE_MOUSE_BUTTON) { // Middle button
        in.mi.dwFlags = MOUSEEVENTF_MIDDLEDOWN;
    }

    SendInput(1,&in,sizeof(INPUT));
    ZeroMemory(&in,sizeof(INPUT));
}

void XInputSimulatorImplWin::mouseUp(int button)
{
    INPUT in={0};
    in.type = INPUT_MOUSE;

    if (button == XInputSimulator::LEFT_MOUSE_BUTTON) { // Left button
        in.mi.dwFlags = MOUSEEVENTF_LEFTUP;
    } else if (button == XInputSimulator::RIGHT_MOUSE_BUTTON) { // Right button
        in.mi.dwFlags = MOUSEEVENTF_RIGHTUP;
    } else if (button == XInputSimulator::MIDDLE_MOUSE_BUTTON) { // Middle button
        in.mi.dwFlags = MOUSEEVENTF_MIDDLEUP;
    }

    SendInput(1,&in,sizeof(INPUT));
    ZeroMemory(&in,sizeof(INPUT));
}

void XInputSimulatorImplWin::mouseClick(int button)
{
    this->mouseDown(button);
    //std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    this->mouseUp(button);
}

void XInputSimulatorImplWin::mouseScrollX(int length)
{
    int scrollDirection = 1 * 50; // 1 left -1 right

    if(length < 0){
        length *= -1;
        scrollDirection *= -1;
    }

    for(int cnt = 0; cnt < length; cnt++)
    {
        INPUT in;
        in.type = INPUT_MOUSE;
        in.mi.dx = 0;
        in.mi.dy = 0;
        in.mi.dwFlags = MOUSEEVENTF_HWHEEL;
        in.mi.time = 0;
        in.mi.dwExtraInfo = 0;
        in.mi.mouseData = scrollDirection;// WHEEL_DELTA;
        SendInput(1,&in,sizeof(in));
    }
}

void XInputSimulatorImplWin::mouseScrollY(int length)
{
    int scrollDirection = -1 * 50; // 1 up -1 down

    if(length < 0){
        length *= -1;
        scrollDirection *= -1;
    }

    for(int cnt = 0; cnt < length; cnt++)
    {
        INPUT in;
        in.type = INPUT_MOUSE;
        in.mi.dx = 0;
        in.mi.dy = 0;
        in.mi.dwFlags = MOUSEEVENTF_WHEEL;
        in.mi.time = 0;
        in.mi.dwExtraInfo = 0;
        in.mi.mouseData = scrollDirection;// WHEEL_DELTA;
        SendInput(1,&in,sizeof(in));
    }
}

std::tuple<int,int> XInputSimulatorImplWin::getCursorPosition(){
    POINT p;
    GetCursorPos(&p);
    return std::make_tuple(p.x, p.y);
}

void XInputSimulatorImplWin::keyDown(int key) {
    // Press the key
    INPUT input = {};
    input.type = INPUT_KEYBOARD;
    input.ki.wVk = get_key_code_from_int(key);
    SendInput(1, &input, sizeof(INPUT));
}

void XInputSimulatorImplWin::keyUp(int key) {
    // Release the key
    INPUT input = {};
    input.type = INPUT_KEYBOARD;
    input.ki.wVk = get_key_code_from_int(key);
    input.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, &input, sizeof(INPUT));
}

void XInputSimulatorImplWin::keyClick(int key) {
    keyDown(key);
    keyUp(key);
}

int XInputSimulatorImplWin::charToKeyCode(char key_char)
{
    throw NotImplementedException();
}
void XInputSimulatorImplWin::keySequence(const std::string &sequence)
{
    throw NotImplementedException();
}

DWORD XInputSimulatorImplWin::get_key_code_from_int(int key) {
    if (key == XIS::VIRTUAL_KEY_MEDIA_PLAY_PAUSE) {
        return VK_MEDIA_PLAY_PAUSE;
    }
    if (key == XIS::VIRTUAL_KEY_MEDIA_NEXT_TRACK) {
        return VK_MEDIA_NEXT_TRACK;
    }
    if (key == XIS::VIRTUAL_KEY_MEDIA_PREVIOUS_TRACK) {
        return VK_MEDIA_PREV_TRACK;
    }
    
    throw NotImplementedException();
    return 0;
}

#endif //win
