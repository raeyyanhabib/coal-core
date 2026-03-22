[org 0x100]
jmp start

scoreLabel db 'SCORE: 0000', 0
timeLabel  db 'TIME: 01:45', 0
pauseMsg   db 'Press ESC to Pause', 0
balloon1  db '000', 0
balloon2  db '0 0', 0
balloon3  db '000', 0
balloon4  db ' | ', 0
ground1 db '################################################################################', 0
cloud1    db '  .:::.  ', 0
cloud2    db ' :     : ', 0
cloud3    db ':       :', 0
cloud4    db ' :     : ', 0
cloud5    db '  :::::.  ', 0
starPos   dw 2,15, 2,30, 2,45, 2,60, 2,70
          dw 3,10, 3,35, 3,50, 3,65
          dw 4,5, 4,20, 4,40, 4,55, 4,72
          dw 5,12, 5,28, 5,50, 5,65
          dw 6,10, 6,35, 6,55, 6,70
          dw 7,15, 7,30, 7,48, 7,62
          dw 8,5, 8,38, 8,60, 8,73
          dw 9,12, 9,52, 9,70
          dw 20,15, 20,30, 20,65, 20,73
          dw 21,10, 21,30, 21,50, 21,65
          dw 22,5, 22,20, 22,35, 22,52, 22,68
          dw 23,12, 23,28, 23,48, 23,62, 23,75
starCount dw 51
cloudPos  dw 0,0
cloudCount dw 0
frameCount db 0

ClrScr:
    push cx
    push di
    push ax
    push es

    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov cx, 2000
    mov ax, 0x0020

clearScreen:
    mov [es:di], ax
    add di, 2
    loop clearScreen

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

printChar:
    push ax
    push bx
    push cx
    push di
    push es
    push dx

    mov cl, al
    mov ax, 0xB800
    mov es, ax

    mov al, dh
    mov ch, 80
    mul ch
    add al, dl
    adc ah, 0
    shl ax, 1
    mov di, ax

    mov al, cl
    mov [es:di], al
    inc di
    mov [es:di], bl

    pop dx
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

drawStars:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    mov si, starPos
    mov cx, [starCount]
    mov di, 0

starLoop:
    push cx

    lodsw
    mov dh, al
    lodsw
    mov dl, al

    mov al, dl
    add al, dh
    mov bp, ax

    mov ax, di
    and ax, 0x07

    cmp al, 0
    je speed0
    cmp al, 1
    je speed1
    cmp al, 2
    je speed2
    cmp al, 3
    je speed3
    cmp al, 4
    je speed4
    cmp al, 5
    je speed5
    cmp al, 6
    je speed6
    jmp speed7

speed0:
    mov al, [frameCount]
    mov cl, 3
    shr al, cl
    jmp calcBrightness

speed1:
    mov al, [frameCount]
    mov cl, 2
    shr al, cl
    jmp calcBrightness

speed2:
    mov al, [frameCount]
    mov cl, 1
    shr al, cl
    jmp calcBrightness

speed3:
    mov al, [frameCount]
    jmp calcBrightness

speed4:
    mov al, [frameCount]
    add al, al
    jmp calcBrightness

speed5:
    mov al, [frameCount]
    mov cl, al
    add al, al
    add al, cl
    jmp calcBrightness

speed6:
    mov al, [frameCount]
    add al, al
    add al, al
    jmp calcBrightness

speed7:
    mov al, [frameCount]
    add al, al
    add al, al
    add al, al

calcBrightness:
    add ax, bp
    and al, 0x07

    cmp al, 0
    je brightStar
    cmp al, 1
    je brightStar
    cmp al, 2
    je mediumStar
    cmp al, 3
    je mediumStar
    cmp al, 4
    je mediumStar
    cmp al, 5
    je dimStar
    cmp al, 6
    je dimStar
    jmp veryDimStar

brightStar:
    mov bl, 0x0F
    mov al, '*'
    jmp drawStar

mediumStar:
    mov bl, 0x07
    mov al, '*'
    jmp drawStar

dimStar:
    mov bl, 0x08
    mov al, '.'
    jmp drawStar

veryDimStar:
    mov bl, 0x07
    mov al, '.'

drawStar:
    call printChar

    inc di
    pop cx
    dec cx
    cmp cx, 0
    je starsDone
    jmp starLoop

starsDone:
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

