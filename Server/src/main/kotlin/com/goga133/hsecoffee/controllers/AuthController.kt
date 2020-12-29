package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.RefreshTokenService
import com.goga133.hsecoffee.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus
import java.util.*

@Controller
class AuthController {

    @Autowired
    private val emailService: EmailService? = null

    @Autowired
    private val userService: UserService? = null

    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val refreshTokenService: RefreshTokenService? = null

    @RequestMapping(value = ["/api/code"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun sendCode(@RequestParam(value = "email") receiver: String): ResponseEntity<String> {
        if (emailService?.trySendCode(receiver) == true) {
            return ResponseEntity.ok("Код был выслан.")
        }

        return ResponseEntity.badRequest().build()
    }

    @RequestMapping(value = ["/api/confirm"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun confirmCode(
        @RequestParam email: String,
        @RequestParam code: Int,
        @RequestParam fingerprint: String
    ): ResponseEntity<String> {
        if (emailService?.isValid(email, code) == true) {
            val user =
                userService?.getUserByEmailOrCreate(email) ?: return ResponseEntity.badRequest().body("Server Error")

            return ResponseEntity.ok(getTokensJSON(user, fingerprint))
        }

        return ResponseEntity.badRequest().body("Incorrect code or email.")
    }

    @RequestMapping(value = ["/api/refresh"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun refreshToken(
        @RequestParam email: String,
        @RequestParam token: UUID,
        @RequestParam fingerPrint: String
    ): ResponseEntity<String> {

        val user = userService?.getUserByEmail(email)
            ?: return ResponseEntity.badRequest()
                .body("Пользователя с такой почтой не существует.")

        if (refreshTokenService?.isValid(user, token, fingerPrint) == true) {
            return ResponseEntity.ok(getTokensJSON(user, fingerPrint))
        }

        return ResponseEntity.badRequest().body("Невозможно обновить токен.")
    }


    private fun getTokensJSON(user: User, fingerPrint: String): String {
        val accessToken = jwtService?.createAccessToken(user)
        val refreshToken = refreshTokenService?.createByUser(user, fingerPrint)?.uuid

        return jacksonObjectMapper().writeValueAsString(
            mapOf<String, Any?>(
                "accessToken" to accessToken,
                "refreshToken" to refreshToken
            )
        )
    }
}

