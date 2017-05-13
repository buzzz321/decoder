	    ;;  nasm -felf64 -g -F dwarf chucky.asm
	    ;;  ld chucky.o -o chucky

	sys_exit        equ     1
	sys_write       equ     1
	stdout          equ     1
	newline         equ     10    


	        global  _start

	        section .text
_start:
	                                    ; write(1, message, 13)
	mov     rax, sys_write          ; system call 1 is write
	mov     rdi, stdout                 	    ; file handle 1 is stdout
	mov     rsi, message            ; address of string to output
	mov     rdx, 13                 ; number of bytes
	syscall                         ; invoke operating system to do the write
    
	mov rax,secend-secret
    xor rax, rax

    call decode
    
   	mov     rax, sys_write          ; system call 1 is write
	mov     rdi, stdout        	    ; file handle 1 is stdout
	mov     rsi, plaintext          ; address of string to output
	mov     rdx, secend-secret+1    ; number of bytes
	syscall                         ; invoke operating system to do the write
  
	                                ; exit(0)
	mov     eax, 60                 ; system call 60 is exit
	xor     rdi, rdi                ; exit code 0
	syscall                         ; invoke operating system to exit
    
decode:
    push rcx                    ; guess it is nice to be a good citizen
    push rdi
    push rsi
    push rax
    mov rcx, secend-secret      ; length of secret message
    mov rdi, secret             ; start of secret
    mov rsi, plaintext          ; output buffer

decloop:    
    mov rax, [rdi + rcx - 1]    ; get a byte
    not rax                     ; decode...
    and rax, 0xff               ; mask
    mov [rsi + rcx - 1], al     ; save if
    dec rcx
    jnz decloop                 ; stop at zero
    
    pop rcx
    pop rdi
    pop rsi
    pop rax
    ret

    section .data
message:
	        db      "Hello, World", 10      ; note the newline at the end

secret: db 10110111b, 10111010b, 10110101b
	db 10111011b, 10111010b, 10101011b
	db 11011111b, 10101001b, 10111110b
	db 10101101b, 11011111b, 10101101b
	db 10110000b, 10110011b, 10110110b
	db 10111000b, 10101011b, 11011111b
	db 10111110b, 10101011b, 10101011b
	db 11011111b, 10101011b, 10101101b
	db 00111011b, 10111001b, 10111001b
	db 10111110b, 11011111b, 10111011b
	db 10110110b, 10111000b
secend: db 0

plaintext:  times secend-secret db 0
plainend:   db 10,0
