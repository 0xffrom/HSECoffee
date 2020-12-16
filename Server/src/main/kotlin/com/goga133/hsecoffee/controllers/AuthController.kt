package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.databind.JsonSerializer
import com.fasterxml.jackson.databind.ser.std.JsonValueSerializer
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.service.EmailService
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.RefreshTokenService
import com.goga133.hsecoffee.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.json.JsonParser
import org.springframework.boot.json.JsonParserFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*

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
            fingerPrint = json["fingerPrint"] as String
        } catch (e: ClassCastException) {
            return ResponseEntity.badRequest().body(e.message)
        }

        if (emailService?.isValid(email, code) == true) {
            val user = userService?.getUserByEmailOrCreate(email) ?:
                return ResponseEntity.badRequest().body("Server Error")

            val accessToken = jwtService?.createAccessToken(user)
            val refreshToken = refreshTokenService?.createByUser(user, fingerPrint)?.uuid

            val response = jacksonObjectMapper().
            writeValueAsString(mapOf("accessToken" to accessToken, "refreshToken" to refreshToken))

            return ResponseEntity.ok(response)
        }

        return ResponseEntity.badRequest().body("Incorrect code or email.")
    }

    @RequestMapping(value = ["/api/refresh"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun refresh(){
        TODO("Не реализовано.")
    }
}

