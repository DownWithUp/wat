;wat, the coreutils spin off of cat, for Windows.

Format PE Console
include 'win32a.inc'
entry start

section '.data' data readable writable
szMsgHelp db "Usage: wat [filename]", 0xA, 0
szFile db "%s", 0xA, 0
szArgv db "ARGV[0] = %s", 0xA, 0

section '.bss' readable writable
szFileName rb 256
nArgs dd ?
pArgStr dd ?
nSizeOfFile dd ?
hFile dd ?
lpBytesRead dd ?
hHeap dd ?
pHeapData dd ?

nArgc dd ?
cArgv dd ?
cEnv dd ?
sInfo STARTUPINFO

section '.text' code readable writable executable
showHelp:
        invoke printf, szMsgHelp
        invoke ExitProcess, 0
start:

        cinvoke __getmainargs, nArgc, cArgv, cEnv, 0, sInfo

        cmp [nArgc], 2 ;Must have 2 arguments
        jne showHelp

        mov eax, [cArgv]
        mov eax, [eax]
        invoke strlen, eax ;Length of first argument
        inc eax ;Add 1 byte for 0x00
        add ecx, eax ;Points to second arguemnt

        mov ebx, ecx
        mov DWORD [szFileName], ebx
        invoke CreateFile, ebx, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
        mov [hFile], eax
        invoke GetFileSize, [hFile], 0
        inc eax ;We need +1 0x00 for end line
        mov [nSizeOfFile], eax
        ;Create Heap for our file
        invoke GetProcessHeap
        mov [hHeap], eax
        invoke HeapAlloc, [hHeap], HEAP_ZERO_MEMORY, [nSizeOfFile]
        mov [pHeapData], eax

        invoke ReadFile, [hFile], [pHeapData], [nSizeOfFile], lpBytesRead, 0

        invoke printf, szFile, [pHeapData]
        invoke HeapFree, [hHeap]
        invoke ExitProcess, 0


section '.idata' import readable writable
library kernel32, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

include 'api\kernel32.inc'

import msvcrt,\
       printf, 'printf',\
       fgets, 'fgets',\
       strlen, 'strlen',\
       __p__iob, '__p__iob',\
       __getmainargs, '__getmainargs'
