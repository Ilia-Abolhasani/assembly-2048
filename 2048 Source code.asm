; multi-segment executable file template.

data segment
    ; add your data here!
    Rows db 16 dup(0) 
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax               
                 
    call Create  
    call Create   
    ;call start_value
While:                               
        call IsEnd
        cmp al, 1         
        je EndW                          
        call Display                                                                      
        call ReadKey         
        call Clear                            
        call Create    
        jmp While   
EndW:         

    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
    

ends        
;################################
;start_value PROC                             
;    lea si,Rows
;    mov [si],2
;    mov [si+1],2
;    mov [si+2],2
;    mov [si+3],2
;    mov [si+4],3
;    mov [si+5],3
;    mov [si+6],4
;    mov [si+7],4
;    mov [si+8],5
;    mov [si+9],5
;    mov [si+10],5
;    mov [si+11],3
;    mov [si+12],2
;    mov [si+13],5
;    mov [si+14],2
;    mov [si+15],2   
;    ret
;start_value ENDP                             
            
;################################
;mov al, 1  ; If game ends
;mov al, 0  ; else    
IsEnd PROC                             
    mov cx,16    
    lea si, Rows  
    IsEnd_While:         
        mov al,[si]        
        cmp al,0
        jz IsEnd_Con
        inc si
    loop IsEnd_While       
;cheak Horizontal 
mov cx,4
lea si, Rows
IsEnd_cmp_Horizontal:         
    mov al,[si]
    mov ah,[si+1]
    cmp al,ah    
    JE IsEnd_Con        
    mov al,[si+1]
    mov ah,[si+2]
    cmp al,ah    
    JE IsEnd_Con
    mov al,[si+2]
    mov ah,[si+3]
    cmp al,ah    
    JE IsEnd_Con                  
    add si,4
loop IsEnd_cmp_Horizontal    
;cheak Vertical 
mov cx,4
lea si, Rows
IsEnd_cmp_Vertical:               
    mov al,[si]
    mov ah,[si+4]
    cmp al,ah    
    JE IsEnd_Con        
    mov al,[si+4]
    mov ah,[si+8]
    cmp al,ah    
    JE IsEnd_Con
    mov al,[si+8]
    mov ah,[si+12]
    cmp al,ah    
    JE IsEnd_Con                  
    inc si
loop IsEnd_cmp_Vertical    
    mov al, 1 
    ret    
IsEnd_Con:     
    mov al, 0 
    ret    
IsEnd ENDP              
;################################
Up PROC
    call Marge_Up         
    mov cx,4              
    lea si,Rows
    Up_loop:
    mov al,[si] 
    mov ah,[si+4]
    cmp al,ah
    jnz Up_loop_not_cheange
    cmp al,0
    jz Up_loop_not_cheange        
    inc [si]
    mov [si+4],0
    Up_loop_not_cheange:
    mov al,[si+4] 
    mov ah,[si+8]    
    cmp al,ah
    jnz Up_loop_not_cheange1
    cmp al,0
    jz Up_loop_not_cheange1                
    inc [si+4]
    mov [si+8],0   
    Up_loop_not_cheange1:
    mov al,[si+8]
    mov ah,[si+12]
    cmp al,ah
    jnz Up_loop_not_cheange2
    cmp al,0
    jz Up_loop_not_cheange2                      
    inc [si+8]
    mov [si+12],0   
    Up_loop_not_cheange2:               
    inc si
    loop Up_loop  
    call Marge_Up
    ret       
Up ENDP   
;################################    
Marge_Up PROC
    mov cx ,4    
    lea si, Rows        
    Marge_Up_loop:
        mov di,4
        Marge_Up_loop_shift0:       
        mov al,[si]                
        cmp al,0                               
        jne Marge_Up_loop_shift1
        mov al,[si+4]
        mov [si],al
        mov al,[si+8]
        mov [si+4],al
        mov al,[si+12]
        mov [si+8],al        
        mov [si+12],0                                
        sub di,1
        cmp di,0
        jne Marge_Up_loop_shift0                      
        mov di,3
        Marge_Up_loop_shift1:       
        mov al,[si+4]                
        cmp al,0                               
        jne Marge_Up_loop_shift2        
        mov al,[si+8]
        mov [si+4],al
        mov al,[si+12]
        mov [si+8],al        
        mov [si+12],0                                
        sub di,1
        cmp di,0
        jne Marge_Up_loop_shift1                                    
        Marge_Up_loop_shift2:                 
        mov al,[si+8]                
        cmp al,0                                       
        jne Marge_Up_shift3                
        mov al,[si+12]
        mov [si+8],al        
        mov [si+12],0                                                        
        Marge_Up_shift3:        
        inc si
        loop Marge_Up_loop:    
    ret              
