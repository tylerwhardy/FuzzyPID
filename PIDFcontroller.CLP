;; PID Fuzzy Controller
;; By Tyler Hardy

;; Deftemplates

;; Global Variables

(defglobal ?*plantOutput* = 70)

;; Input and fuzzification

(defrule getSetpoint
	(declare (salience 1000))
	=>
	(printout t "Set system temperature: ")

	(bind ?t (read))
	(if (< ?t 65)
		then
		(assert (Setpoint low))
	)

	(if (< ?t 76)
		then
		(if (> ?t 64)
		then 
			(assert (Setpoint medium))
		)
	)

	(if (> ?t 75)
		then
		(assert (Setpoint high))
	)


	(if (> ?t ?*plantOutput*)
		then
			(assert (preerror low))
	)

	(if (= ?t ?*plantOutput*)
		then
			(assert (preerror none))
		)
	)

	(if (> ?t ?*plantOutput*)
		then
			(assert (preerror high))
	)
)

;; Proportional Error 
(defrule pError1
	(declare (salience 50))
	(preerror low)
	=>
	(assert (Perror low))
)

(defrule pError2
	(declare (salience 50))
	(preerror none)
	=>
	(assert (Perror none))
)

(defrule pError3
	(declare (salience 50))
	(preerror high)
	=>
	(assert (Perror high))
)

(defrule pError4
	(declare (salience 50))
	(preerror lowlow)
	=>
	(assert (Perror lowlow))
)

(defrule pError5
	(declare (salience 50))
	(preerror highhigh)
	=>
	(assert (Perror highhigh))
)
;; Integral Error
;; preerror+error

(defrule IError1
	(declare (salience 70))
	(error low)(preerror low)
	=>
	(assert (Ierror low))
)

(defrule IError2
	(declare (salience 70))
	(error none)(preerror low)
	=>
	(assert (Ierror none))
)

(defrule IError3
	(declare (salience 70))
	(error high)(preerror low)
	=>
	(assert (Ierror high))
)

(defrule IError4
	(declare (salience 70))
	(error low)(preerror none)
	=>
	(assert(Ierror low))
)

(defrule IError5
	(declare (salience 70))
	(error none)(preerror none)
	=>
	(assert(Ierror none))
)

(defrule IError6
	(declare (salience 750))
	(error high)(preerror none)
	=>
	(assert (Ierror high))
)

(defrule IError7
	(declare (salience 70))
	(error low)(preerror high)
	=>
	(assert(Ierror none))
)

(defrule IError8
	(declare (salience 70))
	(error none)(preerror high)
	=>
	(assert (Ierror none))
)

(defrule IError9
	(declare (salience 70))
	(error high)(preerror high)
	=>
	(assert(Ierror high))
)

;; Derivative Error
;; error - preerror

(defrule DError1
	(declare (salience 60))
	(error low)(preerror low)
	=>
	(assert (Derror none))
)

(defrule DError2
	(declare (salience 60))
	(error none)(preerror low)
	=>
	(assert (Derror high))
)

(defrule DError3
	(declare (salience 60))
	(error high)(preerror low)
	=>
	(assert (Derror high))
)

(defrule DError4
	(declare (salience 60))
	(error low)(preerror none)
	=>
	(assert (Derror low))
)

(defrule DError5
	(declare (salience 60))
	(error none)(preerror none)
	=>
	(assert (Derror none))
)

(defrule DError6
	(declare (salience 60))
	(error high)(preerror none)
	=>
	(assert (Derror high))
)

(defrule DError7
	(declare (salience 60))
	(error low)(preerror high)
	=>
	(assert (Derror low))
)

(defrule DError8
	(declare (salience 60))
	(error none)(preerror high)
	=>
	(assert (Derror low))
)

(defrule DError9
	(declare (salience 60))
	(error high)(preerror high)
	=>
	(assert (Derror none))
)

;; Pre-Summation

(defrule presum1
	(declare (salience -100))
	(Ierror low)(Derror low)
	?f <- (Ierror low)
	?g <- (Derror low)
	=>
	(retract ?f)
	(retract ?g)
	(assert (Nerror low))
)

(defrule presum2
	(declare (salience -100))
	(Ierror low)(Derror none)
	?f <- (Ierror low)
	?g <- (Derror none)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror low))
)

(defrule presum3
	(declare (salience -100))
	(Ierror none)(Derror low)
	?f <- (Ierror none)
	?g <- (Derror low)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror low))
)


(defrule presum4
	(declare (salience -100))
	(Ierror none)(Derror none)
	?f <- (Ierror none)
	?g <- (Derror none)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror none))
)

