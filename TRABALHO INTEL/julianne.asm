; trabalho intel

  .model small
	.stack
    
        CR		equ		13
        LF		equ		10
    
     .data 

        ;-----------------------------------------------------
		erro_abertura_arquivo db "Erro! Arquivo de entrada nao existe!", CR, LF, 0
		erro_leitura_arquivo db "Houve um erro na leitura do arquivo!", CR, LF, 0
        erro_char_arq db "Erro! Letra invalida no arquivo: ", 0
        erro_excesso_bases db "Erro! Ultrapassou 10.000 bases!", CR, LF, 0

        a_print db "A;", 0
        c_print db "C;", 0
        t_print db "T;", 0
        g_print db "G;", 0
        plus_print db "A+T;C+G;", 0

        linha_errada db "Esta na linha: ", 0

        r_num_linhas db "Numero de linhas do arquivo de entrada que contem bases: ",0
        r_num_bases db "Numero de bases no arquivo de entrada: ", 0
        r_tam_n db "Tamanho dos grupos a serem calculados: ", 0
        r_nome_out db "Nome do arquivo de saida: ", 0
        r_nome_input db "Nome do arquivo de entrada: ", 0

        r_num_grupos db "Numero de grupos a serem processados: ", 0
        r_cabecalho db "Informacoes a serem colocadas no arquivo de saida: ", 0
		
		flag_erro_leitura dw 0
		flag_erro_abertura dw 0
		
		nome_arquivo db 255 dup(0)
		buffer_arquivo db 10000 dup(0)
		file_handle dw 0
		index_buffer dw 0

        FileHandleDst dw 0

        nome_arquivo_out db 255 dup(0)
			
		codigo_prompt db 255 dup(0)
		codigo_prompt_formatado db 255 dup(0)
		codigo_prompt_formatado_final db 255 dup(0)
		codigo_prompt_formatado_tamanho dw 0

        ;--------------Ja testados------------------

        texto_prompt db 255 dup(0)
        tam_texto db 0

        ;-------------tratamento de erro----------------
        opcao_invalida db "Erro! Opcao invalida!", CR, LF, 0
        op_invalida dw 0
        opcao_eh db "Opcao invalida: ", CR, LF, 0
        invalid_op db 255 dup(0)
        sem_op db "Erro! Sem opcao informada", CR, LF, 0

        a_out db "a.out", 0

        f_sem_param db "Erro! -f sem parametro", CR, LF, 0
        o_sem_param db "Erro! -o sem parametro", CR, LF, 0
        n_sem_param db "Erro! -n sem parametro!", CR, LF, 0
        n_invalid db "Opcao -n invalida!", CR, LF, 0

        problema_f db "Erro! Opcao -f nao informada ou repetida!", CR, LF, 0
       
        n_zero db "Erro! Opcao -n eh zero!", CR, LF, 0
        problema_atcg  db "Erro! Bases nao informadas!", CR, LF, 0
        o_repeat db "Erro! Opcao -o repetida!", CR, LF, 0

        n_not db "Erro! Opcao -n nao informada!", CR, LF, 0
        n_repeat db "Erro! Opcao -n repetida!", CR, LF, 0
        n_nao_numero  db "Erro! Opcao -n nao eh numero!", CR, LF, 0

        erro_quat_maior_bases db "Erro! Mais de 10.000 bases no arquivo!", CR, LF, 0
        erro_menos_base db "Erro! Quantidade bases menor que o necessario para um grupo!", CR, LF, 0

        tudo_bem db "Tudo bem ate aqui!", CR, LF, 0


        ;----------------------------------------------------------
        nenhum_arquivo db "Erro! Nenhum arquivo foi fornecido", CR, LF, 0
        nao_possui_n  db "Erro! Faltou a opcao -n", CR, LF, 0
        numero_n_invalido db "Erro! Parametro para -n invalido", CR, LF, 0

        entrada_invalida db "Erro! Entrada invalida!", CR, LF, 0
        base_invalida1 db "Erro! BASE INVALIDA!", CR, LF, 0
		
        negativo db "Erro! negativo!", CR, LF, 0
		pula_linha db CR, LF, 0
		
		flag_f dw 0
		flag_o dw 0
		flag_n dw 0
        flag_atcg dw 0
        flag_char_erro_arq dw 0
        flag_erro_criacao dw 0
        flag_erro_escrita dw 0

        ;lembrar de inicializar num
        num dw 0

        imprime_a dw 0
        imprime_t dw 0
        imprime_c dw 0
        imprime_g dw 0
        imprime_plus dw 0

        num_grupos db 255 dup(0)
        string_bases db 255 dup(0)


        tamanho_arquivo dw 0

        sw_n	dw	0
        sw_f	db	0
        sw_m	dw	0

        mostra_tamanho db 10000 dup (?)
        num_contagem dw 0 

        letra_invalida db 255 dup(0)

        mostra_quant_linhas db 10000 dup (?)
        mostra_num_contagem db 10000 dup(?)
        mostra_grupos db 10000 dup(?)
        quantLinhas dw 1
         ;---------------------------------------

        MsgErroWriteFile db "Erro na escrita do arquivo!", CR, LF, 0
        MsgErroCreateFile db "Erro na criacao do arquivo!", CR, LF, 0
		
		cod_64 dw 0
		cod_48 dw 0
		cod_32 dw 0
		cod_16 dw 0
		
		texto_cod_64 db 10 dup(0)
		texto_cod_48 db 10 dup(0)
		texto_cod_32 db 10 dup(0)
		texto_cod_16 db 10 dup(0)
		
		texto_cod_completo db 40 dup(0)
		texto_cod_completo_formatado db 40 dup(0)
		texto_cod_completo_formatado_final db 40 dup(0)
		texto_cod_completo_formatado_tamanho dw 0
		
		;;usado na comparacao dos dois codigos
		
		
		;;variáveis para a conversão de hexa em asc	
		
		mascara dw 0f000h
		deslocamento db 12

    ;-------------------------------------------------

    .code
    .startup
	
		call inicializa
    
        push ds ; salva as informações de segmentos
        push es
        
        mov ax,ds ; troca DS <-> ES, para poder usa o MOVSB
        mov bx,es
        mov ds,bx
        mov es,ax
    
        mov si,80h ; obtém o tamanho do string e coloca em CX
        mov al, [si] ;;salva o tamanho da string de entrada
        mov tam_texto, al
        
        mov ch,0
        mov cl,[si]
    
        mov si,81h ; inicializa o ponteiro de origem
        lea di,texto_prompt; inicializa o ponteiro de destino
    
        rep movsb
    
        pop es ; retorna as informações dos registradores de segmentos
        pop ds
        
        ;;print_s o que foi colocado no prompt de comando
        ;lea bx, texto_prompt
        ;call printf_s
		
		;;procura caracteres especiais no texto do prompt e seta todas as variaveis necessarias
		lea bx, texto_prompt
		call procura_especial

        cmp op_invalida, 1
        je fim

        ;processou entrada, agora deve fazer a conferencia
    ;---------------verifica flags----------------------

        ;f precisa ser acionado para o programa funcionar
		cmp flag_f, 1       
        je confere_o        ;se for igual a 1 sem problemas, segue...

        ;f_sem_param db "-f sem parametro"
        cmp flag_f, 0
        jl sem_f

        ;se eh 0 ou outro numero maior que zero, nao sendo 1, entao ou falta f ou eh repetido
        ;jne fim_falta_f        ;se f nao for 1, nao pode ler o arquivo pois ou f nao foi acionado ou so pode ser acionada uma vez (e foi mais)
		lea bx, problema_f
        call printf_s
        jmp confere_o

    sem_f:
        lea bx, f_sem_param 
        call printf_s

    ;--------------------------------
    confere_o:

    ;se for igual a 1 tudo certo
		cmp flag_o, 1       
        je confere_n        ;se for igual a 1 sem problemas, segue...

    ;------------------------------------

        ; cmp flag_o, 0 
        ; je nomeia_o

    ;-----------------------------
    
        ;se for -1, sem parametro
        cmp flag_o, 0
        jl sem_o

        ;cmp flag_o, 2
        ;jge o_repetido

        jmp confere_n
    ;-------------------------------------

    sem_o:
        lea bx, o_sem_param
        call printf_s
        jmp confere_n

    ;o_repetido:
       ; lea bx, o_repeat
       ; call printf_s

    ;o sem nome, nomeia o com "a.out"
    ; nomeia_o:

    ;     lea bx, a_out
    ;     lea nome_arquivo_out, bx
    ;     ; lea bp, nome_arquivo_out

    ;     ; mov dl, [bx]
    ;     ; cmp dl, 0
    ;     ; je printa_a_out

    ;     ; ;se nao, coloca a letra correspondendo no destino
	; 	; mov [bp], dl
	; 	; inc bp
	; 	; inc bx
	; 	; jmp nomeia_o

    ; printa_a_out:

    ;     lea bx, nome_arquivo_out
    ;     call printf_s 

    ;     jmp confere_n