Marge_Up ENDP 
;################################
Down PROC 
    call Marge_Down
    mov cx,4              
    lea si,Rows
    Down_loop:
    mov al,[si+12] 
    mov ah,[si+8]
    cmp al,ah
    jnz Down_loop_not_cheange
    cmp al,0
    jz Down_loop_not_cheange        
    inc [si+12]
    mov [si+8],0
    Down_loop_not_cheange:
    mov al,[si+8] 
    mov ah,[si+4]    
    cmp al,ah
    jnz Down_loop_not_cheange1
    cmp al,0
    jz Down_loop_not_cheange1                
    inc [si+8]
    mov [si+4],0   
    Down_loop_not_cheange1:
    mov al,[si+4]
    mov ah,[si]
    cmp al,ah
    jnz Down_loop_not_cheange2
    cmp al,0
    jz Down_loop_not_cheange2                      
    inc [si+4]
    mov [si],0   
    Down_loop_not_cheange2:               
    inc si
    loop Down_loop  
    call Marge_Down
    ret      
Down ENDP   
;################################   
Marge_Down PROC
    mov cx ,4    
    lea si, Rows        
    Marge_Down_loop:
        mov di,4
        Marge_Down_loop_shift0:       
        mov al,[si+12]                
        cmp al,0                               
        jne Marge_Down_loop_shift1
        mov al,[si+8]
        mov [si+12],al
        mov al,[si+4]
        mov [si+8],al
        mov al,[si]
        mov [si+4],al        
        mov [si],0                                
        sub di,1
        cmp di,0
        jne Marge_Down_loop_shift0                      
        mov di,3
        Marge_Down_loop_shift1:       
        mov al,[si+8]                
        cmp al,0                               
        jne Marge_Down_loop_shift2        
        mov al,[si+4]
        mov [si+8],al
        mov al,[si]
        mov [si+4],al        
        mov [si],0                                
        sub di,1
        cmp di,0
        jne Marge_Down_loop_shift1                                    
        Marge_Down_loop_shift2:                 
        mov al,[si+4]                
        cmp al,0                                       
        jne Marge_Down_shift3                
        mov al,[si]
        mov [si+4],al        
        mov [si],0                                                        
        Marge_Down_shift3:        
        inc si     
        loop Marge_Down_loop:    
    ret              
Marge_Down ENDP 
;################################
Left PROC   
    call Marge_Left                           
    mov cx,4              
    lea si,Rows
    Left_loop:
    mov al,[si] 
    mov ah,[si+1]
    cmp al,ah
    jnz Left_loop_not_cheange
    cmp al,0
    jz Left_loop_not_cheange        
    inc [si]
    mov [si+1],0
    Left_loop_not_cheange:
    mov al,[si+1] 
    mov ah,[si+2]    
    cmp al,ah
    jnz Left_loop_not_cheange1
    cmp al,0
    jz Left_loop_not_cheange1                
    inc [si+1]
    mov [si+2],0   
    Left_loop_not_cheange1:
    mov al,[si+2]
    mov ah,[si+3]
    cmp al,ah
    jnz Left_loop_not_cheange2
    cmp al,0
    jz Left_loop_not_cheange2                      
    inc [si+2]
    mov [si+3],0   
    Left_loop_not_cheange2:               
    add si,4
    loop Left_loop          
    call Marge_Left
    ret
Left ENDP

