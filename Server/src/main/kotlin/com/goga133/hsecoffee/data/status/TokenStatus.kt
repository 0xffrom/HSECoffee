package com.goga133.hsecoffee.data.status

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity

enum class TokenStatus {
    CORRECT, INCORRECT, EXPIRED
}