;-------------------------------------------------
    ;----------------------------------
    confere_n:
        
        cmp flag_n, 1
        je pula_problema_n

    ;------problemas de n--------

        ;repetido
        cmp flag_n, 2
        jge repeat_n

        cmp flag_n, 0
        je n_nao_informada

        cmp flag_n, -1
        je sem_n    ;flag n = -1 , sem parametro

        cmp flag_n, -2
        je invalid_n

    ;entao n nao eh numero
        lea bx, n_nao_numero
        call printf_s
        jmp fim

        ;---------------------
    invalid_n:
        ;n_sem_param db "Opcao -n parametro invalido!"
        lea bx, n_invalid
        call printf_s
        jmp confere_atcg

        ;-----------------------
    n_nao_informada:
        ;deu ruim para o n, ele nao foi informado
        lea bx, n_not
        call printf_s
        jmp confere_atcg

    repeat_n:
        ;deu ruim para o n, foi informado com repeticao
        lea bx, n_repeat
        call printf_s
        jmp confere_atcg

    ;-----fim problemas n----------

    pula_problema_n:
        ;transformar uma string em um numero de 16 bits
        lea		bx, num_grupos
		call	atoi

        mov num, ax

        ;se n for 0 nao forma nenhum grupo, grupo de 0 bases = erro
        cmp num, 0
        jne confere_atcg

        ;se n=0
        lea bx, n_zero
        call printf_s
        jmp confere_atcg

    ;--------------------------------

    sem_n:
        lea bx, n_sem_param 
        call printf_s

    ;---------------------------
    confere_atcg:

        cmp flag_atcg, 1
        je continua_programa

        lea bx, problema_atcg
        call printf_s
        jmp fim