;################################
Marge_Left PROC
    mov cx ,4    
    lea si, Rows        
    Marge_Left_loop:
        mov di,4
        Marge_Left_loop_shift0:       
        mov al,[si]                
        cmp al,0                               
        jne Marge_Left_loop_shift1
        mov al,[si+1]
        mov [si],al
        mov al,[si+2]
        mov [si+1],al
        mov al,[si+3]
        mov [si+2],al        
        mov [si+3],0                                
        sub di,1
        cmp di,0
        jne Marge_Left_loop_shift0                      
        mov di,3
        Marge_Left_loop_shift1:       
        mov al,[si+1]                
        cmp al,0                               
        jne Marge_Left_loop_shift2        
        mov al,[si+2]
        mov [si+1],al
        mov al,[si+3]
        mov [si+2],al        
        mov [si+3],0                                
        sub di,1
        cmp di,0
        jne Marge_Left_loop_shift1                                    
        Marge_Left_loop_shift2:                 
        mov al,[si+2]                
        cmp al,0                                       
        jne Marge_Left_shift3                
        mov al,[si+3]
        mov [si+2],al        
        mov [si+3],0                                                        
        Marge_Left_shift3:        
        add si,4           
        loop Marge_Left_loop:    
    ret              
Marge_Left ENDP  
;################################   
Right PROC 
    call Marge_Right             
    mov cx,4              
    lea si,Rows
    Right_loop:
    mov al,[si+3] 
    mov ah,[si+2]
    cmp al,ah
    jnz Right_loop_not_cheange
    cmp al,0
    jz Right_loop_not_cheange          
    inc [si+3]
    mov [si+2],0
    Right_loop_not_cheange:
    mov al,[si+2] 
    mov ah,[si+1]    
    cmp al,ah
    jnz Right_loop_not_cheange1
    cmp al,0
    jz Right_loop_not_cheange1                
    inc [si+2]
    mov [si+1],0   
    Right_loop_not_cheange1:
    mov al,[si+1]
    mov ah,[si]
    cmp al,ah
    jnz Right_loop_not_cheange2
    cmp al,0
    jz Right_loop_not_cheange2                      
    inc [si+1]
    mov [si],0   
    Right_loop_not_cheange2:               
    add si,4
    loop Right_loop      
    call Marge_Right                                                          
    ret
Right ENDP   
;################################
Marge_Right PROC
      mov cx ,4    
    lea si, Rows        
    Marge_Right_loop:
        mov di,4
        Marge_Right_loop_shift0:       
        mov al,[si+3]                
        cmp al,0                               
        jne Marge_Right_loop_shift1
        mov al,[si+2]
        mov [si+3],al
        mov al,[si+1]
        mov [si+2],al
        mov al,[si]
        mov [si+1],al        
        mov [si],0                                
        sub di,1
        cmp di,0
        jne Marge_Right_loop_shift0                      
        mov di,3
        Marge_Right_loop_shift1:       
        mov al,[si+2]                
        cmp al,0                               
        jne Marge_Right_loop_shift2        
        mov al,[si+1]
        mov [si+2],al
        mov al,[si]
        mov [si+1],al        
        mov [si],0                                
        sub di,1
        cmp di,0
        jne Marge_Right_loop_shift1                                    
        Marge_Right_loop_shift2:                 
        mov al,[si+1]                
        cmp al,0                                       
        jne Marge_Right_shift3                
        mov al,[si]
        mov [si+1],al        
        mov [si],0                                                        
        Marge_Right_shift3:        
        add si,4           
        loop Marge_Right_loop: 
    ret              
Marge_Right ENDP               
;################################
Clear PROC 
    mov ax,0003h
    int 10h 
    ret
