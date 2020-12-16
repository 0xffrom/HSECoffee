package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.RefreshTokenService
import com.goga133.hsecoffee.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.json.JsonParserFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import java.util.*

@Controller
class AuthController() {

    @Autowired
    private val emailService: EmailService? = null

    @Autowired
    private val userService: UserService? = null

    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val refreshTokenService: RefreshTokenService? = null

    /**
     * Body Example: { "email": "email_value", "code": <integer>, "fingerprint": "fingerprint value"}
     *
     */
    @RequestMapping(value = ["/api/confirm"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun confirm(
        @RequestBody body: String
    ): ResponseEntity<String> {
        val json = JsonParserFactory.getJsonParser().parseMap(body)

        val email: String
        val code: Int
        val fingerPrint: String
        try {
            email = json["email"] as String
            code = json["code"] as Int
            fingerPrint = json["fingerprint"] as String
        } catch (e: ClassCastException) {
            return ResponseEntity.badRequest().body("Неверный формат")
        }

        if (emailService?.isValid(email, code) == true) {
            val user =
                userService?.getUserByEmailOrCreate(email) ?: return ResponseEntity.badRequest().body("Server Error")

            return ResponseEntity.ok(getTokensJSON(user, fingerPrint))
        }

        return ResponseEntity.badRequest().body("Incorrect code or email.")
    }


    /**
     * Body Example: { "email": "email_value", "refreshToken": "refresh token value",
     *                 "fingerprint": "fingerprint value"}
     *
     */
    @RequestMapping(value = ["/api/refresh"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun refresh(@RequestBody body: String): ResponseEntity<String> {
        val json = JsonParserFactory.getJsonParser().parseMap(body)

        val email: String
        val token: UUID
        val fingerPrint: String
        try {
            email = json["email"] as String
            token = UUID.fromString(json["refreshToken"] as String)
            fingerPrint = json["fingerprint"] as String
        } catch (e: ClassCastException) {
            return ResponseEntity.badRequest().body("Неверный формат")
        }

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

