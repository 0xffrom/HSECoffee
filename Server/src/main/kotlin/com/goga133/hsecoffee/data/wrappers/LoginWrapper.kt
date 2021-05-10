package com.goga133.hsecoffee.data.wrappers

import com.goga133.hsecoffee.entity.User
import org.springframework.http.ResponseEntity

/**
 * Data class. Обёртка над результатом ответа после выполнения авторизации.
 */
data class LoginWrapper(val user : User? = null, val responseEntity: ResponseEntity<String>? = null){
    fun isSuccessful(): Boolean {
        return user != null
    }
}
