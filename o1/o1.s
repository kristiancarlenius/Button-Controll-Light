.thumb
.syntax unified

.include "gpio_constants.s"     // Register-adresser og konstanter for GPIO
.include "sys-tick_constants.s"
.text
	.global Start
	
Start:

	Loop:
		LDR R0, =BUTTON_PORT
		LDR R1, =PORT_SIZE
		MUL R0, R0, R1
		LDR R1, =GPIO_BASE
		ADD R0, R0, R1

		LDR R1, =GPIO_PORT_DIN

		LDR R2, [R0, R1] //R3 tar verdien fra minneadressen til DIN

		LDR R0, =LED_PORT
		LDR R1, =PORT_SIZE
		MUL R0, R0, R1
		LDR R1, =GPIO_BASE
		ADD R0, R0, R1 //R0 er led

		MVN R2, R2 //Inverterer R2, siden knappen er aktivt høy
		MOV R5, #1
		LSL R4, R5, BUTTON_PIN
		AND R3, R2, R4 // and av r2 og verdi
		#LSR R2, R2, #BUTTON_PIN //Right shifter R2 #BUTTON_PIN antall plasser. R2 har nå 1 på lsb hvis knappen er på
		#MOV R3, R2
		LSL R2, R5, LED_PIN //Left shifter R2 #LED_PIN antall plasser. R2 har nå 1 på pinnen som styrer LEDen hvis knappen er på


		CMP R3, R4
		BNE False
		BEQ True
		True:
			LDR R1, =GPIO_PORT_DOUTSET
			B EndIf
		False:
			LDR R1, =GPIO_PORT_DOUTCLR
			B EndIf
		EndIf:
			STR R2, [R0, R1]
			B Loop

NOP // Behold denne på bunnen av fila

