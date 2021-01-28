package com.goga133.hsecoffee.data.wrappers

import com.goga133.hsecoffee.entity.User
import org.springframework.http.ResponseEntity

data class LoginWrapper(val user : User? = null, val responseEntity: ResponseEntity<String>? = null){
    fun isSuccessful(): Boolean {
        return user != null
    }
}