;----------------------------------
;Le o arquivo:
;----------------------------------

continua_programa:
		
        ;para teste
		;lea bx, nome_arquivo
		;call printf_s
		
		;le arquivo que teve o nome fornecido e coloca suas letras no buffer
		call le_arquivo

        cmp flag_char_erro_arq, 1
        je fim
		
		cmp flag_erro_leitura, 1
		je fim
		
		cmp flag_erro_abertura, 1
		je fim	

        ; lea bx, buffer_arquivo
        ; call printf_s

        ; lea bx, pula_linha
        ; call printf_s
        ;----------------------------

        

        ;--------trata erro do arquivo------------

        ;quantidade de letras < n_entrada = deve ser informada a quantidade minima de letras que deve existir, na verdade printar -n N
        cmp num_contagem, 10000
        ja erro_quantidade_maior_bases

        ;arquivo ultrapassa tamanho, mais de 10.000 bases, informa que tem mais de 10.000 bases
        mov ax, num
        cmp num_contagem, ax
        jl erro_menos_bases


        ; call contagem_agrupamento

        ;---------------------------------------------------------------------------------------------

        ; se deu tudo certo na abertura e leitura do arquivo entao 
        ; cria arquivo de saida e dentro dele processa o que precisa processar e depois ja escreve nele
        ;lea bp, nome_arquivo_out
        call escrita_saida

        ;r_nome_input db "Nome do arquivo de entrada: ", 0
        lea bx, r_nome_input
        call printf_s

        lea bx, nome_arquivo
        call printf_s

        ;-----------------------

        lea bx, pula_linha
        call printf_s

        ;-------------------------
        ;r_nome_out db "Nome do arquivo de saida: ". 0
        lea bx, r_nome_out
        call printf_s

        cmp nome_arquivo_out, 0
        je	sem_nome1

        lea	bx,nome_arquivo_out
        jmp segue_com_nome1

        sem_nome1:
            ;nome padrao
            lea bx, a_out
            ; jmp segue_com_nome

        call printf_s

        ;------------------------------------------
        lea bx, pula_linha
        call printf_s

        segue_com_nome1:
        ;r_tam_n db "Tamanho dos grupos a serem calculados: ", 0

        lea bx, r_tam_n
        call printf_s

        lea bx, num_grupos
        call printf_s

         ;-----------------------
        lea bx, pula_linha
        call printf_s
        ;-------------------------
        ;r_cabecalho db "Informações a serem colocadas no arquivo de saída: ", 0
        lea bx, r_cabecalho
        call printf_s

        cmp imprime_a, 1
        je printa_a

        segue1:
        cmp imprime_t, 1
        je printa_t

        segue2:
        cmp imprime_c, 1
        je printa_c

        segue3:
        cmp imprime_g, 1
        je print_g

        segue4:
        cmp imprime_plus, 1
        je print_plus
        jmp segue_aqui

    ;---------------------
        printa_a:
        lea bx, a_print
        call printf_s
        jmp segue1

        printa_t:
        lea bx, t_print
        call printf_s
        jmp segue2

        printa_c:
        lea bx, c_print
        call printf_s
        jmp segue3

        print_g:
        lea bx, g_print
        call printf_s
        jmp segue4

        print_plus:
        lea bx, plus_print
        call printf_s

        segue_aqui:
         ;-----------------------
        lea bx, pula_linha
        call printf_s
        ;-------------------------
        ;r_num_bases db "Número de bases no arquivo de entrada: ", 0
        lea bx, r_num_bases
        call printf_s

        mov ax, num_contagem
        lea bx, mostra_num_contagem
        call sprintf_w

        lea		bx, mostra_num_contagem
	    call	printf_s
        ;-----------------------------
        lea bx, pula_linha
        call printf_s

        ;r_num_grupos db "Número de grupos a serem processados: ", 0
        lea bx, r_num_grupos
        call printf_s

         mov ax, num_contagem
         sub ax, num
         add ax, 1

         lea bx, mostra_grupos
        call sprintf_w

        lea		bx, mostra_grupos
	    call	printf_s


         ;-----------------------
        lea bx, pula_linha
        call printf_s
        ;-------------------------
        ;r_num_linhas db "Número de linhas do arquivo de entrada que contém bases: ",0
        lea bx, r_num_linhas
        call printf_s

        mov ax, quantLinhas
        lea bx, mostra_quant_linhas
        call sprintf_w

        lea		bx, mostra_quant_linhas
        call	printf_s

        lea bx, pula_linha
        call printf_s

        ;------------------------------------------------

        cmp flag_erro_criacao, 1
		je fim
        
        cmp flag_erro_escrita, 1
        jmp fim

        ;-------------RESUMO NA TELA-------------------------

        ;se deu tudo certo e chegou ate aqui
        ;imprime na tela
        ; As informações das opções são as seguintes:
        ; • Nome do arquivo de entrada;
        ; • Nome do arquivo de saída;
        ; • Tamanho dos grupos de bases a serem calculados (valor da opção “-n”);
        ; • Informações a serem colocadas no arquivo de saída (“A”, “T”, “C”, “G” e/ou “A+T;C+G”).
        ; As informações do arquivo de entrada são as seguintes:
        ; • Número de bases no arquivo de entrada;
        ; • Número de grupos a serem processados;
        ; • Número de linhas do arquivo de entrada que contém bases.

    jmp fim

    erro_quantidade_maior_bases:

        lea bx, erro_quat_maior_bases
        call printf_s
        jmp fim

    erro_menos_bases:
        lea bx, erro_menos_base
        call printf_s

