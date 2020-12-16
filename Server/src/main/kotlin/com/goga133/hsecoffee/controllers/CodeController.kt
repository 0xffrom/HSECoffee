package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*

@Controller
class CodeController(@Value("\${hsecoffee.code.lifetime.ms}") val lifeTime: Int) {
    @Autowired
    private val emailService: EmailService? = null

    @RequestMapping(value = ["/api/code"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun receiver(@RequestParam(value = "email") receiver: String): ResponseEntity<String> {
        if (emailService?.trySendCode(receiver) == true) {
            return ResponseEntity.ok("Код был выслан.")
        }

        return ResponseEntity.badRequest().build()
    }
}