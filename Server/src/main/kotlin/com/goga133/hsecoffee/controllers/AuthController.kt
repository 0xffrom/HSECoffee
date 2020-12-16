
package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus

@Controller
class AuthController() {

    @Autowired
    private val emailService: EmailService? = null

    @RequestMapping(value = ["/api/confirm"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun confirm(
        @RequestParam(value = "email") email: String,
        @RequestParam(value = "code") code: Int,
    ): ResponseEntity<String> {
        if(emailService?.isValid(email, code) == true){
            // TODO: Вернём JWT + RT
        }

        return ResponseEntity.badRequest().body("Incorrect code or email.")
    }


}

