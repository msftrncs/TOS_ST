

(* @NESTEDCOMMENTS := 'Yes' *)
(* @PATH := '\/Timing' *)
(* @OBJECTFLAGS := '0, 8' *)
(* @SYMFILEFLAGS := '2048' *)
FUNCTION_BLOCK TOS (* restartable and stoppable version of TP, rising edge of IN restarts, or use SR action to start, or C to clear *)
VAR_INPUT
	IN : BOOL := FALSE; (* Trigger for Start of the Signal, or use SR to retrigger, or C to clear *)
	PT : TIME; (* The length of the High-Signal *)
END_VAR
VAR_OUTPUT
	Q : BOOL := FALSE; (* The pulse, can be extended with SR, or cleared with C *)
	ET : TIME; (* The current phase of the High-Signal, remains until timer restarts *)
END_VAR
VAR
	StartTime : TIME; (* system timer at most recent reset *)
	M : BOOL := FALSE; (* edge detection of IN *)
END_VAR
(* @END_DECLARATION := '0' *)
IF IN <> M THEN
	IF IN THEN
		SR(); (* start, or restart the timer *)
	ELSE
		M := FALSE; (* rearm of timer trigger *)
	END_IF
END_IF

IF Q THEN
	ET := TIME() - StartTime;
	Q := ET < PT;
END_IF

END_FUNCTION_BLOCK
ACTION	C:
IN := M := Q := FALSE; (* clear out timer *)
END_ACTION

ACTION	SR:
(* SET or RESET the one shot timer *)
IN := M := Q := TRUE;
StartTime := TIME();
ET := t#0s;

END_ACTION



