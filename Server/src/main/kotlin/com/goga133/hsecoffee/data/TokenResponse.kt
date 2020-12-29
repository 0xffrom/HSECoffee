package com.goga133.hsecoffee.data

import org.springframework.http.HttpStatus

data class TokenResponse(val httpStatus : HttpStatus, val message : String, val email : String?)