fim:	
        
    .exit

;;=================================================================================
;Funções auxiliares
;;=================================================================================
    
	
	;;==================================================================================
	;Função: Imprimir na tela a string fornecida
	;Entrada: (A) BX -> Com o endereço da string a ser imprimida na tela
	;;==================================================================================
    
    printf_s	proc	near

    ;	While (*s!='\0') {
        mov		dl,[bx]
        cmp		dl,0
        je		ps_1

    ;		putchar(*s)
        push	bx
        mov		ah,2
        int		21H
        pop		bx

    ;		++s;
        inc		bx
            
    ;	}
        jmp		printf_s
		
    ps_1:
        ret
	
    printf_s	endp
    
;;==========================================================================================
;Procura_Especial
;;==========================================================================================
    procura_especial proc near
	
;procura "-" ate o fim da string da linha de comando
continua_procura:
	;	While (*s != '\0'){
		mov dl, [bx]
		cmp dl, 0
		je fim_procura
		
	;	++s	
		inc bx
	
	; 	verifica se o caractér é um - 
		
		cmp dl, '-'
		je casos
		
	;	}

        jmp continua_procura

;----------------------------------------
;se achou um "-", vê em qual opção se enquadra
casos:
		mov dl, [bx]

        ;pega nome do arquivo de entrada
		cmp dl, 'f'
        je leitura_arquivo_input

        ;nomeia arquivo de saida
        cmp dl, 'o'
		je leitura_arquivo_out

        ;obtem um numero inteiro sem sinal
        cmp dl, 'n'
		je confere_numero

        ;------atcg+-------
        cmp dl, 'a'
        je confere_imprime_saida

        cmp dl, 't'
        je confere_imprime_saida

        cmp dl, 'g'
        je confere_imprime_saida

        cmp dl, 'c'
        je confere_imprime_saida

        cmp dl, '+'
        je confere_imprime_saida
        
        ;se chegou ate aqui sem encontrar nenhuma das opcoes valida = erro opcao invalida
        jmp erro_opcao_invalida

;----------------------------------------
;ve quais o que precisa se inpresso 
confere_imprime_saida:

        add flag_atcg, 1