Clear ENDP        
;################################
Display PROC 
    mov dh,0
    mov cx,16
    lea si, Rows
    mov bl,1 ;count to four
    mov bh,0 ;    
    Display_loop:               
    cmp bl,5
   jnz Display_not_new_line        
	add dh,3
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h		
    mov bl,1  
    Display_not_new_line:
    mov dl,[si]        
    cmp dl,0
    jnz Display_not_show_0    
    call   printme
    db '[]   ', 0              
    jmp Display_not_show:
    Display_not_show_0:
    cmp dl,1    
    jnz Display_not_show_2
    call   printme
    db '2    ', 0                  
    jmp Display_not_show:
    Display_not_show_2:
    cmp dl,2
    jnz Display_not_show_4
    call   printme
    db '4    ', 0                
    jmp Display_not_show:
    Display_not_show_4:
    cmp dl,3
    jnz Display_not_show_8
    call   printme
    db '8    ', 0                    
    jmp Display_not_show:
    Display_not_show_8:
    cmp dl,4
    jnz Display_not_show_16
    call   printme
    db '16   ', 0              
    jmp Display_not_show:
    Display_not_show_16:
    cmp dl,5
    jnz Display_not_show_32
    call   printme
    db '32   ', 0              
    jmp Display_not_show:
    Display_not_show_32: 
    cmp dl,6        
    jnz Display_not_show_64    
    call   printme
    db '64   ', 0              
    jmp Display_not_show:
    Display_not_show_64:
    cmp dl,7
    jnz Display_not_show_128
    call   printme
    db '128  ', 0              
    jmp Display_not_show:
    Display_not_show_128: 
    cmp dl,8
    jnz Display_not_show_256
    call   printme
    db '256  ', 0           
    jmp Display_not_show:
    Display_not_show_256:
    cmp dl,9
    jnz Display_not_show_512
    call   printme
    db '512  ', 0          
    jmp Display_not_show:
    Display_not_show_512:
    cmp dl,10
    jnz Display_not_show_1024         
    call   printme
    db '1024 ', 0         
    jmp Display_not_show:
    Display_not_show_1024:
    cmp dl,11
    jnz Display_not_show_2048
    call   printme
    db '2048 ', 0        
    jmp Display_not_show:
    Display_not_show_2048:
    cmp dl,12
    jnz Display_not_show_4096
    call   printme
    db '4096 ', 0     
    jmp Display_not_show:
    Display_not_show_4096:
    cmp dl,12
    jnz Display_not_show
    call   printme
    db '8192 ', 0 
    Display_not_show:      
    inc si
    inc bl
    loop Display_loop   
    ret          
Display ENDP
;################################
printme:

mov     cs:temp1, si  ; protect si register.

pop     si            ; get return address (ip).

push    ax            ; store ax register.

next_char:      
        mov     al, cs:[si]
        inc     si            ; next byte.
        cmp     al, 0
        jz      printed        
        mov     ah, 0eh       ; teletype function.
        int     10h
        jmp     next_char     ; loop.
printed:

pop     ax            ; re-store ax register.

; si should point to next command after
; the call instruction and string definition:
push    si            ; save new return address into the stack.

mov     si, cs:temp1  ; re-store si register.

ret
; variable to store original
; value of si register.
temp1  dw  ? 
;################################
ReadKey PROC   
    ReadKey_repeat:
    mov ah,0
    int 0x16    
    cmp ah,0x48
    jne ReadKey_dont_Up
    call Up 
    ret
    ReadKey_dont_Up: 
    cmp ah,0x4B
    jne ReadKey_dont_Left
    call Left
    ret
    ReadKey_dont_Left: 
    cmp ah,0x4D
    jne ReadKey_dont_Right
    call Right 
    ret
    ReadKey_dont_Right: 
    cmp ah,0x50
    jne ReadKey_dont_Down
    call Down 
    ret            
    ReadKey_dont_Down:     
    cmp ah,1    
    jne ReadKey_repeat
    mov ax, 4c00h ; exit to operating system.
    int 21h        
    ret
ReadKey ENDP
;################################
Create PROC     
    mov dx, 0 
    sub dx, 1
    
    ;;; cx is random number between 1 16            
    ;;; cx is random number between 1 16
Create_While: 
    add dx, 1
    cmp dx, 10h                                   
    jnz Create_Jmp                                
    sub dx, dx;mov dx , 0 
Create_Jmp:                                 
    lea si, Rows
    add si, dx    
    mov al, [si]                          
    cmp al, 0 
    jz Create_EndW                       
    jmp Create_While 
Create_EndW: 
    loop Create_While
    mov [si], 1
    ret      
Create ENDP  
;################################

end start ; set entry point and stop the assembler.
