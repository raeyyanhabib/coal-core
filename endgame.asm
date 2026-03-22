[org 0x100]
jmp start

gameOver1 db '====================================', 0
gameOver2 db '                                    ', 0
gameOver3 db '         G A M E   O V E R         ', 0
gameOver4 db '                                    ', 0
gameOver5 db '====================================', 0

thankMsg  db 'Thank You for Playing!', 0
finalScore db 'FINAL SCORE: 0850', 0

restartBtn db '    RESTART    Press R', 0
exitBtn    db '    EXIT       Press E', 0

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
    mov bl, 0x35
    call drawBalloon
    
    mov dh, 3
    mov dl, 70
    mov bl, 0x31
    call drawBalloon
    
    mov dh, 17
    mov dl, 8
    mov bl, 0x36
    call drawBalloon
    
    mov dh, 17
    mov dl, 68
    mov bl, 0x34
    call drawBalloon
    
    mov dh, 6
    mov dl, 22
    mov si, gameOver1
    mov bl, 0xB4
    call printStr
    
    mov dh, 7
    mov dl, 22
    mov si, gameOver2
    mov bl, 0xB4
    call printStr
    
    mov dh, 8
    mov dl, 22
    mov si, gameOver3
    mov bl, 0xB4
    call printStr
    
    mov dh, 9
    mov dl, 22
    mov si, gameOver4
    mov bl, 0xB4
    call printStr
    
    mov dh, 10
    mov dl, 22
    mov si, gameOver5
    mov bl, 0xB4
    call printStr
    
    mov dh, 12
    mov dl, 29
    mov si, thankMsg
    mov bl, 0xB4
    call printStr
    
    mov dh, 14
    mov dl, 32
    mov si, finalScore
    mov bl, 0x37
    call printStr
    
    mov dh, 17
    mov dl, 28
    mov si, restartBtn
    mov bl, 0x37
    call printStr
    
    mov dh, 19
    mov dl, 28
    mov si, exitBtn
    mov bl, 0x36
    call printStr
    
    mov ah, 0
    int 16h
    
    mov ax, 0x4C00
    int 21h