loop_confere_bases:

        mov dl, [bx]

        cmp dl, 'a'
        je add_a

        cmp dl, 't'
        je add_t

        cmp dl, 'c'
        je add_c

        cmp dl, 'g'
        je add_g

        cmp dl, '+'
        je add_plus


;loop_bases:

        ;mov dl, [bx]
    ;   se a proxima letra for um ' ', quer dizer que as bases acabaram, mas ainda tem linha de comando para processar 
        cmp dl, ' '
        je continua_procura

        cmp dl, '-'
        je entrada_invalida1

    ;	se a proxima letra for 0, quer dizer que a linha de comando terminou
        cmp dl, 0 
        je fim_procura

        jmp base_invalida
;---------------------------

add_a:  add imprime_a, 1
        inc bx
        jmp loop_confere_bases

add_t:  add imprime_t, 1
        inc bx
        jmp loop_confere_bases

add_c:  add imprime_c, 1
        inc bx
        jmp loop_confere_bases

add_g:  add imprime_g, 1
        inc bx
        jmp loop_confere_bases

add_plus:   add imprime_plus, 1
            inc bx
            jmp loop_confere_bases

;------------------------------------------------------------------
leitura_arquivo_input:
	
	;	liga o flag que indica que algum arquivo foi lido e conta a quantidade de vezes que a funçao foi chamada
		add flag_f, 1
		
	;	guarda o endereço do arquivo de destino no bp	
		lea bp, nome_arquivo
		
        ;pula um para ler o parametro
		inc bx
	
	pula_espacos:
	
		;loop para que quando acabar os espaços, o parametro seja lido
		mov dl, [bx]

        ;-f sem parametro
        cmp dl, 0
		je f_sem

        ;-f parametro invalido
        cmp dl, '-'
        je f_sem

		cmp dl, ' '
		jg loop_nome ;escreve o parametro no local adequado
		inc bx
		jmp pula_espacos
	
	loop_nome:
	
	;   se a proxima letra for um ' ', quer dizer que o nome do arquivo acabou (teoricamente)
		mov dl, [bx]
		cmp dl, ' '
		je continua_procura
	
	;	se a proxima letra for 0, quer dizer que a linha de comando terminou
		cmp dl, 0
		je fim_procura

	;	se nao, coloca a letra correspondendo no destino
		mov [bp], dl
		inc bp
		inc bx
		jmp loop_nome

;-----------------------------
f_sem:

        mov flag_f, -1
        inc bx
        jmp continua_procura

;-------------------------------
;----------------------------------------
leitura_arquivo_out:
	
	;	liga o flag que indica que algum arquivo foi lido e conta a quantidade de vezes que a funçao foi chamada
		add flag_o, 1
		
	;	guarda o endereço do arquivo de destino no bp	
		lea bp, nome_arquivo_out
		
        ;pula um para ler o parametro
		inc bx
	
	pula_espacos2:
	
		;loop para que quando acabar os espaços, o parametro seja lido
		mov dl, [bx]

        cmp dl, 0
		je o_sem

        cmp dl, '-'
        je o_sem

		cmp dl, ' '
		jg loop_nome2 ;escreve o parametro no local adequado
		inc bx
		jmp pula_espacos2
	
	loop_nome2:
	
	;   se a proxima letra for um ' ', quer dizer que o nome do arquivo acabou (teoricamente)
		mov dl, [bx]
		cmp dl, ' '
		je continua_procura
	
	;	se a proxima letra for 0, quer dizer que a linha de comando terminou
		cmp dl, 0
		je fim_procura
		
	;	se nao, coloca a letra correspondendo no destino
		mov [bp], dl
		inc bp
		inc bx
		jmp loop_nome2

;-------------------------
o_sem:

    mov flag_o, -1
    inc bx
    jmp continua_procura     

;----------------------

