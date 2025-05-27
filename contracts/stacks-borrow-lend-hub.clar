;; Project Name: Stacks Borrow-Lend Hub (SBH)
;;
;; Description:
;; A basic decentralized borrow-lend protocol on the Stacks blockchain.
;; Lenders deposit STX to earn interest, and borrowers can take out loans by locking up collateral.
;; This skeleton outlines core functions: lending, borrowing, repaying, and basic read-only queries.

(define-constant ADMIN tx-sender)

;; Global state variables
(define-data-var total-lent uint u0)
(define-data-var total-borrowed uint u0)

;; Mapping of lender balances (STX deposited)
(define-map lender-balances { lender: principal } uint)

;; Mapping for borrower data:
;; collateral: STX locked as collateral by the borrower
;; loan: current outstanding loan amount
(define-map borrower-collateral { borrower: principal } uint)
(define-map borrower-loans { borrower: principal } uint)

;; -------------------------------
;; Lend: Deposit STX for Interest
;; -------------------------------
(define-public (lend (amount uint))
  (begin
    (asserts! (> amount u0) (err u100))  ;; Must deposit more than zero
    ;; Transfer STX from sender to the contract
    (match (stx-transfer? amount tx-sender (as-contract tx-sender))
      success (begin
          (let ((current (default-to u0 (map-get? lender-balances { lender: tx-sender }))))
            (map-set lender-balances { lender: tx-sender } (+ current amount)))
          (var-set total-lent (+ (var-get total-lent) amount))
          (ok true))
      error (err u101)
    )
  )
)

;; -------------------------------
;; Borrow: Use STX as Collateral to Borrow Funds
;; -------------------------------
(define-public (borrow (loan-amount uint) (collateral uint))
  (begin
    (asserts! (> loan-amount u0) (err u102))
    (asserts! (> collateral u0) (err u103))
    ;; Require collateral to be at least 150% of the loan amount.
    (let ((required-collateral (/ (* loan-amount u150) u100)))
      (asserts! (>= collateral required-collateral) (err u104)))
    ;; Transfer collateral from borrower to the contract.
    (match (stx-transfer? collateral tx-sender (as-contract tx-sender))
      success (begin
          (let (
                (current-collateral (default-to u0 (map-get? borrower-collateral { borrower: tx-sender })))
                (current-loan (default-to u0 (map-get? borrower-loans { borrower: tx-sender })))
               )
            (map-set borrower-collateral { borrower: tx-sender } (+ current-collateral collateral))
            (map-set borrower-loans { borrower: tx-sender } (+ current-loan loan-amount)))
          (var-set total-borrowed (+ (var-get total-borrowed) loan-amount))
          ;; Transfer the loan amount from contract to borrower.
          (match (as-contract (stx-transfer? loan-amount tx-sender tx-sender))
            transfer-success (ok true)
            error (err u105)))
      error (err u106)
    )
  )
)

;; -------------------------------
;; Repay Loan: Borrower repays part or all of their loan
;; -------------------------------
(define-public (repay (amount uint))
  (let ((current-loan (default-to u0 (map-get? borrower-loans { borrower: tx-sender }))))
    (begin
      (asserts! (<= amount current-loan) (err u107))
      (map-set borrower-loans { borrower: tx-sender } (- current-loan amount))
      (var-set total-borrowed (- (var-get total-borrowed) amount))
      ;; Transfer STX from sender to contract as repayment.
      (match (stx-transfer? amount tx-sender (as-contract tx-sender))
        success (ok true)
        error (err u108)
      )
    )
  )
)

;; -------------------------------
;; Get Lender Balance
;; -------------------------------
(define-read-only (get-lender-balance (lender principal))
  (ok (default-to u0 (map-get? lender-balances { lender: lender })))
)

;; -------------------------------
;; Get Borrower Info
;; -------------------------------
(define-read-only (get-borrower-info (borrower principal))
  (ok {
       collateral: (default-to u0 (map-get? borrower-collateral { borrower: borrower })),
       loan: (default-to u0 (map-get? borrower-loans { borrower: borrower }))
     })
)