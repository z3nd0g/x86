
	; wykres(bmp->line, bmp->w, bmp->h, a, b, c, S);
    
    ; rdi - wskaźnik do tablicy wskaźników na początek linii bitmapy
	; rsi - szerokość obrazka
	; rdx - wysokość obrazka
	; xmm0 - a, xmm1 - b, xmm2 - c , xmm3 - S

	; xmm7 - x, od -1 do 1, co 2/szerokość obrazka
	; xmm15 - y = a*x^2 + b*x +c

	; r8 - połowa szerokości
	; r10 - wartość y dla danego x wyrażona w pikselach
	
	; r12 - licznik petli po x (po pikselach, po szerokości obrazka)
    ; r15 = rdi - wskaźnik na bufor

	global wykres
	section .text


wykres:

	push rbp  ;Zapisujemy adres poprzedniej ramki stosu
	mov rbp, rsp  ;ustawiamy nową ramkę stosu - dla bieżącej procedury

	;ustawiamy licznik pętli r12 := 0
    xor r12, r12
    
    ;ustawiamy początkowy x na -1.0 (oś X będziemy mieli w zakresie [-1,-1])
    mov rax, -1
	cvtsi2sd xmm7, rax ;-1.0
	
	;zapisujemy wartość połowy wysokości ekranu, przyda się później
	mov r8, rsi ;wysokość
	shr r8, 1 ;wysokość/2

	;obliczamy długość kroku, jako dlugosc osi X / liczba pikseli na osi X = 2/szerokość
	mov rax, 2
	cvtsi2sd xmm13, rax ;xmm13 = 2.0    
	cvtsi2sd xmm12, rdx ;szerokość
    divsd xmm13, xmm12 	;xmm13 = 2/szerokość

	
petla:

    addsd xmm7, xmm13	;zwiększamy x o długość kroku

    ;obliczenie wartości y
	movsd xmm15, xmm7 ;x
	mulsd xmm15, xmm7 ;x^2
	mulsd xmm15, xmm0 ;a*x^2
	
	movsd xmm5, xmm7 ;x
	mulsd xmm5, xmm1 ;b*x
	
	addsd xmm15, xmm5 ;ax^2 + bx
    addsd xmm15, xmm2 ;ax^2 + bx + c

	;zamiana y na wartość wyrażoną w piskelach (mnożymy przez połowę wysokości wykresu)
	cvtsi2sd xmm12, r8 ;połowa wysokości
	mulsd xmm15, xmm12 ;y w pikselach

	;konwersja do liczby całkowitej:
	cvtsd2si r10, xmm15 ;y w pikselach - liczba całkowita
	add r10, r8 ;dodaj do y połowę wysokości		
    
    ;licznik po x-ach
    inc r12	 ;przechodzimy do kolejnego piksela na osi X
	cmp r12, rsi ;rsi = szerokość obrazka
	jg koniec  ;sprawdzamy czy dotarliśmy do końca

	;sprawdzenie czy y nie wyszedł poza zakres obrazka
	cmp r10, rdx ; wysokość obrazka
	jg petla
	cmp r10, 1
	jl petla

	mov r15, rdi ;r15 - wskaznik na tablicę wskaźników linii bitmapy
	mov r9, rdx ;rdx to wysokość
	sub r9, r10 ;wysokosc - y piksela 
	shl r9, 3 ;
	add r15, r9 ;przesuwamy wskaźnik na odpowiednią linię bitmapy

	;wpisujemy czarny kolor w odpowiednie miejsce w buforze
	mov rbx, [r15] ; wpisujemy do rbx wskaznik na linię bitmapy
	add rbx, r12   ; przechodzimy na odpowiedni piksel w tej linii
	xor al, al		
	mov [rbx], al  ; wpisujemy tam czarny kolor	

	jmp petla


koniec:	

	mov rsp, rbp	; restore original stack pointer
	pop rbp		; restore "calling procedure" frame pointer
	ret