(defrule presum5
	(declare (salience -100))
	(Ierror low)(Derror high)
	?f <- (Ierror low)
	?g <- (Derror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror none))
)

(defrule presum6
	(declare (salience -100))
	(Ierror high)(Derror low)
	?f <- (Ierror high)
	?g <- (Derror low)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror none))
)

(defrule presum7
	(declare (salience -100))
	(Ierror high)(Derror high)
	?f <- (Ierror high)
	?g <- (Derror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror high))
)

(defrule presum8
	(declare (salience -100))
	(Ierror high)(Derror none)
	?f <- (Ierror high)
	?g <- (Derror none)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror high))
)

(defrule presum9
	(declare (salience -100))
	(Ierror none)(Derror high)

	?f <- (Ierror none)
	?g <- (Derror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (Nerror high))
)

;; Full Error Summation

;;(defrule sum1
;;	(declare (salience -500))
;;	(Perror lowlow)(Nerror low)
;;	=>
;;	(retract (Perror lowlow)(Nerror low))
;;	(assert (error low))
;;)

;;(defrule sum2
;;	(declare (salience -500))
;;	(Perror lowlow)(Nerror none)
;;	=>
;;	(retract (Perror lowlow)(Nerror none))
;;	(assert (error low))
;;)

;;(defrule sum3
;;	(declare (salience -500))
;;	(Perror lowlow)(Nerror high)
;;	=>
;;	(retract (Perror lowlow)(Nerror high))
;;	(assert (error none))
;;)

(defrule sum4
	(declare (salience -500))
	(Perror low)(Nerror low)
	?f <- (Perror low)
	?g <- (Nerror low)
	=>
	(retract ?f)
	(retract ?g)
	(assert (error low))
)

(defrule sum5
	(declare (salience -500))
	(Perror low)(Nerror none)
	?f <- (Perror low)
	?g <- (Nerror none)
	=>
	(retract ?f)
	(retract ?g)
	(assert (error none))
)

(defrule sum6
	(declare (salience -500))
	(Perror low)(Nerror high)

	?f <- (Perror low)
	?g <- (Nerror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum7
	(declare (salience -500))
	(Perror none)(Nerror low)

	?f <- (Perror none)
	?g <- (Nerror low)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum8
	(declare (salience -500))
	(Perror none)(Nerror none)

	?f <- (Perror none)
	?g <- (Nerror none)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum9
	(declare (salience -500))
	(Perror none)(Nerror high)

	?f <- (Perror low)
	?g <- (Nerror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum10
	(declare (salience -500))
	(Perror high)(Nerror low)

	?f <- (Perror high)
	?g <- (Nerror low)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum11
	(declare (salience -500))
	(Perror high)(Nerror none)

	?f <- (Perror high)
	?g <- (Nerror none)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error none))
)

(defrule sum12
	(declare (salience -500))
	(Perror high)(Nerror high)

	?f <- (Perror high)
	?g <- (Nerror high)
	=>
	(retract ?f)
	(retract ?g)

	(assert (error high))
)

;;(defrule sum13
;;	(declare (salience -500))
;;	(Perror highhigh)(Nerror low)

;;	?f <- (Perror highhigh)
;;	?g <- (Nerror low)
;;	=>
;;	(retract ?f)
;;	(retract ?g)

;;	(assert (error none))
;;)

;;(defrule sum14
;;	(declare (salience -500))
;;	(Perror highhigh)(Nerror none)

;;	?f <- (Perror highhigh)
;;	?g <- (Nerror none)
;;	=>
;;	(retract ?f)
;;	(retract ?g)
;;	(assert (error high))
;;)

;;(defrule sum15
;;	(declare (salience -500))
;;	(Perror highhigh)(Nerror high)

;;	?f <- (Perror highhigh)
;;	?g <- (Nerror high)
;;	=>
;;	(retract ?f)
;;	(retract ?g)
;;	(assert (error high))
;;)

;; Plant

(defrule plantCooldown
	(declare (salience 1))
	(error low)
	?f <- (error low)
	=>
;;	(retract ?f)
	(assert (preerror low))
	(bind ?*plantOutput* (- ?*plantOutput* 1))
	(printout t "Lowering plant output" crlf)
)

(defrule plantSS
	(declare (salience 1))
	(error none)
	?f <- (error none)
	=>
;;	(retract ?f)
	(assert (preerror none))
	(printout t "Maintaining plant output" crlf)
)

(defrule plantHeatup
	(declare (salience 1))
	(error high)
	?f <- (error high)
	=>
;;	(retract ?f)
	(assert (preerror high))
	(bind ?*plantOutput* (+ ?*plantOutput* 1))
	(printout t "Increasing plant output" crlf)
)