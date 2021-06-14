	AREA HEAPSORT, CODE, READWRITE
	ENTRY
	
	LDR		R0, =ARRAY			; Store array location
    MOV		R1, #6				; Store array length
	
	MOV     R11, #1         	; constant 1 value
    MOV     R12, #2         	; constant 2 value
	
	CMP     R1, #1          	; If the array length is less than or equal 1, go sort finish
	BLE     finish
	
	CMP     R1, #2          	; If the array length is less than or equal 2, go simple sort
    BLE     sort_2
	
	MOV 	R10, R1, ASR #1 	; R10 = len / 2
	SUB     R10, R10, #1		; R10 = R10 - 1
	
	SUB     R9, R1, #1			; R9 = len - 1 ; last index of the array
	
	MOV     R2, R10 			; Start heapify index 
	
heapify

	MOV     R3, R2          	; Store index of smallest value
	MLA     R4, R2, R12, R11   	; R4 = (R2 * 2) + 1 ; Left index
    MLA     R5, R2, R12, R12   	; R5 = (R2 * 2) + 2 ; Right index
    LDR     R6, [R0, R2, LSL#2]	; R6 = R0 + (R2 * 4); The value in R2
    MOV     R7, R6             	; Current smallest value
	
left

	CMP     R4, R9             	; If left index is greater than array size, that means it is 
    BGT     right				; not in bounds of the array. So, go to heapify right
	
    LDR     R8, [R0, R4, LSL#2] ; R8 = R0 + (R4 * 4); The value in R4
    CMP     R8, R7              ; If left value is less than or equal to the smallest value,
    BLE     right				; go to heapify right
	
    MOV     R3, R4             	; Else, copy the left node location to the smallest node location and
    MOV     R7, R8             	; copy the left node value to the smallest value
	
right
	
    CMP     R5, R9             	; If right index is greater than array size, that means it is 
    BGT     swap        		; not in bounds of the array. So, go to heapify swap
	
    LDR     R8, [R0, R5, LSL#2] ; R8 = R0 + (R5 * 4); The value in R5
    CMP     R8, R7            	; If rgiht value is less than or equal to the smallest value,
    BLE     swap     			; go to heapify swap
	
    MOV     R3, R5           	; Else, copy the left node location to the smallest node location and
    MOV     R7, R8          	; copy the left node value to the smallest value

swap

    CMP     R2, R3             	; If left smallest node location equal to the initial node location,
    BEQ     next        		; exit the heapify loop
	
    STR     R7, [R0, R2, LSL#2] ; else, swap smallest and initial values
    STR     R6, [R0, R3, LSL#2]	; 
    MOV     R2, R3            	; and change index to smallest index,
    B       heapify           	; go to heapify

next

    CMP     R10, #0           	; If last index is 0, heap is finished
    BEQ     heapify_pop			; go to heapify pop
	
    SUB     R10, R10, #1      	; Else,
    MOV     R2, R10				; change index to next index,
    B       heapify				; go to heapify

heapify_pop

    LDR     R3, [R0]            ; Smallest value 
    LDR     R4, [R0, R9, LSL#2]	; Value from end of heap
    STR     R3, [R0, R9, LSL#2] ; Store smallest value at end of heap
    STR     R4, [R0]            ; Store end value at start of heap
    SUB     R9, #1            	; Decrement end of heap index
    CMP     R9, #1            	; If there are two items left,
    BEQ     sort_2				; go to simple sort
	
    MOV     R2, #0            	; Else, change index with 0
    B       heapify				; go to heapify

sort_2

    LDR     R2, [R0]          	; 
    LDR     R3, [R0, #4]      	; 
    CMP     R2, R3            	; Compare values
    STRGT   R3, [R0]         	; Swap if out of order
    STRGT   R2, [R0, #4]		;

finish
	POP     {R2-R12,PC}      	; Return
	
ARRAY dcd 3,1,6,5,2,4
	
	END