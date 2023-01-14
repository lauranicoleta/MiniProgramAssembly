.model small
.stack 100h
.data 
    msjmx db "Numarul maxim este:$"
	msjmn db "Numarul minim este:$"
	negativ db ?
	maxim dw ? ;definit pe 16 biti
	minim dw ?
.code
start:
    call citireNr ;1
	
	mov maxim,0
	mov minim,0
	
	mov maxim, dx
	mov minim, dx
	
	call citireNr ;2
	call comparare
	call citireNr ;3
	call comparare
	call citireNr ;4
	call comparare
    call citireNr ;5
	call comparare
	call citireNr ;6
	call comparare
	call citireNr ;7
	call comparare
	call citireNr ;8
	call comparare
	call citireNr ;9
	call comparare
	call citireNr ;10
	call comparare

	mov ax,@data
    mov ds, ax
	mov dx, offset msjmx  ;afiseaza mesajul pentru afisarea maximului
	mov ah, 09h
	int 21h

    xor ax,ax
	xor dx,dx
	
	mov ax, maxim
	call afisareNr
	

	mov dl, 10
    mov ah, 02h  ;new line
    int 21h
	
	mov ax,@data
    mov ds, ax
	mov dx, offset msjmn ;se incarca in dx adresa variabilei mesajmn
	mov ah, 09h ;afiseaza mesajul pentru afisarea minimului
	int 21h

    xor ax,ax
	xor dx,dx 
	
	mov ax, minim
	call afisareNr
	
	

jmp skipProceduri 
	
citireNr proc ;numarul va fi construit in DX
	mov ax, @data
	mov ds, ax
	
	xor bx, bx
	mov cx, 10
	
	mov ah, 01h ; se citeste un caracter de la tastatura codul ASCII al caracterului introdus va fi in AL 
	int 21h
	cmp al, '-' ; Jump Equal or Jump Zero
		je esteNegativ
	
	mov negativ, 0
	sub al, 48 ; se obtine valoarea numerica scazandu-se codul lui 0 in ASCII, 48
	mov ah, 0
	mov dx, ax
	jmp citireCifra
	
	esteNegativ:
		mov negativ, 1
		xor dx, dx
	
	citireCifra:
		mov ah, 01h
		int 21h
		cmp al, 13
			je amTerminat
	 	sub al, 48
		mov bl, al
		mov ax, dx
		mul cx    ; inmultim cx cu ax
		add ax, bx
		mov dx, ax
		jmp citireCifra
	
	amTerminat:
	
	cmp negativ, 1
		je transformaInNegativ
	jmp exit
	
	transformaInNegativ:
		neg dx
	
	exit:
	ret
endp

comparare proc
    
	cmp dx, maxim
	    jg maximiaval ;Jump Greater or Jump Not Less/Equal
	
	cmp dx, minim
        jl minimiaval ;Jump Less or Jump Not Greater/Equal
	
	jmp amTerminat1
    
	maximiaval:
       mov maxim,0
        mov maxim, dx
		jmp amTerminat1
		
    minimiaval:
		mov minim,0
        mov minim, dx
	
	amTerminat1:
    
	ret
endp	

afisareNr proc	;numarul de afisat trebuie sa fie in AX

	cmp ax, 0
		jge afiseazaPozitiv ;Jump Greater/Equal or Jump Not Less
	mov cx, ax
	mov dl, '-'
	mov ah, 02h
	int 21h
	neg cx ;multiply operand by -1
	mov ax, cx
	
	afiseazaPozitiv:
	
	mov bx, 10
	xor cx, cx
	
	descompuneNr:
		xor dx, dx
		div bx
		inc cx
		push dx
		cmp ax, 0
			je afiseazaCifre
		jmp descompuneNr
		
		afiseazaCifre:
			pop dx
			add dl, 48
			mov ah, 02h
			int 21h
		loop afiseazaCifre

	ret
endp

skipProceduri:

	mov ah, 4ch ;functia DOS de terminare proces
	int 21h     ;terminare program

end start
