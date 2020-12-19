package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.databind.JsonSerializer
import com.fasterxml.jackson.databind.SerializerProvider
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.objects.Sex
import com.goga133.hsecoffee.objects.User
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.UserService
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.JwtException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.json.JsonParserFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import java.lang.IllegalArgumentException

@Controller
class UserController {
    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val userService: UserService? = null

    @RequestMapping(value = ["/api/user/settings"], method = [RequestMethod.POST])
    @ResponseStatus(HttpStatus.OK)
    fun changeSettings(@RequestBody body: String): ResponseEntity<String> {
        val json = JsonParserFactory.getJsonParser().parseMap(body)

        val token: String
        try {
            token = json["token"] as String
        } catch (e: ClassCastException) {
            return ResponseEntity.badRequest().body("Неверный формат")
        }

        val email: String;

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.badRequest().build()
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("The token has expired.")
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect token")
        }

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
            .body("Server error");

        if (json.containsKey("first_name")) {
            user.firstName = json["first_name"] as String
        }
        if (json.containsKey("last_name")) {
            user.lastName = json["last_name"] as String
        }
        if (json.containsKey("sex")) {
            try {
                user.sex = Sex.valueOf(json["sex"] as String)
            } catch (e: IllegalArgumentException) {
                return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body("Incorrect sex")
            }
        }
        if (json.containsKey("contacts")) {
            val contacts: List<String>
            try {
                contacts = json["contacts"] as List<String>
            } catch (e: ClassCastException) {
                return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body("Incorrect contacts")
            }

            contacts.forEach {
                val map = it.toString().split(":")
                if (map.size != 2)
                    return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                        .body("Incorrect contacts: incorrect element format of array")
            }

            user.contacts = contacts
        }
        if (json.containsKey("faculty")) {
            user.faculty = json["faculty"] as String
        }

        userService.save(user)
        return ResponseEntity.ok("Success")
    }

    @RequestMapping(value = ["/api/user/settings"], method = [RequestMethod.GET])
    @ResponseStatus(HttpStatus.OK)
    fun getSettings(@RequestBody body: String): ResponseEntity<String> {
        val json = JsonParserFactory.getJsonParser().parseMap(body)

        val token: String
        try {
            token = json["token"] as String
        } catch (e: ClassCastException) {
            return ResponseEntity.badRequest().body("Неверный формат")
        }

        val email: String;

        try {
            val claim = jwtService?.validateAccessToken(token)

            if (claim?.body?.subject == null)
                return ResponseEntity.badRequest().build()
            else
                email = claim.body.subject
        } catch (e: ExpiredJwtException) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("The token has expired.")
        } catch (e: JwtException) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect token")
        }

        val user = userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
            .body("Server error");


        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(user))
    }
}

