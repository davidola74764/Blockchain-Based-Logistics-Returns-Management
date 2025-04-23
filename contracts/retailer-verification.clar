;; Retailer Verification Contract
;; This contract validates legitimate business entities

(define-data-var admin principal tx-sender)

;; Map to store verified retailers
(define-map verified-retailers principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-VERIFIED (err u101))
(define-constant ERR-NOT-VERIFIED (err u102))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify a retailer
(define-public (verify-retailer (retailer principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? verified-retailers retailer)) ERR-ALREADY-VERIFIED)
    (ok (map-set verified-retailers retailer true))))

;; Revoke verification from a retailer
(define-public (revoke-verification (retailer principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? verified-retailers retailer)) ERR-NOT-VERIFIED)
    (ok (map-delete verified-retailers retailer))))

;; Check if a retailer is verified
(define-read-only (is-verified (retailer principal))
  (default-to false (map-get? verified-retailers retailer)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))))