drawCloudAnimated:
    push dx
    push si
    push ax
    push bx

    mov ah, al
    add ah, [frameCount]
    and ah, 0x01

    cmp ah, 0
    je normalCloud
    mov bl, 0x08
    jmp cloudSet
normalCloud:
    mov bl, 0x07

cloudSet:
    mov si, cloud1
    call printStr

    inc dh
    pop si
    push si
    mov si, cloud2
    call printStr

    inc dh
    pop si
    push si
    mov si, cloud3
    call printStr

    inc dh
    pop si
    push si
    mov si, cloud4
    call printStr

    inc dh
    pop si
    push si
    mov si, cloud5
    call printStr

    pop bx
    pop ax
    pop si
    pop dx
    ret

drawClouds:
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, cloudPos
    mov cx, [cloudCount]
    mov bl, 0

cloudLoop:
    push cx

    mov dx, [si]
    add si, 2

    mov al, bl
    call drawCloudAnimated

    inc bl

    pop cx
    loop cloudLoop

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

drawBalloon:
    push dx
    push si
    push bx
    push ax

    mov ah, 0x00

    mov ch, bl
    mov cl, bh

    mov bl, ch
    and bl, 0x0F
    or bl, ah
    mov si, balloon1
    call printStr

    inc dh

    push dx
    mov bl, ch
    and bl, 0x0F
    or bl, ah
    mov al, '0'
    call printChar

    inc dl
    mov al, cl
    mov bl, 0x8F
    call printChar

    inc dl
    mov al, '0'
    mov bl, ch
    and bl, 0x0F
    or bl, ah
    call printChar
    pop dx

    inc dh

    mov bl, ch
    and bl, 0x0F
    or bl, ah
    mov si, balloon3
    call printStr

    inc dh

    mov bl, 0x08
    mov si, balloon4
    call printStr

    pop ax
    pop bx
    pop si
    pop dx
    ret

drawGround:
    push dx
    push si
    push bx

    mov dh, 24
    mov dl, 0
    mov bl, 0x06
    mov si, ground1
    call printStr

    pop bx
    pop si
    pop dx
    ret

animate:
    mov al, [frameCount]
    inc al
    and al, 0x3F
    mov [frameCount], al

    call drawStars

    push cx
    mov cx, 0xFFFF
delayLoop:
    loop delayLoop
    pop cx
    ret

start:
    call ClrScr

    call drawStars

    mov dh, 20
    mov dl, 0
    mov bl, 0x00
    mov si, ground1
    call printStr

    call drawGround

    mov dh, 0
    mov dl, 2
    mov si, scoreLabel
    mov bl, 0x0E
    call printStr

    mov dh, 0
    mov dl, 35
    mov si, timeLabel
    mov bl, 0x0B
    call printStr

    mov dh, 0
    mov dl, 58
    mov si, pauseMsg
    mov bl, 0x07
    call printStr

    mov dh, 18
    mov dl, 8
    mov bl, 0x0C
    mov bh, 'A'
    call drawBalloon

    mov dh, 12
    mov dl, 20
    mov bl, 0x0E
    mov bh, 'K'
    call drawBalloon

    mov dh, 15
    mov dl, 32
    mov bl, 0x0D
    mov bh, 'M'
    call drawBalloon

    mov dh, 10
    mov dl, 44
    mov bl, 0x0A
    mov bh, 'R'
    call drawBalloon

    mov dh, 17
    mov dl, 56
    mov bl, 0x0B
    mov bh, 'T'
    call drawBalloon

    mov dh, 14
    mov dl, 68
    mov bl, 0x0C
    mov bh, 'B'
    call drawBalloon

    mov dh, 11
    mov dl, 5
    mov bl, 0x0D
    mov bh, 'H'
    call drawBalloon

    mov dh, 19
    mov dl, 42
    mov bl, 0x0A
    mov bh, 'P'
    call drawBalloon

    mov dh, 13
    mov dl, 75
    mov bl, 0x0E
    mov bh, 'D'
    call drawBalloon

    mov dh, 16
    mov dl, 25
    mov bl, 0x0B
    mov bh, 'F'
    call drawBalloon

animLoop:
    mov ah, 1
    int 16h
    jnz keyPressed

    call animate
    jmp animLoop

keyPressed:
    mov ah, 0
    int 16h

    mov ax, 0x4C00
    int 21h



gamescreen(correct)