;----------------------------------------
confere_numero:

    add flag_n, 1

    ;	guarda o endereço do arquivo de destino no bp	
	lea bp, num_grupos

    ;pula um para ler o parametro
	inc bx

    pula_espacos3:
	
		;loop para que quando acabar os espaços, o parametro seja lido
		mov dl, [bx]

        cmp dl, 0
		je n_sem_parametro
    ;---------------------
        cmp dl, '-'
        je n_sem_parametro
        ;-------------------
        cmp dl, '.'
        je n_invalido

        cmp dl, ','
        je n_invalido
        ;-------------------
		cmp dl, ' '
		jg loop_num ;escreve o parametro no local adequado
		inc bx
		jmp pula_espacos3

    loop_num:

    ;   se a proxima letra for um ' ', quer dizer que nao tem numero
		mov dl, [bx]
		cmp dl, ' '
		je continua_procura
    
	;	se a proxima letra for 0, quer dizer que a linha de comando terminou
		cmp dl, 0
		je fim_procura

        cmp dl, '.'
        je n_invalido
        cmp dl, ','
        je n_invalido

    ;eh 1
        ;mov dl, [bx]
		cmp dl, '1'
        je segue_loop2

        ;eh 2
        cmp dl, '2'
		je segue_loop2

        ;eh 3
        cmp dl, '3'
		je segue_loop2

        ;eh 4
        cmp dl, '4'
		je segue_loop2

        ;eh 5
        cmp dl, '5'
		je segue_loop2

        ;eh 6
        cmp dl, '6'
		je segue_loop2

        ;eh 7
        cmp dl, '7'
		je segue_loop2

        ;eh 8
        cmp dl, '8'
		je segue_loop2

        ;eh 9
        cmp dl, '9'
		je segue_loop2

        jmp n_nao_eh_num

        ;------erro letra invalida----------
	
    segue_loop2:
	;	se nao, coloca a letra correspondendo no destino
		mov [bp], dl
		inc bp
		inc bx
		jmp loop_num

;----------------------------
n_sem_parametro:

    mov flag_n, -1
    inc bx
    jmp continua_procura

n_invalido:

    mov flag_n, -2
    inc bx
    jmp continua_procura

 n_nao_eh_num:

     mov flag_n, -3
     inc bx
     jmp continua_procura

;------------------------

;------------------------------------------
;erros tratados
;------------------------------------------
erro_opcao_invalida:

    add op_invalida,1
    ;---------------------
		
	;	guarda o endereço do arquivo de destino no bp	
		lea bp, invalid_op
		
	pula_espacos5:
	
		;loop para que quando acabar os espaços, o parametro seja lido
		mov dl, [bx]

        ; -\0, fim sem nenhuma opcao
        cmp dl, 0
        je sem_opcao

        ;--, opcao invalida: -
        cmp dl, '-'
        je loop_nome5

        ;-' '    -o, sem nenhuma opcao
		cmp dl, ' '
        je sem_opcao

        cmp dl, ' '
		jg loop_nome5 ;escreve o parametro no local adequado

		inc bx
		jmp pula_espacos5
	
	loop_nome5:
	
	;   se a proxima letra for um ' ', quer dizer que o nome do arquivo acabou (teoricamente)
		mov dl, [bx]

        cmp dl, '-'
        je aqui

        ;sem opcao
		cmp dl, ' '
		je print_invalida
	
    ;sechou aqui sem opcao
	;	se a proxima letra for 0, quer dizer que a linha de comando terminou
		cmp dl, 0
		je print_invalida

aqui:
	;	se nao, coloca a letra correspondendo no destino
		mov [bp], dl
		inc bp
		inc bx
		jmp loop_nome5

print_invalida:

    lea bx, opcao_invalida
    call printf_s

    lea bx, opcao_eh
    call printf_s
    
    lea bx, invalid_op
    call printf_s
    jmp fim_procura

sem_opcao:

    ;sem op ...."Erro! Sem opcao informada"
    lea bx, opcao_invalida
    call printf_s

    lea bx, sem_op
    call printf_s
    jmp fim_procura
;----------------------------------
;os atcg+
entrada_invalida1:
    lea bx, entrada_invalida
    call printf_s
    jmp fim_procura

base_invalida:
    lea bx, base_invalida1
    call printf_s
    jmp fim_procura

;-------------------------------

fim_procura:	
		ret
	
	procura_especial endp

