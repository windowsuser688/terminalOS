BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Clear screen
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10

    mov si, welcome_msg
    call print_string

main_loop:
    mov si, prompt
    call print_string
    call read_line

    mov si, buffer
    mov di, cmd_help
    call strcmp
    jz do_help

    mov si, buffer
    mov di, cmd_echo
    call strncmp
    jz do_echo

    mov si, buffer
    mov di, cmd_cls
    call strcmp
    jz do_cls

    mov si, buffer
    mov di, cmd_crash
    call strcmp
    jz do_crash

    mov si, buffer
    mov di, cmd_shutdown
    call strcmp
    jz do_shutdown

    mov si, buffer
    mov di, cmd_reboot
    call strcmp
    jz do_reboot

    mov si, newline
    call print_string
    mov si, unknown_msg
    call print_string
    jmp main_loop

do_help:
    mov si, newline
    call print_string
    mov si, help_msg
    call print_string
    jmp main_loop

do_echo:
    mov si, newline
    call print_string
    mov si, buffer+5
    call print_string
    mov si, newline
    call print_string
    jmp main_loop

do_cls:
    mov ax, 0x0600
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    jmp main_loop

do_crash:
    mov si, newline
    call print_string
    mov si, crash_msg
    call print_string
.hang: jmp .hang

do_shutdown:
    mov si, newline
    call print_string
    mov si, shutdown_msg
    call print_string
    mov ax, 0x2000
    mov dx, 0x604
    out dx, ax
    hlt

do_reboot:
    mov si, newline
    call print_string
    mov si, reboot_msg
    call print_string
    jmp 0xFFFF:0x0000

; -------------------------
; Utility routines
; -------------------------

print_string:
.next:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .next
.done:
    ret

read_line:
    mov di, buffer
.read_char:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .done

    cmp al, 0x08        ; Backspace
    je .backspace

    cmp ah, 0x4B        ; Left arrow
    je .left

    cmp ah, 0x4D        ; Right arrow
    je .right

    ; Convert lowercase to uppercase
    cmp al, 'a'
    jb .store
    cmp al, 'z'
    ja .store
    sub al, 32

.store:
    stosb
    mov ah, 0x0E
    int 0x10
    jmp .read_char

.backspace:
    cmp di, buffer
    je .read_char
    dec di
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_char

.left:
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    jmp .read_char

.right:
    mov ah, 0x0E
    mov al, ' '
    int 0x10
    jmp .read_char

.done:
    mov al, 0
    stosb
    ret

strcmp:
.loop:
    lodsb
    scasb
    jne .notequal
    or al, al
    jz .equal
    jmp .loop
.notequal:
    mov ax, 1
    ret
.equal:
    xor ax, ax
    ret

strncmp:
.loop:
    lodsb
    scasb
    jne .notequal
    or al, al
    jz .equal
    cmp di, cmd_echo+4
    je .equal
    jmp .loop
.notequal:
    mov ax, 1
    ret
.equal:
    xor ax, ax
    ret

; -------------------------
; Data (trimmed to fit)
; -------------------------
welcome_msg db "TerminalOS 1.0.0.1",0x0D,0x0A,0
prompt      db "> ",0
unknown_msg db "Unknown",0x0D,0x0A,0
help_msg db "HELP,ECHO,CLS,CRASH,SHUTDOWN,REBOOT",0x0D,0x0A,0
crash_msg   db "Crash!",0x0D,0x0A,0
shutdown_msg db "Shutdown...",0x0D,0x0A,0
reboot_msg  db "Reboot...",0x0D,0x0A,0
newline     db 0x0D,0x0A,0

cmd_help db "HELP",0
cmd_echo db "ECHO",0
cmd_cls  db "CLS",0
cmd_crash db "CRASH",0
cmd_shutdown db "SHUTDOWN",0
cmd_reboot db "REBOOT",0

buffer times 8 db 0   ; trimmed buffer size

; Pad to 512 bytes and add boot signature
times 510-($-$$) db 0
dw 0xAA55
