.data
	INX: .half 0
	INY: .half 0
	OUTX: .half 0
	OUTY: .half 0
	START: .byte 0
	UPDOWN: .byte 0

.text
	# Useremo $s0 e $s1 per salvare la posizone precedente,
	# alla prima iterazione devono essere impostati a zero
	add $s0, $zero, $zero
	add $s1, $zero, $zero

# Aspettiamo che la parola 0x80 sia caricata in START, quando essa è caricata usciamo dal ciclo	
IDLE:   lbu $t0, START
	li  $t1, 0x80
	bne $t0, $t1, IDLE
		
	# Carichiamo in $t0 il valore presente nella cella INX 
	# e in $t1 il valore presente nella cella INY
	lh $t0, INX($zero)
	lh $t1 INY($zero)
	
	# Calcoliamo lo spostamento
	# Spostamento = destinazione - posizione precedente
	sub $t0, $t0, $s0
	sub $t1, $t1, $s1
	
	# Salviamo la nuova destinazione, che diventa la posizone
	# attuale, in $s0 e in $s1
	lh $s0, INX($zero)
	lh $s1 INY($zero)
	
	# Inviamo in OUTX e OUTY lo spostamento calcolato
	sh $t0, OUTX($zero)
	sh $t1, OUTY($zero)
	
	# Scriviamo in UPDOWN il valore 0xC3 per far scendere la testata
	addi $a0, $zero, 0xC3
	sb $a0, UPDOWN($zero)
	
	# Aspettiamo 400 millisecondi - valore da impostare: 100 000 000
	li $t0, 100000000
	
LOOP:	addi $t0, $t0, -1
	bne $t0, $zero, LOOP

	# Scriviamo in UPDOWN il valore 0x3C per far salire la testata
	addi $a0, $zero, 0x3C
	sb $a0, UPDOWN($zero)
	
	# Ritorniamo all'inizio del programma
	j IDLE