;;===================================================================================================
;funcao que le o arquivo
;Calcula Codigo Arquivo
;Função: Abre o arquivo fornecido no prompt de comando e calcula seu codigo de verificação
;;==============================================================================================
	
	le_arquivo proc near
		
	;fopen(nome_arquivo, r)
		mov al, 0            ;indica que apenas haverá leitura de arquivo
		mov ah, 3dh	         ;função 3d da int 21 que abre um arquivo
		lea dx, nome_arquivo ;nome do arquivo a ser lido
		int 21h
		
		jnc continua_1      ;se após a execução da int 21 o bit de carry nao estiver ligado, quer dizer que a função funcionou
		
		mov flag_erro_abertura, 1
		lea bx, erro_abertura_arquivo ;se houve erro, imprime isso
		call printf_s
		
		jmp final ;e termina a função
	
	continua_1:
	
		mov file_handle, ax
        lea dx, buffer_arquivo
		
	loop_leitura:
	
		mov bx, file_handle
		mov ah, 3fh            ;função 3f da int 21 que le caracter por caracter de um arquivo
		mov cx, 1			   ;indica que será lida uma letra por vez
		;lea dx, buffer_arquivo ;local onde os caracters serão armazenados
		;add dx, index_buffer   ;faz com que a função percorra o vetor de caracteres (buffer)
		int 21h	     

        jc erro_leitura         ;se o bit de carry nao estiver ligado (não houve erro) pode continuar

        ;------------
		 mov bx,dx

         ;lf nova linha
		 cmp [bx],0Dh
		 je somaLinha

		 cmp [bx],0Ah
		 je loop_leitura
        ;-----------
        ;----------filtra bases-----------------
        ;eh A
		cmp [bx], 41h
        je segue_loop

        ;eh C
        cmp [bx], 43h
		je segue_loop

        ;eh T
        cmp [bx], 54h
		je segue_loop

        ;eh G
        cmp [bx], 47h
		je segue_loop

        cmp [bx], 0
        je segue_loop

        ;------erro letra invalida----------
        mov dx, [bx]
        lea bp, letra_invalida
		mov [bp], dx

        ;Informa erro
        mov flag_char_erro_arq, 1
        lea bx, erro_char_arq
		call printf_s
        
        ;"Letra invalida eh: ... "
        lea bx, letra_invalida
        call printf_s

        lea bx, pula_linha
        call printf_s
	
        ;"Esta na linha: "
        lea bx, linha_errada
        call printf_s

        mov ax, quantLinhas
        lea bx, mostra_quant_linhas
        call sprintf_w

        lea		bx, mostra_quant_linhas
	    call	printf_s

        lea bx, pula_linha
        call printf_s
        
        ;se nao for informa erro 
        mov al,1 
		jmp fecha_arquivo
        ;---------------------------------
    segue_loop:

        inc dx

        jmp continua_2
		
	
    erro_leitura:

        ;houve erro de leitura
		mov flag_erro_leitura, 1
		lea bx, erro_leitura_arquivo
		call printf_s
		
		mov al,1 
		jmp fecha_arquivo
        
    ;-------------------------------------------
		
	continua_2:
	
		cmp ax, 0 ;se o valor retornado em ax pela função int 21 for 0, quer dizer que nenhum caracter foi lido, logo, é o final do arquivo
		jne somaChar
		
		mov al, 0
		jmp fecha_arquivo

    ;------------processamento do arquivo------------------------

     somaLinha: 

         add quantLinhas, 1
         jmp loop_leitura
		
	somaChar:

        add num_contagem, 1
		jmp loop_leitura

    ;-------------------------------------------------------
		
	fecha_arquivo:
	
		mov bx, file_handle ;fecha o arquivo
		mov ah, 3eh
		int 21h
		
	final:
	
		ret
		
	le_arquivo endp

;--------------------------------------------------------------------


;--------------------------------------------------------------------
sprintf_w	proc	near

;void sprintf_w(char *string, WORD n) {
	mov		sw_n,ax

;	k=5;
	mov		cx,5
	
;	m=10000;
	mov		sw_m,10000
	
;	f=0;
	mov		sw_f,0
	
;	do {
sw_do:

;		quociente = n / m : resto = n % m;	// Usar instru��o DIV
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
;		if (quociente || f) {
;			*string++ = quociente+'0'
;			f = 1;
;		}
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
;		n = resto;
	mov		sw_n,dx
	
;		m = m/10;
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
;		--k;
	dec		cx
	
;	} while(k);
	cmp		cx,0
	jnz		sw_do

;	if (!f)
;		*string++ = '0';
	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


;	*string = '\0';
	mov		byte ptr[bx],0
		
;}
	ret
		
sprintf_w	endp

;-----------------------PROCESSAMENTO PARA O ARQUIVO DE SAIDA-----------------------------------------------

escrita_saida proc near

;----------------------------------------------
    ;trata se nenhum nome informado
    cmp nome_arquivo_out, 0
    je	sem_nome

    lea		dx,nome_arquivo_out
    jmp segue_com_nome

        sem_nome:
            ;nome padrao
            lea dx, a_out
            ; jmp segue_com_nome

    segue_com_nome:
        ;FileHandleDst = BX
        mov		cx,0
        mov     al, 0
	    mov		ah,3ch
	    int		21h

        jnc continua1
        ;----------------------------
        mov flag_erro_criacao, 1
        lea		bx, MsgErroCreateFile
        call	printf_s
        ;mov al,1 
        jmp     fclose
        ;----------------------------

    continua1:

        mov FileHandleDst, ax
        lea dx, buffer_arquivo  ;colocar aqui o que precisa escrever no arquivo

    loop_escrita:
        mov		bx,FileHandleDst
        ;escreve...
        mov		ah,40h
        mov		cx,1
        int		21h

        jc erro_escrita
        
        mov bx,dx

         ;ve se chegou no fim do que precisava escrever
		 cmp [bx],0
		 je fclose

        inc dx

        jmp loop_escrita

    ;---------------------------------
	erro_escrita:
        mov flag_erro_escrita, 1
        lea		bx, MsgErroWriteFile
        call	printf_s
        ;mov al,1  ;rever se precisa
        jmp	fclose
    
    ;---------------------------------
		
