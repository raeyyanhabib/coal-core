[org 0x100]
jmp start

title1    db '====================================', 0
title2    db '                                    ', 0
title3    db '       B A L L O O N   P O P        ', 0
title4    db '                                    ', 0
title5    db '====================================', 0
startBtn  db '    START     Press S', 0
exitBtn   db '    EXIT      Press E', 0
scoreMsg  db 'SCORE: 0000', 0
gameInfo  db 'Pop balloons by typing their letters!', 0
timeInfo  db 'Time Limit: 2 Minutes', 0

balloon1  db '  @  ', 0
balloon2  db ' @@@ ', 0
balloon3  db '@@@@@', 0
balloon4  db ' @@@ ', 0
balloon5  db '  @  ', 0
balloon6  db '  |  ', 0

ClrScr:
    push cx
    push di
    push ax
    push es
    
    mov ax, 0xB800
    mov es, ax
    mov cx, 2000
    mov di, 0
    mov ax, 0x3020
    
clear:
    mov [es:di], ax
    add di, 2
    loop clear
    
    pop es
    pop ax
    pop di
    pop cx
    ret


printStr:
    push ax
    push bx
    push cx
    push di
    push es
    
    mov ax, 0xB800
    mov es, ax
    
    mov al, dh
    mov cl, 80
    mul cl
    add al, dl
    adc ah, 0
    shl ax, 1
    mov di, ax
    
    mov bh, bl
    
printLoop:
    mov bl, [si]
    cmp bl, 0
    je printDone
    mov [es:di], bl
    inc di
    mov [es:di], bh
    inc di
    inc si
    jmp printLoop
    
printDone:
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret


drawBalloon:
    push dx
    push si
    
    mov si, balloon1
    call printStr
    
    inc dh
    pop si
    push si
    mov si, balloon2
    call printStr
    
    inc dh
    pop si
    push si
    mov si, balloon3
    call printStr
    
    inc dh
    pop si
    push si
    mov si, balloon4
    call printStr
    
    inc dh
    pop si
    push si
    mov si, balloon5
    call printStr
    
    inc dh
    pop si
    push si
    mov si, balloon6
    call printStr
    
    pop si
    pop dx
    ret

start:
    call ClrScr
    
    mov dh, 2
    mov dl, 5
    mov bl, 0x3C
    call drawBalloon
    
    mov dh, 3
    mov dl, 70
    mov bl, 0x3E
    call drawBalloon
    
    mov dh, 18
    mov dl, 8
    mov bl, 0x3D
    call drawBalloon
    
    mov dh, 17
    mov dl, 68
    mov bl, 0x3A
    call drawBalloon
    
    mov dh, 1
    mov dl, 34
    mov si, scoreMsg
    mov bl, 0x3F
    call printStr
    
    mov dh, 6
    mov dl, 22
    mov si, title1
    mov bl, 0x3E
    call printStr
    
    mov dh, 7
    mov dl, 22
    mov si, title2
    mov bl, 0x3E
    call printStr
    
    mov dh, 8
    mov dl, 22
    mov si, title3
    mov bl, 0x3F
    call printStr
    
    mov dh, 9
    mov dl, 22
    mov si, title4
    mov bl, 0x3E
    call printStr
    
    mov dh, 10
    mov dl, 22
    mov si, title5
    mov bl, 0x3E
    call printStr
    
    mov dh, 12
    mov dl, 21
    mov si, gameInfo
    mov bl, 0x3B
    call printStr
    
    mov dh, 13
    mov dl, 29
    mov si, timeInfo
    mov bl, 0x3B
    call printStr
    
    mov dh, 16
    mov dl, 30
    mov si, startBtn
    mov bl, 0x3A
    call printStr
    
    mov dh, 18
    mov dl, 30
    mov si, exitBtn
    mov bl, 0x3C
    call printStr
    
    mov ah, 0
    int 16h
    
    mov ax, 0x4C00
    int 21h