fclose:
	mov		bx,FileHandleDst	; Fecha arquivo destino
    mov		ah,3eh
    int		21h

    ret

escrita_saida endp
		
;;==============================================================================

; contagem_agrupamento proc near











;     ret
; contagem_agrupamento endp
;--------------------------------------------------------------------
;atoi
;--------------------------------------------------------------------
atoi	proc near

		; A = 0;
		mov		ax,0
		
atoi_2:
		; while (*S!='\0') {
		cmp		byte ptr[bx], 0
		jz		atoi_1

		; 	A = 10 * A
		mov		cx,10
		mul		cx

		; 	A = A + *S
		mov		ch,0
		mov		cl,[bx]
		add		ax,cx

		; 	A = A - '0'
		sub		ax,'0'

		; 	++S
		inc		bx
		
		;}
		jmp		atoi_2

atoi_1:

		; return
		ret

atoi	endp

;;======================================================
	;Funcao: Inicializa todas as variaveis do meu programa
	;;======================================================
	
	inicializa proc near
	
		;;inicializa variaveis definidas com db ou dw (sem ser vetor)
		mov tam_texto, byte ptr 0
		mov flag_erro_leitura, 0
		mov flag_erro_abertura, 0
		mov file_handle, 0
		mov index_buffer, 0
		mov codigo_prompt_formatado_tamanho, 0

    ;----------------------
        mov tamanho_arquivo, 0
		mov flag_f, 0
		mov flag_o, 0
		mov flag_n, 0
        mov flag_atcg, 0

        mov flag_erro_criacao, 0
        mov flag_erro_escrita, 0

        mov op_invalida, 0
        mov invalid_op,0

        mov num, 0
        
        mov imprime_a, 0
        mov imprime_t, 0
        mov imprime_c, 0
        mov imprime_g, 0
        mov imprime_plus, 0

    ;----------------------

		mov cod_64, 0
		mov cod_48, 0
		mov cod_32, 0
		mov cod_16, 0
		mov texto_cod_completo_formatado_tamanho, 0
		mov mascara, 0f000h
		mov deslocamento, byte ptr 12
	
	;;inicializa todos os vetores
	;-------------------------		
		lea bx, texto_prompt
		mov cx, 255
			
	inic_1:
		
		mov [bx], byte ptr 0
		inc bx
		loop inic_1
	;------------------------		
		lea bx, nome_arquivo
		mov cx, 255
	
	inic_2:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_2
	;---------------------------	
	
		lea bx, buffer_arquivo
		mov cx, 1024
		
	inic_3:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_3
		
	;-------------------------------
	
		lea bx, codigo_prompt
		mov cx, 255
		
	inic_4:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_4
		
	;--------------------------------
	
		lea bx, codigo_prompt_formatado
		mov cx, 255
		
	inic_5:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_5
		
	;--------------------------------
	
		lea bx, codigo_prompt_formatado_final
		mov cx, 255
		
	inic_6:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_6
		
	;---------------------------------------
	
		lea bx, texto_cod_16
		mov cx, 10
		
	inic_7:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_7
		
	;-------------------------------------
		
		lea bx, texto_cod_32
		mov cx, 10
		
	inic_8:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_8
		
	;--------------------------------------
	
		lea bx, texto_cod_48
		mov cx, 10
		
	inic_9:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_9

	;-------------------------------------------
	
		lea bx, texto_cod_64
		mov cx, 10
		
	inic_10:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_10
		
	;-------------------------------------------
	
		lea bx, texto_cod_completo
		mov cx, 40
		
	inic_11:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_11

	;---------------------------------------------
	
		lea bx, texto_cod_completo_formatado
		mov cx, 40
		
	inic_12:
	
		mov [bx],byte ptr 0
		inc bx
		loop inic_12
		
	;----------------------------------------------
	
		lea bx, texto_cod_completo_formatado_final
		mov cx, 40
		
	inic_13:
	
		mov [bx], byte ptr 0
		inc bx
		loop inic_13
		
	;--------------------------------------------------
	
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0
	mov bp, 0
	
		ret
		
	inicializa endp
		
		
	;--------------------------------------------------------------------
			end
	;--------------------------------------------------------------------
